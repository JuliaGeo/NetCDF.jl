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
