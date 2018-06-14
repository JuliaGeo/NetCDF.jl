import StaticArrays: MVector

"Exception type for error thrown by the NetCDF library"
mutable struct NetCDFError <: Exception
    code::Cint
    msg::String
end

"Construct a NetCDFError from the error code"
NetCDFError(code::Cint) = NetCDFError(code, unsafe_string(nc_strerror(code)))

function Base.showerror(io::IO, err::NetCDFError)
    print(io, "NetCDF error code $(err.code):\n\t$(err.msg)")
end

"Check the NetCDF error code, raising an error if nonzero"
function check(code::Cint)
    # zero means success, return
    if code == Cint(0)
        return
    # otherwise throw an error message
    else
        throw(NetCDFError(code))
    end
end

const funext = [
    (Float64, "double", "float64a"),
    (Float32, "float", "float32a"),
    (Int32,   "int", "int32a"),
    (UInt8,   "uchar", "uint8a"),
    (Int8,    "schar", "int8a"),
    (Int16,   "short", "int16a"),
    (Int64,   "longlong", "int64a")]

# const ida          = zeros(Int32,1)
# const namea        = zeros(UInt8,NC_MAX_NAME+1)
# const lengtha      = zeros(Csize_t,1)
# const dimida       = zeros(Int32,NC_MAX_VAR_DIMS)
# const chunk_sizea  = zeros(Csize_t,NC_MAX_VAR_DIMS)
# const storagep     = zeros(Int32,1)
# const ndima        = zeros(Int32,1)
# const nvara        = zeros(Int32,1)
# const ngatta       = zeros(Int32,1)
# const nunlimdimida = zeros(Int32,1)
# const typea        = zeros(Int32,1)
# const natta        = zeros(Int32,1)
# const nvals        = zeros(Csize_t,1)
# const dima         = zeros(Int32,1)
# const varida       = zeros(Int32,1)
# const vara         = zeros(Int32,1)
# const dumids       = zeros(Int32,NC_MAX_DIMS)
# const gstart       = zeros(UInt,NC_MAX_DIMS)
# const gcount       = zeros(UInt,NC_MAX_DIMS)

# for (t,ending,aname) in funext
#     @eval const $(Symbol(aname)) = zeros($t,1)
# end

"""
    nc_char2string(x::Array{UInt8})

Convert a `UInt8` array read from a NetCDF variable of type `NC_CHAR` to a Julia array of Strings
"""
function nc_char2string(x::Array{UInt8})
    y = copy(x)
    y[end,:] .= 0
    squeeze(mapslices(i -> unsafe_string(pointer(i)), y, 1), dims=1)
end

"""
    nc_string2char(x::Array{String})

Convert a Julia `String` array to an `Array{UInt8}` so that it can be written to a
NetCDF variable of type `NC_CHAR`.
"""
function nc_string2char(s::Array{String})
    maxlen=maximum(length(i) for i in s)
    c = zeros(UInt8,maxlen+1,size(s)...)
    offs=1
    for i=1:length(s)
        copyto!(c,offs,s[i],1)
        offs+=maxlen+1
    end
    c
end

function nc_open(fname::AbstractString,omode::UInt16)
    # Function to open file fname, returns a NetCDF file ID
    ida=MVector{1,Int32}()
    nc_open(fname,omode,ida)
    return ida[1]
end

function nc_create(name,mode)
  ida=MVector{1,Int32}()
  nc_create(name,mode,ida);
  return ida[1]
end

function nc_inq_dim(id::Integer,idim::Integer)
  # File to inquire dimension idimm returns dimension name and length
  namea = MVector{NC_MAX_NAME+1,UInt8}()
  lengtha = MVector{1,Csize_t}()
  nc_inq_dim(id,idim,namea,lengtha)
  namea[end]=0
  name=unsafe_string(pointer(namea))
  return (name,lengtha[1])
end

function nc_inq_dimid(id::Integer,name::AbstractString)
    # Function to read dimension id for a given function name
    dimida = MVector{1,Cint}
    NetCDF.nc_inq_dimid(id,name,dimida)
    return dimida[1]
end

function nc_redef(nc::NcFile)
    if (!nc.in_def_mode)
        nc_redef(nc.ncid)
        nc.in_def_mode=true
    end
end

function nc_enddef(nc::NcFile)
    if nc.in_def_mode
        nc_enddef(nc.ncid)
        nc.in_def_mode=false
    end
end


function nc_inq(id::Integer)
  # Inquire NetCDF file, return number of dims, number of variables, number of global attributes and number of unlimited dimensions
  ndima,nvara,ngatta,nunlimdimida = MVector{1,Cint}(),MVector{1,Cint}(),MVector{1,Cint}(),MVector{1,Cint}()
  nc_inq(id,ndima,nvara,ngatta,nunlimdimida)
  return (ndima[1],nvara[1],ngatta[1],nunlimdimida[1])
end


function nc_inq_attname(ncid::Integer, varid::Integer, attnum::Integer)
    # Get attribute name from attribute number
    namea = MVector{NC_MAX_NAME+1,UInt8}()
    nc_inq_attname(ncid,varid,attnum,namea)
    namea[end] = 0
    name = unsafe_string(pointer(namea))
    return name
end

function nc_get_att(ncid::Integer, varid::Integer, attnum::Integer)
    #Reads attribute name, type and number of values
    name = nc_inq_attname(ncid,varid,attnum)
    typea = MVector{1,Cint}()
    nvals = MVector{1,Csize_t}()
    nc_inq_att(ncid,varid,name,typea,nvals)
    text = nc_get_att(ncid,varid,string(name),typea[1],nvals[1])
    return name, text
end

#Define methods for writing attributes
nc_put_att(ncid::Integer,varid::Integer,name::AbstractString,val::Int8)    = nc_put_att_schar(ncid,varid,name,NC_BYTE,1,Ref(val))
nc_put_att(ncid::Integer,varid::Integer,name::AbstractString,val::Int16)   = nc_put_att_short(ncid,varid,name,NC_SHORT,1,Ref(val))
nc_put_att(ncid::Integer,varid::Integer,name::AbstractString,val::Int32)   = nc_put_att_int(ncid,varid,name,NC_INT,1,Ref(val))
nc_put_att(ncid::Integer,varid::Integer,name::AbstractString,val::Int64)   = nc_put_att_long(ncid,varid,name,NC_LONG,1,Ref(val))
nc_put_att(ncid::Integer,varid::Integer,name::AbstractString,val::Float32) = nc_put_att_float(ncid,varid,name,NC_FLOAT,1,Ref(val))
nc_put_att(ncid::Integer,varid::Integer,name::AbstractString,val::Float64) = nc_put_att_double(ncid,varid,name,NC_DOUBLE,1,Ref(val))

nc_put_att(ncid::Integer,varid::Integer,name::AbstractString,val::Vector{Int8})    = nc_put_att_schar(ncid,varid,name,NC_BYTE,length(val),val)
nc_put_att(ncid::Integer,varid::Integer,name::AbstractString,val::Vector{Int16})   = nc_put_att_short(ncid,varid,name,NC_SHORT,length(val),val)
nc_put_att(ncid::Integer,varid::Integer,name::AbstractString,val::Vector{Int32})   = nc_put_att_int(ncid,varid,name,NC_INT,length(val),val)
nc_put_att(ncid::Integer,varid::Integer,name::AbstractString,val::Vector{Int64})   = nc_put_att_long(ncid,varid,name,NC_LONG,length(val),val)
nc_put_att(ncid::Integer,varid::Integer,name::AbstractString,val::Vector{Float32}) = nc_put_att_float(ncid,varid,name,NC_FLOAT,length(val),val)
nc_put_att(ncid::Integer,varid::Integer,name::AbstractString,val::Vector{Float64}) = nc_put_att_double(ncid,varid,name,NC_DOUBLE,length(val),val)

# nc_put_att(ncid::Integer,varid::Integer,name::AbstractString,val::Int8) = begin int8a = MVector{1,Int8}(val); nc_put_att(ncid,varid,name,int8a) end
# nc_put_att(ncid::Integer,varid::Integer,name::AbstractString,val::Int16) = begin int16a = MVector{1,Int16}(val); nc_put_att(ncid,varid,name,int16a) end
# nc_put_att(ncid::Integer,varid::Integer,name::AbstractString,val::Int32) = begin int32a = MVector{1,Int32}(val); nc_put_att(ncid,varid,name,int32a) end
# nc_put_att(ncid::Integer,varid::Integer,name::AbstractString,val::Int64) = begin int64a = MVector{1,Int8}(val); nc_put_att(ncid,varid,name,int64a) end
# nc_put_att(ncid::Integer,varid::Integer,name::AbstractString,val::Float32) = begin float32a = MVector{1,Int8}(val); nc_put_att(ncid,varid,name,float32a) end
# nc_put_att(ncid::Integer,varid::Integer,name::AbstractString,val::Float64) = begin float64a = MVector{1,Int8}(val); nc_put_att(ncid,varid,name,float64a) end
# nc_put_att(ncid::Integer,varid::Integer,name::AbstractString,val) = error("Writing attribute of type $(typeof(val)) is currently not possible.")

function nc_put_att(ncid::Integer,varid::Integer,name::AbstractString,val::AbstractString)
    val = string(val)
    len = sizeof(val)
    nc_put_att_text(ncid,varid,name,len+1,val)
end

function nc_get_att(ncid::Integer,varid::Integer,name::AbstractString,attype::Integer,attlen::Integer)
    if attype == NC_CHAR
        valsa = zeros(UInt8,attlen+1)
        nc_get_att_text(ncid,varid,name,valsa)
        valsa[end] = 0
        return unsafe_string(pointer(valsa))
    else
        valsa = Array{nctype2jltype[attype]}(undef,attlen)
        return nc_get_att!(ncid,varid,name,valsa)
    end
end

nc_get_att!(ncid::Integer,varid::Integer,name::AbstractString,valsa::Array{UInt8}) = begin nc_get_att_ubyte(ncid,varid,name,valsa);valsa end
nc_get_att!(ncid::Integer,varid::Integer,name::AbstractString,valsa::Array{Int8})  = begin nc_get_att_schar(ncid,varid,name,valsa); valsa end
nc_get_att!(ncid::Integer,varid::Integer,name::AbstractString,valsa::Array{Int16})  = begin nc_get_att_short(ncid,varid,name,valsa); valsa end
nc_get_att!(ncid::Integer,varid::Integer,name::AbstractString,valsa::Array{Int32})  = begin nc_get_att_int(ncid,varid,name,valsa); valsa end
nc_get_att!(ncid::Integer,varid::Integer,name::AbstractString,valsa::Array{Int64})  = begin nc_get_att_long(ncid,varid,name,valsa); valsa end
nc_get_att!(ncid::Integer,varid::Integer,name::AbstractString,valsa::Array{Float32})  = begin nc_get_att_float(ncid,varid,name,valsa); valsa end
nc_get_att!(ncid::Integer,varid::Integer,name::AbstractString,valsa::Array{Float64})  = begin nc_get_att_double(ncid,varid,name,valsa); valsa end

function nc_get_att!(ncid::Integer,varid::Integer,name::AbstractString,valsa::Array{T,N}) where {T<:AbstractString,N}
  #Assert that length of the attribute matches length of output
  lengtha = MVector{1,Csize_t}()
  nc_inq_attlen(ncid, varid, name, lengtha)
  @assert lengtha[1]==length(valsa)
  valsa_c = Array{Ptr{UInt8}}(undef,length(valsa))
  nc_get_att_string(ncid,varid,name,valsa_c)
  for i = 1:length(valsa)
    valsa[i] = unsafe_string(valsa_c[i])
  end
  nc_free_string(length(valsa_c),valsa_c)
  valsa
end

function nc_inq_var(nc::NcFile,varid::Integer)
    # Inquire variables in the file
    namea = MVector{NC_MAX_NAME+1,UInt8}()
    typea = MVector{1,Cint}()
    ndima = MVector{1,Cint}()
    dimida= MVector{NC_MAX_VAR_DIMS,Int32}()
    natta = MVector{1,Cint}()
    nc_inq_var(nc.ncid,varid,namea,typea,ndima,dimida,natta)
    dimids = ndima[1] > 0 ? dimida[1:ndima[1]] : Int32[]
    namea[end] = 0
    name = unsafe_string(pointer(namea))
    #Find out chunks
    storagep = MVector{1,Cint}()
    chunk_sizea = MVector{NC_MAX_VAR_DIMS,Csize_t}()
    nc_inq_var_chunking(nc.ncid,varid,storagep,chunk_sizea)
    chunksize=storagep[1] == NC_CONTIGUOUS ? ntuple(i->0,ndima[1]) : ntuple(i->chunk_sizea[i],ndima[1])
    return name, typea[1], dimids, natta[1], ndima[1], isdimvar(nc,name), chunksize
end

#Test if a variable name is also a dimension name
isdimvar(v::NcVar) = v.name == v.dim[1].name ? true : false

function isdimvar(nc::NcFile,name::AbstractString)
    for n in nc.dim
        if n[2].name==name
            return true
        end
    end
    return false
end


function getdimnamebyid(nc::NcFile,dimid::Integer)
    da = ""
    for d in nc.dim
        da = d[2].dimid == dimid ? d[2].name : da
    end
    return da
end


function getatts_all(ncid::Integer, varid::Integer, natts::Integer)
    atts = Dict{Any,Any}()
    for attnum = 0:natts-1
        attname, attval = nc_get_att(ncid, varid, attnum)
        if ((length(attval)==1) && !(typeof(attval)<:AbstractString))
            attval = attval[1]
        end
        atts[attname] = attval
    end
    return atts
end

function readdimvars(nc::NcFile)
    for v in nc.vars
        if isdimvar(v[2])
            v[2].dim[1].vals = readvar(nc,v[1])
            d[2].atts = v[2].atts
        end
    end
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

function _readdimvars(nc::NcFile)
    for d in nc.dim
        for v in nc.vars
            if d[2].name == v[2].name
                d[2].vals = readvar(nc,v[2].name)
                d[2].atts = v[2].atts
            end
        end
    end
end

ischunked(v::NcVar) = v.chunksize[1] > 0

defaultstart(v::NcVar) = ones(Int, v.ndim)
defaultcount(v::NcVar) = Int[i for i in size(v)]


function parsedimargs(dim)
    idim = 0
    dimlen = nothing
    dimvals = nothing
    dimatts = nothing
    name = nothing
    d = NcDim[]
    for a in dim
        if isa(a, AbstractString)
            #Assume a name is given
            #first create an NcDim object from the last dim
            if (name != nothing)
                push!(d, finalizedim(dimlen,dimvals,dimatts,name))
                idim = idim+1
                dimlen = nothing
                dimvals = nothing
                dimatts = nothing
                name = nothing
            end
            name = a
        elseif isa(a, Integer)
            #Assume a dimension length is given
            if a > 0
                dimlen = a
            else
                #Assume unlimited dimension
                dimlen = 0
            end
        elseif isa(a, AbstractFloat) && isinf(a)
            #Generate unlimited dimension
            dimlen = 0
        elseif isa(a, AbstractArray)
            #Assume dimension values are given
            if dimvals == nothing
                dimvals = a
                dimlen = length(dimvals)
            else
                error("Dimension values of $name defined more than once")
            end
        elseif isa(a, Dict)
            #Assume attributes are given
            dimatts = dimatts == nothing ? a : error("Dimension attributes of $name defined more than once")
        else
            error("Could not parse argument $a in nccreate")
        end
    end
    push!(d, finalizedim(dimlen,dimvals,dimatts,name))
    return d
end

function finalizedim(dimlen, dimvals, dimatts, name)
    if (dimlen == nothing) && (dimvals == nothing)
        dimlen = 1
    end
    if (dimlen != nothing) && (dimvals == nothing)
        dimvals = Float64[]
    end
    if dimatts == nothing
        dimatts = Dict("missval"=>-9999)
    end
    isunlimited = dimlen == 0 ? true : false
    return NcDim(name, dimlen, atts=dimatts, values=dimvals, unlimited=isunlimited)
end

struct NetCDFException <: Exception
  code::Int
end
