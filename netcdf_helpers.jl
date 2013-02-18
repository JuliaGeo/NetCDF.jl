module ncHelpers
using Base
using netcdf
using C

jltype2nctype={Int16=>NC_SHORT,
               Int32=>NC_INT,
               Float32=>NC_FLOAT,
               Float64=>NC_DOUBLE}

function _cchartostring(in)
  iname=1
  name=""
  #println(in)
  if (length(in)>0)
    while (char(in[iname])!='\0' && iname<length(in))
      name=string(name,char(in[iname]))
      iname=iname+1
    end
  end
  return name
end


function _nc_op(fname::String)
  # Open netcdf file
  ida=Array(Int32,1)
  omode=0
  netcdf.C._nc_open_c(fname,omode,ida)
  id=ida[1]
  println("Successfully opened ",fname," dimid=",id)
  return id
end

function _nc_inq_dim(id::Integer,idim::Integer)
  namea=Array(Uint8,NC_MAX_NAME+1);lengtha=Array(Int32,1)
  netcdf.C._nc_inq_dim_c(id,idim,namea,lengtha)
  name=_cchartostring(namea)
  dimlen=lengtha[1]
  NC_VERBOSE ? println("Successfully read from file") : nothing
  NC_VERBOSE ? println("name=",name," dimlen=",dimlen) : nothing
  return (name,dimlen)
end

function _ncf_inq(id::Integer)
  # Inquire number of codes in netCDF file
  ndima=Array(Int32,1);nvara=Array(Int32,1);ngatta=Array(Int32,1);nunlimdimida=Array(Int32,1)
  C._nc_inq_c(id,ndima,nvara,ngatta,nunlimdimida)
  ndim=ndima[1]
  nvar=nvara[1]
  ngatt=ngatta[1]
  nunlimdimid=nunlimdimida[1]
  netcdf.NC_VERBOSE ? println("Successfully read from file") : nothing
  netcdf.NC_VERBOSE ? println("ndim=",ndim," nvar=",nvar," ngatt=",ngatt," numlimdimid=",nunlimdimid) : nothing
  return (ndim,nvar,ngatt,nunlimdimid)
end

function _nc_inq_attname(ncid::Integer,varid::Integer,attnum::Integer)
  # Get attribute name from attribute number
  namea=Array(Uint8,NC_MAX_NAME+1)
  C._nc_inq_attname_c(ncid,varid,attnum,namea)
  name=_cchartostring(namea)
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
  C._nc_inq_att_c(ncid,varid,name,typea,nvals)
  attype=typea[1]
  NC_VERBOSE ? println("Successfully read attribute type and number of vals") : nothing
  NC_VERBOSE ? println("atttype=",attype," nvals=",nvals[1]) : nothing
  text=_nc_get_att(ncid,varid,name,attype,nvals[1])
  return (name,text)
end

function _nc_get_att(ncid::Integer,varid::Integer,name,attype::Integer,attlen::Integer)
  if (attype==NC_CHAR)
    valsa=Array(Uint8,attlen+5)
    C._nc_get_att_text_c(ncid,varid,name,valsa)
    valsa=string(_cchartostring(valsa))
  elseif (attype==NC_SHORT)
    valsa=Array(Int16,attlen)
    C._nc_get_att_short_c(ncid,varid,name,valsa)
  elseif (attype==NC_INT)
    valsa=Array(Int32,attlen)
    C._nc_get_att_int_c(ncid,varid,name,valsa)
  elseif (attype==NC_FLOAT)
    valsa=Array(Float32,attlen)
    C._nc_get_att_float_c(ncid,varid,name,valsa)
  elseif (attype==NC_DOUBLE)
    valsa=Array(Float64,attlen)
    C._nc_get_att_double_c(ncid,varid,name,valsa)
  end
  return valsa
end

function _ncv_inq(nc::NcFile,varid::Integer)
  id=nc.ncid
  ndim=length(nc.dim)
  # Inquire variables in the file
  namea=Array(Uint8,NC_MAX_NAME+1);xtypea=Array(Int32,1);ndimsa=Array(Int32,1);dimida=Array(Int32,ndim);natta=Array(Int32,1)
  C._nc_inq_var_c(id,varid,namea,xtypea,ndimsa,dimida,natta)
  println("dimida=",dimida," ndimsa=",ndimsa)
  nctype=xtypea[1]
  vndim=ndimsa[1]
  dimids=vndim>0 ? dimida[1:vndim] : []
  natts=natta[1]
  NC_VERBOSE ? println("Successfully read from file") : nothing
  name=_cchartostring(namea)
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

function _getdimindexbyname(nc::NcFile,dimname::String)
  da=nothing
  for d in nc.dim
    da = d[2].name==dimname ? d[2] : da
  end
  return da.dimid
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
    atts[gatt[1]]=string(gatt[2])
  end
  NC_VERBOSE ? println(atts) : nothing
  return atts
end

function _readdimvars(nc::NcFile)
  for d in nc.dim
    for v in nc.vars
      if (d[2].name==v[2].name)
        println(d[2].name," ",v[2].name)
        d[2].vals=readvar(nc,v[2].varid,[1],[-1])
        d[2].atts=v[2].atts
      end
    end
  end
end


end #Module
