# This example demonstrates the use of the medium-level R-ncdf-like interface
#
# First of all we create an array with top-of the atmosphere radiation data

using NetCDF

include("toa.jl")

# Define longitudes and latitudes, day and timesteps
lat = collect(-89:89)
lon = collect(0:359)
day = 1
tim = collect(0:23)

# Create radiation array
rad = Float64[g_pot(x2,x1,day,x3) for x1=lon, x2=lat, x3=tim]

# Define some attributes of the variable (optionlal)
varatts = Dict("longname" => "Radiation at the top of the atmosphere",
               "units"    => "W/m^2")
lonatts = Dict("longname" => "Longitude",
               "units"    => "degrees east")
latatts = Dict("longname" => "Latitude",
               "units"    => "degrees north")
timatts = Dict("longname" => "Time",
               "units"    => "hours since 01-01-2000 00:00:00")

#Here we start by defining the dimensions. This is done by creating NcDim objects:

latdim = NcDim("lat", lat, latatts)
londim = NcDim("lon", lon, lonatts)
timdim = NcDim("time", tim, timatts)

# Then we create an NcVar object, the data type is defined by the corresponding julia type:

radvar = NcVar("rad", [londim, latdim, timdim]; atts=varatts, t=Float32)

# Now we can finally create the netcdf-file and get a file handler in return:

isfile("radiation2.nc") && rm("radiation2.nc")
NetCDF.create("radiation2.nc", radvar) do nc

  # Writing data to the file is done using putvar

  NetCDF.putvar(nc, "rad", rad)

end

# We open a file for reading:

NetCDF.open("radiation2.nc") do nc

  # we now have an NcFile object that can be browsed

  println("Names of the NcFile fields: \n", fieldnames(typeof(nc)))

  println("Attributes of the variable rad: ", nc.vars["rad"].atts)

  # we read the whole variable:

  x = NetCDF.readvar(nc, "rad", start=[1, 1, 1], count=[-1, -1, -1])
  println("Successfully read an array of size ", size(x))

  # Additional
  # Reading parts of a file, for example reading only time steps 5 and 6 can be done with:

  x = NetCDF.readvar(nc, "rad", start=[1,1,5], count=[-1,-1,2])
  println("Successfully read an array of size ", size(x))

#here the first array [1,1,5] gives the starting position for reading while the second array [1,1,2] gives the number of blocks to be read along each dimension.
# If the count is set to -1 the whole dimension is read.
end
