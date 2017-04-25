# Medium-level interface

## Getting information

    nc = netCDF.open(filename, mode=NC_NOWRITE, readdimvar=false)

this function returns an object of type NcVar, which contains all file metainformation and attributes. You can browse it, just type

    names(nc)

to find out the fields of the type NcVar. Most of the other functions of the medium-level interface will use the NcFile object as their first argument. The optional argument mode determines the mode in which the files is opened(NC_NOWRITE or NC_WRITE). If you set readdimvar=true, then the dimension variables will be read when opening the file and added to the NcFIle object.

## Reading data

    netCDF.readvar(nc, varname, start=[1,1,...], count=[-1,-1,...])

This function returns an array of values read from the file. The first argument is of type NcFile and is the file handler of a previously opened netCDF file. varname is the variable name of the variable to be read. start and count are optional integer arrays of the same length as the number of variable dimensions, giving the starting indices and the number of steps to be read along each dimension. Setting values in the count vector to -1 will cause the function to read all indices of the respective dimension. If the start and count argument are omitted, the whole variable will be read.

## Writing data

    netCDF.putvar(nc, varname, vals, start=[1,1,...], count=[size(vals)...])

This function writes the values from the array vals to a netCDF file. nc is a netCDF file handler of type NcFile, varname the variable name and vals an array with the same dimension as the variable in the netCDF file. The optional parameter start gives the first index in each dimension along which the writing should begin. It is assumed that the input array vals has the same number of dimensions as the and writing happens along these dimensions. However, you can specify the number of values to be written along each dimension by adding an optional count argument, which is a vector whose length equals the number of variable dimensions.

This function writes the values from the array vals to a netcdf file. nc is a netcdf file handler of type NcFile, varname the variable name and vals an array with the same dimension as the variable in the netcdf file. The optional parameter start gives the first index in each dimension along which the writing should begin. It is assumed that the input array vals has the same number of dimensions as the and writing happens along these dimensions. However, you can specify the number of values to be written along each dimension by adding an optional count argument, which is a vector whose length equals the number of variable dimensions.


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
