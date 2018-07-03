# Define some types to convert missings and to apply scale and offset
abstract type MissingConverter end
struct ApplyMissings{T} <: MissingConverter
  missval::T
  fillval::T
end
getmissval(mc::ApplyMissings)=mc.missval
struct ManualMissings <: MissingConverter end
getmissval(mc::ManualMissings)=error("Write Union array to this variable. Consider opening the file with the replace_missing=true")
function get_replace_object(a::Dict,nctype)
  T = getJLType(nctype)
  missval = get(a,"missing_value",getfill(T))
  fillval = get(a,"_FillValue",getfill(T))
  TV = Union{T,Missing}
  TV,ApplyMissings(convert(T,missval),convert(T,fillval))
end

"""
    NcVar

`NcVar{T,N,M}` represents a NetCDF variable. It is a subtype of AbstractArray{T,N}, so normal indexing using `[]`
will work for reading and writing data to and from a NetCDF file. `NcVar` objects are returned by `NetCDF.open`, by
indexing an `NcFile` object (e.g. `myfile["temperature"]`) or, when creating a new file, by its constructor. The type parameter `M`
denotes the NetCDF data type of the variable, which may or may not correspond to the Julia Data Type.
"""
mutable struct NcVar{T,N,M,MC<:MissingConverter} <: AbstractArray{T,N}
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
    mc::MC
end

Base.convert(::Type{NcVar{T,N,M}},v::NcVar{S,N,M}) where {S,T,N,M}=NcVar{T,N,M}(v.ncid,v.varid,v.ndim,v.natts,v.nctype,v.name,v.dimids,v.dim,v.atts,v.compress,v.chunksize,v.mc)
Base.convert(::Type{NcVar{T}},v::NcVar{S,N,M}) where {S,T,N,M}=NcVar{T,N,M}(v.ncid,v.varid,v.ndim,v.natts,v.nctype,v.name,v.dimids,v.dim,v.atts,v.compress,v.chunksize,v.mc)

"""
    NcVar(name::AbstractString,dimin::Union{NcDim,Array{<:NcDim,1}}

Creates a new NetCDF variable `name` in memory. The variable is associated to a
list of NetCDF dimensions specified by `dimin`.

### Keyword arguments

* `atts` Dictionary representing the variables attributes
* `t` either a Julia type, (one of `Int16, Int32, Float32, Float64, String`) or a NetCDF data type (`NC_SHORT, NC_INT, NC_FLOAT, NC_DOUBLE, NC_CHAR, NC_STRING`) determines the data type of the variable. Defaults to -1
* `compress` Integer which sets the compression level of the variable for NetCDF4 files. Defaults to -1 (no compression). Compression levels of 1..9 are valid
"""
function NcVar(name::AbstractString,dimin::Union{NcDim,Array{<:NcDim,1}};
  atts::Dict=Dict{Any,Any}(),
  t::Union{DataType,Integer}=Float64,
  compress::Integer=-1,
  chunksize=ntuple(i->zero(Int32),isa(dimin,NcDim) ? 1 : length(dimin)),
  replace_missings=false)
    dim = isa(dimin,NcDim) ? NcDim[dimin] : dimin
    TV,mc = replace_missings ? get_replace_object(atts,getNCType(t)) : (getJLType(t),ManualMissings())
    return NcVar{TV,length(dim),getNCType(t),typeof(mc)}(-1,-1,length(dim),length(atts), getNCType(t),name,zeros(Int32,length(dim)),dim,atts,compress,chunksize,mc)
end
NcVar(name::AbstractString,dimin::Union{NcDim,Array{<:NcDim,1}},atts,t::Union{DataType,Integer}=Float64) = NcVar(name,dimin,atts=atts,t=t)
close(v::NcVar)=nc_close(v.ncid)

#Array methods
@generated function Base.size(a::NcVar{T,N}) where {T,N}
    :(@ntuple($N,i->Int(a.dim[i].dimlen)))
end
const IndR  = Union{Integer,UnitRange,Colon}
const ArNum = Union{AbstractArray,Number,Missing}

IndexStyle(::NcVar) = IndexCartesian()
Base.getindex(v::NcVar{T,1},i1::IndR) where {T} = readvar(v,i1)
Base.getindex(v::NcVar{T,2},i1::IndR,i2::IndR) where {T} = readvar(v,i1,i2)
Base.getindex(v::NcVar{T,3},i1::IndR,i2::IndR,i3::IndR) where {T} = readvar(v,i1,i2,i3)
Base.getindex(v::NcVar{T,4},i1::IndR,i2::IndR,i3::IndR,i4::IndR) where {T} = readvar(v,i1,i2,i3,i4)
Base.getindex(v::NcVar{T,5},i1::IndR,i2::IndR,i3::IndR,i4::IndR,i5::IndR) where {T} = readvar(v,i1,i2,i3,i4,i5)
Base.getindex(v::NcVar{T,6},i1::IndR,i2::IndR,i3::IndR,i4::IndR,i5::IndR,i6::IndR) where {T} = readvar(v,i1,i2,i3,i4,i5,i6)

Base.setindex!(v::NcVar{T,1},x::ArNum,i1::IndR) where {T} = putvar(v,x,i1)
Base.setindex!(v::NcVar{T,2},x::ArNum,i1::IndR,i2::IndR) where {T} = putvar(v,x,i1,i2)
Base.setindex!(v::NcVar{T,3},x::ArNum,i1::IndR,i2::IndR,i3::IndR) where {T} = putvar(v,x,i1,i2,i3)
Base.setindex!(v::NcVar{T,4},x::ArNum,i1::IndR,i2::IndR,i3::IndR,i4::IndR) where {T} = putvar(v,x,i1,i2,i3,i4)
Base.setindex!(v::NcVar{T,5},x::ArNum,i1::IndR,i2::IndR,i3::IndR,i4::IndR,i5::IndR) where {T} = putvar(v,x,i1,i2,i3,i4,i5)
Base.setindex!(v::NcVar{T,6},x::ArNum,i1::IndR,i2::IndR,i3::IndR,i4::IndR,i5::IndR,i6::IndR) where {T} = putvar(v,x,i1,i2,i3,i4,i5,i6)

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
function readvar(v::NcVar{T,N};start::Vector=defaultstart(v),count::Vector=defaultcount(v)) where {T,N}
    s = [count[i]==-1 ? size(v,i)-start[i]+1 : count[i] for i=1:length(count)]
    retvalsa = zeros(T,s...)
    readvar!(v, retvalsa, start=start, count=count)
    return retvalsa
end

"""
    NetCDF.readvar{T,N}(v::NcVar{T,N},I::Union{Integer, UnitRange, Colon}...)

Reads data from a NetCDF file with array-style indexing. `Integer`s and `UnitRange`s and `Colon`s are valid indices for each dimension.
"""
function readvar(v::NcVar{T,N},I::IndR...) where {T,N}
    count=ntuple(i->counti(I[i],v.dim[i].dimlen),length(I))
    retvalsa = zeros(T,count...)
    readvar!(v, retvalsa, I...)
    return retvalsa
end


# Here are some functions for array-style indexing readvar
#For single indices
@generated function readvar(v::NcVar{T,N},I::Integer...)::T where {T,N}
    N==length(I) || error("Dimension mismatch")
    gstartex = Expr(:vect,[:(Csize_t(I[$(N-i)]-1)) for i=0:(N-1)]...)
    quote
        checkbounds(v,I...)
        gstart = @SVector $gstartex
        nc_get_var1_x(v,gstart)
    end
end

"""
    NetCDF.readvar!(v::NcVar, d::Array;start::Vector=ones(UInt,ndims(d)),count::Vector=size(d))

Reads the values from the file associated to the `NcVar` object `v` into the array `d`. By default the whole variable is read

### Keyword arguments

* `start` Vector of length `ndim(v)` setting the starting index for each dimension
* `count` Vector of length `ndim(v)` setting the count of values to be read along each dimension. The value -1 is treated as a special case to read all values from this dimension

### Example

Assume `v` is a NetCDF variable with dimensions (3,3,10).

    x = zeros(3,1,10)
    NetCDF.readvar(v, x, start=[1,2,1], count=[3,1,-1])

This reads all values from the first and last dimension and only the second value from the second dimension.
"""
function readvar!(v::NcVar, retvalsa::AbstractArray;start::Vector=defaultstart(v),count::Vector=defaultcount(v))

    isa(retvalsa,Array) || Base.iscontiguous(retvalsa) || error("Can only read into contiguous pieces of memory")

    length(start) == v.ndim || error("Length of start ($(length(start))) must equal the number of variable dimensions ($(v.ndim))")
    length(count) == v.ndim || error("Length of start ($(length(count))) must equal the number of variable dimensions ($(v.ndim))")

    gstart,gcount = preparestartcount(start, count, v)

    length(retvalsa) != prod(gcount) && error("Size of output array ($(length(retvalsa))) does not equal number of elements to be read ($p)!")

    nc_get_vara_x!(v, gstart, gcount, retvalsa)

    post_read_proc(v,retvalsa)

    retvalsa
end

post_read_proc(v::NcVar,retvalsa)=nothing
function post_read_proc(v::NcVar{Union{T,Missing}},retvalsa::AbstractArray{Union{T,Missing}}) where T
  missval=getmissval(v.mc)
  @inbounds for i in eachindex(retvalsa)
    retvalsa[i]==missval && (retvalsa[i]=missing)
  end
end


firsti(i::Integer,l::Integer) = i-1
counti(i::Integer,l::Integer) = 1
firsti(r::UnitRange,l::Integer) = first(r)-1
counti(r::UnitRange,l::Integer) = length(r)
firsti(r::Colon,l::Integer) = 0
counti(r::Colon,l::Integer) = Int(l)

# For ranges
"""
    NetCDF.readvar!{T,N}(v::NcVar{T,N},d::AbstractArray, I::Union{Integer, UnitRange, Colon}...)

Reads data from a NetCDF file with array-style indexing and writes them to d. `Integer`s and `UnitRange`s and `Colon`s are valid indices for each dimension.
"""
@generated function readvar!(v::NcVar{T,N}, retvalsa::AbstractArray,I::IndR...) where {T,N}

    N == length(I) || error("Dimension mismatch")
    gstartex = Expr(:vect,[:(Csize_t(firsti(I[$(N-i)],v.dim[$(N-i)].dimlen))) for i=0:(N-1)]...)
    gcountex = Expr(:vect,[:(Csize_t(counti(I[$(N-i)],v.dim[$(N-i)].dimlen))) for i=0:(N-1)]...)
    quote
        checkbounds(v, I...)

        isa(retvalsa, Array) || Base.iscontiguous(retvalsa) || error("Can only read into contiguous pieces of memory")

        gstart = @SVector $gstartex
        gcount = @SVector $gcountex
        p = prod(gcount)
        length(retvalsa) != p && error(string("Size of output array ($(length(retvalsa))) does not equal number of elements to be read (",p,")!"))
        nc_get_vara_x!(v,gstart,gcount,retvalsa)
        post_read_proc(v,retvalsa)
        retvalsa
    end
end


for (t,ending,arname) in funext
    fname = Symbol("nc_get_vara_$ending")
    fname1 = Symbol("nc_get_var1_$ending")
    arsym = Symbol(arname)
    @eval nc_get_vara_x!(v::NcVar{Union{$t,Missing}},start::AbstractVector{UInt},count::AbstractVector{UInt},retvalsa::AbstractArray{Union{$t,Missing}})=$fname(v.ncid,v.varid,start,count,retvalsa)
    @eval nc_get_vara_x!(v::NcVar{$t},start::AbstractVector{UInt},count::AbstractVector{UInt},retvalsa::AbstractArray{$t})=$fname(v.ncid,v.varid,start,count,retvalsa)
    @eval nc_get_var1_x(v::NcVar{$t},start::AbstractVector{UInt})=begin a = MVector{1,$t}(); $fname1(v.ncid,v.varid,start,a); a[1] end
    @eval nc_get_var1_x(v::NcVar{Union{$t,Missing}},start::AbstractVector{UInt})=begin a = MVector{1,$t}(); $fname1(v.ncid,v.varid,start,a); a[1]==getmissval(v.mc) ? missing : a[1] end
end

nc_get_vara_x!(v::NcVar{UInt8,N,NC_CHAR},start::AbstractVector{UInt},count::AbstractVector{UInt},retvalsa::AbstractArray{UInt8}) where {N} =
    nc_get_vara_text(v.ncid,v.varid,start,count,retvalsa)
nc_get_var1_x!(v::NcVar{UInt8,N,NC_CHAR},start::AbstractVector{UInt},retvalsa::AbstractArray{UInt8}) where {N} =
    nc_get_var1_text(v.ncid,v.varid,start,retvalsa)

function nc_get_vara_x!(v::NcVar{String,N,NC_STRING},start::AbstractVector{UInt},count::AbstractVector{UInt},retvalsa::AbstractArray{String}) where N
    @assert length(retvalsa)==prod(view(count,1:N))
    retvalsa_c=fill(Ptr{UInt8}(0),length(retvalsa))
    nc_get_vara_string(v.ncid,v.varid,start,count,retvalsa_c)
    for i=1:length(retvalsa)
        retvalsa[i]=unsafe_string(retvalsa_c[i])
    end
    nc_free_string(length(retvalsa_c),retvalsa_c)
    retvalsa
end

function nc_get_var1_x(v::NcVar{String,N,NC_STRING},start::Vector{UInt}) where N
    retvalsa_c=fill(Ptr{UInt8}(0),1)
    nc_get_var1_string(v.ncid,v.varid,start,retvalsa_c)
    retval=string(retvalsa_c[1])
    nc_free_string(1,retvalsa_c)
    retval
end

function checkboundsNC(v::NcVar{T,N},gstart,gcount) where {T,N}
    nd = N
    for i = 1:nd
        ci = nd + 1 - i
        gstart[ci] < 0 && error("Start index must not be smaller than 1")
        if gstart[ci] + gcount[ci] > v.dim[i].dimlen
            if v.dim[i].unlim
                #Reset length of unlimited dimension
                v.dim[i].dimlen=gstart[ci] + gcount[ci]
            else
                error("Start + Count exceeds dimension length in dimension $(v.dim[i].name)")
            end
        end
        nothing
    end
end

@generated function preparestartcount(start, count, v::NcVar{T,N}) where {T,N}

  gstartex = Expr(:vect,[:(Csize_t(start[$(N-i)]-1)) for i=0:(N-1)]...)
  gcountex = Expr(:vect,[:(Csize_t(count[$(N-i)] < 0 ? v.dim[$(N-i)].dimlen - gstart[$(i+1)] : count[$(N-i)])) for i=0:(N-1)]...)
  quote
    length(start) == v.ndim || error("Length of start ($(length(start))) must equal the number of variable dimensions ($(v.ndim))")
    length(count) == v.ndim || error("Length of start ($(length(count))) must equal the number of variable dimensions ($(v.ndim))")

    gstart = @SVector $gstartex
    gcount = @SVector $gcountex

    checkboundsNC(v,gstart,gcount)

    return gstart,gcount
  end
end

ischunked(v::NcVar) = v.chunksize[1] > 0

defaultstart(v::NcVar) = ones(Int, v.ndim)
defaultcount(v::NcVar) = Int[i for i in size(v)]
fill_missvals(v::NcVar,vals)=nothing
function fill_missvals(v::NcVar,vals::Array{Union{T, Missing}}) where T
  mv = getmissval(v.mc)
  for i in eachindex(vals)
    if ismissing(vals[i])
      vals[i]=mv
      vals[i]=missing
    end
  end
end


"""
    NetCDF.putvar(v::NcVar,vals::Array;start::Vector=ones(Int,length(size(vals))),count::Vector=[size(vals)...])

Writes the values from the array `vals` to a netcdf file. `v` is the NcVar handle of the respective variable and `vals` an array
with the same dimension as the variable in the netcdf file.

### Keyword arguments

* `start` Vector of length `ndim(v)` setting the starting index for each dimension
* `count` Vector of length `ndim(v)` setting the count of values to be read along each dimension. The value -1 is treated as a special case to read all values from this dimension

"""
function putvar(v::NcVar,vals::Array;start::Vector=ones(Int,length(size(vals))),count::Vector=[size(vals)...])
    gstart, gcount = preparestartcount(start, count, v)
    fill_missvals(v,vals)
    nc_put_vara_x(v, gstart, gcount, vals)
end

"""
    NetCDF.putvar(v::NcVar, val, i...)

Writes the value(s) `val` to the variable `v` while the indices are given in in an array-style indexing manner.
"""
@generated function putvar(v::NcVar{T,N},val::Any,I::IndR...) where {T,N}

    N==length(I) || error("Dimension mismatch")
    gstartex = Expr(:vect,[:(Csize_t(firsti(I[$(N-i)],v.dim[$(N-i)].dimlen))) for i=0:(N-1)]...)
    gcountex = Expr(:vect,[:(Csize_t(counti(I[$(N-i)],v.dim[$(N-i)].dimlen))) for i=0:(N-1)]...)
    quote

      gstart = @SVector $gstartex
      gcount = @SVector $gcountex
      checkboundsNC(v,gstart,gcount)
      p=prod(gcount)
      length(val) != p && error(string("Size of output array ($(length(retvalsa))) does not equal number of elements to be read (",p,")!"))
      fill_missvals(v,val)
      nc_put_vara_x(v,gstart,gcount,val)
    end
end

@generated function putvar(v::NcVar{T,N}, val::Any, I::Integer...) where {T,N}

    N == length(I) || error("Dimension mismatch")
    gstartex = Expr(:vect,[:(Csize_t(firsti(I[$(N-i)],v.dim[$(N-i)].dimlen))) for i=0:(N-1)]...)
    quote
      gstart = @SVector $gstartex
      @nall($N,d->((I[d]<=v.dim[d].dimlen && I[d]>0) || v.dim[d].unlim)) || throw(BoundsError(v,I))
      nc_put_var1_x(v,gstart,ismissing(val) ? getmissval(v.mc) : val)
    end

end
import StaticArrays: SArray
for (t, ending, arname) in funext
    fname = Symbol("nc_put_vara_$ending")
    fname1 = Symbol("nc_put_var1_$ending")
    arsym = Symbol(arname)
    @eval nc_put_vara_x(v::NcVar,start::SArray, count::SArray, vals::Array{Union{$t,Missing}}) where {N}=$fname(v.ncid,v.varid,start,count,vals)
    @eval nc_put_vara_x(v::NcVar,start::SArray, count::SArray, vals::Array{$t}) where {N}=$fname(v.ncid,v.varid,start,count,vals)
    @eval nc_put_var1_x(v::NcVar,start::SArray,val::$t) where {N}=begin ar=@SVector [val] ;$fname1(v.ncid,v.varid,start,ar) end
end

nc_put_vara_x(v::NcVar{UInt8,N,NC_CHAR},start::SArray, count::SArray, vals::Array{UInt8}) where {N}=nc_put_vara_text(v.ncid,v.varid,start,count,vals)
nc_put_var1_x(v::NcVar{UInt8,N,NC_CHAR},start::SArray,val::UInt8) where {N}=begin vals=UInt8[val]; nc_put_var1_text(v.ncid,v.varid,start,count,vals) end

function nc_put_vara_x(v::NcVar{String,N,NC_STRING}, start, count,vals::Array{String}) where N
    vals_p = map(x->pointer(x),vals)
    nc_put_vara_string(v.ncid,v.varid,start,count,vals_p)
end

function nc_put_var1_x(v::NcVar{String,N,NC_STRING},start::Vector{UInt},val::String) where N
  val_p = [pointer(val)]
  nc_put_var1_string(v.ncid,v.varid,start,val_p)
end


function Base.push!(v::NcVar,a::AbstractArray)
    sold = size(v)
    N = ndims(v)
    iunlim = find(map(x->x.unlim,v.dim))
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
    NetCDF.putvar(v, a, start=st, count=co)
end

function Base.push!(v::NcVar{T,1}, a::Number) where T
    push!(v, collect(a))
end

function setcompression(v::NcVar,mode)
    if v.compress > -1
        if (NC_NETCDF4 & mode) == 0
            warn("Compression only possible for NetCDF4 file format. Compression will be ingored.")
            v.compress = -1
        else
            v.compress = max(v.compress,9)
            nc_def_var_deflate(v.ncid, v.varid, Int32(1), Int32(1), v.compress);
        end
    end
end

function create_var(nc,v::NcVar{T,N},mode) where {T,N}
  nc_redef(nc)

  v.dimids = Int32[v.dim[i].dimid for i=1:length(v.dim)]
  dumids   = SVector{N,Cint}(reverse(v.dimids))
  vara     = MVector{1,Cint}()
  nc_def_var(nc.ncid,v.name,v.nctype,v.ndim,dumids,vara)
  v.varid=vara[1];
  if v.chunksize[1]>0
    chunk_sizea = SVector{N,Csize_t}(v.chunksize)
    nc_def_var_chunking(nc.ncid, v.varid, NC_CHUNKED, chunk_sizea)
  end
  nc.vars[v.name] = v
  putatt(nc.ncid,v.varid,v.atts)
  setcompression(v,mode)
end
