"""
    nccreate (filename, varname, dimensions ...)

Create a variable in an existing netcdf file or generates a new file. `filename` and `varname` are strings.
After that follows a list of dimensions. Each dimension entry starts with a dimension name (a String), and
may be followed by a dimension length, an array with dimension values or a Dict containing dimension attributes.
Then the next dimension is entered and so on. Have a look at examples/high.jl for an example use.

###Keyword arguments

- **atts** Dict of attribute names and values to be assigned to the variable created
- **gatts** Dict of attribute names and values to be written as global attributes
- **compress** Integer [0..9] setting the compression level of the file, only valid if mode=NC_NETCDF4
- **t** variable type, currently supported types are: const NC_BYTE, NC_CHAR, NC_SHORT, NC_INT, NC_FLOAT, NC_LONG, NC_DOUBLE
- **mode** file creation mode, only valid when new file is created, choose one of: NC_NETCDF4, NC_CLASSIC_MODEL, NC_64BIT_OFFSET
"""
function nccreate(fil::AbstractString,varname::AbstractString,dims...;
  atts::Dict=Dict{Any,Any}(),gatts::Dict=Dict{Any,Any}(),compress::Integer=-1,
  t::Union{DataType,Integer}=NC_DOUBLE,mode::UInt16=NC_NETCDF4,chunksize=(0,))
    # Checking dims argument for correctness
    dim = parsedimargs(dims)
    # Check chunksize
    chunksize = chunksize[1]==0 ? ntuple(i->0,length(dim)) : chunksize
    # create the NcVar object
    v = NcVar(varname,dim,atts=atts,compress=compress,t=t,chunksize=chunksize)
    # Test if the file already exists
    if isfile(fil)
      open(fil,mode=NC_WRITE) do nc
        v.ncid = nc.ncid
        haskey(nc.vars,varname) && error("Variable $varname already exists in file $fil")
        # Check if dimensions exist, if not, create
        # Remember if dimension was created
        dcreate = falses(length(dim))
        for i=1:length(dim)
          @show dim[i]
            if !haskey(nc.dim,dim[i].name)
                create_dim(nc,dim[i])
                v.dimids[i] = dim[i].dimid
                if !isempty(dim[i].vals)
                  create_var(nc,NcVar{Float64,1,NC_DOUBLE}(nc.ncid,0,1,length(dim[i].atts),NC_DOUBLE,dim[i].name,[dim[i].dimid],[dim[i]],dim[i].atts,-1,(0,),NC_FILL_DOUBLE,NC_FILL_DOUBLE),mode)
                end
                dcreate[i] = true
            else
                v.dimids[i] = nc.dim[dim[i].name].dimid
                v.dim[i] = nc.dim[dim[i].name]
                dcreate[i] = false
            end
        end

        # Create variable
        create_var(nc, v, mode)
        nc_enddef(nc)
        for i = 1:length(dim)
            if dcreate[i] & !isempty(dim[i].vals)
                ncwrite(dim[i].vals,fil,dim[i].name)
            end
        end
      end
    else
        nc = create(fil,v,gatts=gatts,mode=mode | NC_NOCLOBBER)
        for d in dim
            !isempty(d.vals) && ncwrite(d.vals,fil,d.name)
        end
        close(nc)
    end
    return nothing
end

#High-level functions for writing data to a file
"""
    ncwrite(x::Array,fil::AbstractString,vname::AbstractString)

Writes the array `x` to the file `fil` and variable `vname`.

### Keyword arguments

* `start` Vector of length `ndim(v)` setting the starting index for writing for each dimension
* `count` Vector of length `ndim(v)` setting the count of values to be written along each dimension. The value -1 is treated as a special case to write all values from this dimension. This is usually inferred by the given array size.
"""
function ncwrite(x::Array,fil::AbstractString,vname::AbstractString;start=ones(Int,length(size(x))),count=[size(x)...])
  open(fil,mode=NC_WRITE,replace_missing=isa(missing,eltype(x))) do nc
    putvar(nc,vname,x,start=start,count=count)
  end
end
ncwrite(x::Array,fil::AbstractString,vname::AbstractString,start::Array)=ncwrite(x,fil,vname,start=start)

"""
    ncgetatt(filename, varname, attname)

This reads a NetCDF attribute `attname` from the specified file and variable. To read global attributes, set varname to `Global`.
"""
function ncgetatt(fil::AbstractString,vname::AbstractString,att::AbstractString)
  open(fil,mode=NC_NOWRITE) do nc
    haskey(nc.vars,vname) ? get(nc.vars[vname].atts,att,nothing) : get(nc.gatts,att,nothing)
  end
end

# Define some high-level functions
"""
    ncread(filename, varname)

reads the values of the variable varname from file filename and returns the values in an array.

### Keyword arguments

* `start` Vector of length `ndim(v)` setting the starting index for each dimension
* `count` Vector of length `ndim(v)` setting the count of values to be read along each dimension. The value -1 is treated as a special case to read all values from this dimension

### Example

To read the second slice of a 3D NetCDF variable one can write:

    ncread("filename","varname", start=[1,1,2], count = [-1,-1,1])

"""
function ncread(fil::AbstractString,vname::AbstractString;start::Array{T}=Int[],count::Array{T}=Int[],replace_missing=false) where T<:Integer
  open(fil,replace_missing=replace_missing) do nc
    length(start)==0 && (start=defaultstart(nc[vname]))
    length(count)==0 && (count=defaultcount(nc[vname]))
    readvar(nc[vname],start=start,count=count)
  end
end
ncread(fil::AbstractString,vname::AbstractString,start::Array{T,1},count::Array{T,1}) where {T<:Integer}=ncread(fil,vname,start=start,count=count)

"""
ncread!(filename, varname, d)

reads the values of the variable varname from file filename and writes the results to the pre-allocated array `d`

### Keyword arguments

* `start` Vector of length `ndim(v)` setting the starting index for each dimension
* `count` Vector of length `ndim(v)` setting the count of values to be read along each dimension. The value -1 is treated as a special case to read all values from this dimension

### Example

To read the second slice of a 3D NetCDF variable one can write:

d = zeros(10,10,1)
ncread!("filename","varname", d, start=[1,1,2], count = [-1,-1,1])

"""
function ncread!(fil::AbstractString,vname::AbstractString,vals::AbstractArray;start::Vector{Int}=ones(Int,ndims(vals)),count::Vector{Int}=[size(vals,i) for i=1:ndims(vals)])
  open(fil) do nc
    readvar!(nc,vname,vals,start=start,count=count)
  end
end

"""
    ncinfo()

prints information on the variables, dimension and attributes conatained in the file
"""
function ncinfo(fil::AbstractString)
    open(fil) do nc
      println(nc)
    end
end

"""
    ncputatt(nc::String,varname::String,atts::Dict)

Writes the attributes defined in `atts` to the variable `varname` for the given NetCDF file name
`nc`. Existing attributes are overwritten. If varname is not a valid variable name,
a global attribute will be written.
"""
function ncputatt(nc::AbstractString,varname::AbstractString,atts::Dict)
  open(nc,mode=NC_WRITE) do nc
    putatt(nc, varname, atts)
  end
end
