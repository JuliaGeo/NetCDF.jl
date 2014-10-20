# This example demonstrates the use of the high-level Matlab-like interface
#
# First of all we create an array with top-of the atmosphere radiation data

using NetCDF
include("toa.jl")

# Define longitudes and latitudes, day and timesteps
lat=[-89:89]
lon=[0:359]
day=1
tim=[0:23]

# Create radiation array
rad = float64([g_pot(x2,x1,day,x3) for x1=lon, x2=lat, x3=tim])

# Define some attributes of the variable (optionlal)
varatts = @Compat.Dict("longname" => "Radiation at the top of the atmosphere",
           "units"    => "W/m^2")
lonatts = @Compat.Dict("longname" => "Longitude",
           "units"    => "degrees east")
latatts = @Compat.Dict("longname" => "Latitude",
           "units"    => "degrees north")
timatts = @Compat.Dict("longname" => "Time",
           "units"    => "hours since 01-01-2000 00:00:00")

# Now we create the file radiation.nc and call the variable rad, define also the dimensions the variables depends on

isfile("radiation.nc") ? rm("radiation.nc") : nothing
nccreate("radiation.nc","rad","lon",lon,lonatts,"lat",lat,latatts,"time",tim,timatts,atts=varatts)

# Now we can write values to the file

ncwrite(rad,"radiation.nc","rad")

# And close the file

ncclose("radiation.nc")

# Reading the whole dataset is done by:

x=ncread("radiation.nc","rad");
println("Successfully read an array of size ",size(x))

# Additional
# Reading parts of a file, for example reading only time steps 5 and 6 can be done with:

x=ncread("radiation.nc","rad",[1,1,5],[-1,-1,2])
println("Successfully read an array of size ",size(x))

#here the first array [1,1,5] gives the starting position for reading while the second array [1,1,2] gives the number of blocks to be read along each dimension.
# If the count is set to -1 the whole dimension is read.

#The same can be done for ncwrite

x=ones(Float64,1,360,1)
#ncwrite(x,"radiation.nc","rad",[60,1,4])
# This would set all values at 60deg longitude at the 4th time step to 1.





