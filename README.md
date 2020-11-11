NetCDF.jl
=========

| **Documentation**                                                               | **Build Status**                                                                                |
|:-------------------------------------------------------------------------------:|:-----------------------------------------------------------------------------------------------:|
| [![][docs-dev-img]][docs-dev-url] | [![][travis-img]][travis-url] [![][appveyor-img]][appveyor-url] |


NetCDF support for the julia programming language, there is a high-level and a medium-level interface for writing and reading netcdf files.

# Installation

```julia
pkg> add NetCDF
```

# Quickstart

First, load the library:

```julia
using NetCDF
```

The high-level interface is quite similar to the Matlab NetCDF interface, reading files is done by:

```julia
x = ncread("myfile.nc", "Radiation")
```

which will read the variable called "Radiation" from the file "myfile.nc". General information can be gained by using

```julia
ncinfo(filename)
```

which gives an overview of the dimensions, variables and attributes stored in the file.

```julia
filename = "myfile.nc"
varname  = "var1"
attribs  = Dict("units"   => "mm/d",
                "data_min" => 0.0,
                "data_max" => 87.0)
```

 Creating variables and files is done by using the nccreate command:

```julia
nccreate(filename, varname, "x1", collect(11:20), "t", 20, Dict("units"=>"s"), atts=attribs)
```

This will create the variable called var1 in the file myfile.nc. The attributes defined in the Dict attribs are written to the file and are associated with the
newly created variable. The dimensions "x1" and "t" of the variable are called "x1" and "t" in this example. If the dimensions do not exist yet in the file,
they will be created. The dimension "x1" will be of length 10 and have the values 11..20, and the dimension "t" will have length 20 and the attribute "units"
with the value "s".

Now we can write data to the file:

```julia
d = rand(10, 20)
ncwrite(d, filename, varname)
```

The full documentation can be found [here][docs-dev-url]

An alternative interface for reading NetCDF files can be found here: https://github.com/Alexander-Barth/NCDatasets.jl

# DiskArray interface

As of version 0.9 we provide an interface to DiskArrays.jl, which lets you treat NetCDF variables as Julia AbstractArrays. Special methods for accessing, reading slices and reductions and broadcasting are implemented, so that working with the arrays should be efficient.

So the following returns a lazy AbstractArray container referencing the data in the variable.

```julia
v = NetCDF.open(filename, varname)
```

## Credits

This package was originally started and is mostly maintained by Fabian Gans (fgans@bgc-jena.mpg.de). The automatic C wrapper generator was contributed by Martijn Visser (https://github.com/visr). Many thanks to several people who contributed bug fixes and enhancements.

[docs-dev-img]: https://img.shields.io/badge/docs-dev-blue.svg
[docs-dev-url]: https://JuliaGeo.github.io/NetCDF.jl/dev

[travis-img]: https://travis-ci.com/JuliaGeo/NetCDF.jl.svg?branch=master
[travis-url]: https://travis-ci.com/JuliaGeo/NetCDF.jl

[appveyor-img]: https://ci.appveyor.com/api/projects/status/m9okydt7700kgavi?svg=true
[appveyor-url]: https://ci.appveyor.com/project/JuliaGeo/netcdf-jl/branch/master
