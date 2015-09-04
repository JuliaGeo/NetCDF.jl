module NetCDF
using Compat
using Formatting
using Base.Cartesian
include("netcdf_c.jl")
import Base.show
export NcDim,NcVar,NcFile,ncread,ncread!,ncwrite,nccreate,ncsync,ncinfo,ncclose,ncputatt,NC_BYTE,NC_SHORT,NC_INT,NC_FLOAT,NC_DOUBLE, ncgetatt,NC_NOWRITE,NC_WRITE,NC_CLOBBER,NC_NOCLOBBER,NC_CLASSIC_MODEL,NC_64BIT_OFFSET,NC_NETCDF4
NC_VERBOSE=false
#Some constants

function __init__()
  global const jltype2nctype=@Compat.Dict(Int8=>NC_BYTE,
                   Int16=>NC_SHORT,
                   Int32=>NC_INT,
                   Int64=>NC_INT64,
                   Float32=>NC_FLOAT,
                   Float64=>NC_DOUBLE,
                   Uint8=>NC_CHAR)

  global const nctype2jltype=@Compat.Dict(NC_BYTE=>Int8,
                    NC_SHORT=>Int16, 
                    NC_INT=>Int32,
                    NC_LONG=>Int64,
                    NC_FLOAT=>Float32,
                    NC_DOUBLE=>Float64,
                    NC_CHAR=>Uint8,
                    NC_STRING=>Ptr{Uint8})

  global const nctype2string=@Compat.Dict(NC_BYTE=>"BYTE",
                   NC_SHORT=>"SHORT",
                   NC_INT=>"INT",
                   NC_FLOAT=>"FLOAT",
                   NC_DOUBLE=>"DOUBLE",
                   NC_INT64=>"INT64")
end

"""The type `NcDim` Represents an NcDim object representing a NetCDF dimension of name `name` with dimension values.
"""
type NcDim
  ncid::Int32
  dimid::Int32
  varid::Int32
  name::ASCIIString
  dimlen::Uint
  vals::AbstractArray
  atts::Dict{Any,Any}
end

"""

    NcDim(name::String,dimlength::Integer;values::Union(AbstractArray,Number)=[],atts::Dict{Any,Any}=Dict{Any,Any}())`
This constructor creates an NcDim object with the name `name` and length `dimlength`.
""" 
function NcDim(name::String,dimlength::Integer;values::Union(AbstractArray,Number)=[],atts::Dict{Any,Any}=Dict{Any,Any}())
    (length(values)>0 && length(values)!=dimlength) ? error("Dimension value vector must have the same length as dimlength!") : nothing
    NcDim(-1,-1,-1,name,dimlength,values,atts)
  end

"""
    NcDim(name::String,dimlength::Integer;values::Union(AbstractArray,Number)=[],atts::Dict{Any,Any}=Dict{Any,Any}())
This constructor creates an NcDim object with the name `name` and and associated values `values`. Upon creation of the NetCDF file a 
dimension variable will be generated and the values be written to this variable. Optionally a Dict of attributes can be supplied. 
""" 
NcDim(name::String,values::AbstractArray;atts::Dict=Dict{Any,Any}())=
  NcDim(name,length(values),values=values,atts=atts)
NcDim(name::String,values::AbstractArray,atts::Dict)=
  NcDim(name,length(values),values=values,atts=atts)

"""
The type `NcVar{T,N}` represents a NetCDF variable. It is a subtype of AbstractArray{T,N}, so normal indexing using `[]` 
will work for reding and writing data to and from a NetCDF file. `NcVar` objects can be returned by the `open` function , by
indexing an `NcFIle` object (e.g. `myfile["temperature"]`) or, when creating a new file, constructing it directly.
"""
type NcVar{T,N} <: AbstractArray{T,N}
  ncid::Int32
  varid::Int32
  ndim::Int32
  natts::Int32
  nctype::Int32
  name::ASCIIString
  dimids::Vector{Int32}
  dim::Vector{NcDim}
  atts::Dict
  compress::Int32
end

Base.convert{S,T,N}(::Type{NcVar{T,N}},v::NcVar{S,N})=NcVar{T,N}(v.ncid,v.varid,v.ndim,v.natts,v.nctype,v.name,v.dimids,v.dim,v.atts,v.compress)

"""
    NcVar(name::String,dimin::Union(NcDim,Array{NcDim,1});atts::Dict{Any,Any}=Dict{Any,Any}(),t::Union(DataType,Integer)=Float64,compress::Integer=-1)
Here varname is the name of the variable, dimlist an array of type NcDim holding the dimensions associated to the variable, varattributes is a Dict 
holding pairs of attribute names and values. t is the data type that should be used for storing the variable. You can either specify a julia type 
(Int16, Int32, Float32, Float64) which will be translated to (NC_SHORT, NC_INT, NC_FLOAT, NC_DOUBLE) or directly specify one of the latter list. 
You can also set the compression level of the variable by setting compress to a number in the range 1..9 This has only an effect in NetCDF4 files.   
"""
#Some additional constructors
function NcVar(name::String,dimin::Union(NcDim,Array{NcDim,1});atts::Dict{Any,Any}=Dict{Any,Any}(),t::Union(DataType,Integer)=Float64,compress::Integer=-1)
  dim = isa(dimin,NcDim) ? NcDim[dimin] : dimin
  return NcVar{typeof(t)==DataType ? t : nctype2jltype[t],length(dim)}(-1,-1,length(dim),length(atts), typeof(t)==DataType ? jltype2nctype[t] : t,name,Array(Int32,length(dim)),dim,atts,compress)
end
NcVar(name::String,dimin::Union(NcDim,Array{NcDim,1}),atts::Dict{Any,Any},t::Union(DataType,Integer)=Float64)=NcVar{typeof(t)==DataType ? t : nctype2jltype[t],length(dimin)}(-1,-1,length(dimin),length(atts), typeof(t)==DataType ? jltype2nctype[t] : t,name,Array(Int,length(dimin)),dimin,atts,-1)

#Array methods
@generated function Base.size{T,N}(a::NcVar{T,N})
  :(@ntuple($N,i->Int(a.dim[i].dimlen)))
end
typealias IndR Union{Integer,UnitRange,Colon}
typealias ArNum Union{AbstractArray,Number}

Base.linearindexing(::NcVar)=Base.LinearSlow()
Base.getindex{T}(v::NcVar{T,1},i1::IndR)=readvar(v,i1)
Base.getindex{T}(v::NcVar{T,2},i1::IndR,i2::IndR)=readvar(v,i1,i2)
Base.getindex{T}(v::NcVar{T,3},i1::IndR,i2::IndR,i3::IndR)=readvar(v,i1,i2,i3)
Base.getindex{T}(v::NcVar{T,4},i1::IndR,i2::IndR,i3::IndR,i4::IndR)=readvar(v,i1,i2,i3,i4)
Base.getindex{T}(v::NcVar{T,5},i1::IndR,i2::IndR,i3::IndR,i4::IndR,i5::IndR)=readvar(v,i1,i2,i3,i4,i5)
Base.getindex{T}(v::NcVar{T,6},i1::IndR,i2::IndR,i3::IndR,i4::IndR,i5::IndR,i6::IndR)=readvar(v,i1,i2,i3,i4,i5,i6)

Base.setindex!{T}(v::NcVar{T,1},x::ArNum,i1::IndR)=putvar(v,x,i1)
Base.setindex!{T}(v::NcVar{T,2},x::ArNum,i1::IndR,i2::IndR)=putvar(v,x,i1,i2)
Base.setindex!{T}(v::NcVar{T,3},x::ArNum,i1::IndR,i2::IndR,i3::IndR)=putvar(v,x,i1,i2,i3)
Base.setindex!{T}(v::NcVar{T,4},x::ArNum,i1::IndR,i2::IndR,i3::IndR,i4::IndR)=putvar(v,x,i1,i2,i3,i4)
Base.setindex!{T}(v::NcVar{T,5},x::ArNum,i1::IndR,i2::IndR,i3::IndR,i4::IndR,i5::IndR)=putvar(v,x,i1,i2,i3,i4,i5)
Base.setindex!{T}(v::NcVar{T,6},x::ArNum,i1::IndR,i2::IndR,i3::IndR,i4::IndR,i5::IndR,i6::IndR)=putvar(v,x,i1,i2,i3,i4,i5,i6)


"""
The type `NcFile` represents a link to a NetCDF file. I can be retrieved by `NetCDF.open` or by `NetCDF.create`. 
"""
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
#Define getindex method to retrieve a variable
Base.getindex(nc::NcFile,i::AbstractString)=haskey(nc.vars,i) ? nc.vars[i] : error("NetCDF file $(nc.name) does not have a variable named $(i)")

include("netcdf_helpers.jl")

const currentNcFiles=Dict{ASCIIString,NcFile}()


readvar!(nc::NcFile, varname::String, retvalsa::Array;start::Vector=defaultstart(nc[varname]),count::Vector=defaultcount(nc[varname]))=readvar!(nc[varname],retvalsa,start=start,count=count)


"""
readvar!(v::NcVar, d::Array;start::Vector=ones(Uint,ndims(d)),count::Vector=size(d))
is the mutating form of `readvar` which expects a pre-allocated array d, where the data are written to. It reads the values of the NcVar object `v`
writing the values to the preallocated array `d`. 
If only parts of the variable are to be read, you can provide optionally `start` and `count`, which enable you to read blocks of data. `start` and `count` have the same 
length as the number of variable dimensions. start gives the initial index for each dimension, while count gives the number of indices to be read along each dimension. 
As a special case, setting a value in count to -1 will cause the function to read all values along this dimension. 
"""
function readvar!(v::NcVar, retvalsa::Array;start::Vector=defaultstart(v),count::Vector=defaultcount(v))

  length(start) == v.ndim || error("Length of start ($(length(start))) must equal the number of variable dimensions ($(v.ndim))")
  length(count) == v.ndim || error("Length of start ($(length(count))) must equal the number of variable dimensions ($(v.ndim))")

  p=preparestartcount(start,count,v)

  length(retvalsa) != p && error("Size of output array ($(length(retvalsa))) does not equal number of elements to be read ($p)!")

  nc_get_vara_x!(v.ncid,v.varid,gstart,gcount,retvalsa)

  retvalsa
end
#readvar{T<:Integer}(nc::NcFile,varname::AbstractString,start::Array{T,1},count::Array{T,1})=readvar(nc,varname,start=start,count=count)


readvar(nc::NcFile, varname::String;start::Vector=defaultstart(nc[varname]),count::Vector=defaultcount(nc[varname]))=readvar(nc[varname],start=start,count=count)

"""
readvar{T,N}(v::NcVar{T,N};start::Vector=ones(Int,v.ndim),count::Vector=zeros(Int,v.ndim))
`readvar` reads the values of the NcVar object `v` and returns them.  
If only parts of the variable are to be read, you can provide optionally `start` and `count`, which enable you to read blocks of data. `start` and `count` have the same 
length as the number of variable dimensions. start gives the initial index for each dimension, while count gives the number of indices to be read along each dimension. 
As a special case, setting a value in count to -1 will cause the function to read all values along this dimension. 
"""
function readvar{T,N}(v::NcVar{T,N};start::Vector=defaultstart(v),count::Vector=defaultcount(v))
    retvalsa = Array(T,count...) 
    readvar!(v, retvalsa, start=start, count=count)
    return retvalsa
end

"""
    readvar{T,N}(v::NcVar{T,N},I::IndR...)
Reading data from NetCDF file with array-style indexing. Integers and UnitRanges are valid indices for each dimension. 
"""
function readvar{T,N}(v::NcVar{T,N},I::IndR...)
    count=ntuple(i->counti(I[i],v.dim[i].dimlen),length(I))
    retvalsa = zeros(T,count)
    readvar!(v, retvalsa, I...)
    return retvalsa
end


# Here are some functions for array-style indexing readvar
#For single indices
@generated function readvar{T,N}(v::NcVar{T,N},I::Integer...)
  N==length(I) || error("Dimension mismatch")
  quote
    checkbounds(v,I...)
    @nexprs $N i->gstart[v.ndim+1-i]=I[i]-1
    nc_get_var1_x(v.ncid,v.varid,gstart,T)::T
  end
end

firsti(i::Integer,l::Integer)=i-1
counti(i::Integer,l::Integer)=1
firsti(r::UnitRange,l::Integer)=start(r)-1
counti(r::UnitRange,l::Integer)=length(r)
firsti(r::Colon,l::Integer)=0
counti(r::Colon,l::Integer)=Int(l)
# For ranges
@generated function readvar!{T,N}(v::NcVar{T,N}, retvalsa::Array,I::IndR...)
  
  N==length(I) || error("Dimension mismatch")

  quote
    checkbounds(v,I...)
    @nexprs $N i->gstart[v.ndim+1-i]=firsti(I[i],v.dim[i].dimlen)
    @nexprs $N i->gcount[v.ndim+1-i]=counti(I[i],v.dim[i].dimlen)
    p=1
    @nexprs $N i->p=p*gcount[v.ndim+1-i]
    length(retvalsa) != p && error(string("Size of output array ($(length(retvalsa))) does not equal number of elements to be read (",p,")!"))
    nc_get_vara_x!(v.ncid,v.varid,gstart,gcount,retvalsa)
    retvalsa
  end
end


for (t,ending,arname) in funext
    fname = symbol("nc_get_vara_$ending")
    fname1 = symbol("nc_get_var1_$ending")
    arsym=symbol(arname)
    @eval nc_get_vara_x!(ncid::Integer,varid::Integer,start::Vector{Uint},count::Vector{Uint},retvalsa::Array{$t})=$fname(ncid,varid,start,count,retvalsa)
    @eval nc_get_var1_x(ncid::Integer,varid::Integer,start::Vector{Uint},::Type{$t})=begin $fname1(ncid,varid,start,$(arsym)); $(arsym)[1] end
end


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

"""
    ncputatt(nc::String,varname::String,atts::Dict)
Writes name-value pairs of attributes given in `atts` to the file `nc`. If `varname` is a valid variable indentifier, the attribute(s) will be written to this variable. 
Otherwise, global attributes will be generated. This function automatically overwrites existing attributes.  
"""
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

putvar(nc::NcFile,varname::String,vals::Array;start=ones(Int,length(size(vals))),count=[size(vals)...])=putvar(nc[varname],vals,start=start,count=count)

"""
    putvar(v::NcVar,vals::Array;start::Vector=ones(Int,length(size(vals))),count::Vector=[size(vals)...])
This function writes the values from the array `vals` to a netcdf file. `v` is the NcVar handle of the respective variable and `vals` an array 
with the same dimension as the variable in the netcdf file. The optional parameter start gives the first index in each dimension along which the writing should 
begin. It is assumed that the input array vals has the same number of dimensions as the and writing happens along these dimensions. However, you can specify 
the number of values to be written along each dimension by adding an optional count argument, which is a vector whose length equals the number of variable dimensions. 
"""
function putvar(v::NcVar,vals::Array;start::Vector=ones(Int,length(size(vals))),count::Vector=[size(vals)...])
  p=preparestartcount(start,count,v)
  nc_put_vara_x(v.ncid,v.varid,gstart,gcount,vals)
end

@generated function putvar{T,N}(v::NcVar{T,N},val::Any,I::IndR...)
  
  N==length(I) || error("Dimension mismatch")

  quote
    checkbounds(v,I...)
    @nexprs $N i->gstart[v.ndim+1-i]=firsti(I[i],v.dim[i].dimlen)
    @nexprs $N i->gcount[v.ndim+1-i]=counti(I[i],v.dim[i].dimlen)
    p=1
    @nexprs $N i->p=p*gcount[v.ndim+1-i]
    length(val) != p && error(string("Size of output array ($(length(retvalsa))) does not equal number of elements to be read (",p,")!"))
    nc_put_vara_x(v.ncid,v.varid,gstart,gcount,val)
  end
end

function putvar{T,N}(v::NcVar{T,N},val::Any,I::Integer...)

    N==length(I) || error("Dimension mismatch")
    quote
      checkbounds(v,I...)
      @nexprs $N i->gstart[v.ndim+1-i]=I[i]-1
      nc_put_var1_x(v.ncid,v.varid,gstart,val)
    end

end

for (t,ending,arname) in funext
    fname = symbol("nc_put_vara_$ending")
    fname1= symbol("nc_put_var1_$ending")
    arsym=symbol(arname)
    @eval nc_put_vara_x(ncid::Integer, varid::Integer, start, count, vals::Array{$t})=$fname(ncid,varid,start,count,vals)
    @eval nc_put_var1_x(ncid::Integer,varid::Integer,start::Vector{Uint},val::$t)=begin $(arsym)[1]=val; $fname1(ncid,varid,start,$(arsym)) end
end



"Synchronizes the changes made to the file and writes changes to the disk. If the argument is omitted, all open files are synchronized. "
function ncsync()
  for ncf in currentNcFiles
    _nc_sync_c(ncf[2].ncid)
  end
end

function sync(nc::NcFile)
  _nc_sync_c(nc.ncid)
end

#Function to close netcdf files
"Closes the file and writes changes to the disk. If argument is omitted, all open files are closed.   "
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
            nc_def_var_deflate(v.ncid,v.varid,Int32(1),Int32(1),v.compress);
        end
    end
end
"""
    NetCDF.create(name::String,varlist::Array{NcVar};gatts::Dict{Any,Any}=Dict{Any,Any}(),mode::Uint16=NC_NETCDF4)
This creates a new NetCDF file. Here, `filename`
 is the name of the file to be created and `varlist` an array of `NcVar` holding the variables that should appear in the file. In the optional 
argument `gatts` you can specify a Dict containing global attributes and `mode` is the file type you want to create (NC_NETCDF4, NC_CLASSIC_MODEL or NC_64BIT_OFFSET). 
"""
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
  nunlim=0
  ndim=Int32(length(dims))
  
  #Create the NcFile Object
  nc=NcFile(id,Int32(length(vars)),ndim,zero(Int32),vars,Dict{ASCIIString,NcDim}(),Dict{Any,Any}(),zero(Int32),name,NC_WRITE,true)
  
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

create(name::String,varlist::NcVar...;gatts::Dict{Any,Any}=Dict{Any,Any}(),mode::Uint16=NC_NETCDF4)=create(name,NcVar[varlist[i] for i=1:length(varlist)];gatts=gatts,mode=mode)

"""
    NetCDF.close(nc::NcFile)
closes a NetCDF file handle
"""
function close(nco::NcFile)
  #Close file
  nc_close(nco.ncid)
  delete!(currentNcFiles,abspath(nco.name))
  return nco.ncid
end

"""
    NetCDF.open(fil::String,v::String; mode::Integer=NC_NOWRITE, readdimvar::Bool=false)
opens a NetCDF variable `v` in the NetCDF file `fil` and returns an `NcVar` handle that implements the AbstractArray interface for reading and writing. 
"""
function open(fil::String,v::String; mode::Integer=NC_NOWRITE, readdimvar::Bool=false)
    nc=open(fil,mode=mode,readdimvar=readdimvar)
    nc.vars[v]
end

"""
    open(fil::String; mode::Integer=NC_NOWRITE, readdimvar::Bool=false)
opens the NetCDF file `fil` and returns a `NcFile` handle. The optional argument mode determines the `mode` in which the files is opened (`NC_NOWRITE` or `NC_WRITE`). 
If you set `readdimvar=true`, then the dimension variables will be read when opening the file and added to the NcFIle object.  
"""
function open(fil::String; mode::Integer=NC_NOWRITE, readdimvar::Bool=false)
  # Open netcdf file
  ncid=nc_open(fil,mode)
  
  #Get initial information
  ndim,nvar,ngatt,nunlimdimid = nc_inq(ncid)

  #Create ncdf object
  ncf=NcFile(ncid,Int32(nvar-ndim),ndim,ngatt,Dict{ASCIIString,NcVar}(),Dict{ASCIIString,NcDim}(),Dict{Any,Any}(),nunlimdimid,abspath(fil),mode,false)
  
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
    ncf.vars[name]=NcVar{nctype2jltype[nctype],Int(vndim)}(ncid,Int32(varid),vndim,natts,nctype,name,dimids[vndim:-1:1],vdim[vndim:-1:1],atts,0)
  end
  readdimvar==true ? _readdimvars(ncf) : nothing
  currentNcFiles[abspath(ncf.name)]=ncf
  return ncf
end

# Define some high-level functions
"""
ncread(filename, varname, start=[1,1,...], count=[-1,-1,...] )
reads the values of the variable varname from file filename and returns the values in an array. 
If only parts of the variable are to be read, you can provide optionally `start` and `count`, which enable you to read blocks of data. `start` and `count` have the same 
length as the number of variable dimensions. start gives the initial index for each dimension, while count gives the number of indices to be read along each dimension. 
As a special case, setting a value in count to -1 will cause the function to read all values along this dimension. 
"""
function ncread{T<:Integer}(fil::String,vname::String;start::Array{T}=Array(Int,0),count::Array{T}=Array(Int,0))
  nc = haskey(currentNcFiles,abspath(fil)) ? currentNcFiles[abspath(fil)] : open(fil)
  length(start)==0 && (start=defaultstart(nc[vname]))
  length(count)==0 && (count=defaultcount(nc[vname]))
  x  = readvar(nc[vname],start=start,count=count)
  return x
end
ncread{T<:Integer}(fil::String,vname::String,start::Array{T,1},count::Array{T,1})=ncread(fil,vname,start=start,count=count)

"""
ncread! ( filename, varname, d, start=[1,1,...], count=[-1,-1,...] )
is the mutating form of `ncread` which expects a pre-allocated array d, where the data are written to. It reads the values of the variable varname from file filename
writing the values to the preallocated array `d`. 
If only parts of the variable are to be read, you can provide optionally `start` and `count`, which enable you to read blocks of data. `start` and `count` have the same 
length as the number of variable dimensions. start gives the initial index for each dimension, while count gives the number of indices to be read along each dimension. 
As a special case, setting a value in count to -1 will cause the function to read all values along this dimension. 
"""
function ncread!{T<:Integer}(fil::String,vname::String,vals::Array;start::Array{T}=ones(Int,ndims(vals)),count::Array{T}=Array(Int,size(vals)))
  nc = haskey(currentNcFiles,abspath(fil)) ? currentNcFiles[abspath(fil)] : open(fil)
  x  = readvar!(nc,vname,vals,start=start,count=count)
  return x
end

"prints information on the variables, dimension and attributes conatained in the file"
function ncinfo(fil::String)
  nc = haskey(currentNcFiles,abspath(fil)) ? currentNcFiles[abspath(fil)] : open(fil)
  return(nc)
end

iswritable(nc::NcFile)=(nc.omode & NC_WRITE) != zero(UInt16)

#High-level functions for writing data to a file
"""
    ncwrite{T<:Integer}(x::Array,fil::String,vname::String;start::Array{T,1}=ones(Int,length(size(x))),count::Array{T,1}=[size(x)...])
Writes the array `x` to the file `fil` and variable `vname`. If no `start` argument is supplied, writing starts at index 1 in each dimension. 
You can supply the argument `start`, a vector that has the same number as the number of variable dimensions, that provides the indices where to start writing the data. 
As default the number of values written along each dimension equals the dimension of the input array. However you can specify the along which dimension the data will be 
written by setting a `count` argument, an integer vector indicating the number of values written along each dimension.
"""
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

"This reads an attribute from the specified file and variable. To read global attributes, set varname to `Global`."
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

"""
    nccreate (filename, varname, dimensions ..., atts=atts,gatts=gatts,compress=compress,t=t,mode=mode)
This creates a variable in an existing netcdf file or creates a new file. `filename` and `varname` are strings.  
After that follows a list of dimensions. Each dimension entry starts with a dimension name (a String), and 
may be followed by a dimension length, an array with dimension values or a Dict containing dimension attributes. 
Then the next dimension is entered and so on. Have a look at examples/high.jl for an example use.

Possible optional arguments are:

- **atts** Dict of attribute names and values to be assigned to the variable created
- **gatts** Dict of attribute names and values to be written as global attributes
- **compress** Integer [0..9] setting the compression level of the file, only valid if mode=NC_NETCDF4
- **t** variable type, currently supported types are: const NC_BYTE, NC_CHAR, NC_SHORT, NC_INT, NC_FLOAT, NC_LONG, NC_DOUBLE
- **mode** file creation mode, only valid when new file is created, choose one of: NC_NETCDF4, NC_CLASSIC_MODEL, NC_64BIT_OFFSET
"""
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
            !isempty(d.vals) && ncwrite(d.vals,fil,d.name)
        end
    end
end

#show{T<:Any,N}(io::IO,a::NcVar{T,N})=println(io,a.name)
#showcompact{T<:Any,N}(io::IO,a::NcVar{T,N})=println(io,a.name)
function show(io::IO,nc::NcFile)
    nrow,ncol=Base.tty_size()
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
    println(hline)
  for d in nc.dim
    println(io,tolen(d[2].name,l2),tolen(d[2].dimlen,l1))
  end
  l1=div(ncol,5)
  l2=2*l1
  println(io,"")
  println(io,"##### Variables #####")
  println(io,"")
  println(io,tolen("Name",l2),tolen("Type",l1),tolen("Dimensions",l2))
  println(hline)
  for v in nc.vars
    s1=string(tolen(v[2].name,l2))
    s2=string(tolen(nctype2string[Int(v[2].nctype)],l1))
    s3=""
    for d in v[2].dim
      s3=string(s3,d.name," ")
    end
    println(s1,s2,tolen(s3,l2))
  end
  l1=div(ncol,4)
  l2=2*l1
  println(io,"")
  println(io,"##### Attributes #####")
  println(io,"")
  println(io,tolen("Variable",l1),tolen("Name",l1),tolen("Value",l2))
  println(hline)
  for a in nc.gatts
    println(io,tolen("global",l1),tolen(a[1],l1),tolen(a[2],l2))
  end
  for v in nc.vars
    for a in v[2].atts
      println(io,tolen(v[2].name,l1),tolen(a[1],l1),tolen(a[2],l2))
    end
  end

end
tolen(s::Any,l::Number)=tolen(string(s),round(Int,l))
function tolen(s::AbstractString,l::Integer)
  ls = length(s)
  if ls<l
    return rpad(s,l)
  elseif ls>l
    return string(s[1:prevind(s,l-1)],"..")
  else
    return s
  end
end

end # Module
