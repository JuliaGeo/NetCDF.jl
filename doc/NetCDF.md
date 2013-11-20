Julia NetCDF documentation
==========================

# High-level interface

## Getting information

    ncinfo ( filename )

prints information on the variables, dimension and attributes conatained in the file

## Reading data

    ncread ( filename, varname, start=[1,1,...], count=[-1,-1,...] )
    
reads the values of the variable varname from file filename. If only parts of the variable are to be read, you can provide optionally start and count, which enable you to read blocks of data. 
start and count have the same length as the number of variable dimensions. start gives the initial index for each dimension, while count gives the number of indices to be read along each dimension. As a special case, setting a value in count to -1 will cause the function to read all values along this dimension. 

## Writing data

    ncwrite (data, filename, varname, start=start, count=count)
    
Writes the array data to the file. If no start argument is supplied, writing starts at index 1 in each dimension. 
You can supply the argument start, a vector that has the same number as the number of variable dimensions, 
that provides the indices where to start writing the data. As default the number of values written along each dimension
equals the dimension of the input array. However you can specify the along which dimension the data will be written by
setting a count argument, an integer vector indicating the number of values written along each dimension.

## Reading attributes

    ncgetatt (filename, varname, attname)
    
This reads an attribute from the specified file and variable. To read global attributes, set varname to "Global". 

## Writing attributes

    ncputatt (filename, varname, attributes)
    
Here the filename is a string, varname the name of the variable the attribute is associated with. If varname is not a valid variable name, then a global attribute is created. 

## Creating files

    nccreate (filename, varname, dimensions ..., atts=atts,gatts=gatts,compress=compress,t=t,mode=mode)

This creates a variable in an existing netcdf file or creates a new file. Filename and varname are strings.  
After that follows a list of dimensions. Each dimension entry starts with a dimension name (a String), and 
may be followed by a dimension length, an array with dimension values or a Dict containing dimension attributes. 
Then the next dimension is entered and so on. Have a look at examples/high.jl for an example use.

Possible optional arguments are:
- **atts** Dict of attribute names and values to be assigned to the variable created
- **gatts** Dict of attribute names and values to be written as global attributes
- **compress** Integer [0..9] setting the compression level of the file, only valid if mode=NC_NETCDF4
- **t** variable type, currently supported types are: const NC_BYTE, NC_CHAR, NC_SHORT, NC_INT, NC_FLOAT, NC_LONG, NC_DOUBLE
- **mode** file creation mode, only valid when new file is created, choose one of: NC_NETCDF4, NC_CLASSIC_MODEL, NC_64BIT_OFFSET

## Miscellaneous

    ncsync( [ filename ] )
    
Synchronizes the changes made to the file and writes changes to the disk. If the argument is omitted, all open files are synchronized. 

    ncclose( [ filename ] )
    
Closes the file and writes changes to the disk. If argument is omitted, all open files are closed.   

# Medium-level interface

## Getting information

    nc = netcdf.open ( filename, mode=NC_NOWRITE, readdimvar=false )
    
this function returns an object of type NcVar, which contains all file metainformation and attributes. You can browse it, just type 

    names ( nc )
    
to find out the fields of the type NcVar. Most of the other functions of the medium-level interface will use the NcFile object as their first argument. The optional argument mode determines the mode in which the files is opened (NC_NOWRITE or NC_WRITE). If you set readdimvar=true, then the dimension variables will be read when opening the file and added to the NcFIle object. 

## Reading data

    NetCDF.readvar( nc, varname, start=[1,1,...], count=[-1,-1,...])
    
This function returns an array of values read from the file. The first argument is of type NcFile and is the file handler of a previously opened netcdf file. varname is the variable name of the variable to be read. start and count are optional integer arrays of the same length as the number of variable dimensions, giving the starting indices and the number of steps to be read along each dimension. Setting values in the count vector to -1 will cause the function to read all indices of the respective dimension. If the start and count argument are omitted, the whole variable will be read. 

## Writing data

    NetCDF.putvar( nc, varname, vals, start=[1,1,...], count=[size(vals)...])
    
This function writes the values from the array vals to a netcdf file. nc is a netcdf file handler of type NcFile, varname the variable name and vals an array with the same dimension as the variable in the netcdf file. The optional parameter start gives the first index in each dimension along which the writing should begin. It is assumed that the input array vals has the same number of dimensions as the and writing happens along these dimensions. However, you can specify the number of values to be written along each dimension by adding an optional count argument, which is a vector whose length equals the number of variable dimensions. 

  
## Creating files

To create a netCDF file you first have to define the dimensions and variables that it is supposed to hold. As representations for netCDF dimensions and variables there are the predefined NcVar and NcDim types. An NcDim object is created by:

    NcDim ( dimname, dimlength, atts=Dict{Any,Any}(), values=[] )
    
here dimname is the dimension name, dimlength is the dimension length. The optional argument values is a 1D array of values that are written to the dimension variable and the optional argument atts is a Dict holding pairs of attribute names and values. 

After defining the dimensions, you can create NcVar objects with

    NcVar( varname , dimlist; atts=Dict{Any,Any}(), t=Float64, compress=-1)
    
Here *varname* is the name of the variable, *dimlist* an array of type NcDim holding the dimensions associated to the variable, varattributes is a Dict holding pairs of attribute names and values. *t* is the data type that should be used for storing the variable.  You can either specify a julia type (Int16, Int32, Float32, Float64) which will be translated to (NC_SHORT, NC_INT, NC_FLOAT, NC_DOUBLE) or directly specify one of the latter list. You can also set the compression level of the variable by setting *compress* to a number in the range 1..9 This has only an effect in NetCDF4 files. 

Having defined the variables, the netcdf file can be created:

    NetCDF.create ( filename, varlist, gatts=Dict{Any,Any}(),mode=NC_NETCDF4)
    
Here, filename is the name of the file to be created and varlist an array of NcVar holding the variables that should appear in the file. In the optional argument *gatts* you can specify a Dict containing global attributes and mode is the file type you want to create (NC_NETCDF4, NC_CLASSIC_MODEL or NC_64BIT_OFFSET). 

## Miscellaneous

once you have finished reading, writing or editing your files you can close the file with

    NetCDF.close ( nc )

If you just want to synchronize your changes to the disk, run

    NetCDF.sync ( nc )
    
where nc is a netcdf file handler. 

