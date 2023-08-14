# # Quickstart

# ## Reading a file

# The most common task is probably to just read a `NetCDF` file into memory. This is done with:

# `ncread(filename, varname)`


# This reads the whole variable into memory and returns it as a Julia array. To read only
# a slice of a `NetCDF` file, there are optional `start` and `count` keyword arguments, where
# one can specify the starting index and count along each dimension.

# ## Example

# In this example we show how to create a `NetCDF` file from scratch, write some data to it and read it back in afterwards.
# First of all we create an array with top-of the atmosphere radiation data:

using NetCDF
include(joinpath(dirname(pathof(NetCDF)), "../docs/scripts/guide/toa.jl"))

# Define longitudes and latitudes, day and timesteps

lat = -89.5:89.5
lon = -179.5:179.5
day = 1
tempo = 0:23;

# ## Create radiation array

rad = [g_pot(la, lo, day, t) for lo in lon, la in lat, t in tempo];

# The resulting array is a 3-dimensional array with dimensions lon-lat-time, resembling
# approximately the hourly top of atmosphere radiation on January 1st. For documentation
# purposes we want to add atributes to the variable as well as the dimensions. Throughout
# this package, attributes are represented `Dict{String}`s:

# ## add atributes

varatts = Dict("longname" => "Radiation at the top of the atmosphere",
           "units"    => "W/m^2")
lonatts = Dict("longname" => "Longitude",
           "units"    => "degrees east")
latatts = Dict("longname" => "Latitude",
           "units"    => "degrees north")
timatts = Dict("longname" => "Time",
           "units"    => "hours since 01-01-2000 00:00:00");

# Now we have all the meta-information ready to create the actual file.

# ## save file

fn = "radiation.nc"
isfile(fn) && rm(fn) # clear create

nccreate(fn, "rad",
    "lon", lon, lonatts,
    "lat", lat, latatts,
    "time", tempo, timatts,
    atts=varatts);


# Once the file is created we can write the actual data to it:

ncwrite(rad, fn, "rad")

# ## ncinfo

# Now we assume we just retrieved this radiation `NetCDF` file and want to get some information about it.
# This is done using `ncinfo`:

ncinfo(fn)

# Here we learn the most important information about the file, which variables it contains,
# the variable dimensions and their attributes. We decide to read the radiation variable:

x = ncread(fn,"rad");
size(x)

# ## slicing

# This reads the whole array at once. If we only want to read a certain part of the variable,
# for example if we only want to plot the time series at a certain location, we can use the `start` and `count`
# keywords:

ts = ncread(fn, "rad", start=[180,45,1], count=[1,1,-1])

# ## time series plot
# In order to correctly label the time steps we retrieve the time information from the file:

using Dates
tvec = DateTime(2001,1,1) + Hour.(ncread(fn,"time"))

# Now we can generate the plot:

using CairoMakie
# manual time ticks 
tempo = string.(tvec)
lentime = length(tempo)
slice_dates = range(1, lentime, step=lentime ÷ 8)

# the actual plot

fig, ax, obj = lines(1:length(tvec), ts[1,1,:])
ax.xticks = (slice_dates, tempo[slice_dates])
ax.xticklabelrotation = π / 2
ax.xticklabelalign = (:right, :center)
fig

# ## Heatmap plot

# Another example would be to generate a heatmap plot of the solar radiation at 12am UTC:

lons = ncread(fn, "lon")
lats = ncread(fn, "lat")
m = ncread(fn, "rad", start=[1,1,12], count=[-1,-1,1]);
heatmap(lons, lats, m[:,:,1]; colormap = :plasma,
    axis = (; xlabel = "lon", ylabel = "lat"))