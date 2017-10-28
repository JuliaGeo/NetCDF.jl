# Medium-level interface

## Open a file

```@docs
NetCDF.open
```

## Getting information

The `NetCDF.open` function returns an object of type `NcFile` which contains meta-Information about the file and associated variables. You can index
the NcFile object `nc[varname]` to retrieve an NcVar object and retrieve information about it. You can run `names(nc)` to get a list of available variables.

Most of the following functions of the medium-level interface will use either an `NcFile` or an `NcVar` object as their first argument.

## Reading data

```@docs
NetCDF.readvar
```

## Writing data

```@docs
NetCDF.putvar
```


## Creating files

To create a netCDF file you first have to define the dimensions and variables that it is supposed to hold. As representations for netCDF dimensions and variables there are the predefined NcVar and NcDim types. An NcDim object is created by:

    NcDim(dimname, dimlength, atts=Dict{Any,Any}(), values=[], unlimited=false)

here dimname is the dimension name, dimlength is the dimension length. The optional argument values is a 1D array of values that are written to the dimension variable and the optional argument atts is a Dict holding pairs of attribute names and values. Setting `unlimited=true` creates an unlimited dimension.

After defining the dimensions, you can create NcVar objects with

    NcVar(varname , dimlist; atts=Dict{Any,Any}(), t=Float64, compress=-1)

Here *varname* is the name of the variable, *dimlist* an array of type NcDim holding the dimensions associated to the variable, varattributes is a Dict holding pairs of attribute names and values. *t* is the data type that should be used for storing the variable.  You can either specify a Julia type(Int16, Int32, Float32, Float64) which will be translated to(NC_SHORT, NC_INT, NC_FLOAT, NC_DOUBLE) or directly specify one of the latter list. You can also set the compression level of the variable by setting *compress* to a number in the range 1..9 This has only an effect in netCDF4 files.


Having defined the variables, the netCDF file can be created:

    netCDF.create(filename, varlist, gatts=Dict{Any,Any}(),mode=NC_netCDF4)

Here, filename is the name of the file to be created and varlist an array of NcVar holding the variables that should appear in the file. In the optional argument *gatts* you can specify a Dict containing global attributes and mode is the file type you want to create(NC_netCDF4, NC_CLASSIC_MODEL or NC_64BIT_OFFSET).


## Miscellaneous

once you have finished reading, writing or editing your files you can close the file with

    netCDF.close(nc)

If you just want to synchronize your changes to the disk, run

    netCDF.sync(nc)

where nc is a netCDF file handler.

## Interface for creating files

```@docs
NcDim
```

```@docs
NcVar
```

```@docs
NetCDF.create
```
