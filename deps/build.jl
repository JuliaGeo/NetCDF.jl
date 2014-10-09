using BinDeps

@BinDeps.setup


@osx_only begin
    using Homebrew
    netcdf = library_dependency("libnetcdf", aliases = ["libnetcdf.7"])
    provides( Homebrew.HB, "netcdf", netcdf, os = :Darwin )
end

@linux_only begin
    netcdf = library_dependency("libnetcdf", aliases = ["libnetcdf-7"])
    provides(AptGet, Dict("libnetcdf-dev"=>netcdf))
    provides(Yum, Dict("netcdf-devel"=>netcdf))
end

@windows_only begin
    netcdf = library_dependency("netcdf")
    provides (Binaries,URI("http://www.paratools.com/Azure/NetCDF/paratools-netcdf-4.1.3.tar.gz"),netcdf,os=:Windows)
    push!(DL_LOAD_PATH, joinpath(Pkg.dir(),"NetCDF","deps","netcdf-4.1.3","bin"))
end

provides(Sources, URI("ftp://ftp.unidata.ucar.edu/pub/netcdf/netcdf-4.3.0.tar.gz"),netcdf)


@BinDeps.install
