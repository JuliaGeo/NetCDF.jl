NetCDF.jl
============

[![Build Status](https://travis-ci.org/JuliaGeo/NetCDF.jl.png)](https://travis-ci.org/JuliaGeo/NetCDF.jl)

NetCDF support for the julia programming language, there is a high-level and a medium-level interface for writing and reading netcdf files. 

# Installation

    Pkg.add("NetCDF")

# Quickstart

The high-level interface is quite similar to the Matlab NetCDF interface, reading files is done by:

    x = ncread("myfile.nc", "Radiation")
    
which will read the variable called "Radiation" from the file "myfile.nc". General information can be gained by using 

    ncinfo( filename )
    
which gives an overview of the dimensions, variables and attributes stored in the file.

    filename   = "myfile.nc"
    varname    = "var1"
    attribs    = {"units"    => "mm/d",
                  "data_min" => 0.0,
                  "data_max" => 87.0}

 Creating variables and files is done by using the nccreate command:
    
    nccreate( filename , varname , "x1" , 11:20, "t", 20 ,{"units"=>"s"}, atts=attribs)
    
This will create the variable called var1 in the file myfile.nc. The attributes defined in the Dict attribs are written to the file and are associated with the 
newly created variable. The dimensions "x1" and "t" of the variable are called "x1" and "t" in this example. If the dimensions do not exist yet in the file, 
they will be created. The dimension "x1" will be of length 10 and have the values 11..20, and the dimension "t" will have length 20 and the attribute "units"
with the value "s". 

Now we can write data to the file:

    d = rand( 10, 20 )
    ncwrite(d, filename, varname)
    
To learn more, have a look at https://github.com/meggart/NetCDF.jl/blob/master/doc/NetCDF.md. 

Contact info:
Fabian Gans (fgans@bgc-jena.mpg.de)
Max-Planck-Institute for Biogeochemistry
Jena, Germany
