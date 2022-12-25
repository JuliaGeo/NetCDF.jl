module NetCDF

using NetCDF_jll
using Formatting
using Base.Cartesian
import DiskArrays: readblock!, writeblock!, AbstractDiskArray, eachchunk, GridChunks,
       estimate_chunksize, haschunks, Chunked, Unchunked

include("netcdf_constants.jl")
include("netcdf_c.jl")

import Base.show

export NcDim,
       NcVar,
       NcFile,
       ncread,
       ncread!,
       ncwrite,
       nccreate,
       ncinfo,
       ncclose,
       ncputatt,
       NC_BYTE,
       NC_SHORT,
       NC_INT,
       NC_FLOAT,
       NC_DOUBLE,
       NC_STRING,
       ncgetatt,
       NC_NOWRITE,
       NC_WRITE,
       NC_CHAR,
       NC_CLOBBER,
       NC_NOCLOBBER,
       NC_CLASSIC_MODEL,
       NC_64BIT_OFFSET,
       NC_NETCDF4,
       NC_UNLIMITED,
       nc_char2string,
       nc_string2char

@deprecate ncclose() nothing
@deprecate ncsync() nothing
@deprecate ncclose(::AbstractString) nothing

NC_VERBOSE = false
#Some constants
#Define a short ASCIIChar type to map to NC_CHAR,
#We can not use Julias Char because it has 4 bytes size
#create a new AbstractChar type to test the fallbacks,
#this is re-used from the julialang tests
#https://github.com/JuliaLang/julia/blob/master/test/char.jl#L242
primitive type ASCIIChar <: AbstractChar 8 end
ASCIIChar(c::UInt8) = reinterpret(ASCIIChar, c)
ASCIIChar(c::UInt32) = ASCIIChar(UInt8(c))
Base.codepoint(c::ASCIIChar) = reinterpret(UInt8, c)
Base.zero(::Type{ASCIIChar}) = ASCIIChar(0)

global const nctype2jltype = Dict(
    NC_BYTE => Int8,
    NC_UBYTE => UInt8,
    NC_SHORT => Int16,
    NC_USHORT => UInt16,
    NC_INT => Int32,
    NC_UINT => UInt32,
    NC_INT64 => Int64,
    NC_UINT64 => UInt64,
    NC_FLOAT => Float32,
    NC_DOUBLE => Float64,
    NC_CHAR => ASCIIChar,
    NC_STRING => String,
)

global const nctype2string = Dict(
    NC_BYTE => "BYTE",
    NC_UBYTE => "UBYTE",
    NC_SHORT => "SHORT",
    NC_USHORT => "USHORT",
    NC_INT => "INT",
    NC_UINT => "UINT",
    NC_INT64 => "INT64",
    NC_UINT64 => "UINT64",
    NC_FLOAT => "FLOAT",
    NC_DOUBLE => "DOUBLE",
    NC_STRING => "STRING",
    NC_CHAR => "CHAR",
)


function jl2nc(t::DataType)
    popfirst!(collect(keys(nctype2jltype))[findall(
        e -> (t <: e),
        collect(values(nctype2jltype)),
    )])
end
jl2nc(t::Type{UInt8}) = NC_UBYTE

getJLType(t::DataType) = t
getJLType(t::Int) = nctype2jltype[t]

getNCType(t::DataType) = jl2nc(t)
getNCType(t::Int) = Int(t)

"""
    NcDim

Represents a NetCDF dimension of name `name` optionally holding the dimension values.
"""
mutable struct NcDim
    ncid::Int32
    dimid::Int32
    varid::Int32
    name::String
    dimlen::UInt
    vals::AbstractArray
    atts::Dict
    unlim::Bool
end


"""
    NcDim(name::String,dimlength::Integer)

Creates a NetCDF dimension object named `name` with length `dimlength` in memory.

### Keyword arguments

* `values=[]` optional for adding dimension values which can be written to a dimension variable
* `atts` a Dict of attributes associated to the dimension variable
* `unlimited` is this the record dimension, defaults to `false`
"""
function NcDim(
    name::AbstractString,
    dimlength::Integer;
    values::Union{AbstractArray,Number} = [],
    atts::Dict = Dict{Any,Any}(),
    unlimited = false,
)
    length(values) > 0 &&
    dimlength != 0 &&
    length(values) != dimlength &&
    error("Dimension value vector must have the same length as dimlength!")
    NcDim(-1, -1, -1, string(name), dimlength, collect(values), atts, unlimited)
end


"""
NcDim(name::String,values::AbstractVector)

Creates a NetCDF dimension object named `name` and associated `values` in memory.

### Keyword arguments

* `atts` a Dict of attributes associated to the dimension variable
* `unlimited` is this the record dimension, defaults to `false`
"""
NcDim(
    name::AbstractString,
    values::AbstractArray;
    atts::Dict = Dict{Any,Any}(),
    unlimited = false,
) = NcDim(name, length(values), values = values, atts = atts, unlimited = unlimited)
NcDim(name::AbstractString, values::AbstractArray, atts::Dict; unlimited = false) =
    NcDim(name, length(values), values = values, atts = atts, unlimited = unlimited)


"""
    NcVar

`NcVar{T,N,M}` represents a NetCDF variable. It is a subtype of `AbstractArray{T,N}`, so normal indexing using `[]`
will work for reading and writing data to and from a NetCDF file. `NcVar` objects are returned by `NetCDF.open`, by
indexing an `NcFile` object (e.g. `myfile["temperature"]`) or, when creating a new file, by its constructor. The type parameter `M`
denotes the NetCDF data type of the variable, which may or may not correspond to the Julia Data Type.
"""
mutable struct NcVar{T,N,M} <: AbstractDiskArray{T,N}
    ncid::Int32
    varid::Int32
    ndim::Int32
    natts::Int32
    nctype::Int32
    name::String
    dimids::Vector{Int32}
    dim::Vector{NcDim}
    atts::Dict
    compress::Int32
    chunksize::NTuple{N,Int32}
    ncfile #Kept to prevent closing through finalizer
end

Base.convert(::Type{NcVar{T,N,M}}, v::NcVar{S,N,M}) where {S,T,N,M} = NcVar{T,N,M}(
    v.ncid,
    v.varid,
    v.ndim,
    v.natts,
    v.nctype,
    v.name,
    v.dimids,
    v.dim,
    v.atts,
    v.compress,
    v.chunksize,
    v.ncfile,
)
Base.convert(::Type{NcVar{T}}, v::NcVar{S,N,M}) where {S,T,N,M} = NcVar{T,N,M}(
    v.ncid,
    v.varid,
    v.ndim,
    v.natts,
    v.nctype,
    v.name,
    v.dimids,
    v.dim,
    v.atts,
    v.compress,
    v.chunksize,
    v.ncfile
)


# Implement the DiskArrays interface
function readblock!(v::NcVar, aout, r::AbstractUnitRange...)
  readvar!(v,aout,start = [first(i) for i in r], count = [length(i) for i in r])
end
function writeblock!(v::NcVar, a, r::AbstractUnitRange...)
  putvar(v,a,start = [first(i) for i in r], count = [length(i) for i in r])
  sync(v.ncfile)
end
getchunksize(v::NcVar) = getchunksize(haschunks(v),v)
getchunksize(::Chunked, v::NcVar) = GridChunks(v,reverse(map(Int64,v.chunksize)))
getchunksize(::Unchunked, v::NcVar) = estimate_chunksize(v)
eachchunk(v::NcVar) = getchunksize(v)
haschunks(v::NcVar) = all(iszero,v.chunksize) ? Unchunked() : Chunked()

"""
    NcVar(name::AbstractString,dimin::Union{NcDim,Array{NcDim,1}}

Creates a new NetCDF variable `name` in memory. The variable is associated to a
list of NetCDF dimensions specified by `dimin`.

### Keyword arguments

* `atts` Dictionary representing the variables attributes
* `t` either a Julia type, (one of `Int16`, `Int32`, `Float32`, `Float64`, `String`) or a NetCDF data type (`NC_SHORT`, `NC_INT`, `NC_FLOAT`, `NC_DOUBLE`, `NC_CHAR`, `NC_STRING`) determines the data type of the variable. Defaults to -1
* `compress` Integer which sets the compression level of the variable for NetCDF4 files. Defaults to -1 (no compression). Compression levels of 1..9 are valid
"""
function NcVar(
    name::AbstractString,
    dimin::Union{NcDim,Array{NcDim,1}};
    atts::Dict = Dict{Any,Any}(),
    t::Union{DataType,Integer} = Float64,
    compress::Integer = -1,
    chunksize::Tuple = ntuple(i -> zero(Int32), isa(dimin, NcDim) ? 1 : length(dimin)),
)
    dim = isa(dimin, NcDim) ? NcDim[dimin] : dimin
    chunksize = map(Int32, chunksize)
    return NcVar{getJLType(t),length(dim),getNCType(t)}(
        Int32(-1),
        Int32(-1),
        Int32(length(dim)),
        Int32(length(atts)),
        getNCType(t),
        name,
        fill(Int32(-1), length(dim)),
        dim,
        atts,
        Int32(compress),
        chunksize,
        nothing,
    )
end

#Array methods
@generated function Base.size(a::NcVar{T,N}) where {T,N}
    :(@ntuple($N, i -> Int(a.dim[i].dimlen)))
end
const IndR = Union{Integer,UnitRange,Colon}
const ArNum = Union{AbstractArray,Number}

"""
    NcFile

Represents a link to a NetCDF file. Is returned by `NetCDF.open` or by `NetCDF.create`.
"""
mutable struct NcFile
    ncid::Int32
    nvar::Int32
    ndim::Int32
    ngatts::Int32
    vars::Dict{String,NcVar}
    dim::Dict{String,NcDim}
    gatts::Dict
    unlimdimids::Vector{Int32}
    name::String
    omode::UInt16
    in_def_mode::Bool
end
#Define getindex method to retrieve a variable
Base.getindex(nc::NcFile, i::AbstractString) = haskey(nc.vars, i) ? nc.vars[i] :
error("NetCDF file $(nc.name) does not have a variable named $(i)")
Base.keys(nc::NcFile) = keys(nc.vars)

include("netcdf_helpers.jl")


readvar!(
    nc::NcFile,
    varname::AbstractString,
    retvalsa::AbstractArray;
    start::Vector = defaultstart(nc[varname]),
    count::Vector = defaultcount(nc[varname]),
) = readvar!(nc[varname], retvalsa, start = start, count = count)


"""
    NetCDF.readvar!(v::NcVar, d::Array;start::Vector=ones(UInt,ndims(d)),count::Vector=size(d))

Reads the values from the file associated to the `NcVar` object `v` into the array `d`. By default the whole variable is read.

### Keyword arguments

* `start` Vector of length `ndim(v)` setting the starting index for each dimension
* `count` Vector of length `ndim(v)` setting the count of values to be read along each dimension. The value -1 is treated as a special case to read all values from this dimension

### Example

Assume `v` is a NetCDF variable with dimensions (3,3,10).

    x = zeros(3,1,10)
    NetCDF.readvar(v, x, start=[1,2,1], count=[3,1,-1])

This reads all values from the first and last dimension and only the second value from the second dimension.
"""
function readvar!(
    v::NcVar,
    retvalsa::AbstractArray;
    start::Vector = defaultstart(v),
    count::Vector = defaultcount(v),
)

    isa(retvalsa, Array) ||
    Base.iscontiguous(retvalsa) || error("Can only read into contiguous pieces of memory")

    length(start) == v.ndim || error("Length of start ($(length(start))) must equal the number of variable dimensions ($(v.ndim))")
    length(count) == v.ndim || error("Length of start ($(length(count))) must equal the number of variable dimensions ($(v.ndim))")

    p = preparestartcount(start, count, v)

    length(retvalsa) != p && error("Size of output array ($(length(retvalsa))) does not equal number of elements to be read ($p)!")

    nc_get_vara_x!(v, gstart, gcount, retvalsa)

    retvalsa
end


readvar(
    nc::NcFile,
    varname::AbstractString;
    start::Vector = defaultstart(nc[varname]),
    count::Vector = defaultcount(nc[varname]),
) = readvar(nc[varname], start = start, count = count)

"""
    NetCDF.readvar(v::NcVar;start::Vector=ones(UInt,ndims(d)),count::Vector=size(d))

Reads the values from the file associated to the `NcVar` object `v` and returns them. By default the whole variable is read

### Keyword arguments

* `start` Vector of length `ndim(v)` setting the starting index for each dimension
* `count` Vector of length `ndim(v)` setting the count of values to be read along each dimension. The value -1 is treated as a special case to read all values from this dimension

### Example

Assume `v` is a NetCDF variable with dimensions (3,3,10).

    x = NetCDF.readvar(v, start=[1,2,1], count=[3,1,-1])

This reads all values from the first and last dimension and only the second value from the second dimension.
"""
function readvar(
    v::NcVar{T,N};
    start::Vector = defaultstart(v),
    count::Vector = defaultcount(v),
) where {T,N}
    s = [count[i] == -1 ? size(v, i) - start[i] + 1 : count[i] for i = 1:length(count)]
    retvalsa = Array{T}(undef, s...)
    readvar!(v, retvalsa, start = start, count = count)
    return retvalsa
end

"""
    NetCDF.readvar{T,N}(v::NcVar{T,N},I::Union{Integer, UnitRange, Colon}...)

Reads data from a NetCDF file with array-style indexing. `Integer`s and `UnitRange`s and `Colon`s are valid indices for each dimension.
"""
function readvar(v::NcVar{T,N}, I::IndR...) where {T,N}
    count = ntuple(i -> counti(I[i], v.dim[i].dimlen), length(I))
    retvalsa = Array{T}(undef, count...)
    readvar!(v, retvalsa, I...)
    return retvalsa
end


# Here are some functions for array-style indexing readvar
#For single indices
@generated function readvar(v::NcVar{T,N}, I::Integer...) where {T,N}
    N == length(I) || error("Dimension mismatch")
    if N == 0
        quote
            checkbounds(v, I...)
            gstart[1] = 0
            nc_get_var1_x(v, gstart, T)::T
        end
    else
        quote
            checkbounds(v, I...)
            @nexprs $N i -> gstart[v.ndim+1-i] = I[i] - 1
            nc_get_var1_x(v, gstart, T)::T
        end
    end
end

firsti(i::Integer, l::Integer) = i - 1
counti(i::Integer, l::Integer) = 1
firsti(r::UnitRange, l::Integer) = first(r) - 1
counti(r::UnitRange, l::Integer) = length(r)
firsti(r::Colon, l::Integer) = 0
counti(r::Colon, l::Integer) = Int(l)

# For ranges
"""
    NetCDF.readvar!{T,N}(v::NcVar{T,N},d::AbstractArray, I::Union{Integer, UnitRange, Colon}...)

Reads data from a NetCDF file with array-style indexing and writes them to d. `Integer`s and `UnitRange`s and `Colon`s are valid indices for each dimension.
"""
@generated function readvar!(v::NcVar{T,N}, retvalsa::AbstractArray, I::IndR...) where {T,N}

    N == length(I) || error("Dimension mismatch")

    quote
        checkbounds(v, I...)

        isa(retvalsa, Array) ||
        Base.iscontiguous(retvalsa) ||
        error("Can only read into contiguous pieces of memory")

        @nexprs $N i -> gstart[v.ndim+1-i] = firsti(I[i], v.dim[i].dimlen)
        @nexprs $N i -> gcount[v.ndim+1-i] = counti(I[i], v.dim[i].dimlen)
        p = 1
        @nexprs $N i -> p = p * gcount[v.ndim+1-i]
        length(retvalsa) != p && error(string(
            "Size of output array ($(length(retvalsa))) does not equal number of elements to be read (",
            p,
            ")!",
        ))
        nc_get_vara_x!(v, gstart, gcount, retvalsa)
        retvalsa
    end
end


for (t, ending, arname) in funext
    fname = Symbol("nc_get_vara_$ending")
    fname1 = Symbol("nc_get_var1_$ending")
    arsym = Symbol(arname)
    @eval nc_get_vara_x!(
        v::NcVar{$t},
        start::Vector{UInt},
        count::Vector{UInt},
        retvalsa::AbstractArray{$t},
    ) = $fname(v.ncid, v.varid, start, count, retvalsa)
    @eval nc_get_var1_x(v::NcVar{$t}, start::Vector{UInt}, ::Type{$t}) = begin
        $fname1(v.ncid, v.varid, start, $(arsym))
        $(arsym)[1]
    end
end

nc_get_vara_x!(
    v::NcVar{ASCIIChar,N,NC_CHAR},
    start::Vector{UInt},
    count::Vector{UInt},
    retvalsa::AbstractArray{<:ASCIIChar},
) where {N} = nc_get_vara_text(v.ncid, v.varid, start, count, retvalsa)
nc_get_var1_x!(
    v::NcVar{ASCIIChar,N,NC_CHAR},
    start::Vector{UInt},
    retvalsa::AbstractArray{<:ASCIIChar},
) where {N} = nc_get_var1_text(v.ncid, v.varid, start, retvalsa)

function nc_get_vara_x!(
    v::NcVar{String,N,NC_STRING},
    start::Vector{UInt},
    count::Vector{UInt},
    retvalsa::AbstractArray{<:String},
) where {N}
    @assert length(retvalsa) == prod(view(count, 1:N))
    retvalsa_c = fill(Ptr{UInt8}(0), length(retvalsa))
    nc_get_vara_string(v.ncid, v.varid, start, count, retvalsa_c)
    for i = 1:length(retvalsa)
        retvalsa[i] = unsafe_string(retvalsa_c[i])
    end
    nc_free_string(length(retvalsa_c), retvalsa_c)
    retvalsa
end

function nc_get_var1_x(
    v::NcVar{String,N,NC_STRING},
    start::Vector{UInt},
    ::Type{String},
) where {N}
    retvalsa_c = fill(Ptr{UInt8}(0), 1)
    nc_get_var1_string(v.ncid, v.varid, start, retvalsa_c)
    retval = unsafe_string(retvalsa_c[1])
    nc_free_string(1, retvalsa_c)
    retval
end


function putatt(ncid::Integer, varid::Integer, atts::Dict)
    for a in atts
        name = a[1]
        val = a[2]
        nc_put_att(ncid, varid, name, val)
    end
end

function putatt(nc::NcFile, atts::Dict)
    putatt(nc.ncid, NC_GLOBAL, atts)
    merge!(nc.gatts, getatts(nc.ncid, NC_GLOBAL, collect(keys(atts))))
end

function putatt(var::NcVar, atts::Dict)
    putatt(var.ncid, var.varid, atts)
    merge!(var.atts, getatts(var.ncid, var.varid, collect(keys(atts))))
end

"""
    NetCDF.putatt(nc::NcFile, varname::String, atts::Dict)

Writes the attributes defined in `atts` to the variable `varname` in the NetCDF file
`nc`. Existing attributes are overwritten. If varname is not a valid variable name,
a global attribute will be written.
"""
function putatt(nc::NcFile, varname::AbstractString, atts::Dict)
    chdef = false
    if !nc.in_def_mode
        chdef = true
        nc_redef(nc.ncid)
    end
    if haskey(nc.vars, varname)
        putatt(nc.vars[varname], atts)
    else
        putatt(nc, atts)
    end
    chdef && nc_enddef(nc.ncid)
end

"""
    ncputatt(nc::String,varname::String,atts::Dict)

Writes the attributes defined in `atts` to the variable `varname` for the given NetCDF file name
`nc`. Existing attributes are overwritten. If varname is not a valid variable name,
a global attribute will be written.
"""
function ncputatt(ncs::AbstractString, varname::AbstractString, atts::Dict)
    open(ncs, mode = NC_WRITE) do nc
        if (nc.omode == NC_NOWRITE)
            fil = nc.name
            close(nc)
            println("reopening file in WRITE mode")
            open(fil, mode = NC_WRITE)
        end
        putatt(nc, varname, atts)
    end
end

putvar(
    nc::NcFile,
    varname::AbstractString,
    vals::AbstractArray;
    start = ones(Int, length(size(vals))),
    count = [size(vals)...],
) = putvar(nc[varname], vals, start = start, count = count)

"""
    NetCDF.putvar(v::NcVar,vals::Array;start::Vector=ones(Int,length(size(vals))),count::Vector=[size(vals)...])

Writes the values from the array `vals` to a NetCDF file. `v` is the `NcVar` handle of the respective variable and `vals` is an array
with the same dimension as the variable in the NetCDF file.

### Keyword arguments

* `start` Vector of length `ndim(v)` setting the starting index for each dimension
* `count` Vector of length `ndim(v)` setting the count of values to be read along each dimension. The value -1 is treated as a special case to read all values from this dimension

"""
function putvar(
    v::NcVar,
    vals::AbstractArray;
    start::Vector = ones(Int, length(size(vals))),
    count::Vector = [size(vals)...],
)
    isa(vals, Array) ||
    Base.iscontiguous(vals) || error("Can only write from contiguous pieces of memory")
    p = preparestartcount(start, count, v)
    nc_put_vara_x(v, gstart, gcount, vals)
end

"""
    NetCDF.putvar(v::NcVar, val, i...)

Writes the value(s) `val` to the variable `v` while the indices are given in in an array-style indexing manner.
"""
@generated function putvar(v::NcVar{T,N}, val::Any, I::IndR...) where {T,N}

    N == length(I) || error("Dimension mismatch")
    quote
        isa(val, Number) ||
        isa(val, Array) ||
        Base.iscontiguous(val) || error("Can only write from contiguous pieces of memory")
        @nexprs $N i -> gstart[v.ndim+1-i] = firsti(I[i], v.dim[i].dimlen)
        @nexprs $N i -> gcount[v.ndim+1-i] = counti(I[i], v.dim[i].dimlen)
        checkboundsNC(v)
        p = 1
        @nexprs $N i -> p = p * gcount[v.ndim+1-i]
        length(val) != p && error(string(
            "Size of output array ($(length(retvalsa))) does not equal number of elements to be read (",
            p,
            ")!",
        ))
        nc_put_vara_x(v, gstart, gcount, val)
    end
end

@generated function putvar(v::NcVar{T,N}, val::Any, I::Integer...) where {T,N}

    N == length(I) || error("Dimension mismatch")
    if N == 0
        quote
            gstart[1] = 0
            nc_put_var1_x(v, gstart, val[1])
        end
    else
        quote
            @nexprs $N i -> gstart[v.ndim+1-i] = I[i] - 1
            @nall(
                $N,
                d -> ((I[d] <= v.dim[d].dimlen && I[d] > 0) || v.dim[d].unlim),
            ) || throw(BoundsError(v, I))
            nc_put_var1_x(v, gstart, val[1])
        end
    end

end

for (t, ending, arname) in funext
    fname = Symbol("nc_put_vara_$ending")
    fname1 = Symbol("nc_put_var1_$ending")
    arsym = Symbol(arname)
    @eval nc_put_vara_x(
        v::NcVar,
        start::Vector{UInt},
        count::Vector{UInt},
        vals::AbstractArray{$t},
    ) = $fname(v.ncid, v.varid, start, count, vals)
    @eval nc_put_var1_x(v::NcVar, start::Vector{UInt}, val::$t) = begin
        $(arsym)[1] = val
        $fname1(v.ncid, v.varid, start, $(arsym))
    end
end

nc_put_vara_x(
    v::NcVar{ASCIIChar,N,NC_CHAR},
    start::Vector{UInt},
    count::Vector{UInt},
    vals::AbstractArray{ASCIIChar},
) where {N} = nc_put_vara_text(v.ncid, v.varid, start, count, vals)
nc_put_var1_x(
    v::NcVar{ASCIIChar,N,NC_CHAR},
    start::Vector{UInt},
    val::ASCIIChar,
) where {N} = begin
    vals = UInt8[val]
    nc_put_var1_text(v.ncid, v.varid, start, count, vals)
end

function nc_put_vara_x(
    v::NcVar{String,N,NC_STRING},
    start,
    count,
    vals::AbstractArray{String},
) where {N}
    vals_p = map(x -> pointer(x), vals)
    nc_put_vara_string(v.ncid, v.varid, start, count, vals_p)
end

function nc_put_var1_x(
    v::NcVar{String,N,NC_STRING},
    start::Vector{UInt},
    val::String,
) where {N}
    val_p = [pointer(val)]
    nc_put_var1_string(v.ncid, v.varid, start, val_p)
end


function Base.push!(v::NcVar, a::AbstractArray)
    sold = size(v)
    N = ndims(v)
    iunlim = findall(map(x -> x.unlim, v.dim))
    length(iunlim) == 1 || error("You can only push to a NetCDF variable with one unlimited dimension")
    st = fill(1, N)
    st[iunlim[1]] = sold[iunlim[1]] + 1
    co = fill(-1, N)
    if ndims(v) == ndims(a)
        co[iunlim[1]] = size(a, iunlim[1])
    elseif ndims(v) == ndims(a) + 1
        co[iunlim[1]] = 1
    else
        error("You can only push variables that have equal or one fewer dimension than the NetCDF Variable")
    end
    NetCDF.putvar(v, a, start = st, count = co)
end

function Base.push!(v::NcVar{T,1}, a::Number) where {T}
    push!(v, collect(a))
end

"""
    NetCDF.sync(nc::NcFile)

Synchronizes the changes made to the file and writes changes to the disk.
"""
function sync(nc::NcFile)
    nc_sync(nc.ncid)
end

function setcompression(v::NcVar, mode)
    if v.compress > -1
        if (NC_NETCDF4 & mode) == 0
            warn("Compression only possible for NetCDF4 file format. Compression will be ingored.")
            v.compress = -1
        else
            v.compress = min(v.compress, 9)
            nc_def_var_deflate(v.ncid, v.varid, Int32(1), Int32(1), v.compress)
        end
    end
end

"""
    NetCDF.create(name::AbstringString,varlist::Array{NcVar};gatts::Dict=Dict{Any,Any}(),mode::UInt16=NC_NETCDF4,add_finalizer = true)

Creates a new NetCDF file. Here, `name`
 is the name of the file to be created and `varlist` an array of `NcVar` holding the variables that should appear in the file.

### Keyword arguments

* `gatts` a Dict containing global attributes of the NetCDF file
* `mode` NetCDF file type (`NC_NETCDF4`, `NC_CLASSIC_MODEL` or `NC_64BIT_OFFSET`), defaults to `NC_NETCDF4`
"""
function create(
    name::AbstractString,
    varlist::Array{<:NcVar};
    gatts::Dict = Dict{Any,Any}(),
    mode::UInt16 = NC_NETCDF4,
    add_finalizer = true,
)

    #Create the file
    id = nc_create(name, mode)
    # Collect Dimensions and set NetCDF ID
    vars = Dict{String,NcVar}()
    varlist = collect(NcVar, varlist)
    dims = Set{NcDim}()
    for v in varlist
        v.ncid = id
        for d in v.dim
            push!(dims, d)
        end
    end
    nunlim = 0
    ndim = Int32(length(dims))

    #Create the NcFile Object
    nc = NcFile(
        id,
        Int32(length(vars)),
        ndim,
        zero(Int32),
        vars,
        Dict{String,NcDim}(),
        Dict{Any,Any}(),
        Int32[],
        name,
        NC_WRITE,
        true,
    )

    for d in dims
        create_dim(nc, d)
        if d.unlim
            push!(nc.unlimdimids, d.dimid)
        end
        if (length(d.vals) > 0) & (!haskey(nc.vars, d.name))
            elt = eltype(d.vals)
            push!(
                varlist,
                NcVar{elt,1,jl2nc(elt)}(
                    id,
                    varida[1],
                    1,
                    length(d.atts),
                    jl2nc(elt),
                    d.name,
                    [d.dimid],
                    [d],
                    d.atts,
                    -1,
                    (zero(Int32),),
                    nc
                ),
            )
        end
    end

    # Create variables in the file
    for v in varlist
        create_var(nc, v, mode)
        v.ncfile = nc
    end

    # Put global attributes
    if !isempty(gatts)
        putatt(nc, gatts)
    end

    # Leave define mode
    nc_enddef(nc)

    for d in nc.dim
        #Write dimension variable
        if length(d[2].vals) > 0
            putvar(nc, d[2].name, d[2].vals)
        end
    end

    add_finalizer && finalizer(_close,nc)

    return nc
end

create(
    name::AbstractString,
    varlist::NcVar...;
    gatts::Dict = Dict{Any,Any}(),
    mode::UInt16 = NC_NETCDF4,
    add_finalizer = true,
) = create(name, NcVar[varlist[i] for i = 1:length(varlist)]; gatts = gatts, mode = mode, add_finalizer = add_finalizer)

"""
    NetCDF._close(nc::NcFile)

closes a NetCDF file handle
"""
function _close(nco::Union{NcFile, NcVar})
    #Close file
    nc_close(nco.ncid)
    nothing
end

function close(x::Union{NcFile, NcVar})
  println(stacktrace())
  @warn "NetCDF.close is deprecated, because closing files is done with finalizers from now on. "
end

"""
    NetCDF.open(fil::AbstractString,v::AbstractString)

opens a NetCDF variable `v` in the NetCDF file `fil` and returns an `NcVar` handle that implements the `AbstractArray` interface for reading and writing.
Note that it is in the user's responsibility to close the file after usage using `NetCDF.close`.

### Keyword arguments

* `mode` mode in which the file is opened, defaults to `NC_NOWRITE`, choose `NC_WRITE` for write access
* `readdimvar` determines if dimension variables will be read into the file structure, default is `false`
"""
function open(
    fil::AbstractString,
    v::AbstractString;
    mode::Integer = NC_NOWRITE,
    readdimvar::Bool = false,
    add_finalizer = true,
)
    nc = open(fil, mode = mode, readdimvar = readdimvar, add_finalizer=add_finalizer)
    nc.vars[v]
end

"""
    NetCDF.open(fil::AbstractString)

opens the NetCDF file `fil` and returns a `NcFile` handle. Note that it is in the user's responsibility to close the file after usage using `NetCDF.close`.

### Keyword arguments

* `mode` mode in which the file is opened, defaults to `NC_NOWRITE`, choose `NC_WRITE` for write access
* `readdimvar` determines if dimension variables will be read into the file structure, default is `false`
"""
function open(fil::AbstractString; mode::Integer = NC_NOWRITE, readdimvar::Bool = false, add_finalizer=true)

    # Open netcdf file
    ncid = nc_open(fil, mode)

    #Get initial information
    ndim, nvar, ngatt, nunlimdimid = nc_inq(ncid)

    #Get unlimited dimensions
    nunlimdims = Ref(Int32(0))
    nc_inq_unlimdims(ncid, nunlimdims, C_NULL)
    unlimdims = fill(Int32(0), nunlimdims[])
    nc_inq_unlimdims(ncid, nunlimdims, unlimdims)

    #Create ncdf object
    ncf = NcFile(
        ncid,
        Int32(nvar - ndim),
        ndim,
        ngatt,
        Dict{String,NcVar}(),
        Dict{String,NcDim}(),
        Dict{Any,Any}(),
        unlimdims,
        abspath(fil),
        mode,
        false,
    )

    #Read global attributes
    ncf.gatts = getatts_all(ncid, NC_GLOBAL, ngatt)

    #Read dimensions
    for dimid = 0:ndim-1
        (name, dimlen) = nc_inq_dim(ncid, dimid)
        ncf.dim[name] = NcDim(
            ncid,
            dimid,
            -1,
            name,
            dimlen,
            [],
            Dict{Any,Any}(),
            in(dimid, unlimdims) ? true : false,
        )
    end

    #Read variable information
    for varid = 0:(nvar-1)
        (name, nctype, dimids, natts, vndim, isdimvar, chunksize) = nc_inq_var(ncf, varid)
        if (isdimvar)
            ncf.dim[name].varid = varid
        end
        atts = getatts_all(ncid, varid, natts)
        vdim = Array{NcDim}(undef, length(dimids))
        for (i, did) in enumerate(dimids)
            vdim[i] = ncf.dim[getdimnamebyid(ncf, did)]
        end
        ncf.vars[name] = NcVar{nctype2jltype[nctype],Int(vndim),Int(nctype)}(
            ncid,
            Int32(varid),
            vndim,
            natts,
            nctype,
            name,
            dimids[vndim:-1:1],
            vdim[vndim:-1:1],
            atts,
            0,
            chunksize,
            ncf,
        )
    end
    readdimvar == true && _readdimvars(ncf)
    add_finalizer && finalizer(_close,ncf)
    return ncf
end

"""
    NetCDF.open(f::Function, args...;kwargs...)

Opens a NetCDF file, applies the function f on the resulting file or variable handle and properly closes the file after usage.
This is convenient to use together with the `do` block syntax, for example:

data = open("myfile.nc","myvar") do v
  NetCDF.readvar(v,start=[1,1,1], count=[-1,-1,1])
end
"""
function open(f::Function, args...; kwargs...)
    io = open(args...;add_finalizer=false, kwargs...)
    try
        f(io)
    finally
        _close(io)
    end
end

"""
    NetCDF.create(f::Function, args...;kwargs...)

Creates a NetCDF file, applies the function f on the resulting file or variable handle and properly closes the file after usage.
This is convenient to use together with the `do` block syntax, for example:

d = NcDim("time",1:10)
v = NcVar("obs",d);
NetCDF.create("newfile.nc",v) do nc
  nc["obs"][:] = rand(10)
end
"""
function create(f::Function, args...; kwargs...)
    io = create(args...; add_finalizer=false, kwargs...)
    try
        f(io)
    finally
        _close(io)
    end
end

# Define some high-level functions
"""
    ncread(filename, varname)

reads the values of the variable `varname` from file `filename` and returns the values in an array.

### Keyword arguments

* `start` Vector of length `ndim(v)` setting the starting index for each dimension
* `count` Vector of length `ndim(v)` setting the count of values to be read along each dimension. The value -1 is treated as a special case to read all values along the dimension

### Example

To read the second slice of a 3D NetCDF variable, you can write:

    ncread("filename","varname", start=[1,1,2], count = [-1,-1,1])

"""
function ncread(
    fil::AbstractString,
    vname::AbstractString;
    start::Array{T} = Array{Int}(undef, 0),
    count::Array{T} = Array{Int}(undef, 0),
) where {T<:Integer}
    open(fil) do nc
        length(start) == 0 && (start = defaultstart(nc[vname]))
        length(count) == 0 && (count = defaultcount(nc[vname]))
        readvar(nc[vname], start = start, count = count)
    end
end
ncread(
    fil::AbstractString,
    vname::AbstractString,
    start::Array{T,1},
    count::Array{T,1},
) where {T<:Integer} = ncread(fil, vname, start = start, count = count)

"""
    ncread!(filename, varname, d)

reads the values of the variable varname from file filename and writes the results to the pre-allocated array `d`

### Keyword arguments

* `start` Vector of length `ndim(v)` setting the starting index for each dimension
* `count` Vector of length `ndim(v)` setting the count of values to be read along each dimension. The value -1 is treated as a special case to read all values from this dimension

### Example

To read the second slice of a 3D NetCDF variable one can write:

    d = zeros(10,10,1)
    ncread!("filename","varname", d, start=[1,1,2], count = [-1,-1,1])

"""
function ncread!(
    fil::AbstractString,
    vname::AbstractString,
    vals::AbstractArray;
    start::Vector{Int} = ones(Int, ndims(vals)),
    count::Vector{Int} = [size(vals, i) for i = 1:ndims(vals)],
)
    open(fil) do nc
        readvar!(nc, vname, vals, start = start, count = count)
    end
end

"""
    ncinfo(filename)

prints information on the variables, dimension and attributes conatained in the file
"""
function ncinfo(fil::AbstractString)
    open(show, fil)
end

iswritable(nc::NcFile) = (nc.omode & NC_WRITE) != zero(UInt16)

#High-level functions for writing data to a file
"""
    ncwrite(x::Array,fil::AbstractString,vname::AbstractString)

Writes the array `x` to the file `fil` and variable `vname`.

### Keyword arguments

* `start` Vector of length `ndim(v)` setting the starting index for writing for each dimension
* `count` Vector of length `ndim(v)` setting the count of values to be written along each dimension. The value -1 is treated as a special case to write all values along the dimension. This is usually inferred by the given array size.
"""
function ncwrite(
    x::Array,
    fil::AbstractString,
    vname::AbstractString;
    start = ones(Int, length(size(x))),
    count = [size(x)...],
)
    open(fil, mode = NC_WRITE) do nc
        if (nc.omode == NC_NOWRITE)
            close(nc)
            println("reopening file in WRITE mode")
            open(fil, mode = NC_WRITE)
        end
        putvar(nc, vname, x, start = start, count = count)
    end
end
ncwrite(x::Array, fil::AbstractString, vname::AbstractString, start::Array) =
    ncwrite(x, fil, vname, start = start)

"""
    ncgetatt(filename, varname, attname)

This reads a NetCDF attribute `attname` from the specified file and variable. To read global attributes, set varname to `Global`.
"""
function ncgetatt(fil::AbstractString, vname::AbstractString, att::AbstractString)
    open(fil) do nc
        haskey(nc.vars, vname) ? get(nc.vars[vname].atts, att, nothing) :
        get(nc.gatts, att, nothing)
    end
end

#High-level function for creating files and variables
#
# if the file does not exist, it will be created
# if the file already exists, the variable will be added to the file

function create_dim(nc, dim)
    nc_redef(nc)
    nc_def_dim(nc.ncid, dim.name, dim.dimlen, dima)
    dim.dimid = dima[1]
    nc.dim[dim.name] = dim
end


function create_var(nc, v, mode)
    nc_redef(nc)

    v.dimids = Int32[v.dim[i].dimid for i = 1:length(v.dim)]
    for i = 1:v.ndim
        dumids[i] = v.dimids[v.ndim+1-i]
    end
    nc_def_var(nc.ncid, v.name, v.nctype, v.ndim, dumids, vara)
    v.varid = vara[1]
    if any(i -> i > 0, v.chunksize)
        chunk_sizea[1:v.ndim] .= reverse(v.chunksize)
        nc_def_var_chunking(nc.ncid, v.varid, NC_CHUNKED, chunk_sizea)
    end
    nc.vars[v.name] = v
    putatt(nc.ncid, v.varid, v.atts)
    setcompression(v, mode)
end

"""
    nccreate (filename, varname, dimensions ...)

Creates a variable in an existing NetCDF file or generates a new file. `filename` and `varname` are strings.
After that follows a list of dimensions. Each dimension entry starts with a dimension name (a String), and
may be followed by a dimension length, an array with dimension values or a Dict containing dimension attributes.
Then the next dimension is entered and so on. Have a look at examples/high.jl for an example use.

### Keyword arguments

- **atts** Dict of attribute names and values to be assigned to the variable created
- **gatts** Dict of attribute names and values to be written as global attributes
- **compress** Integer [0..9] setting the compression level of the file, only valid if `mode=NC_NETCDF4`
- **t** variable type, currently supported types are: const `NC_BYTE`, `NC_CHAR`, `NC_SHORT`, `NC_INT`, `NC_FLOAT`, `NC_LONG`, `NC_DOUBLE`
- **mode** file creation mode, only valid when new file is created, choose one of: `NC_NETCDF4`, `NC_CLASSIC_MODEL`, `NC_64BIT_OFFSET`
"""
function nccreate(
    fil::AbstractString,
    varname::AbstractString,
    dims...;
    atts::Dict = Dict{Any,Any}(),
    gatts::Dict = Dict{Any,Any}(),
    compress::Integer = -1,
    t::Union{DataType,Integer} = NC_DOUBLE,
    mode::UInt16 = NC_NETCDF4,
    chunksize = (0,),
)
  # Checking dims argument for correctness
    dim = parsedimargs(dims)
  # Check chunksize
    chunksize = chunksize[1] == 0 ? ntuple(i -> 0, length(dim)) : chunksize
  # create the NcVar object
    v = NcVar(varname, dim, atts = atts, compress = compress, t = t, chunksize = chunksize)
  # Test if the file already exists
    if isfile(fil)
        nc = open(fil, mode = NC_WRITE) do nc
            v.ncid = nc.ncid
            v.ncfile = nc
            haskey(
                nc.vars,
                varname,
            ) && error("Variable $varname already exists in file $fil")
      # Check if dimensions exist, if not, create
      # Remember if dimension was created

            dcreate = falses(length(dim))
            for i = 1:length(dim)
                if !haskey(nc.dim, dim[i].name)
                    create_dim(nc, dim[i])
                    v.dimids[i] = dim[i].dimid
                    if length(dim[i].vals) > 0
                        elt = eltype(dim[i].vals)
                        create_var(
                            nc,
                            NcVar{elt,1,jl2nc(elt)}(
                                nc.ncid,
                                0,
                                1,
                                length(dim[i].atts),
                                jl2nc(elt),
                                dim[i].name,
                                [dim[i].dimid],
                                [dim[i]],
                                dim[i].atts,
                                -1,
                                (0,),
                                nc,
                            ),
                            mode,
                        )
                    end
                    dcreate[i] = true
                else
                    v.dimids[i] = nc.dim[dim[i].name].dimid
                    v.dim[i] = nc.dim[dim[i].name]
                    dcreate[i] = false
                end
            end

      # Create variable
            create_var(nc, v, mode)
            nc_enddef(nc)
            for i = 1:length(dim)
                if dcreate[i] & !isempty(dim[i].vals)
                    ncwrite(dim[i].vals, fil, dim[i].name)
                end
            end
        end
    else
        create(fil, v, gatts = gatts, mode = mode | NC_NOCLOBBER) do nc
          for d in dim
            !isempty(d.vals) && ncwrite(d.vals, fil, d.name)
          end
        end
    end
    return nothing
end

#show{T<:Any,N}(io::IO,a::NcVar{T,N})=println(io,a.name)
#showcompact{T<:Any,N}(io::IO,a::NcVar{T,N})=println(io,a.name)
function show(io::IO, nc::NcFile)
    nrow, ncol = Base.displaysize(io)
    hline = repeat("-", ncol)
    l1 = div(ncol, 3)
    l2 = 2 * l1
    println(io, "")
    println(io, "##### NetCDF File #####")
    println(io, "")
    println(io, nc.name)
    println(io, "")
    println(io, "##### Dimensions #####")
    println(io, "")
    println(io, tolen("Name", l2), tolen("Length", l1))
    println(io, hline)
    for d in nc.dim
        println(
            io,
            tolen(d[2].name, l2),
            tolen(
                d[2].unlim ? string("UNLIMITED (", d[2].dimlen, " currently)") :
                d[2].dimlen,
                l1,
            ),
        )
    end
    l1 = div(ncol, 5)
    l2 = 2 * l1
    println(io, "")
    println(io, "##### Variables #####")
    println(io, "")
    println(io, tolen("Name", l2), tolen("Type", l1), tolen("Dimensions", l2))
    println(io, hline)
    for v in nc.vars
        s1 = string(tolen(v[2].name, l2))
        s2 = string(tolen(nctype2string[Int(v[2].nctype)], l1))
        s3 = ""
        for d in v[2].dim
            s3 = string(s3, d.name, " ")
        end
        println(io, s1, s2, tolen(s3, l2))
    end
    l1 = div(ncol, 4)
    l2 = 2 * l1
    println(io, "")
    println(io, "##### Attributes #####")
    println(io, "")
    println(io, tolen("Variable", l1), tolen("Name", l1), tolen("Value", l2))
    println(io, hline)
    for a in nc.gatts
        println(io, tolen("global", l1), tolen(a[1], l1), tolen(a[2], l2))
    end
    for v in nc.vars
        for a in v[2].atts
            println(io, tolen(v[2].name, l1), tolen(a[1], l1), tolen(a[2], l2))
        end
    end
end

tolen(s::Any, l::Number) = tolen(string(s), round(Int, l))
function tolen(s::AbstractString, l::Integer)
    ls = length(s)
    if ls < l
        return rpad(s, l)
    elseif ls > l
        return string(s[1:prevind(s, l - 1)], "..")
    else
        return s
    end
end
function tolen(s::Array{String,1}, l::Number)
    cs = "["
    for se in s
        cs *= string(se, ", ")
    end
    cs = isempty(s) ? string(cs, ']') : string(cs[1:end-2], ']')
    return tolen(cs, l)
end


end # Module
