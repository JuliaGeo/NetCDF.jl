# This example demonstrates the use of the high-level Matlab-like interface
# 
# First of all we create an array with top-of the atmosphere radiation data

using netcdf
include("toa.jl")

# Define longitudes and latitudes, day and timesteps
lat=[-89:10:89]
lon=[0:30:359]
day=1
tim=[0:0]

# Create radiation array
rad = float64([g_pot(x2,x1,day,0) for x1=lon, x2=lat, x3=tim])

# Define some attributes of the variable (optionlal)
varatts = {"longname" => "Radiation at the top of the atmosphere",
           "units"    => "W/m^2"}
lonatts = {"longname" => "Longitude",
           "units"    => "degrees east"}
latatts = {"longname" => "Latitude",
           "units"    => "degrees north"}
timatts = {"longname" => "Time",
           "units"    => "hours since 01-01-2000 00:00:00"}
           
# Now we create the file radiation.nc and call the variable rad, define also the dimensions the variables depends on

nccreate("radiation.nc","rad",varatts,"lon",lon,lonatts,"lat",lat,latatts,"time",tim,timatts)

# Now we can write values to the file

ncwrite(rad,"radiation.nc","rad")

# And close the file

ncclose("radiation.nc")