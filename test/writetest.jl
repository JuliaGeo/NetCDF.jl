using netcdf
lon=NcDim("longitude",[1:10])
lat=NcDim("latitude",[1:20])
rad=NcVar("Radiation",[lon,lat],{"units"=>"W/m^2"},Float32)
nc=netcdf.create("test.nc",rad)
x=rand(10,20);
netcdf.putvar(nc,"Radiation",[1,1],x)
netcdf.close(nc)