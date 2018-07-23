using BinDeps
import CondaBinDeps

@BinDeps.setup
libnetcdf = library_dependency("libnetcdf", aliases = ["libnetcdf4","libnetcdf-7","netcdf"])

#CondaBinDeps.Conda.add_channel("conda-forge")
provides(CondaBinDeps.Manager, "libnetcdf", libnetcdf)
provides(AptGet, "libnetcdf-dev", libnetcdf, os = :Linux)
provides(Yum, "netcdf-devel", libnetcdf, os = :Linux)

@BinDeps.install Dict(:libnetcdf => :libnetcdf)
