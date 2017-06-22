# Quickstart

## Reading a file

The most common task is probably to just read a NetCDF file into memory. This is done with

    ncread(filename, varname)

This reads the whole variable into memory and returns it as a Julia array. To read only
a slice of a NetCDF file, there are optional `start` and `count` keyword arguments, where
on can specify the starting index and count along each dimension.

## A more advanced example

In this example we show how to create a NetCDF file from scratch, write some data to it and read it back in afterwards.
First of all we create an array with top-of the atmosphere radiation data

```@example 1
using NetCDF
include(joinpath(Pkg.dir("NetCDF"),"examples","toa.jl"))

# Define longitudes and latitudes, day and timesteps
lat=collect(-89.5:89.5)
lon=collect(-179.5:179.5)
day=1
tim=collect(0:23)

# Create radiation array
rad = [g_pot(x2,x1,day,x3) for x1=lon, x2=lat, x3=tim];

```

The resulting array is a 3-dimensional array with dimensions lon-lat-time, resembling
approximately the hourly top of atmosphere radiation on January 1st. For documentation
purposes we want to add atributes to the variable as well as the dimensions. Throughout
this package, attributes are represented `Dict{String}`s

```@example 1
varatts = Dict("longname" => "Radiation at the top of the atmosphere",
          "units"    => "W/m^2")
lonatts = Dict("longname" => "Longitude",
          "units"    => "degrees east")
latatts = Dict("longname" => "Latitude",
          "units"    => "degrees north")
timatts = Dict("longname" => "Time",
          "units"    => "hours since 01-01-2000 00:00:00");
```

Now we have all the meta-information ready to create the actual file:

```@example 1
fn = joinpath(tempdir(),"radiation.nc")
isfile(fn) && rm(fn)
nccreate(fn,"rad","lon",lon,lonatts,"lat",lat,latatts,"time",tim,timatts,atts=varatts);
nothing # hide
```

Once the file is created we can write the actual data to it:

```@example 1
ncwrite(rad,fn,"rad");
```

This does not yet ensure that the data is actually written to the file, it might still be cached
by the NetCDF library. In order to write and close the file we run `ncclose`

```@example 1
ncclose(fn)
nothing # hide
```

Now we assume we just retrieved this radiation NetCDF file and want to get some information about it.
This is done using `ncinfo`

```@example 1
ncinfo(fn)
```

Here we learn the most important information about the file, which variables it contains,
the variable dimensions and their attributes. We decide to read the radiation variable:

```@example 1
x=ncread(fn,"rad")
size(x)
```

This reads the whole array at once. If we only want to read a certain part of the variable,
for example if we only want to plot the time series at a certain location, we can use the `start` and `count`
keywords:

```@example 1
ts = ncread(fn,"rad",start=[180,45,1], count=[1,1,-1])
```

In order to correctly label the time steps we retrieve the time information from the file

```@example 1
tvec = Base.Dates.DateTime(2001,1,1)+Base.Dates.Hour.(ncread(fn,"time"))
```

Now we can generate the plot.

```@example 1
using PlotlyJS
plot(scatter(x=tvec,y=collect(ts)))
```

Another example would be to generate a heatmap plot of the solar radiation
at 12am UTC:

```@example 1
lons = ncread(fn,"lon")
lats = ncread(fn,"lat")
m    = ncread(fn,"rad",start=[1,1,12],count=[-1,-1,1])
plot(heatmap(x=lons,y=lats,z=m))
```
