jltype2nctype=@Compat.Dict(Int8=>NC_BYTE,
	               Int16=>NC_SHORT,
                   Int32=>NC_INT,
                   Int64=>NC_LONG,
                   Float32=>NC_FLOAT,
                   Float64=>NC_DOUBLE)



# These are some helper functions that automatically 
# First we define some constant arrays that are placeholders for pointers in ccall functions
const error_description=
     [int32(-33)=> "Not a netcdf id",
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
     int32(-64)=> "File likely truncated or possibly corrupted"]

const ida          = zeros(Int32,1)
const namea        = zeros(Uint8,NC_MAX_NAME+1)
const lengtha      = zeros(Int32,1)
const dimida       = zeros(Int32,1)
const ndima        = zeros(Int32,1)
const nvara        = zeros(Int32,1)
const ngatta       = zeros(Int32,1)
const nunlimdimida = zeros(Int32,1)
const typea        = zeros(Int32,1)
const nvals        = zeros(Int32,1)
const int8a        = zeros(Int8,1)
const int16a       = zeros(Int16,1)
const int32a       = zeros(Int32,1)
const int64a       = zeros(Int64,1)
const float32a     = zeros(Float32,1)
const float64a     = zeros(Float64,1)

function nc_open(fname::String,omode::Uint16)
    # Function to open file fname, returns a NetCDF file ID
    ret=nc_open(fname,omode,ida)
    ret!=0 && error("NetCDF error when opening file $fname: $(error_description[ret])")
    NC_VERBOSE ? println("Successfully opened ",fname," dimid=",id) : nothing
    return ida[1]
end

function nc_inq_dim(id::Integer,idim::Integer)
    # File to inquire dimension idimm returns dimension name and length
    nc_inq_dim(id,idim,namea,lengtha)
    name=bytestring(convert(Ptr{Uint8}, namea))
    dimlen=lengtha[1]
    NC_VERBOSE ? println("name=",name," dimlen=",dimlen) : nothing
    return (name,dimlen)
end

function nc_inq_dimid(id::Integer,name::String)
    # Function to read dimension id for a given function name, returns -1 if no such dimension exists 
    # TODO: this should be changed  
    ret = NetCDF.nc_inq_dimid(id,name,dimida)
    if ret<0
        dimida[1]=-1
    end
    NC_VERBOSE ? println("Successfully read from file") : nothing
    return dimida[1]
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

function nc_inq_att(ncid::Integer,varid::Integer,attnum::Integer)
    #Reads attribute name, type and number of values
    name=nc_inq_attname(ncid,varid,attnum)
    nc_inq_att(ncid,varid,name,typea,nvals)
    attype=typea[1]
    NC_VERBOSE ? println("Successfully read attribute type and number of vals") : nothing
    NC_VERBOSE ? println("atttype=",typea[1]," nvals=",nvals[1]) : nothing
    text=_nc_get_att(ncid,varid,name,typea[1],nvals[1])
    return (name,text)
end

#Define methods for different input array types
nc_put_att(ncid::Integer,varid::Integer,name::String,val::Array{Int8})    = nc_put_att_byte(ncid,varid,name,NC_BYTE,length(val),val)
nc_put_att(ncid::Integer,varid::Integer,name::String,val::Array{Int16})   = nc_put_att_short(ncid,varid,name,NC_SHORT,length(val),val)
nc_put_att(ncid::Integer,varid::Integer,name::String,val::Array{Int32})   = nc_put_att_int(ncid,varid,name,NC_INT,length(val),val)
nc_put_att(ncid::Integer,varid::Integer,name::String,val::Array{Int64})   = nc_put_att_long(ncid,varid,name,NC_LONG,length(val),val)
nc_put_att(ncid::Integer,varid::Integer,name::String,val::Array{Float32}) = nc_put_att_float(ncid,varid,name,NC_FLOAT,length(val),val)
nc_put_att(ncid::Integer,varid::Integer,name::String,val::Array{Float64}) = nc_put_att_double(ncid,varid,name,NC_DOUBLE,length(val),val)
nc_put_att(ncid::Integer,varid::Integer,name::String,val::String)         = nc_put_att_text(ncid,varid,name,NC_CHAR,length(val)+1,val)
nc_put_att(ncid::Integer,varid::Integer,name::String,val::Array{Any})     = error("Writing attribute array of type Any is not possible") 

nc_put_att(ncid::Integer,varid::Integer,name::String,val::Int8) = begin int8a[1] = val; nc_put_att(ncid,varid,name,int8a) end
nc_put_att(ncid::Integer,varid::Integer,name::String,val::Int16) = begin int16a[1] = val; nc_put_att(ncid,varid,name,int16a) end
nc_put_att(ncid::Integer,varid::Integer,name::String,val::Int32) = begin int32a[1] = val; nc_put_att(ncid,varid,name,int32a) end
nc_put_att(ncid::Integer,varid::Integer,name::String,val::Int64) = begin int64a[1] = val; nc_put_att(ncid,varid,name,int64a) end
nc_put_att(ncid::Integer,varid::Integer,name::String,val::Float32) = begin float32a[1] = val; nc_put_att(ncid,varid,name,float32a) end
nc_put_att(ncid::Integer,varid::Integer,name::String,val::Float64) = begin float64a[1] = val; nc_put_att(ncid,varid,name,float64a) end
nc_put_att(ncid::Integer,varid::Integer,name::String,val) = error("Writing attribute of type $(typeof(val)) is currently not possible.") 




function _nc_get_att(ncid::Integer,varid::Integer,name,attype::Integer,attlen::Integer)
  if (attype==NC_CHAR)
    valsa=Array(Uint8,attlen)
    _nc_get_att_text_c(ncid,varid,name,valsa)
    valsa=bytestring(valsa)
  elseif (attype==NC_SHORT)
    valsa=Array(Int16,attlen)
    _nc_get_att_short_c(ncid,varid,name,valsa)
  elseif (attype==NC_INT)
    valsa=Array(Int32,attlen)
    _nc_get_att_int_c(ncid,varid,name,valsa)
  elseif (attype==NC_LONG)
    valsa=Array(Int64,attlen)
    _nc_get_att_long_c(ncid,varid,name,valsa)
  elseif (attype==NC_FLOAT)
    valsa=Array(Float32,attlen)
    _nc_get_att_float_c(ncid,varid,name,valsa)
  elseif (attype==NC_DOUBLE)
    valsa=Array(Float64,attlen)
    _nc_get_att_double_c(ncid,varid,name,valsa)
  elseif (attype==NC_BYTE)
    valsa=Array(Int8,attlen)
    _nc_get_att_byte_c(ncid,varid,name,valsa)
  else
    valsa="Could not read attribute, currently unsupported datatype by the netcdf package"
  end
  return valsa
end

function _ncv_inq(nc::NcFile,varid::Integer)
  id=nc.ncid
  ndim=length(nc.dim)
  # Inquire variables in the file
  namea=Array(Uint8,NC_MAX_NAME+1);xtypea=Array(Int32,1);ndimsa=Array(Int32,1);dimida=Array(Int32,ndim);natta=Array(Int32,1)
  _nc_inq_var_c(id,varid,namea,xtypea,ndimsa,dimida,natta)
  NC_VERBOSE ? println("dimida=",dimida," ndimsa=",ndimsa) : nothing
  nctype=xtypea[1]
  vndim=ndimsa[1]
  dimids=vndim>0 ? dimida[1:vndim] : []
  natts=natta[1]
  NC_VERBOSE ? println("Successfully read from file") : nothing
  name=bytestring(convert(Ptr{Uint8}, namea))
  isdimvar=false
  for n in nc.dim
    if (n[2].name==name)
      isdimvar=true
      break
    end
  end
  NC_VERBOSE ? println("name=",name," nctype=",nctype," dimids=",dimids," natts=",natts," vndim=",vndim) : nothing
  return (name,nctype,dimids,natts,vndim,isdimvar)
end

function _getvarindexbyname(nc::NcFile,varname::String)
  va=nothing
  for v in nc.vars
    va = v[2].name==varname ? v[2] : va
  end
  return va
end

function getvarbyid(nc::NcFile,varid::Integer)
  va=nothing
  for v in nc.vars
    va = v[2].varid==varid ? v[2] : va
  end
  return va
end

function getdimidbyname(nc::NcFile,dimname::String)
  da=nothing
  for d in nc.dim
    da = d.name==dimname ? d : da
  end
  return da.dimid
end

function getdimnamebyid(nc::NcFile,dimid::Integer)
  da=nothing
  for d in nc.dim
    da = d[2].dimid==dimid ? d[2] : da
  end
  return da.name
end

function _readdimdvar(ncid::Integer,dim::NcDim)
  start=0
  p=dim.dimlen
  #Determine size of Array
  retvalsa=Array(Float64,p)
  _nc_get_vara_double_c(ncid,varid,start,count,retvalsa)
  NC_VERBOSE ? println("Successfully read dimension from file ",dim.name) : nothing
  dim.vals=retvalsa
  end

function _nc_getatts_all(ncid::Integer,varid::Integer,natts::Integer)
  atts=Dict{Any,Any}()
  for attnum=0:natts-1
    gatt=_nc_inq_att(ncid,varid,attnum)
    v=gatt[2]
    if ((length(v)==1) & !(typeof(v)<:String))
      v=v[1]
    end
    atts[gatt[1]]=v
  end
  NC_VERBOSE ? println(atts) : nothing
  return atts
end

function _readdimvars(nc::NcFile)
  for d in nc.dim
    for v in nc.vars
      if (d[2].name==v[2].name)
        NC_VERBOSE ?println(d[2].name," ",v[2].name) : nothing
        d[2].vals=readvar(nc,v[2].name)
        d[2].atts=v[2].atts
      end
    end
  end
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
