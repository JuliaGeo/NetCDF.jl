using BinDeps

@BinDeps.setup


netcdf = library_dependency("netcdf", aliases = ["libnetcdf","libnetcdf-7"])


@osx_only begin
  using Homebrew
  provides( Homebrew.HB, "netcdf", netcdf, os = :Darwin )
end

@linux_only begin
  provides(AptGet, {"libnetcdf-dev"=>netcdf})
  provides(Yum, {"netcdf-devel"=>netcdf})
end

#@windows_only begin
#  #provides (Binaries,URI("ftp://ftp.unidata.ucar.edu/pub/netcdf/contrib/win32/netcdf-4.1.1-win32-bin.zip"),netcdf,os=:Windows)
  provides (Binaries,URI("http://www.paratools.com/Azure/NetCDF/paratools-netcdf-4.1.3.tar.gz"),netcdf,os=:Windows)
  push!(DL_LOAD_PATH, joinpath(Pkg.dir(),"NetCDF","deps","netcdf-4.1.3","bin"))
#end

provides(Sources, URI("ftp://ftp.unidata.ucar.edu/pub/netcdf/netcdf-4.3.0.tar.gz"),netcdf)


@BinDeps.install
