"""
    NcDim

Represents a NetCDF dimension of name `name` optionally holding the dimension values.
"""
mutable struct NcDim
  ncid::Int32
  dimid::Int32
  varid::Int32
  name::String
  dimlen::UInt
  vals::AbstractArray
  atts::Dict
  unlim::Bool
end


"""
    NcDim(name::String,dimlength::Integer)

Creates a NetCDF dimension object named `name` with length `dimlength` in memory.

### Keyword arguments

* `values=[]` optional for adding dimension values which can be written to a dimension variable
* `atts` a Dict of attributes associated to the dimension variable
* `unlimited` is this the record dimension, defaults to `false`
"""
function NcDim(name::AbstractString,dimlength::Integer;values::Union{AbstractArray,Number}=[],atts::Dict=Dict{Any,Any}(),unlimited=false)
    length(values) > 0 && length(values) != dimlength && error("Dimension value vector must have the same length as dimlength!")
    NcDim(-1,-1,-1,string(name),dimlength,values,atts,unlimited)
end


"""
NcDim(name::String,values::AbstractVector)

Creates a NetCDF dimension object named `name` and associated `values` in memory.

### Keyword arguments

* `atts` a Dict of attributes associated to the dimension variable
* `unlimited` is this the record dimension, defaults to `false`
"""
NcDim(name::AbstractString,values::AbstractArray;atts::Dict=Dict{Any,Any}(),unlimited=false) =
  NcDim(name,length(values),values=values,atts=atts,unlimited=unlimited)
NcDim(name::AbstractString,values::AbstractArray,atts::Dict;unlimited=false) =
  NcDim(name,length(values),values=values,atts=atts,unlimited=unlimited)


function create_dim(nc,dim)
  nc_redef(nc)
  dima = MVector{1,Cint}()
  nc_def_dim(nc.ncid,dim.name,dim.dimlen,dima);
  dim.dimid=dima[1];
  dim.dimlen == 0 && push!(nc.unlimdims,dima[1])
  nc.dim[dim.name]=dim;
end
