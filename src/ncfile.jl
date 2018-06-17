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
    unlimdims::Vector{Int32}
    name::String
    omode::UInt16
    in_def_mode::Bool
end
#Define getindex method to retrieve a variable
Base.getindex(nc::NcFile,i::AbstractString) = haskey(nc.vars,i) ? nc.vars[i] : error("NetCDF file $(nc.name) does not have a variable named $(i)")

readvar(nc::NcFile, varname::AbstractString;start::Vector=defaultstart(nc[varname]),count::Vector=defaultcount(nc[varname])) =
  readvar(nc[varname],start=start,count=count)

putvar(nc::NcFile,varname::AbstractString,vals::Array;start=ones(Int,length(size(vals))),count=[size(vals)...]) =
  putvar(nc[varname], vals, start=start, count=count)

"""
  NetCDF.sync(nc::NcFile)

  Synchronizes the changes made to the file and writes changes to the disk.
"""
function sync(nc::NcFile)
  nc_sync(nc.ncid)
end

"""
    NetCDF.create(name::String,varlist::Array{<:NcVar};gatts::Dict=Dict{Any,Any}(),mode::UInt16=NC_NETCDF4)

Creates a new NetCDF file. Here, `name`
 is the name of the file to be created and `varlist` an array of `NcVar` holding the variables that should appear in the file.

### Keyword arguments

* `gatts` a Dict containing global attributes of the NetCDF file
* `mode` NetCDF file type (NC_NETCDF4, NC_CLASSIC_MODEL or NC_64BIT_OFFSET), defaults to NC_NETCDF4
"""
function create(name::AbstractString,varlist::Array{<:NcVar};gatts::Dict=Dict{Any,Any}(),mode::UInt16=NC_NETCDF4)
    #Create the file
    id = nc_create(name,mode)
    # Collect Dimensions and set NetCDF ID
    vars = Dict{String,NcVar}()
    dims = Set{NcDim}()
    for v in varlist
        v.ncid=id
        for d in v.dim
            push!(dims,d)
        end
    end
    ndim = Int32(length(dims))

    #Create the NcFile Object
    nc = NcFile(id,Int32(length(vars)),ndim,zero(Int32),vars,Dict{String,NcDim}(),Dict{Any,Any}(),Int32[],name,NC_WRITE,true)

    for d in dims
        create_dim(nc, d)
        if (length(d.vals)>0) & (!haskey(nc.vars,d.name))
            push!(varlist,NcVar{Float64,1,NC_DOUBLE}(id,0,1,length(d.atts),NC_DOUBLE,d.name,[d.dimid],[d],d.atts,-1,(zero(Int32),)))
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

    for d in nc.dim
        #Write dimension variable
        if length(d[2].vals) > 0
            putvar(nc,d[2].name,d[2].vals)
        end
    end

    return(nc)
end

create(name::AbstractString,varlist::NcVar...;gatts::Dict=Dict{Any,Any}(),mode::UInt16=NC_NETCDF4) =
  create(name,NcVar[varlist[i] for i=1:length(varlist)];gatts=gatts,mode=mode)

readvar!(nc::NcFile, varname::AbstractString, retvalsa::AbstractArray;start::Vector=defaultstart(nc[varname]),count::Vector=defaultcount(nc[varname])) =
  readvar!(nc[varname],retvalsa,start=start,count=count)

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

"""
NetCDF.close(nc::NcFile)

closes a NetCDF file handle
"""
function close(nco::NcFile)
  #Close file
  nc_close(nco.ncid)
  return nco.ncid
end

"""
NetCDF.open(fil::AbstractString,v::AbstractString)

opens a NetCDF variable `v` in the NetCDF file `fil` and returns an `NcVar` handle that implements the AbstractArray interface for reading and writing.

### Keyword arguments

* `mode` mode in which the file is opened, defaults to `NC_NOWRITE`, choose `NC_WRITE` for write access
* `readdimvar` determines if dimension variables will be read into the file structure, default is `false`
"""
function open(fil::AbstractString,v::AbstractString; mode::Integer=NC_NOWRITE, readdimvar::Bool=false)
  nc=open(fil,mode=mode,readdimvar=readdimvar)
  nc.vars[v]
end

"""
NetCDF.open(fil::AbstractString)

opens the NetCDF file `fil` and returns a `NcFile` handle.

### Keyword arguments

* `mode` mode in which the file is opened, defaults to `NC_NOWRITE`, choose `NC_WRITE` for write access
* `readdimvar` determines if dimension variables will be read into the file structure, default is `false`
"""
function open(fil::AbstractString; mode::Integer=NC_NOWRITE, readdimvar::Bool=false)

  # Open netcdf file
  ncid = nc_open(fil,mode)

  #Get initial information
  ndim,nvar,ngatt,unlimdims = nc_inq(ncid)

  #Create ncdf object
  ncf = NcFile(ncid,Int32(nvar-ndim),ndim,ngatt,Dict{String,NcVar}(),Dict{String,NcDim}(),Dict{Any,Any}(),unlimdims,abspath(fil),mode,false)

  #Read global attributes
  ncf.gatts=getatts_all(ncid,NC_GLOBAL,ngatt)

  #Read dimensions
  for dimid = 0:ndim-1
    (name,dimlen)=nc_inq_dim(ncid,dimid)
    ncf.dim[name]=NcDim(ncid,dimid,-1,name,dimlen,[],Dict{Any,Any}(),in(dimid,unlimdims) ? true : false)
  end

  #Read variable information
  for varid = 0:(nvar-1)
    (name,nctype,dimids,natts,vndim,isdimvar,chunksize) = nc_inq_var(ncf,varid)
    if (isdimvar)
      ncf.dim[name].varid=varid
    end
    atts = getatts_all(ncid,varid,natts)
    vdim = NcDim[ncf.dim[findfirst(i->i.dimid==did,ncf.dim)] for did in dimids]
    ncf.vars[name]=NcVar{nctype2jltype[nctype],Int(vndim),Int(nctype)}(ncid,Int32(varid),vndim,natts,nctype,name,dimids[vndim:-1:1],vdim[vndim:-1:1],atts,0,chunksize)
  end
  readdimvar == true && _readdimvars(ncf)
  return ncf
end

function open(f::Function, args...;kwargs...)
  io = open(args...;kwargs...)
  try
    f(io)
  finally
    close(io)
  end
end

nc_redef(nc::NcFile)=nc.in_def_mode || begin nc_redef(nc.ncid);nc.in_def_mode=true end
nc_enddef(nc::NcFile)=nc.in_def_mode && begin nc_enddef(nc.ncid);nc.in_def_mode=false end

"""
    readdimvars(nc::NcFile)

Read the values of all dimension variable into memory.
"""
function readdimvars(nc::NcFile)
    for v in nc.vars
        if isdimvar(v[2])
            v[2].dim[1].vals = readvar(nc,v[1])
            d[2].atts = v[2].atts
        end
    end
end

function show(io::IO,nc::NcFile)
    nrow,ncol=Base.displaysize(io)
    hline = repeat("-",ncol)
    l1=div(ncol,3)
    l2=2*l1
    println(io,"")
    println(io,"##### NetCDF File #####")
    println(io,"")
    println(io,nc.name)
    println(io,"")
    println(io,"##### Dimensions #####")
    println(io,"")
    println(io,tolen("Name",l2),tolen("Length",l1))
    println(io,hline)
    for d in nc.dim
        println(io,tolen(d[2].name,l2),tolen(d[2].unlim ? string("UNLIMITED (" ,d[2].dimlen," currently)") : d[2].dimlen,l1))
    end
    l1 = div(ncol,5)
    l2 = 2 * l1
    println(io,"")
    println(io,"##### Variables #####")
    println(io,"")
    println(io,tolen("Name",l2),tolen("Type",l1),tolen("Dimensions",l2))
    println(hline)
    for v in nc.vars
        s1 = string(tolen(v[2].name,l2))
        s2 = string(tolen(nctype2string[Int(v[2].nctype)],l1))
        s3 = ""
        for d in v[2].dim
            s3 = string(s3,d.name," ")
        end
        println(s1,s2,tolen(s3,l2))
    end
    l1 = div(ncol,4)
    l2 = 2 * l1
    println(io,"")
    println(io,"##### Attributes #####")
    println(io,"")
    println(io,tolen("Variable",l1),tolen("Name",l1),tolen("Value",l2))
    println(io,hline)
    for a in nc.gatts
        println(io,tolen("global",l1),tolen(a[1],l1),tolen(a[2],l2))
    end
    for v in nc.vars
        for a in v[2].atts
            println(io,tolen(v[2].name,l1),tolen(a[1],l1),tolen(a[2],l2))
        end
    end
end

tolen(s::Any, l::Number) = tolen(string(s), round(Int,l))
function tolen(s::AbstractString, l::Integer)
    ls = length(s)
    if ls<l
        return rpad(s,l)
    elseif ls>l
        return string(s[1:prevind(s,l-1)],"..")
    else
        return s
    end
end
