__precompile__()

module NetCDF

using Formatting
import StaticArrays: SVector, MVector, @SVector
using Base.Cartesian

include("netcdf_c.jl")

import Base.show

export NcDim,NcVar,NcFile,ncread,ncread!,ncwrite,nccreate,ncsync,ncinfo,ncputatt,
    NC_BYTE,NC_SHORT,NC_INT,NC_FLOAT,NC_DOUBLE,NC_STRING,ncgetatt,NC_NOWRITE,NC_WRITE,NC_CHAR,
    NC_CLOBBER,NC_NOCLOBBER,NC_CLASSIC_MODEL,NC_64BIT_OFFSET,NC_NETCDF4,NC_UNLIMITED,
    nc_char2string, nc_string2char

#Some constants

global const nctype2jltype = Dict(
    NC_BYTE => Int8,
    NC_UBYTE => UInt8,
    NC_SHORT => Int16,
    NC_INT => Int32,
    NC_INT64 => Int64,
    NC_FLOAT => Float32,
    NC_DOUBLE => Float64,
    NC_CHAR => UInt8,
    NC_STRING => String)

global const nctype2string = Dict(
  NC_BYTE => "BYTE",
  NC_UBYTE => "UBYTE",
  NC_SHORT => "SHORT",
  NC_INT => "INT",
  NC_INT64 => "INT64",
  NC_FLOAT => "FLOAT",
  NC_DOUBLE => "DOUBLE",
  NC_STRING => "STRING",
  NC_CHAR => "CHAR")


function jl2nc(t::DataType)
    popfirst!(collect(keys(nctype2jltype))[findall(e->(t <: e), collect(values(nctype2jltype)))])
end
jl2nc(t::Type{UInt8}) = NC_UBYTE

getJLType(t::DataType) = t
getJLType(t::Int) = nctype2jltype[t]

getNCType(t::DataType) = jl2nc(t)
getNCType(t::Int) = Int(t)

include("netcdf_helpers.jl")
include("ncdim.jl")
include("ncvar.jl")
include("ncfile.jl")
include("highlevel.jl")

"""
    NetCDF.putatt(nc::NcFile, varname::String, atts::Dict)

Writes the attributes defined in `atts` to the variable `varname` in the NetCDF file
`nc`. Existing attributes are overwritten. If varname is not a valid variable name,
a global attribute will be written.
"""
function putatt(nc::NcFile,varname::AbstractString,atts::Dict)
    varid = haskey(nc.vars,varname) ? nc.vars[varname].varid : NC_GLOBAL
    chdef = false
    if !nc.in_def_mode
        chdef = true
        nc_redef(nc.ncid)
    end
    putatt(nc.ncid,varid,atts)
    chdef && nc_enddef(nc.ncid)
end


#show{T<:Any,N}(io::IO,a::NcVar{T,N})=println(io,a.name)
#showcompact{T<:Any,N}(io::IO,a::NcVar{T,N})=println(io,a.name)


end # Module
