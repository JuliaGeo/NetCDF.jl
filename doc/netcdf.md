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

## Miscellaneous

    ncsync( [filename] )
    
Synchronizes the changes made to the file and writes changes to the disk. If the argument is omitted, all open files are synchronized. 

    ncclose( [filename] )
    
Closes the file and writes changes to the disk. If argument is omitted, all open files are closed.   
