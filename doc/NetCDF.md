Julia netCDF documentation
==========================

# High-level interface

## Getting information

    ncinfo(filename)

prints information on the variables, dimension and attributes contained in the file

## Reading data

    ncread(filename, varname, start=[1,1,...], count=[-1,-1,...])

reads the values of the variable varname from file filename. If only parts of the variable are to be read, you can provide optionally start and count, which enable you to read blocks of data.
start and count have the same length as the number of variable dimensions. start gives the initial index for each dimension, while count gives the number of indices to be read along each dimension. As a special case, setting a value in count to -1 will cause the function to read all values along this dimension.

    ncread!(filename, varname, d, start=[1,1,...], count=[-1,-1,...])

is the mutating form of `ncread` which expects a pre-allocated array d, where the data are written to. In performance-critical situations you should always use this function for two reasons: First you can avoid unnecessary memory allocation if you read and process data in a loop and can reuse memory. The second point is that the mutating version is type-safe is contrast to the non-mutating version. `ncread` will return an array with a type depending on the data type of your netCDF variable, which means that type-inference can not work correctly and further operations on that array might be slow. `ncread!` will always try to convert the data to the array-type provided by the user and never change the type of `d`, so that the element type of the returned array is predictable and operations on the returned array run fast.

## Writing data

    ncwrite(data, filename, varname, start=start, count=count)

Writes the array data to the file. If no start argument is supplied, writing starts at index 1 in each dimension.
You can supply the argument start, a vector that has the same number as the number of variable dimensions,
that provides the indices where to start writing the data. As default the number of values written along each dimension
equals the dimension of the input array. However you can specify the along which dimension the data will be written by
setting a count argument, an integer vector indicating the number of values written along each dimension.

## Reading attributes

    ncgetatt(filename, varname, attname)

This reads an attribute from the specified file and variable. To read global attributes, set varname to "Global".

## Writing attributes

    ncputatt(filename, varname, attributes)

Here the filename is a string, varname the name of the variable the attribute is associated with. If varname is not a valid variable name, then a global attribute is created.

## Creating files

    nccreate(filename, varname, dimensions ..., atts=atts,gatts=gatts,compress=compress,t=t,mode=mode)

This creates a variable in an existing netCDF file or creates a new file. Filename and varname are strings.  
After that follows a list of dimensions. Each dimension entry starts with a dimension name (a String), and
may be followed by a dimension length (can be Inf for unlimited dimensions), an array with dimension values or a Dict containing dimension attributes.
Then the next dimension is entered and so on. Have a look at examples/high.jl for an example use.

Possible optional arguments are:
- **atts** Dict of attribute names and values to be assigned to the variable created
- **gatts** Dict of attribute names and values to be written as global attributes
- **compress** Integer [0..9] setting the compression level of the file, only valid if mode=NC_netCDF4
- **t** variable type, currently supported types are: const NC_BYTE, NC_CHAR, NC_SHORT, NC_INT, NC_FLOAT, NC_LONG, NC_DOUBLE
- **mode** file creation mode, only valid when new file is created, choose one of: NC_netCDF4, NC_CLASSIC_MODEL, NC_64BIT_OFFSET

## Miscellaneous

    ncsync([ filename ])

Synchronizes the changes made to the file and writes changes to the disk. If the argument is omitted, all open files are synchronized.

    ncclose([ filename ])

Closes the file and writes changes to the disk. If argument is omitted, all open files are closed.   

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

# Reading and writing NC_CHAR and NC_STRING variables

There are two common types for storing String data in NetCDF variables. The first is `NC_CHAR`,
where a 1D array of strings is stored in a 2D `char**` array. Here the user must define the maximum
string length and add a respective NetCDF dimension. Since NetCDF4 there is the `NC_STRING` data type that allows
 the direct definition of String variables so that an N-dimensional String array directly maps to an N-dimensional
 array in the NetCDF file structure.

## NC_STRING variables

In this package, the Julia type `String` maps to the `NC_STRING` datatype, which means that creating a variable with any of

    nccreate(filename, varname, dims..., t=String)

or

    NcVar(varname,dims,t=String)

will result in a NetCDF variable of type `NC_STRING`. You can directly write an `Array{String}` of matching shape to these
variables. Similarly, calling `ncread` or `NetCDF.readvar` on any of these variables will return an `Array{String}`

## NC_CHAR variables

Dealing with `NC_CHAR` variables is a bit more complicated. This has 2 reasons. First, the dimensions of the NetCDF variables
do not match the dimensions of the resulting string array because of the additional `str_len` (or similar) axis that is introduced in the
NetCDF file. So an n-dimensional String-Array maps to an (n+1)-dimensional `NC_CHAR` array.

Second, historically the `NC_CHAR` type has been used to store compressed data, too. So it is not always desirable to automatically convert
these char arrays to strings. Anyhow, here is how you can deal with these variable types:

Assume you have a NetCDF variable of type `NC_CHAR` of dimensions (str_len: 10, axis2: 20).
Calling `x=ncread(...)` or `x=readvar(...)` on this variable will return an `Array{UInt8,2}` with size `(10,20)` as it is represented on disk.
If you You can either use this data directly (if it is numeric) or convert them to a `Vector{String}` by calling

    y=nc_char2string(x)

which will return a string vector of length 20.

An example for creating `NC_CHAR` and writing variables would be the following:

    nccreate(filename,varname,"str_len",20,"DimValues",5,t=NC_CHAR)
    xs = ["a","bb","ccc","dddd","eeeee"]
    ncwrite(filename,varname,nc_string2char(xs))

The call of `string2char` will convert the `Vector{String}` to a `Matrix{UInt8}`. which
can be written to the NetCDF file.
