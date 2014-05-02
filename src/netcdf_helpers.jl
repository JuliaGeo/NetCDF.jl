jltype2nctype={Int8=>NC_BYTE,
	           Int16=>NC_SHORT,
               Int32=>NC_INT,
               Int64=>NC_LONG,
               Float32=>NC_FLOAT,
               Float64=>NC_DOUBLE}


function _nc_op(fname::String,omode::Uint16)
  # Open netcdf file
  ida=Array(Int32,1)
  NetCDF._nc_open_c(fname,omode,ida)
  id=ida[1]
  NC_VERBOSE ? println("Successfully opened ",fname," dimid=",id) : nothing
  return id
end

function _nc_inq_dim(id::Integer,idim::Integer)
  namea=Array(Uint8,NC_MAX_NAME+1);lengtha=Array(Int32,1)
  NetCDF._nc_inq_dim_c(id,idim,namea,lengtha)
  name=bytestring(convert(Ptr{Uint8}, namea))
  dimlen=lengtha[1]
  NC_VERBOSE ? println("Successfully read from file") : nothing
  NC_VERBOSE ? println("name=",name," dimlen=",dimlen) : nothing
  return (name,dimlen)
end

function _nc_inq_dimid(id::Integer,name::String)
  dimida=Array(Int32,1)
  try
    NetCDF._nc_inq_dimid_c(id,name,dimida)
  catch
    dimida[1]=-1
  end
  NC_VERBOSE ? println("Successfully read from file") : nothing
  return dimida[1]
end


function _ncf_inq(id::Integer)
  # Inquire number of codes in netCDF file
  ndima=Array(Int32,1);nvara=Array(Int32,1);ngatta=Array(Int32,1);nunlimdimida=Array(Int32,1)
  _nc_inq_c(id,ndima,nvara,ngatta,nunlimdimida)
  ndim=ndima[1]
  nvar=nvara[1]
  ngatt=ngatta[1]
  nunlimdimid=nunlimdimida[1]
  NetCDF.NC_VERBOSE ? println("Successfully read from file") : nothing
  NetCDF.NC_VERBOSE ? println("ndim=",ndim," nvar=",nvar," ngatt=",ngatt," numlimdimid=",nunlimdimid) : nothing
  return (ndim,nvar,ngatt,nunlimdimid)
end

function _nc_inq_attname(ncid::Integer,varid::Integer,attnum::Integer)
  # Get attribute name from attribute number
  namea=Array(Uint8,NC_MAX_NAME+1)
  _nc_inq_attname_c(ncid,varid,attnum,namea)
  name=bytestring(convert(Ptr{Uint8}, namea))
  NC_VERBOSE ? println("Successfully read attribute name") : nothing
  NC_VERBOSE ? println("name=",name) : nothing
  return name
end


function _nc_inq_att(ncid::Integer,varid::Integer,attnum::Integer)
  # First get attribute name
  name=_nc_inq_attname(ncid,varid,attnum)
  NC_VERBOSE ? println(name) : nothing
  #Then find out about attribute
  typea=Array(Int32,1);nvals=Array(Int32,1)
  _nc_inq_att_c(ncid,varid,name,typea,nvals)
  attype=typea[1]
  NC_VERBOSE ? println("Successfully read attribute type and number of vals") : nothing
  NC_VERBOSE ? println("atttype=",attype," nvals=",nvals[1]) : nothing
  text=_nc_get_att(ncid,varid,name,attype,nvals[1])
  return (name,text)
end

function _nc_put_att(ncid::Integer,varid::Integer,name,val)
  if name=="_FillValue" return(0) end
  if (start(val)>0)
    if (typeof(val[1])<:Char)
      attlen=length(val)+1
      attype=NC_CHAR
    else
      attlen=length(val)
      attype=jltype2nctype[typeof(val[1])]
    end
  else
    if (typeof(val)<:Char)
      attlen=2
      attype=NC_CHAR
    else
      attlen=1
      attype=jltype2nctype[typeof(val)]
      val=[val]
    end
  end
  NC_VERBOSE ? println(ncid, varid, name, attype, attlen, val) : nothing
  if (attype==NC_CHAR)
    _nc_put_att_text_c(ncid,varid,name,attlen,val)
  elseif (attype==NC_SHORT)
    _nc_put_att_short_c(ncid,varid,name,attype,attlen,val)
  elseif (attype==NC_INT)
    _nc_put_att_int_c(ncid,varid,name,attype,attlen,int32(val))
  elseif (attype==NC_FLOAT)
    _nc_put_att_float_c(ncid,varid,name,attype,attlen,val)
  elseif (attype==NC_DOUBLE)
    _nc_put_att_float_c(ncid,varid,name,NC_FLOAT,attlen,float32(val))
  elseif (attype==NC_BYTE)
    _nc_put_att_byte_c(ncid,varid,name,attype,attlen,val)
  else
    valsa="Could not read attribute, currently unsupported datatype by the netcdf package"  
  end
end

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
    dimatts={"missval"=>-9999}
  end
  return(NcDim(name,dimvals,dimatts))
end
