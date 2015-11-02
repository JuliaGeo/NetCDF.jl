using BinDeps

@BinDeps.setup
libnetcdf = library_dependency("libnetcdf", aliases = ["libnetcdf4","libnetcdf-7"])

using Conda
provides(Conda.Manager, "libnetcdf", libnetcdf)

provides(AptGet, Dict("libnetcdf-dev"=>libnetcdf), os = :Linux)
provides(Yum, Dict("netcdf-devel"=>libnetcdf), os = :Linux)

@BinDeps.install Dict(:libnetcdf => :libnetcdf)
