module NetCDF
using Compat
include("netcdf_c.jl")
import Base.show
export NcDim,NcVar,NcFile,ncread,ncread!,ncwrite,nccreate,ncsync,ncinfo,ncclose,ncputatt,NC_BYTE,NC_SHORT,NC_INT,NC_FLOAT,NC_DOUBLE, ncgetatt,NC_NOWRITE,NC_WRITE,NC_CLOBBER,NC_NOCLOBBER,NC_CLASSIC_MODEL,NC_64BIT_OFFSET,NC_NETCDF4
NC_VERBOSE=false
#Some constants


jltype2nctype=@Compat.Dict(Int8=>NC_BYTE,
                   Int16=>NC_SHORT,
                   Int32=>NC_INT,
                   Float32=>NC_FLOAT,
                   Float64=>NC_DOUBLE,
                   Uint8=>NC_CHAR)

nctype2jltype=@Compat.Dict(NC_BYTE=>Int8,
                    NC_SHORT=>Int16, 
                    NC_INT=>Int32,
                    NC_LONG=>Int64,
                    NC_FLOAT=>Float32,
                    NC_DOUBLE=>Float64,
                    NC_CHAR=>Uint8,
                    NC_STRING=>Ptr{Uint8})

nctype2string=@Compat.Dict(NC_BYTE=>"BYTE",
                   NC_SHORT=>"SHORT",
                   NC_INT=>"INT",
                   NC_FLOAT=>"FLOAT",
                   NC_DOUBLE=>"DOUBLE")


type NcDim
  ncid::Int32
  dimid::Int32
  varid::Int32
  name::ASCIIString
  dimlen::Uint
  vals::AbstractArray
  atts::Dict{Any,Any}
end


NcDim(name::String,dimlength::Integer;values::Union(AbstractArray,Number)=[],atts::Dict{Any,Any}=Dict{Any,Any}())=
  begin
    (length(values)>0 && length(values)!=dimlength) ? error("Dimension value vector must have the same length as dimlength!") : nothing
    NcDim(-1,-1,-1,name,dimlength,values,atts)
  end

NcDim(name::String,values::AbstractArray;atts::Dict{Any,Any}=Dict{Any,Any}())=
  NcDim(name,length(values),values=values,atts=atts)
NcDim(name::String,values::AbstractArray,atts::Dict{Any,Any})=
  NcDim(name,length(values),values=values,atts=atts)


type NcVar{T,N} #<: AbstractArray{T,N}
  ncid::Int32
  varid::Int32
  ndim::Int32
  natts::Int32
  nctype::Int32
  name::ASCIIString
  dimids::Array{Int32}
  dim::Array{NcDim}
  atts::Dict
  compress::Int32
end
#Some additional constructors
function NcVar(name::String,dimin::Union(NcDim,Array{NcDim,1});atts::Dict{Any,Any}=Dict{Any,Any}(),t::Union(DataType,Integer)=Float64,compress::Integer=-1)
  dim=[dimin]
  return NcVar{typeof(t)==DataType ? t : nctype2jltype[t],length(dim)}(-1,-1,length(dim),length(atts), typeof(t)==DataType ? jltype2nctype[t] : t,name,Array(Int,length(dim)),dim,atts,compress)
end
NcVar(name::String,dimin::Union(NcDim,Array{NcDim,1}),atts::Dict{Any,Any},t::Union(DataType,Integer)=Float64)=NcVar{typeof(t)==DataType ? t : nctype2jltype[t],length(dimin)}(-1,-1,length(dimin),length(atts), typeof(t)==DataType ? jltype2nctype[t] : t,name,Array(Int,length(dimin)),dimin,atts,-1)
#Array methods
Base.size(a::NcVar)=[d.dimlen for d in a.dim]



type NcFile
  ncid::Int32
  nvar::Int32
  ndim::Int32
  ngatts::Int32
  vars::Dict{ASCIIString,NcVar}
  dim::Dict{ASCIIString,NcDim}
  gatts::Dict
  nunlimdimid::Int32
  name::ASCIIString
  omode::Uint16
  in_def_mode::Bool
end


include("netcdf_helpers.jl")

const currentNcFiles=Dict{String,NcFile}()

# Read block of data from file
function readvar!(nc::NcFile, varname::String, retvalsa::Array;start::Vector=ones(Uint,ndims(retvalsa)),count::Vector=size(retvalsa))
    haskey(nc.vars,varname) || error("NetCDF file $(nc.name) does not have variable $varname")
    readvar!(nc.vars[varname],retvalsa,start=start,count=count)
end


function readvar!(v::NcVar, retvalsa::Array;start::Vector=ones(Uint,ndims(retvalsa)),count::Vector=size(retvalsa))

  length(start) == v.ndim || error("Length of start ($(length(start))) must equal the number of variable dimensions ($(v.ndim))")
  length(count) == v.ndim || error("Length of start ($(length(count))) must equal the number of variable dimensions ($(v.ndim))")

  p=preparestartcount(start,count,v)

  length(retvalsa) != p && error("Size of output array ($(length(retvalsa))) does not equal number of elements to be read ($p)!")

  nc_get_vara_x!(v.ncid,v.varid,gstart,gcount,retvalsa)

  retvalsa
end
readvar{T<:Integer}(nc::NcFile,varname::String,start::Array{T,1},count::Array{T,1})=readvar(nc,varname,start=start,count=count)


function readvar(nc::NcFile, varname::String;start::Vector=Array(Int,0),count::Vector=Array(Int,0))
    
    haskey(nc.vars,varname) || error("NetCDF file $(nc.name) does not have variable $varname")
    v=nc.vars[varname]
    
    if length(start)==0 start = ones(Int,v.ndim)   end
    if length(count)==0 
        count = Int[v.dim[i].dimlen - start[i] + 1  for i=1:v.ndim] 
    else
        count = Int[count[i] > 0 ? count[i] : v.dim[i].dimlen - start[i] + 1  for i=1:v.ndim]
    end
    
    readvar(v,start=start,count=count)
    
end

function readvar{T,N}(v::NcVar{T,N};start::Vector=ones(Int,v.ndim),count::Vector=zeros(Int,v.ndim))

    retvalsa = Array(T,count...) 
    readvar!(v, retvalsa, start=start, count=count)
    return retvalsa
end

function readvar(v::NcVar,index...)
    for i=1:length(index)
        gstart[length(index)+1-i]=index[i]-1
    end
    readvar(v,gstart)
end
#    nc_get_var1_x!(v.ncid,v.varid,gstart,)

for (t,ending) in funext
    fname = symbol("nc_get_vara_$ending")
    @eval nc_get_vara_x!(ncid::Integer,varid::Integer,start::Vector{Uint},count::Vector{Uint},retvalsa::Array{$t})=$fname(ncid,varid,start,count,retvalsa)
end
#nc_get_var1_x!(ncid::Integer,varid::Integer,index::Vector{Uint},retval::Array{Float64})=nc_get_var1_double

function putatt(ncid::Integer,varid::Integer,atts::Dict)
  for a in atts
    name=a[1]
    val=a[2]
    nc_put_att(ncid,varid,name,val)
  end
end

function putatt(nc::NcFile,varname::String,atts::Dict)
  varid = haskey(nc.vars,varname) ? nc.vars[varname].varid : NC_GLOBAL
  chdef=false
  if (!nc.in_def_mode)
    chdef=true
    nc_redef(nc.ncid)
  end
  putatt(nc.ncid,varid,atts)
  chdef ? nc_enddef(nc.ncid) : nothing
end

function ncputatt(nc::String,varname::String,atts::Dict)
  nc = haskey(currentNcFiles,abspath(nc)) ? currentNcFiles[abspath(nc)] : open(nc,mode=NC_WRITE)
  if (nc.omode==NC_NOWRITE)
    fil=nc.name
    close(nc)
    println("reopening file in WRITE mode")
    open(fil,mode=NC_WRITE)
  end
  putatt(nc,varname,atts)
end

function putvar(nc::NcFile,varname::String,vals::Array;start=ones(Int,length(size(vals))),count=[size(vals)...])
    haskey(nc.vars,varname) ? nothing : error("No variable $varname in file $nc.name")
    putvar(nc.vars[varname],vals, start=start, count=count)
end

function putvar(v::NcVar,vals::Array;start::Vector=ones(Int,length(size(vals))),count::Vector=[size(vals)...])

  p=preparestartcount(start,count,v)
  
  nc_put_vara_x(v.ncid,v.varid,gstart,gcount,vals)
end

nc_put_vara_x(ncid::Integer, varid::Integer, start, count, vals::Array{Float64})=nc_put_vara_double(ncid,varid,start,count,vals)
nc_put_vara_x(ncid::Integer, varid::Integer, start, count, vals::Array{Float32})=nc_put_vara_float(ncid,varid,start,count,vals)
nc_put_vara_x(ncid::Integer, varid::Integer, start, count, vals::Array{Int8})=nc_put_vara_schar(ncid,varid,start,count,vals)
nc_put_vara_x(ncid::Integer, varid::Integer, start, count, vals::Array{Int16})=nc_put_vara_short(ncid,varid,start,count,vals)
nc_put_vara_x(ncid::Integer, varid::Integer, start, count, vals::Array{Int32})=nc_put_vara_int(ncid,varid,start,count,vals)
nc_put_vara_x(ncid::Integer, varid::Integer, start, count, vals::Array{Int64})=nc_put_vara_long(ncid,varid,start,count,vals)
nc_put_vara_x(ncid::Integer, varid::Integer, start, count, vals::ASCIIString)=nc_put_vara_text(ncid,varid,start,count,vals)



# Function to synchronize all files with disk
function ncsync()
  for ncf in currentNcFiles
    _nc_sync_c(ncf[2].ncid)
  end
end

function sync(nc::NcFile)
  _nc_sync_c(nc.ncid)
end

#Function to close netcdf files
function ncclose(fil::String)
  if (haskey(currentNcFiles,abspath(fil)))
    close(currentNcFiles[abspath(fil)])
  else
    println("File $fil not currently opened.")
  end
end

function ncclose()
  for f in keys(currentNcFiles)
    ncclose(f)
  end
end

function setcompression(v::NcVar,mode)
    if v.compress > -1
        if (NC_NETCDF4 & mode)== 0
            warn("Compression only possible for NetCDF4 file format. Compression will be ingored.")
            v.compress=-1
        else
            v.compress=max(v.compress,9)
            nc_def_var_deflate(int32(v.ncid),int32(v.varid),int32(1),int32(1),int32(v.compress));
        end
    end
end


function create(name::String,varlist::Array{NcVar};gatts::Dict{Any,Any}=Dict{Any,Any}(),mode::Uint16=NC_NETCDF4)
  
  #Create the file
  id = nc_create(name,mode)
  
  # Collect Dimensions and set NetCDF ID
  vars=Dict{ASCIIString,NcVar}();
  dims=Set{NcDim}();
  for v in varlist
      v.ncid=id
      for d in v.dim
          push!(dims,d);
      end
  end
  nunlim=0;
  ndim=int32(length(dims))
  
  #Create the NcFile Object
  nc=NcFile(id,int32(length(vars)),ndim,zero(Int32),vars,Dict{ASCIIString,NcDim}(),Dict{Any,Any}(),zero(Int32),name,NC_WRITE,true)
  
  for d in dims

      create_dim(nc,d)
    
    #Create dimension variable, if necessary
    if (length(d.vals)>0) & (!haskey(vars,d.name))
      push!(varlist,NcVar{Float64,1}(id,varida[1],1,length(d.atts),NC_DOUBLE,d.name,[d.dimid],[d],d.atts,-1))
    end
    
  end
 
  # Create variables in the file
  for v in varlist
      create_var(nc,v,mode)
  end
  
  # Put global attributes
  if !isempty(gatts)
    putatt(id,NC_GLOBAL,gatts)
  end
  
  # Leave define mode
  nc_enddef(nc)
  
  currentNcFiles[abspath(nc.name)]=nc
  
  for d in nc.dim
    #Write dimension variable
    if (length(d[2].vals)>0)
      putvar(nc,d[2].name,d[2].vals)
    end
  end
  
  return(nc)
end

create(name::String,varlist::NcVar;gatts::Dict{Any,Any}=Dict{Any,Any}(),mode::Uint16=NC_NETCDF4)=create(name,NcVar[varlist];gatts=gatts,mode=mode)

function close(nco::NcFile)
  #Close file
  nc_close(nco.ncid)
  delete!(currentNcFiles,abspath(nco.name))
  return nco.ncid
end


function open(fil::String; mode::Integer=NC_NOWRITE, readdimvar::Bool=false)
  # Open netcdf file
  ncid=nc_open(fil,mode)
  
  #Get initial information
  ndim,nvar,ngatt,nunlimdimid = nc_inq(ncid)

  #Create ncdf object
  ncf=NcFile(ncid,int32(nvar-ndim),ndim,ngatt,Dict{ASCIIString,NcVar}(),Dict{ASCIIString,NcDim}(),Dict{Any,Any}(),nunlimdimid,abspath(fil),mode,false)
  
  #Read global attributes
  ncf.gatts=getatts_all(ncid,NC_GLOBAL,ngatt)
  
  #Read dimensions
  for dimid = 0:ndim-1
    (name,dimlen)=nc_inq_dim(ncid,dimid)
    ncf.dim[name]=NcDim(ncid,dimid,-1,name,dimlen,[],Dict{Any,Any}())
  end
  
  #Read variable information
  for varid = 0:(nvar-1)
    (name,nctype,dimids,natts,vndim,isdimvar)=nc_inq_var(ncf,varid)
    if (isdimvar)
      ncf.dim[name].varid=varid
    end
    atts=getatts_all(ncid,varid,natts)
    vdim=Array(NcDim,length(dimids))
    i=1;
    for did in dimids
      vdim[i]=ncf.dim[getdimnamebyid(ncf,did)]
      i=i+1
    end
    ncf.vars[name]=NcVar{nctype2jltype[nctype],int(vndim)}(ncid,int32(varid),vndim,natts,nctype,name,int(dimids[vndim:-1:1]),vdim[vndim:-1:1],atts,0)
  end
  readdimvar==true ? _readdimvars(ncf) : nothing
  currentNcFiles[abspath(ncf.name)]=ncf
  return ncf
end

# Define some high-level functions
# High-level functions for writing data to files
function ncread{T<:Integer}(fil::String,vname::String;start::Array{T}=Array(Int,0),count::Array{T}=Array(Int,0))
  nc = haskey(currentNcFiles,abspath(fil)) ? currentNcFiles[abspath(fil)] : open(fil)
  x  = readvar(nc,vname,start,count)
  return x
end

ncread{T<:Integer}(fil::String,vname::String,start::Array{T,1},count::Array{T,1})=ncread(fil,vname,start=start,count=count)
function ncread!{T<:Integer}(fil::String,vname::String,vals::Array;start::Array{T}=ones(Int,ndims(vals)),count::Array{T}=Array(Int,size(vals)))
  nc = haskey(currentNcFiles,abspath(fil)) ? currentNcFiles[abspath(fil)] : open(fil)
  x  = readvar!(nc,vname,vals,start=start,count=count)
  return x
end

function ncinfo(fil::String)
  nc = haskey(currentNcFiles,abspath(fil)) ? currentNcFiles[abspath(fil)] : open(fil)
  return(nc)
end

#High-level functions for writing data to a file
function ncwrite{T<:Integer}(x::Array,fil::String,vname::String;start::Array{T,1}=ones(Int,length(size(x))),count::Array{T,1}=[size(x)...])
  nc = haskey(currentNcFiles,abspath(fil)) ? currentNcFiles[abspath(fil)] : open(fil,mode=NC_WRITE)
  if (nc.omode==NC_NOWRITE)
    close(nc)
    println("reopening file in WRITE mode")
    open(fil,mode=NC_WRITE)
  end
  putvar(nc,vname,x,start=start,count=count)
end
ncwrite(x::Array,fil::String,vname::String,start::Array)=ncwrite(x,fil,vname,start=start)

function ncgetatt(fil::String,vname::String,att::String)
  nc= haskey(currentNcFiles,abspath(fil)) ? currentNcFiles[abspath(fil)] : open(fil,NC_WRITE)
  return ( haskey(nc.vars,vname) ? get(nc.vars[vname].atts,att,nothing) : get(nc.gatts,att,nothing) )
end

#High-level function for creating files and variables
#
# if the file does not exist, it will be created
# if the file already exists, the variable will be added to the file

function create_dim(nc,dim)
    nc_redef(nc)
    nc_def_dim(nc.ncid,dim.name,dim.dimlen,dima);
    dim.dimid=dima[1];
    nc.dim[dim.name]=dim;
end

function create_var(nc,v,mode)
    
    nc_redef(nc)
    
    v.dimids=Int32[v.dim[i].dimid for i=1:length(v.dim)]
    for i=1:v.ndim dumids[i]=v.dimids[v.ndim+1-i] end
    
    nc_def_var(nc.ncid,v.name,v.nctype,v.ndim,dumids,vara)
    
    v.varid=vara[1];
    nc.vars[v.name]=v;
    putatt(nc.ncid,v.varid,v.atts)
    setcompression(v,mode)
end

function nccreate(fil::String,varname::String,dims...;atts::Dict=Dict{Any,Any}(),gatts::Dict=Dict{Any,Any}(),compress::Integer=-1,t::Union(Integer,Type)=NC_DOUBLE,mode::Uint16=NC_NETCDF4)
    # Checking dims argument for correctness
    dim=parsedimargs(dims)
    # open the file
    # create the NcVar object
    v=NcVar(varname,dim,atts=atts,compress=compress,t=t)
    # Test if the file already exists
    if (isfile(fil)) 
        nc=haskey(currentNcFiles,abspath(fil)) ? currentNcFiles[abspath(fil)] : open(fil,mode=NC_WRITE)
        if (nc.omode==NC_NOWRITE)
            close(nc)
            println("reopening file in WRITE mode")
            open(fil,NC_WRITE)
        end
        v.ncid = nc.ncid
        haskey(nc.vars,varname) ? error("Variable $varname already exists in file fil") : nothing
        # Check if dimensions exist, if not, create
        # Remember if dimension was created
        dcreate=Array(Bool,length(dim))
        for i=1:length(dim)
            if !haskey(nc.dim,dim[i].name)
                create_dim(nc,dim[i])
                v.dimids[i]=dim[i].dimid;
                dcreate[i] = true
            else
                v.dimids[i]=nc.dim[dim[i].name].dimid;
                v.dim[i] = nc.dim[dim[i].name]
                dcreate[i] = false
            end
        end
        # Create variable
        create_var(nc,v,mode)
        nc_enddef(nc)
        for i=1:length(dim)
            if dcreate[i] & !isempty(dim[i].vals)
                ncwrite(dim[i].vals,fil,dim[i].name)
            end
        end
    else
        nc = create(fil,v,gatts=gatts,mode=mode | NC_NOCLOBBER)
        for d in dim
            ncwrite(d.vals,fil,d.name)
        end
    end
end

show{T<:Any,N}(io::IO,a::NcVar{T,N})=println(io,a.name)
showcompact{T<:Any,N}(io::IO,a::NcVar{T,N})=println(io,a.name)
function show(io::IO,nc::NcFile)
    ncol,nrow=Base.tty_size()
    hline = repeat("-",nrow)
    println(io,"")
    println(io,"##### NetCDF File #####")
    println(io,"")
    println(io,nc.name)
    println(io,"")
    println(io,"##### Dimensions #####")
    println(io,"")
    @printf(io,"%15s %8s","Name","Length\n")
    println(hline)
  for d in nc.dim
    @printf(io,"%15s %8d\n",d[2].name,d[2].dimlen)
  end
  println(io,"")
  println(io,"##### Variables #####")
  println(io,"")
  @printf(io,"%20s%20s%20s\n","Name","Type","Dimensions")
  println("---------------------------------------------------------------")
  for v in nc.vars
    @printf(io,"%20s",v[2].name)
    @printf(io,"%20s          ",nctype2string[int(v[2].nctype)])
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
