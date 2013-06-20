module NetCDF
include("netcdf_c_wrappers.jl")
import Base.show
export show,NcDim,NcVar,NcFile,new,ncread,ncwrite,nccreate,ncsync,ncinfo,ncclose,ncputatt
#Some constants


jltype2nctype={Int16=>NC_SHORT,
               Int32=>NC_INT,
               Float32=>NC_FLOAT,
               Float64=>NC_DOUBLE}


type NcDim
  ncid::Integer
  dimid::Integer
  varid::Integer
  name::String
  dimlen::Integer
  vals::AbstractArray
  atts::Dict{Any,Any}
end
NcDim(name::String,vals::Union(AbstractArray,Number),atts::Dict{Any,Any})=NcDim(-1,-1,-1,name,length(vals),vals,atts)
NcDim(name::String,vals::Union(AbstractArray,Number))=NcDim(name,vals,{"units"=>"unknown"})


type NcVar
  ncid::Integer
  varid::Integer
  ndim::Integer
  natts::Integer
  nctype::Integer
  name::String
  dimids::Array{}
  dim::Array{NcDim}
  atts::Dict{Any,Any}
end
function NcVar(name::String,dimin,atts::Dict{Any,Any},jltype::Type)
    dim=[dimin]
    return NcVar(-1,-1,length(dim),length(atts),jltype2nctype[jltype],name,Array(Int,length(dim)),dim,atts)
end


type NcFile
  ncid::Integer
  nvar::Integer
  ndim::Integer
  ngatts::Integer
  vars::Dict{String,NcVar}
  dim::Dict{String,NcDim}
  gatts::Dict{Any,Any}
  nunlimdimid::Integer
  name::String
  omode::Uint16
  in_def_mode::Bool
end
NcFile(ncid::Integer,nvar::Integer,ndim::Integer,ngatts::Integer,vars::Dict{String,NcVar},dim::Dict{String,NcDim},gatts::Dict{Any,Any},nunlimdimid::Integer,name::String,omode::Uint16)=NcFile(ncid,nvar,ndim,ngatts,vars,dim,gatts,nunlimdimid,name,omode,false)

include("netcdf_helpers.jl")

global currentNcFiles=Dict{String,NcFile}()  

# Read block of data from file
function readvar(nc::NcFile,varname::String,start::Array,count::Array)
  ncid=nc.ncid
  varid=nc.vars[varname].varid
  start=int64(start)-1
  count=int64(count)
  @assert nc.vars[varname].ndim==length(start)
  @assert nc.vars[varname].ndim==length(count)
  NC_VERBOSE ? println(keys(nc.vars)) : nothing
  for i = 1:length(count)
    count[i]= count[i]>0 ? count[i] : nc.vars[varname].dim[i].dimlen
  end
  #Determine size of Array
  p=1
  for i in count
    p=p*i
  end
  count=count[length(count):-1:1]
  start=start[length(start):-1:1]
  NC_VERBOSE ? println("$ncid $varid $p $start $count") : nothing
  if nc.vars[varname].nctype==NC_DOUBLE
    retvalsa=Array(Float64,p)
    _nc_get_vara_double_c(ncid,varid,start,count,retvalsa)
  elseif nc.vars[varname].nctype==NC_FLOAT
    retvalsa=Array(Float32,p)
    _nc_get_vara_float_c(ncid,varid,start,count,retvalsa)
  elseif nc.vars[varname].nctype==NC_INT
    retvalsa=Array(Int32,p)
    _nc_get_vara_int_c(ncid,varid,start,count,retvalsa)
  elseif nc.vars[varname].nctype==NC_SHORT
    retvalsa=Array(Int32,p)
    _nc_get_vara_int_c(ncid,varid,start,count,retvalsa)
  elseif nc.vars[varname].nctype==NC_CHAR
    retvalsa=Array(Uint8,p)
    _nc_get_vara_text_c(ncid,varid,start,count,retvalsa)
  end
  NC_VERBOSE ? println("Successfully read from file ",ncid) : nothing
  if length(count)>1 
    return reshape(retvalsa,ntuple(length(count),x->count[length(count)-x+1]))
  else
    return retvalsa
  end
end
function readvar(nc::NcFile,varid::Integer,start,count) 
  va=getvarbyid(nc,varid)
  va == nothing ? error("Error: Variable $varid not found in $(nc.name)") : return readvar(nc,va.name,start,count)
end
function readvar(nc::NcFile,varid::NcVar,start,count) 
  return readvar(nc,varid.varid,start,count)
end


function putatt(ncid::Integer,varid::Integer,atts::Dict)
  for a in atts
    name=a[1]
    val=a[2]
    _nc_put_att(ncid,varid,name,val)
  end
end

function putatt(nc::NcFile,varname::String,atts::Dict)
  varid = haskey(nc.vars,varname) ? nc.vars[varname].varid : NC_GLOBAL
  chdef=false
  if (!nc.in_def_mode)
    chdef=true
    _nc_redef_c(nc.ncid)
  end
  putatt(nc.ncid,varid,atts)
  chdef ? _nc_enddef_c(nc.ncid) : nothing
end
function ncputatt(nc::String,varname::String,atts::Dict)
  nc= haskey(currentNcFiles,abspath(nc)) ? currentNcFiles[abspath(nc)] : open(nc,NC_WRITE)
  if (nc.omode==NC_NOWRITE)
    close(nc)
    println("reopening file in WRITE mode")
    open(fil,NC_WRITE)
  end
  putatt(nc,varname,atts)
end


function putvar(nc::NcFile,varname::String,start::Array,vals::Array)
  ncid=nc.ncid
  haskey(nc.vars,varname) ? nothing : error("No variable $varname in file $nc.name")
  @assert nc.vars[varname].ndim==length(start)
  coun=size(vals)
  count=Array(Int64,length(coun))
  start=int64(start)-1
  #Determine size of Array
  p=1
  for i in 1:length(coun)
    p=p*coun[i]
    count[i]=coun[i]
  end
  count=count[length(count):-1:1]
  start=start[length(start):-1:1]
  NC_VERBOSE ? println("$ncid $varname $p $count ",nc.vars[varname].nctype) : nothing
  #x=reshape(vals,p)
  x=vals
  varid=nc.vars[varname].varid
  if nc.vars[varname].nctype==NC_DOUBLE
    _nc_put_vara_double_c(ncid,varid,start,count,x)
  elseif nc.vars[varname].nctype==NC_FLOAT
    _nc_put_vara_double_c(ncid,varid,start,count,x)
  elseif nc.vars[varname].nctype==NC_INT
    _nc_put_vara_int_c(ncid,varid,start,count,x)
  elseif nc.vars[varname].nctype==NC_SHORT
    _nc_put_vara_int_c(ncid,varid,start,count,x)
  elseif nc.vars[varname].nctype==NC_CHAR
    _nc_put_vara_text_c(ncid,varid,start,count,x)
  end
  NC_VERBOSE ? println("Successfully wrote to file ",ncid) : nothing
end
function putvar(nc::NcFile,varname::String,vals::Array)
  start=ones(length(size(vals)))
  putvar(nc,varname,start,vals)
end

# Function to synchronize all files with disk
function ncsync()
  for ncf in currentNcFiles
    id=ncf[2].ncid
    _nc_sync_c(int32(id))
  end
end

function sync(nc::NcFile)
  id=nc.ncid
  _nc_sync_c(int32(id))
end

#Function to close netcdf files
function ncclose(fil::String)
  if (haskey(currentNcFiles,abspath(fil)))
    close(currentNcFiles[abspath(fil)])
  end
end
function ncclose()
  for f in keys(currentNcFiles)
    ncclose(f)
  end
end

function create(name::String,varlist::Union(Array{NcVar},NcVar))
  ida=Array(Int32,1)
  vars=Dict{String,NcVar}();
  #Create the file
  _nc_create_c(name,NC_CLOBBER,ida);
  id=ida[1];
  # Unify types
  if (typeof(varlist)==NcVar)
    varlist=[varlist]
  end
  # Collect Dimensions
  dims=Set{NcDim}();
  for v in varlist
    for d in v.dim
      add!(dims,d);
    end
  end
  nunlim=0;
  ndim=int32(length(dims));
  #Create Dimensions in the file
  dim=Dict{String,NcDim}();
  for d in dims
    dima=Array(Int32,1);
    NC_VERBOSE? println("Dimension length ", d.dimlen) : nothing
    _nc_def_dim_c(id,d.name,d.dimlen,dima);
    d.dimid=dima[1];
    dim[d.name]=d;
    #Create dimension variable
    varida=Array(Int32,1)
    dumids=[copy(d.dimid)]
    _nc_def_var_c(id,d.name,NC_DOUBLE,1,dumids,varida)
    putatt(id,d.dimid,d.atts)
    d.varid=varida[1]
    dd=Array(NcDim,1)
    dd[1]=d
    vars[d.name]=NcVar(id,varida[1],1,length(d.atts),NC_DOUBLE,d.name,[d.dimid],dd,d.atts)
  end
  # Create variables in the file
  for v in varlist
    i=1
    for d in v.dim
      v.dimids[i]=d.dimid
      i=i+1
    end
    vara=Array(Int32,1);
    dumids=int32(v.dimids)
    NC_VERBOSE ? println(dumids) : nothing
    _nc_def_var_c(id,v.name,v.nctype,v.ndim,int32(dumids[v.ndim:-1:1]),vara);
    putatt(id,v.varid,v.atts)
    v.varid=vara[1];
    vars[v.name]=v;
  end
  # Leave define mode
  _nc_enddef_c(id)
  #Write dimension variables
  for d in dims
    #Write dimension variable
    y=float64(d.vals)
    diml=d.dimlen
    _nc_put_vara_double_c(id,d.varid,[0],[diml],y)
  end
  #Create the NcFile Object
  nc=NcFile(id,length(vars),ndim,0,vars,dim,Dict{Any,Any}(),0,name,NC_WRITE)
  currentNcFiles[abspath(nc.name)]=nc
end

function vardef(fid::Integer,v::NcVar)
    _nc_redef(ncid)
    i=1
    for d in v.dim
      v.dimids[i]=d.dimid
      i=i+1
    end
    vara=Array(Int32,1);
    dumids=int32(v.dimids)
    NC_VERBOSE? println(dumids) : nothing
    _nc_def_var_c(id,v.name,v.nctype,v.ndim,int32(dumids[v.ndim:-1:1]),vara);
    v.varid=vara[1];
    vars[v.name]=v;
end

function close(nco::NcFile)
  #Close file
  _nc_close_c(nco.ncid) 
  delete!(currentNcFiles,abspath(nco.name))
  NC_VERBOSE? println("Successfully closed file ",nco.ncid) : nothing
  return nco.ncid
end


function open(fil::String,omode::Uint16=NC_NOWRITE; readdimvar=false)
  # Open netcdf file
  ncid=_nc_op(fil,omode)
  NC_VERBOSE ? println(ncid) : nothing
  #Get initial information
  (ndim,nvar,ngatt,nunlimdimid)=_ncf_inq(ncid)
  NC_VERBOSE ? println(ndim,nvar,ngatt,nunlimdimid) : nothing
  #Create ncdf object
  ncf=NcFile(ncid,nvar-ndim,ndim,ngatt,Dict{String,NcVar}(),Dict{String,NcDim}(),Dict{Any,Any}(),nunlimdimid,abspath(fil),omode)
  #Read global attributes
  ncf.gatts=_nc_getatts_all(ncid,NC_GLOBAL,ngatt)
  #Read dimensions
  for dimid = 0:ndim-1
    (name,dimlen)=_nc_inq_dim(ncid,dimid)
    ncf.dim[name]=NcDim(ncid,dimid,-1,name,dimlen,[1:dimlen],Dict{Any,Any}())
  end
  #Read variable information
  for varid = 0:nvar-1
    (name,nctype,dimids,natts,vndim,isdimvar)=_ncv_inq(ncf,varid)
    if (isdimvar)
      ncf.dim[name].varid=varid
    end
    atts=_nc_getatts_all(ncid,varid,natts)
    vdim=Array(NcDim,length(dimids))
    i=1;
    for did in dimids
      vdim[i]=ncf.dim[getdimnamebyid(ncf,did)]
      i=i+1
    end
    ncf.vars[name]=NcVar(ncid,varid,vndim,natts,nctype,name,int(dimids[vndim:-1:1]),vdim[vndim:-1:1],atts)
  end
  readdimvar==true ? _readdimvars(ncf) : nothing
  currentNcFiles[abspath(ncf.name)]=ncf
  return ncf
end

# Define some high-level functions
# High-level functions for writing data to files
function ncread(fil::String,vname::String,start::Array,count::Array)
  nc= haskey(currentNcFiles,abspath(fil)) ? currentNcFiles[abspath(fil)] : open(fil)
  x=readvar(nc,vname,start,count)
  return x
end
function ncread(fil::String,vname::String,ran...)
  s=ones(length(ran))
  c=ones(length(ran))
  for i in 1:length(ran)
    typeof(ran[i])<:Range1 ? nothing : error("Expected range as input for reading netcdf variable")
    s[i]=int(ran[i][1])
    c[i]=int(length(ran[i]))
  end
  return ncread(fil,vname,s,c)  
end
function ncread(fil::String,vname::String)
  NC_VERBOSE ? println(vname) : nothing
  nc= haskey(currentNcFiles,abspath(fil)) ? currentNcFiles[abspath(fil)] : open(fil)
  s=ones(Int,nc.vars[vname].ndim)
  c=s*(-1)
  return ncread(fil,vname,s,c)
end

function ncinfo(fil::String)
  nc= haskey(currentNcFiles,abspath(fil)) ? currentNcFiles[abspath(fil)] : open(fil)
  return(nc)
end

#High-level functions for writing data to a file
function ncwrite(x,fil::String,vname::String,start::Array)
  
  nc= haskey(currentNcFiles,abspath(fil)) ? currentNcFiles[abspath(fil)] : open(fil,NC_WRITE)
  if (nc.omode==NC_NOWRITE)
    close(nc)
    println("reopening file in WRITE mode")
    open(fil,NC_WRITE)
  end
  putvar(nc,vname,start,x)
end

function ncwrite(x,fil::String,vname::String)
  nc= haskey(currentNcFiles,abspath(fil)) ? currentNcFiles[abspath(fil)] : open(fil,NC_WRITE)
  if (nc.omode==NC_NOWRITE)
    close(nc)
    println("reopening file in WRITE mode")
    open(fil,NC_WRITE)
  end
  start=ones(nc.vars[vname].ndim)
  putvar(nc,vname,start,x)
end

#High-level function for creating files and variables
# 
# if the file does not exist, it will be created
# if the file already exists, the variable will be added to the file

function nccreate(fil::String,varname::String,atts::Dict,dims...)
  # Checking dims argument for correctness
  dim=parsedimargs(dims)
  # to be done
  # open the file
  # create the NcVar object
  v=NcVar(varname,dim,atts,Float64)
  # Test if the file already exists
  if (isfile(fil)) 
    nc=haskey(currentNcFiles,abspath(fil)) ? currentNcFiles[abspath(fil)] : open(fil,NC_WRITE)
    if (nc.omode==NC_NOWRITE)
      close(nc)
      println("reopening file in WRITE mode")
      open(fil,NC_WRITE)
    end
    haskey(nc.vars,varname) ? error("Variable $varname already exists in file fil") : nothing
    # Check if dimensions exist, if not, create
    i=1
    # Remember if dimension was created
    dcreate=Array(Bool,length(dim))
    for d in dim
      did=_nc_inq_dimid(nc.ncid,d.name)
      if (did==-1)
        dima=Array(Int32,1);
        #_nc_redef_c(nc.ncid)
        if (!nc.in_def_mode) 
          _nc_redef_c(nc.ncid)
          nc.in_def_mode=true
        end
        _nc_def_dim_c(nc.ncid,d.name,d.dimlen,dima);
        d.dimid=dima[1];
        v.dimids[i]=d.dimid;
        dcreate[i] = true
      else
        dcreate[i] = false
        v.dimids[i]=nc.dim[d.name].dimid;
      end
      i=i+1
    end
    # Create variable
    vara=Array(Int32,1);
    dumids=int32(v.dimids)
    if (!nc.in_def_mode) 
          _nc_redef_c(nc.ncid)
          nc.in_def_mode=true
    end
    _nc_def_var_c(nc.ncid,v.name,v.nctype,v.ndim,int32(dumids[v.ndim:-1:1]),vara);
    v.varid=vara[1];
    nc.vars[v.name]=v;
    if (nc.in_def_mode) 
          _nc_enddef_c(nc.ncid)
          nc.in_def_mode=false
    end
    i=1
    for d in dim
      if (dcreate[i])
        ncwrite(d.vals,fil,d.name)
      end
      i=i+1
    end
  else
    println(v.dim)
    nc=create(fil,v)
    for d in dim
      ncwrite(d.vals,fil,d.name)
    end
  end
end

function show(io::IO,nc::NcFile)
  println(io,"")
  println(io,"##### NetCDF File #####")
  println(io,"")
  println(io,nc.name)
  println(io,"")
  println(io,"##### Dimensions #####")
  println(io,"")
  @printf(io,"%15s %8s","Name","Length\n")
  println("-------------------------------")
  for d in nc.dim
    @printf(io,"%15s %8d\n",d[2].name,d[2].dimlen)
  end
  println(io,"")
  println(io,"##### Variables #####")
  println(io,"")
  @printf(io,"%20s    %s","Name","Dimensions\n")
  println("---------------------------------------------------------------")
  for v in nc.vars
    @printf(io,"%20s    ",v[2].name)
    for d in v[2].dim
      @printf(io,"%s, ",d.name)
    end
    @printf(io,"\n")
  end
  println(io,"")
  println(io,"##### Attributes #####")
  println(io,"")
  @printf(io,"%20s %20s %20s\n","Variable","Name","Value")
  println("---------------------------------------------------------------")
  for a in nc.gatts
    an=string(a[1])
    av=string(a[2])
    an=an[1:min(length(an),38)]
    av=av[1:min(length(av),38)]
    @printf(io,"%20s %20s %40s\n","global",an,av)
  end
  for v in nc.vars
    for a in v[2].atts
      an=string(a[1])
      av=string(a[2])
      vn=
      an=an[1:min(length(an),38)]
      av=av[1:min(length(av),38)]
      @printf(io,"%20s %20s %40s\n",v[2].name,an,av)
    end
  end

end

end # Module