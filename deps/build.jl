using BinDeps

@BinDeps.setup
netcdf = library_dependency("libnetcdf", aliases = ["libnetcdf4","libnetcdf-7"])

using Conda
provides(Conda.Manager, "libnetcdf", netcdf)

@osx_only begin
    using Homebrew
		provides(Homebrew.HB, "netcdf", netcdf, os = :Darwin )
end

provides(AptGet, Dict("libnetcdf-dev"=>netcdf), os = :Linux)
provides(Yum, Dict("netcdf-devel"=>netcdf), os = :Linux)

@BinDeps.install
