# Wrap netcdf.h header file using Clang.jl
# This produces two files, common.jl and netcdf.jl
#
# common.jl is filtered manually, leaving out constants not starting with the NC_ prefix
# or otherwise unneccesary or invalid lines
# the manually selected constant and wrapped types are then copied into src/netcdf_c.jl
#
# from netcdf.jl first ::Cint and ::nc_type in the type signature are loosened to ::Integer
# then Cstring is replaced with Ptr{UInt8}
# then it is copied entirely to the end of src/netcdf_c.jl
# then all ccalls that return an error code are wrapped in the `check` function

using Clang

workdir = dirname(@__FILE__)
srcdir = joinpath(workdir, "../src")

headerpath = ["/home/martijn/src/netcdf-4.4.1/include/netcdf.h"]
includedirs = ["/home/martijn/src/netcdf-4.4.1/include"]

context = wrap_c.init(headers=headerpath,
                    output_dir=workdir,
                    common_file="common.jl",
                    clang_includes=includedirs,
                    header_library=x -> "libnetcdf")

run(context)
