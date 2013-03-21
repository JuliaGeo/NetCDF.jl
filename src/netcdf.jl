module netcdf
include("netcdf_c_wrappers.jl")
using Base
using C
export show,NcDim,NcVar,NcFile,new,ncread,ncwrite,nccreate,ncsync
#Some constants


jltype2nctype={Int16=>C.NC_SHORT,
               Int32=>C.NC_INT,
               Float32=>C.NC_FLOAT,
               Float64=>C.NC_DOUBLE}


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
using ncHelpers
global currentNcFiles=Dict{String,NcFile}()  

# Read block of data from file
function readvar(nc::NcFile,varname::String,start::Array,count::Array)
  ncid=nc.ncid
  varid=nc.vars[varname].varid
  start=int64(start)-1
  count=int64(count)
  @assert nc.vars[varname].ndim==length(start)
  @assert nc.vars[varname].ndim==length(count)
  println(keys(nc.vars))
  for i = 1:length(count)
    count[i]= count[i]>0 ? count[i] : nc.vars[varname].dim[i].dimlen
  end
  #Determine size of Array
  p=1
  for i in count
    p=p*i
  end
  NC_VERBOSE ? println("$ncid $varid $p $count ${nc.vars[varname].nctype}") : nothing
  if nc.vars[varname].nctype==NC_DOUBLE
    retvalsa=Array(Float64,p)
    C._nc_get_vara_double_c(ncid,varid,start,count,retvalsa)
  elseif nc.vars[varname].nctype==NC_FLOAT
    retvalsa=Array(Float64,p)
    C._nc_get_vara_double_c(ncid,varid,start,count,retvalsa)
  elseif nc.vars[varname].nctype==NC_INT
    retvalsa=Array(Int32,p)
    C._nc_get_vara_int_c(ncid,varid,start,count,retvalsa)
  elseif nc.vars[varname].nctype==NC_SHORT
    retvalsa=Array(Int32,p)
    C._nc_get_vara_int_c(ncid,varid,start,count,retvalsa)
  elseif nc.vars[varname].nctype==NC_CHAR
    retvalsa=Array(Uint8,p)
    C._nc_get_vara_text_c(ncid,varid,start,count,retvalsa)
  end
  NC_VERBOSE ? println("Successfully read from file ",ncid) : nothing
  if length(count)>1 
    return reshape(retvalsa,ntuple(length(count),x->count[x]))
  else
    return retvalsa
  end
end
function readvar(nc::NcFile,varid::Integer,start,count) 
  va=ncHelpers.getvarbyid(nc,varid)
  va == nothing ? error("Error: Variable $varid not found in $(nc.name)") : return readvar(nc,va.varname,start,count)
end
function readvar(nc::NcFile,varid::NcVar,start,count) 
  return readvar(nc,varid.varid,start,count)
end


function putvar(nc::NcFile,varname::String,start::Array,vals::Array)
  ncid=nc.ncid
  has(nc.vars,varname) ? nothing : error("No variable $varname in file $nc.name")
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
  NC_VERBOSE ? println("$ncid $varname $p $count ",nc.vars[varname].nctype) : nothing
  #x=reshape(vals,p)
  x=vals
  varid=nc.vars[varname].varid
  if nc.vars[varname].nctype==NC_DOUBLE
    C._nc_put_vara_double_c(ncid,varid,start,count,x)
  elseif nc.vars[varname].nctype==NC_FLOAT
    C._nc_put_vara_double_c(ncid,varid,start,count,x)
  elseif nc.vars[varname].nctype==NC_INT
    C._nc_put_vara_int_c(ncid,varid,start,count,x)
  elseif nc.vars[varname].nctype==NC_SHORT
    C._nc_put_vara_int_c(ncid,varid,start,count,x)
  elseif nc.vars[varname].nctype==NC_CHAR
    C._nc_put_vara_text_c(ncid,varid,start,count,x)
  end
  NC_VERBOSE ? println("Successfully wrote to file ",ncid) : nothing
end
#function putvar(nc::NcFile,varid::String,start,vals) 
#  va=ncHelpers._getvarindexbyname(nc,varid)
#  va == nothing ? error("Error: Variable $varid not found in $(nc.name)") : return putvar(nc,va.varid,start,vals)
#end


# Function to synchronize all files with disk
function ncsync()
  for ncf in currentNcFiles
    id=ncf[2].ncid
    C._nc_sync_c(int32(id))
  end
end

#Function to close netcdf files
function ncclose(fil::String)
  if (has(currentNcFiles,realpath(fil)))
    close(currentNcFiles[fil])
  end
  
end

function create(name::String,varlist::Union(Array{NcVar},NcVar))
  ida=Array(Int32,1)
  vars=Dict{String,NcVar}();
  #Create the file
  C._nc_create_c(name,NC_CLOBBER,ida);
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
    println("Dimension length ", d.dimlen)
    C._nc_def_dim_c(id,d.name,d.dimlen,dima);
    d.dimid=dima[1];
    dim[d.name]=d;
    #Create dimension variable
    varida=Array(Int32,1)
    dumids=[copy(d.dimid)]
    C._nc_def_var_c(id,d.name,NC_DOUBLE,1,dumids,varida)
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
    println(dumids)
    C._nc_def_var_c(id,v.name,v.nctype,v.ndim,int32(dumids),vara);
    v.varid=vara[1];
    vars[v.name]=v;
  end
  # Leave define mode
  C._nc_enddef_c(id)
  #Write dimension variables
  for d in dims
    #Write dimension variable
    y=float64(d.vals)
    diml=d.dimlen
    C._nc_put_vara_double_c(id,d.varid,[0],[diml],y)
  end
  #Create the NcFile Object
  nc=NcFile(id,length(vars),ndim,0,vars,dim,Dict{Any,Any}(),0,name,C.NC_WRITE)
end

function vardef(fid::Integer,v::NcVar)
    C.redef(ncid)
    i=1
    for d in v.dim
      v.dimids[i]=d.dimid
      i=i+1
    end
    vara=Array(Int32,1);
    dumids=int32(v.dimids)
    println(dumids)
    C._nc_def_var_c(id,v.name,v.nctype,v.ndim,int32(dumids),vara);
    v.varid=vara[1];
    vars[v.name]=v;
end

function close(nco::NcFile)
  #Close file
  C._nc_close_c(nco.ncid) 
  println("Successfully closed file ",nco.ncid)
  return nco.ncid
end


function open(fil::String,omode::Uint16)
  # Open netcdf file
  ncid=ncHelpers._nc_op(fil,omode)
  NC_VERBOSE ? println(ncid) : nothing
  #Get initial information
  (ndim,nvar,ngatt,nunlimdimid)=ncHelpers._ncf_inq(ncid)
  NC_VERBOSE ? println(ndim,nvar,ngatt,nunlimdimid) : nothing
  #Create ncdf object
  ncf=NcFile(ncid,nvar-ndim,ndim,ngatt,Dict{String,NcVar}(),Dict{String,NcDim}(),Dict{Any,Any}(),nunlimdimid,fil,omode)
  #Read global attributes
  ncf.gatts=ncHelpers._nc_getatts_all(ncid,NC_GLOBAL,ngatt)
  #Read dimensions
  for dimid = 0:ndim-1
    (name,dimlen)=ncHelpers._nc_inq_dim(ncid,dimid)
    ncf.dim[name]=NcDim(ncid,dimid,-1,name,dimlen,[1:dimlen],Dict{Any,Any}())
  end
  #Read variable information
  for varid = 0:nvar-1
    (name,nctype,dimids,natts,vndim,isdimvar)=ncHelpers._ncv_inq(ncf,varid)
    if (isdimvar)
      ncf.dim[name].varid=varid
    end
    atts=ncHelpers._nc_getatts_all(ncid,varid,natts)
    vdim=Array(NcDim,length(dimids))
    i=1;
    for did in dimids
      vdim[i]=ncf.dim[ncHelpers.getdimnamebyid(ncf,did)]
      i=i+1
    end
    ncf.vars[name]=NcVar(ncid,varid,vndim,natts,nctype,name,int(dimids),vdim,atts)
  end
  currentNcFiles[realpath(ncf.name)]=ncf
  return ncf
end
open(fil::String) = open(fil,C.NC_NOWRITE)

# Define some high-level functions
# High-level functions for writing data to files
function ncread(fil::String,vname::String,start::Array,count::Array)
  nc= has(currentNcFiles,realpath(fil)) ? currentNcFiles[realpath(fil)] : open(fil)
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
  println(vname)
  nc= has(currentNcFiles,realpath(fil)) ? currentNcFiles[vname] : open(fil)
  s=ones(Int,nc.vars[vname].ndim)
  c=s*(-1)
  return ncread(fil,vname,s,c)
end

#High-level functions for writing data to a file
function ncwrite(x,fil::String,vname::String,start::Array)
  nc= has(currentNcFiles,realpath(fil)) ? currentNcFiles[realpath(fil)] : open(fil,C.NC_WRITE)
  if (nc.omode==C.NC_NOWRITE)
    close(nc)
    println("reopening file in WRITE mode")
    open(fil,C.NC_WRITE)
  end
  putvar(nc,vname,start,x)
end

function ncwrite(x,fil::String,vname::String)
  nc= has(currentNcFiles,realpath(fil)) ? currentNcFiles[realpath(fil)] : open(fil,C.NC_WRITE)
  if (nc.omode==C.NC_NOWRITE)
    close(nc)
    println("reopening file in WRITE mode")
    open(fil,C.NC_WRITE)
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
  dim=ncHelpers.parsedimargs(dims)
  # to be done
  # open the file
  # create the NcVar object
  v=NcVar(varname,dim,atts,Float64)
  # Test if the file already exists
  if (isfile(fil)) 
    nc=has(currentNcFiles,realpath(fil)) ? currentNcFiles[realpath(fil)] : open(fil,C.NC_WRITE)
    if (nc.omode==C.NC_NOWRITE)
      close(nc)
      println("reopening file in WRITE mode")
      open(fil,C.NC_WRITE)
    end
    # Check if dimensions exist, if not, create
    i=1
    # Remember if dimension was created
    dcreate=Array(Bool,length(dim))
    for d in dim
      did=ncHelpers._nc_inq_dimid(nc.ncid,d.name)
      if (did==-1)
        dima=Array(Int32,1);
        #C._nc_redef_c(nc.ncid)
        if (!nc.in_def_mode) 
          C._nc_redef_c(nc.ncid)
          nc.in_def_mode=true
        end
        C._nc_def_dim_c(nc.ncid,d.name,d.dimlen,dima);
        d.dimid=dima[1];
        v.dimids[i]=d.dimid;
      else
        v.dimids[i]=nc.dim[d.name].dimid;
      end
      i=i+1
    end
    # Create variable
    vara=Array(Int32,1);
    dumids=int32(v.dimids)
    if (!nc.in_def_mode) 
          C._nc_redef_c(nc.ncid)
          nc.in_def_mode=true
    end
    C._nc_def_var_c(nc.ncid,v.name,v.nctype,v.ndim,int32(dumids),vara);
    v.varid=vara[1];
    nc.vars[v.name]=v;
    if (nc.in_def_mode) 
          C._nc_enddef_c(nc.ncid)
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
    nc=create(fil,v)
    for d in dim
      ncwrite(d.vals,fil,d.name)
    end
  end
end

function show(nc::NcFile)
  println("File: ",nc.name)
  println("Number of variables: ",nc.nvar)
end


end # Module