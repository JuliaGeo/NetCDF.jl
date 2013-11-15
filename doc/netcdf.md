Julia NetCDF documentation
==========================

# High-level interface

## Getting information

    ncinfo ( filename )

prints information on the variables, dimension and attributes conatained in the file

## Reading data

    ncread ( filename, varname, [start, count] )
    
reads the values of the variable varname from file filename. If only parts of the variable are to be read, you can provide start and count, which enable you to read blocks of data. 
start and count have the same length as the number of variable dimensions. start gives the initial index for each dimension, while count gives the number of indices to be read along each dimension. As a special case, setting a value in count to -1 will cause the function to read all values along this dimension. 

## Writing data

    ncwrite (data, filename, varname, [start])
    
Writes the array data to the file. If no start is supplied, writing starts at index 1 in each dimension. You can supply the argument start, a vector that has the same number as the number of variable dimensions, that provides the indices where to start writing the data. 

## Writing attributes

    ncputatt (filename, varname, attributes)
    
Here the filename is a string, varname the name of the variable the attribute is associated with. If varname is not a valid variable name, then a global attribute is created. 

## Creating files

    nccreate (filename, varname, varattributes, dimensions ...)

This creates a variable in an existing netcdf file or creates a new file. Filename and varname are strings, while varattributes is a Dict consisting of pairs of attribute names and values. 
After that follows a list of dimensions. Each dimension entry starts with a dimension name (a String), and may be followed by a dimension length, an array with dimension values or a Dict containing dimension attributes. Then the next dimension is entered and so on. Have a look at examples/high.jl for an example use. 
 
## Miscellaneous

    ncsync( [filename] )
    
Synchronizes the changes made to the file and writes changes to the disk. If the argument is omitted, all open files are synchronized. 

    ncclose( [filename] )
    
Closes the file and writes changes to the disk. If argument is omitted, all open files are closed.   

# Medium-level interface

## Getting information

    nc = NetCDF.open ( filename )
    
this function returns an object of type NcVar, which contains all file metainformation and attributes. You can browse it, just type 

    names ( nc )
    
to find out the fields of the type NcVar. Most of the other functions of the medium-level interface will use the NcFile object as their first argument. 

## Reading data

    NetCDF.readvar( nc, varname, start, count )
    
This function returns an array of values read from the file. The first argument is of type NcFile and is the file handler of a previously opened netcdf file. varname is the variable name of the variable to be read. start and count are integer arrays of the same length as the number of variable dimensions, giving the starting indices and the number of steps to be read along each dimension. Setting values in the count vector to -1 will cause the function to read all indices of the respective dimension. 

## Writing data

    NetCDF.putvar( nc, varname, [start], vals)
    
This function writes the values from the array vals to a netcdf file. nc is a netcdf file handler of type NcFile, varname the variable name and vals an array with the same dimension as the variable in the netcdf file. The optional parameter start gives the first index in each dimension along which the writing should begin. 

  
## Creating files

To create a netCDF file you first have to define the dimensions and variables that it is supposed to hold. As representations for netCDF dimensions and variables there are the predefined NcVar and NcDim types. An NcDim object is created by:

    NcDim ( dimname, dimvals, [dimattributes] )
    
here dimname is the dimension name, dimvals is a 1D array of value that are written to the dimension variable and the optional argument dimattributes is a Dict holding pairs of attribute names and values. 

After defining the dimensions, you can create NcVar objects with

    NcVar ( varname, dimlist, [varattributes], juliatype )
    
Here varname is the name of the variable, dimlist an array of type NcDim holding the dimensions associated to the variable, varattributes is a Dict holding pairs of attribute names and values. juliatype is the data type that should be used for storing the variable. This type will be translated to the corresponding netCDF data type. Currently the following types are valid options: (Int16, Int32, Float32, Float64) will be translated to (NC_SHORT, NC_INT, NC_FLOAT, NC_DOUBLE). 

Having defined the variables, the netcdf file can be created:

    NetCDF.create ( filename, varlist )
    
Here, filename is the name of the file to be created and varlist an array of NcVar holding the variables that should appear in the file. 

## Miscellaneous

once you have finished reading, writing or editing your files you can close the file with

    NetCDF.close ( nc )

If you just want to synchronize your changes to the disk, run

    NetCDF.sync ( nc )
    
where nc is a netcdf file handler. 

