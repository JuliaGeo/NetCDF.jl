julia_netcdf
============

NetCDF support for the julia programming language, there is a high-level and a medium-level interface for writing and reading netcdf files. 
The high-level API is quite similar to the Matlab NetCDF interface, so reading files will look like:

    x = ncread ("myfile.nc", "Radiation")
    
which will read the variable called "Radiation" from the file "myfile.nc". General information can be gained by using 

    ncinfo ( filename )
    
which gives an overview of the dimensions, variables and attributes stored in the file. Creating variables and files is done by using the nccreate command 