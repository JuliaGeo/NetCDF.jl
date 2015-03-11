


# These are some helper functions that automatically 
# First we define some constant arrays that are placeholders for pointers in ccall functions
const error_description=
     @Compat.Dict(int32(-33)=> "Not a netcdf id",
     int32(-34)=> "Too many netcdfs open",
     int32(-35)=> "netcdf file exists && NC_NOCLOBBER",
     int32(-36)=> "Invalid Argument",
     int32(-37)=> "Write to read only",
     int32(-38)=> "Operation not allowed in data mode",
     int32(-39)=> "Operation not allowed in define mode",
     int32(-40)=> "Index exceeds dimension bound",
     int32(-41)=> "NC_MAX_DIMS exceeded",
     int32(-42)=> "String match to name in use",
     int32(-43)=> "Attribute not found",
     int32(-44)=> "NC_MAX_ATTRS exceeded",
     int32(-45)=> "Not a netcdf data type",
     int32(-46)=> "Invalid dimension id or name",
     int32(-47)=> "NC_UNLIMITED in the wrong index",
     int32(-48)=> "NC_MAX_VARS exceeded",
     int32(-49)=> "Variable not found",
     int32(-50)=> "Action prohibited on NC_GLOBAL varid",
     int32(-51)=> "Not a netcdf file",
     int32(-52)=> "In Fortran, string too short",
     int32(-53)=> "NC_MAX_NAME exceeded",
     int32(-54)=> "NC_UNLIMITED size already in use",
     int32(-55)=> "nc_rec op when there are no record vars",
     int32(-56)=> "Attempt to convert between text & numbers",
     int32(-57)=> "Edge+start exceeds dimension bound",
     int32(-58)=> "Illegal stride",
     int32(-59)=> "Attribute or variable name contains illegal characters",
     int32(-60)=> "Math result not representable",
     int32(-61)=> "Memory allocation (malloc) failure",
     int32(-62)=> "One or more variable sizes violate format constraints",
     int32(-63)=> "Invalid dimension size",
     int32(-64)=> "File likely truncated or possibly corrupted")

const funext = [  (Float64, "double","float64a"),
            (Float32, "float","float32a"),
            (Int32  , "int","int32a"),
            (Uint8  , "text","uint8a"),
            (Int8   , "schar","int8a"),
            (ASCIIString, "text","uint8a")]

const ida          = zeros(Int32,1)
const namea        = zeros(Uint8,NC_MAX_NAME+1)
const lengtha      = zeros(Csize_t,1)
const dimida       = zeros(Int32,NC_MAX_VAR_DIMS)
const ndima        = zeros(Int32,1)
const nvara        = zeros(Int32,1)
const ngatta       = zeros(Int32,1)
const nunlimdimida = zeros(Int32,1)
const typea        = zeros(Int32,1)
const natta        = zeros(Int32,1)
const nvals        = zeros(Csize_t,1)
const int8a        = zeros(Int8,1)
const int16a       = zeros(Int16,1)
const int32a       = zeros(Int32,1)
const int64a       = zeros(Int64,1)
const uint8a       = zeros(Uint8,1)
const float32a     = zeros(Float32,1)
const float64a     = zeros(Float64,1)
const dima         = zeros(Int32,1)
const varida       = zeros(Int32,1)
const vara         = zeros(Int32,1);
const dumids       = zeros(Int32,NC_MAX_DIMS)
const gstart       = zeros(Uint,NC_MAX_DIMS)
const gcount       = zeros(Uint,NC_MAX_DIMS)

#for (t,ending) in funext
#    vname = symbol("ret_$ending")
#    @eval const $vname = zeros($t,1)
#end

function nc_open(fname::String,omode::Uint16)
    # Function to open file fname, returns a NetCDF file ID
    nc_open(fname,omode,ida)
    return ida[1]
end

function nc_create(name,mode)
    nc_create(name,mode,ida);
    return ida[1]
end

function nc_inq_dim(id::Integer,idim::Integer)
    # File to inquire dimension idimm returns dimension name and length
    nc_inq_dim(id,idim,namea,lengtha)
    name=bytestring(convert(Ptr{Uint8}, namea))
    NC_VERBOSE ? println("name=",name," dimlen=",dimlen) : nothing
    return (name,lengtha[1])
end

function nc_inq_dimid(id::Integer,name::String)
    # Function to read dimension id for a given function name
    NetCDF.nc_inq_dimid(id,name,dimida)
    NC_VERBOSE ? println("Successfully read from file") : nothing
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
  nc_inq(id,ndima,nvara,ngatta,nunlimdimida)
  NetCDF.NC_VERBOSE ? println("Successfully read from file") : nothing
  NetCDF.NC_VERBOSE ? println("ndim=",ndim," nvar=",nvar," ngatt=",ngatt," numlimdimid=",nunlimdimid) : nothing
  return (ndima[1],nvara[1],ngatta[1],nunlimdimida[1])
end


function nc_inq_attname(ncid::Integer,varid::Integer,attnum::Integer)
  # Get attribute name from attribute number
  nc_inq_attname(ncid,varid,attnum,namea)
  name=bytestring(convert(Ptr{Uint8}, namea))
  NC_VERBOSE ? println("Successfully read attribute name $name") : nothing
  return name
end

function nc_get_att(ncid::Integer,varid::Integer,attnum::Integer)
    #Reads attribute name, type and number of values
    name=nc_inq_attname(ncid,varid,attnum)
    nc_inq_att(ncid,varid,name,typea,nvals)
    text=nc_get_att(ncid,varid,name,typea[1],nvals[1])
    return (name,text)
end

#Define methods for writing attributes
nc_put_att(ncid::Integer,varid::Integer,name::String,val::Array{Int8})    = nc_put_att_schar(ncid,varid,name,NC_BYTE,length(val),val)
nc_put_att(ncid::Integer,varid::Integer,name::String,val::Array{Int16})   = nc_put_att_short(ncid,varid,name,NC_SHORT,length(val),val)
nc_put_att(ncid::Integer,varid::Integer,name::String,val::Array{Int32})   = nc_put_att_int(ncid,varid,name,NC_INT,length(val),val)
nc_put_att(ncid::Integer,varid::Integer,name::String,val::Array{Int64})   = nc_put_att_long(ncid,varid,name,NC_LONG,length(val),val)
nc_put_att(ncid::Integer,varid::Integer,name::String,val::Array{Float32}) = nc_put_att_float(ncid,varid,name,NC_FLOAT,length(val),val)
nc_put_att(ncid::Integer,varid::Integer,name::String,val::Array{Float64}) = nc_put_att_double(ncid,varid,name,NC_DOUBLE,length(val),val)
nc_put_att(ncid::Integer,varid::Integer,name::String,val::String)         = nc_put_att_text(ncid,varid,name,length(val)+1,val)
nc_put_att(ncid::Integer,varid::Integer,name::String,val::Array{Any})     = error("Writing attribute array of type Any is not possible") 

nc_put_att(ncid::Integer,varid::Integer,name::String,val::Int8) = begin int8a[1] = val; nc_put_att(ncid,varid,name,int8a) end
nc_put_att(ncid::Integer,varid::Integer,name::String,val::Int16) = begin int16a[1] = val; nc_put_att(ncid,varid,name,int16a) end
nc_put_att(ncid::Integer,varid::Integer,name::String,val::Int32) = begin int32a[1] = val; nc_put_att(ncid,varid,name,int32a) end
nc_put_att(ncid::Integer,varid::Integer,name::String,val::Int64) = begin int64a[1] = val; nc_put_att(ncid,varid,name,int64a) end
nc_put_att(ncid::Integer,varid::Integer,name::String,val::Float32) = begin float32a[1] = val; nc_put_att(ncid,varid,name,float32a) end
nc_put_att(ncid::Integer,varid::Integer,name::String,val::Float64) = begin float64a[1] = val; nc_put_att(ncid,varid,name,float64a) end
nc_put_att(ncid::Integer,varid::Integer,name::String,val) = error("Writing attribute of type $(typeof(val)) is currently not possible.") 



function nc_get_att(ncid::Integer,varid::Integer,name::String,attype::Integer,attlen::Integer)

    valsa=Array(nctype2jltype[attype],attlen)
    nc_get_att!(ncid,varid,name,valsa)
end

nc_get_att!(ncid::Integer,varid::Integer,name::String,valsa::Array{Uint8}) = begin nc_get_att_text(ncid,varid,name,valsa); ascii(valsa) end
nc_get_att!(ncid::Integer,varid::Integer,name::String,valsa::Array{Ptr{Uint8}}) = begin nc_get_att_string(ncid,varid,name,valsa); [bytestring(valsa[i]) for i=1:length(valsa)] end
nc_get_att!(ncid::Integer,varid::Integer,name::String,valsa::Array{Int8})  = begin nc_get_att_schar(ncid,varid,name,valsa); valsa end
nc_get_att!(ncid::Integer,varid::Integer,name::String,valsa::Array{Int16})  = begin nc_get_att_short(ncid,varid,name,valsa); valsa end
nc_get_att!(ncid::Integer,varid::Integer,name::String,valsa::Array{Int32})  = begin nc_get_att_int(ncid,varid,name,valsa); valsa end
nc_get_att!(ncid::Integer,varid::Integer,name::String,valsa::Array{Int64})  = begin nc_get_att_long(ncid,varid,name,valsa); valsa end
nc_get_att!(ncid::Integer,varid::Integer,name::String,valsa::Array{Float32})  = begin nc_get_att_float(ncid,varid,name,valsa); valsa end
nc_get_att!(ncid::Integer,varid::Integer,name::String,valsa::Array{Float64})  = begin nc_get_att_double(ncid,varid,name,valsa); valsa end


function nc_inq_var(nc::NcFile,varid::Integer)
  # Inquire variables in the file
  nc_inq_var(nc.ncid,varid,namea,typea,ndima,dimida,natta)
  NC_VERBOSE ? println("dimida=",dimida," ndimsa=",ndima) : nothing
  dimids=ndima[1]>0 ? dimida[1:ndima[1]] : Int32[]
  name=bytestring(convert(Ptr{Uint8}, namea))
  return (name,typea[1],dimids,natta[1],ndima[1],isdimvar(nc,name))
end

#Test if a variable name is also a dimension name
isdimvar(v::NcVar) = v.name==v.dim[1].name ? true : false

function isdimvar(nc::NcFile,name::ASCIIString)
    for n in nc.dim
        if (n[2].name==name)
            return true
        end
    end
    return false
end


function getdimnamebyid(nc::NcFile,dimid::Integer)
    da=""
    for d in nc.dim
        da = d[2].dimid==dimid ? d[2].name : da
    end
    return da
end


function getatts_all(ncid::Integer,varid::Integer,natts::Integer)
  atts=Dict{Any,Any}()
  for attnum=0:natts-1
    attname,attval=nc_get_att(ncid,varid,attnum)
    if ((length(attval)==1) & !(typeof(attval)<:String))
      attval=attval[1]
    end
    atts[attname]=attval
  end
  NC_VERBOSE ? println(atts) : nothing
  return atts
end

function readdimvars(nc::NcFile)
    for v in nc.vars
        if isdimvar(v[2])
            v[2].dim[1].vals=readvar(nc,v[1])
            d[2].atts=v[2].atts
        end
    end
end

function preparestartcount(start,count,v::NcVar)
    
    length(start) == v.ndim || error("Length of start ($(length(start))) must equal the number of variable dimensions ($(nc.vars[varname].ndim))")
    length(count) == v.ndim || error("Length of start ($(length(count))) must equal the number of variable dimensions ($(nc.vars[varname].ndim))")
    
    p  = one(eltype(gcount))
    nd = length(start)
    
    for i=1:nd
        ci             = nd+1-i
        gstart[ci] = start[i] - 1
        gcount[ci] = count[i] < 0 ? v.dim[i].dimlen - start[i] : count[i]
        gstart[ci] < 0 && error("Start index must not be smaller than 1")
        gstart[ci] + gcount[ci] > v.dim[i].dimlen && error("Start + Count exceeds dimension length in dimension $(nc.vars[varname].dim[i].name)")
        p=p*gcount[ci]
    end
    
    return p
end
    

function parsedimargs(dim)
  idim=0
  dimlen=nothing
  dimvals=nothing
  dimatts=nothing
  name=nothing
  #Determine number of dimensions
  ndim=0
  for a in dim
    if (typeof(a)<:String)
      ndim=ndim+1
    end
    NC_VERBOSE ? println(a) : nothing
  end
  d=Array(NcDim,ndim)
  idim=1
  for a in dim
    NC_VERBOSE ? println(a,idim) : nothing
    if (typeof(a)<:String)
      #Assume a name is given
      #first create an NcDim object from the last dim
      if (name!=nothing)
        d[idim]=finalizedim(dimlen,dimvals,dimatts,name)
        idim=idim+1
        dimlen=nothing
        dimvals=nothing
        dimatts=nothing
        name=nothing
      end
      name=a
    elseif (typeof(a)<:Integer)
      #Assume a dimension length is given
      dimlen=a
    elseif (typeof(a)<:AbstractArray)
      #Assume dimension values are given
      if dimvals==nothing
        dimvals=float64(a)
        dimlen=length(dimvals)
      else
        error ("Dimension values of $name defined more than once")
      end
    elseif (typeof(a)<:Dict)
      #Assume attributes are given
      dimatts= dimatts==nothing ? a : error("Dimension attributes of $name defined more than once")
    end
  end
  d[idim]=finalizedim(dimlen,dimvals,dimatts,name)
  return(d)
end

function finalizedim(dimlen,dimvals,dimatts,name)
  if ((dimlen==nothing) & (dimvals==nothing))
    dimlen=1
  end
  if ((dimlen!=nothing) & (dimvals==nothing))
    dimvals=float64([1:dimlen])
  end
  if (dimatts==nothing)
    dimatts=@Compat.AnyDict("missval"=>-9999)
  end
  return(NcDim(name,dimvals,dimatts))
end
