var documenterSearchIndex = {"docs": [

{
    "location": "#",
    "page": "Home",
    "title": "Home",
    "category": "page",
    "text": ""
},

{
    "location": "#NetCDF.jl-1",
    "page": "Home",
    "title": "NetCDF.jl",
    "category": "section",
    "text": "Reading and writing NetCDF files in Julia"
},

{
    "location": "#Package-features-1",
    "page": "Home",
    "title": "Package features",
    "category": "section",
    "text": "High-level (MATLAB-like), low-level (C-like) and array-based access to NetCDF files."
},

{
    "location": "#Manual-Outline-1",
    "page": "Home",
    "title": "Manual Outline",
    "category": "section",
    "text": "Pages = [\n    \"intro.md\",\n    \"quickstart.md\",\n    \"highlevel.md\",\n    \"intermediate.md\",\n    \"strings.md\"\n]\nDepth = 1"
},

{
    "location": "#Acknowledgements-1",
    "page": "Home",
    "title": "Acknowledgements",
    "category": "section",
    "text": "Thanks to everyone who contributed to the package with pull requests, especially to Martijn Visser for creating the new generated C wrapper."
},

{
    "location": "#Index-1",
    "page": "Home",
    "title": "Index",
    "category": "section",
    "text": ""
},

{
    "location": "quickstart/#",
    "page": "Quickstart",
    "title": "Quickstart",
    "category": "page",
    "text": ""
},

{
    "location": "quickstart/#Quickstart-1",
    "page": "Quickstart",
    "title": "Quickstart",
    "category": "section",
    "text": ""
},

{
    "location": "quickstart/#Reading-a-file-1",
    "page": "Quickstart",
    "title": "Reading a file",
    "category": "section",
    "text": "The most common task is probably to just read a NetCDF file into memory. This is done with:ncread(filename, varname)This reads the whole variable into memory and returns it as a Julia array. To read only a slice of a NetCDF file, there are optional start and count keyword arguments, where on can specify the starting index and count along each dimension."
},

{
    "location": "quickstart/#A-more-advanced-example-1",
    "page": "Quickstart",
    "title": "A more advanced example",
    "category": "section",
    "text": "In this example we show how to create a NetCDF file from scratch, write some data to it and read it back in afterwards. First of all we create an array with top-of the atmosphere radiation data:using NetCDF\ninclude(joinpath(dirname(pathof(NetCDF)), \"../examples/toa.jl\"))\n\n# Define longitudes and latitudes, day and timesteps\nlat = collect(-89.5:89.5)\nlon = collect(-179.5:179.5)\nday = 1\ntim = collect(0:23)\n\n# Create radiation array\nrad = [g_pot(x2,x1,day,x3) for x1=lon, x2=lat, x3=tim];The resulting array is a 3-dimensional array with dimensions lon-lat-time, resembling approximately the hourly top of atmosphere radiation on January 1st. For documentation purposes we want to add atributes to the variable as well as the dimensions. Throughout this package, attributes are represented Dict{String}s:varatts = Dict(\"longname\" => \"Radiation at the top of the atmosphere\",\n          \"units\"    => \"W/m^2\")\nlonatts = Dict(\"longname\" => \"Longitude\",\n          \"units\"    => \"degrees east\")\nlatatts = Dict(\"longname\" => \"Latitude\",\n          \"units\"    => \"degrees north\")\ntimatts = Dict(\"longname\" => \"Time\",\n          \"units\"    => \"hours since 01-01-2000 00:00:00\");Now we have all the meta-information ready to create the actual file:fn = joinpath(tempdir(),\"radiation.nc\")\nisfile(fn) && rm(fn)\nnccreate(fn,\"rad\",\"lon\",lon,lonatts,\"lat\",lat,latatts,\"time\",tim,timatts,atts=varatts);\nnothing # hideOnce the file is created we can write the actual data to it:ncwrite(rad,fn,\"rad\");This does not yet ensure that the data is actually written to the file, it might still be cached by the NetCDF library. In order to write and close the file we run ncclose:ncclose(fn)\nnothing # hideNow we assume we just retrieved this radiation NetCDF file and want to get some information about it. This is done using ncinfo:ncinfo(fn)Here we learn the most important information about the file, which variables it contains, the variable dimensions and their attributes. We decide to read the radiation variable:x=ncread(fn,\"rad\")\nsize(x)This reads the whole array at once. If we only want to read a certain part of the variable, for example if we only want to plot the time series at a certain location, we can use the start and count keywords:ts = ncread(fn,\"rad\",start=[180,45,1], count=[1,1,-1])In order to correctly label the time steps we retrieve the time information from the file:using Dates\ntvec = DateTime(2001,1,1) + Hour.(ncread(fn,\"time\"))Now we can generate the plot:plot(tvec,ts)Another example would be to generate a heatmap plot of the solar radiation at 12am UTC:lons = ncread(fn,\"lon\")\nlats = ncread(fn,\"lat\")\nm    = ncread(fn,\"rad\",start=[1,1,12],count=[-1,-1,1])\nplot(heatmap(x=lons,y=lats,z=m))"
},

{
    "location": "highlevel/#",
    "page": "High-level interface",
    "title": "High-level interface",
    "category": "page",
    "text": ""
},

{
    "location": "highlevel/#High-level-interface-1",
    "page": "High-level interface",
    "title": "High-level interface",
    "category": "section",
    "text": ""
},

{
    "location": "highlevel/#NetCDF.ncinfo",
    "page": "High-level interface",
    "title": "NetCDF.ncinfo",
    "category": "function",
    "text": "ncinfo()\n\nprints information on the variables, dimension and attributes conatained in the file\n\n\n\n\n\n"
},

{
    "location": "highlevel/#Getting-information-1",
    "page": "High-level interface",
    "title": "Getting information",
    "category": "section",
    "text": "ncinfo"
},

{
    "location": "highlevel/#NetCDF.ncread",
    "page": "High-level interface",
    "title": "NetCDF.ncread",
    "category": "function",
    "text": "ncread(filename, varname)\n\nreads the values of the variable varname from file filename and returns the values in an array.\n\nKeyword arguments\n\nstart Vector of length ndim(v) setting the starting index for each dimension\ncount Vector of length ndim(v) setting the count of values to be read along each dimension. The value -1 is treated as a special case to read all values from this dimension\n\nExample\n\nTo read the second slice of a 3D NetCDF variable one can write:\n\nncread(\"filename\",\"varname\", start=[1,1,2], count = [-1,-1,1])\n\n\n\n\n\n"
},

{
    "location": "highlevel/#NetCDF.ncread!",
    "page": "High-level interface",
    "title": "NetCDF.ncread!",
    "category": "function",
    "text": "ncread!(filename, varname, d)\n\nreads the values of the variable varname from file filename and writes the results to the pre-allocated array d\n\nKeyword arguments\n\nstart Vector of length ndim(v) setting the starting index for each dimension\ncount Vector of length ndim(v) setting the count of values to be read along each dimension. The value -1 is treated as a special case to read all values from this dimension\n\nExample\n\nTo read the second slice of a 3D NetCDF variable one can write:\n\nd = zeros(10,10,1) ncread!(\"filename\",\"varname\", d, start=[1,1,2], count = [-1,-1,1])\n\n\n\n\n\n"
},

{
    "location": "highlevel/#Reading-data-1",
    "page": "High-level interface",
    "title": "Reading data",
    "category": "section",
    "text": "ncreadncread!"
},

{
    "location": "highlevel/#NetCDF.ncwrite",
    "page": "High-level interface",
    "title": "NetCDF.ncwrite",
    "category": "function",
    "text": "ncwrite(x::Array,fil::AbstractString,vname::AbstractString)\n\nWrites the array x to the file fil and variable vname.\n\nKeyword arguments\n\nstart Vector of length ndim(v) setting the starting index for writing for each dimension\ncount Vector of length ndim(v) setting the count of values to be written along each dimension. The value -1 is treated as a special case to write all values from this dimension. This is usually inferred by the given array size.\n\n\n\n\n\n"
},

{
    "location": "highlevel/#Writing-data-1",
    "page": "High-level interface",
    "title": "Writing data",
    "category": "section",
    "text": "ncwrite"
},

{
    "location": "highlevel/#NetCDF.ncgetatt",
    "page": "High-level interface",
    "title": "NetCDF.ncgetatt",
    "category": "function",
    "text": "ncgetatt(filename, varname, attname)\n\nThis reads a NetCDF attribute attname from the specified file and variable. To read global attributes, set varname to Global.\n\n\n\n\n\n"
},

{
    "location": "highlevel/#Reading-attributes-1",
    "page": "High-level interface",
    "title": "Reading attributes",
    "category": "section",
    "text": "ncgetatt"
},

{
    "location": "highlevel/#NetCDF.ncputatt",
    "page": "High-level interface",
    "title": "NetCDF.ncputatt",
    "category": "function",
    "text": "ncputatt(nc::String,varname::String,atts::Dict)\n\nWrites the attributes defined in atts to the variable varname for the given NetCDF file name nc. Existing attributes are overwritten. If varname is not a valid variable name, a global attribute will be written.\n\n\n\n\n\n"
},

{
    "location": "highlevel/#Writing-attributes-1",
    "page": "High-level interface",
    "title": "Writing attributes",
    "category": "section",
    "text": "ncputatt"
},

{
    "location": "highlevel/#NetCDF.nccreate",
    "page": "High-level interface",
    "title": "NetCDF.nccreate",
    "category": "function",
    "text": "nccreate (filename, varname, dimensions ...)\n\nCreate a variable in an existing netcdf file or generates a new file. filename and varname are strings. After that follows a list of dimensions. Each dimension entry starts with a dimension name (a String), and may be followed by a dimension length, an array with dimension values or a Dict containing dimension attributes. Then the next dimension is entered and so on. Have a look at examples/high.jl for an example use.\n\n###Keyword arguments\n\natts Dict of attribute names and values to be assigned to the variable created\ngatts Dict of attribute names and values to be written as global attributes\ncompress Integer [0..9] setting the compression level of the file, only valid if mode=NC_NETCDF4\nt variable type, currently supported types are: const NCBYTE, NCCHAR, NCSHORT, NCINT, NCFLOAT, NCLONG, NC_DOUBLE\nmode file creation mode, only valid when new file is created, choose one of: NCNETCDF4, NCCLASSICMODEL, NC64BIT_OFFSET\n\n\n\n\n\n"
},

{
    "location": "highlevel/#Creating-files-1",
    "page": "High-level interface",
    "title": "Creating files",
    "category": "section",
    "text": "nccreate"
},

{
    "location": "highlevel/#NetCDF.ncsync",
    "page": "High-level interface",
    "title": "NetCDF.ncsync",
    "category": "function",
    "text": "ncsync()\n\nSynchronizes the changes made all open NetCDF files and writes changes to the disk.\n\n\n\n\n\n"
},

{
    "location": "highlevel/#NetCDF.ncclose",
    "page": "High-level interface",
    "title": "NetCDF.ncclose",
    "category": "function",
    "text": "ncclose(filename::String)\n\nCloses the file and writes changes to the disk. If argument is omitted, all open files are closed.\n\n\n\n\n\n"
},

{
    "location": "highlevel/#Miscellaneous-1",
    "page": "High-level interface",
    "title": "Miscellaneous",
    "category": "section",
    "text": "ncsyncncclose"
},

{
    "location": "intermediate/#",
    "page": "Medium-level interface",
    "title": "Medium-level interface",
    "category": "page",
    "text": ""
},

{
    "location": "intermediate/#Medium-level-interface-1",
    "page": "Medium-level interface",
    "title": "Medium-level interface",
    "category": "section",
    "text": ""
},

{
    "location": "intermediate/#NetCDF.open",
    "page": "Medium-level interface",
    "title": "NetCDF.open",
    "category": "function",
    "text": "NetCDF.open(fil::AbstractString,v::AbstractString)\n\nopens a NetCDF variable v in the NetCDF file fil and returns an NcVar handle that implements the AbstractArray interface for reading and writing.\n\nKeyword arguments\n\nmode mode in which the file is opened, defaults to NC_NOWRITE, choose NC_WRITE for write access\nreaddimvar determines if dimension variables will be read into the file structure, default is false\n\n\n\n\n\nNetCDF.open(fil::AbstractString)\n\nopens the NetCDF file fil and returns a NcFile handle.\n\nKeyword arguments\n\nmode mode in which the file is opened, defaults to NC_NOWRITE, choose NC_WRITE for write access\nreaddimvar determines if dimension variables will be read into the file structure, default is false\n\n\n\n\n\n"
},

{
    "location": "intermediate/#Open-a-file-1",
    "page": "Medium-level interface",
    "title": "Open a file",
    "category": "section",
    "text": "NetCDF.open"
},

{
    "location": "intermediate/#Getting-information-1",
    "page": "Medium-level interface",
    "title": "Getting information",
    "category": "section",
    "text": "The NetCDF.open function returns an object of type NcFile which contains meta-Information about the file and associated variables. You can index the NcFile object nc[varname] to retrieve an NcVar object and retrieve information about it. You can run names(nc) to get a list of available variables.Most of the following functions of the medium-level interface will use either an NcFile or an NcVar object as their first argument."
},

{
    "location": "intermediate/#NetCDF.readvar",
    "page": "Medium-level interface",
    "title": "NetCDF.readvar",
    "category": "function",
    "text": "NetCDF.readvar(v::NcVar;start::Vector=ones(UInt,ndims(d)),count::Vector=size(d))\n\nReads the values from the file associated to the NcVar object v and returns them. By default the whole variable is read\n\nKeyword arguments\n\nstart Vector of length ndim(v) setting the starting index for each dimension\ncount Vector of length ndim(v) setting the count of values to be read along each dimension. The value -1 is treated as a special case to read all values from this dimension\n\nExample\n\nAssume v is a NetCDF variable with dimensions (3,3,10).\n\nx = NetCDF.readvar(v, start=[1,2,1], count=[3,1,-1])\n\nThis reads all values from the first and last dimension and only the second value from the second dimension.\n\n\n\n\n\nNetCDF.readvar{T,N}(v::NcVar{T,N},I::Union{Integer, UnitRange, Colon}...)\n\nReads data from a NetCDF file with array-style indexing. Integers and UnitRanges and Colons are valid indices for each dimension.\n\n\n\n\n\n"
},

{
    "location": "intermediate/#Reading-data-1",
    "page": "Medium-level interface",
    "title": "Reading data",
    "category": "section",
    "text": "NetCDF.readvar"
},

{
    "location": "intermediate/#NetCDF.putvar",
    "page": "Medium-level interface",
    "title": "NetCDF.putvar",
    "category": "function",
    "text": "NetCDF.putvar(v::NcVar,vals::Array;start::Vector=ones(Int,length(size(vals))),count::Vector=[size(vals)...])\n\nWrites the values from the array vals to a netcdf file. v is the NcVar handle of the respective variable and vals an array with the same dimension as the variable in the netcdf file.\n\nKeyword arguments\n\nstart Vector of length ndim(v) setting the starting index for each dimension\ncount Vector of length ndim(v) setting the count of values to be read along each dimension. The value -1 is treated as a special case to read all values from this dimension\n\n\n\n\n\nNetCDF.putvar(v::NcVar, val, i...)\n\nWrites the value(s) val to the variable v while the indices are given in in an array-style indexing manner.\n\n\n\n\n\n"
},

{
    "location": "intermediate/#Writing-data-1",
    "page": "Medium-level interface",
    "title": "Writing data",
    "category": "section",
    "text": "NetCDF.putvar"
},

{
    "location": "intermediate/#Creating-files-1",
    "page": "Medium-level interface",
    "title": "Creating files",
    "category": "section",
    "text": "To create a netCDF file you first have to define the dimensions and variables that it is supposed to hold. As representations for netCDF dimensions and variables there are the predefined NcVar and NcDim types. An NcDim object is created by:NcDim(dimname, dimlength, atts=Dict{Any,Any}(), values=[], unlimited=false)here dimname is the dimension name, dimlength is the dimension length. The optional argument values is a 1D array of values that are written to the dimension variable and the optional argument atts is a Dict holding pairs of attribute names and values. Setting unlimited=true creates an unlimited dimension.After defining the dimensions, you can create NcVar objects withNcVar(varname , dimlist; atts=Dict{Any,Any}(), t=Float64, compress=-1)Here varname is the name of the variable, dimlist an array of type NcDim holding the dimensions associated to the variable, varattributes is a Dict holding pairs of attribute names and values. t is the data type that should be used for storing the variable.  You can either specify a Julia type(Int16, Int32, Float32, Float64) which will be translated to(NCSHORT, NCINT, NCFLOAT, NCDOUBLE) or directly specify one of the latter list. You can also set the compression level of the variable by setting compress to a number in the range 1..9 This has only an effect in netCDF4 files.Having defined the variables, the netCDF file can be created:NetCDF.create(filename, varlist, gatts=Dict{Any,Any}(),mode=NC_netCDF4)Here, filename is the name of the file to be created and varlist an array of NcVar holding the variables that should appear in the file. In the optional argument gatts you can specify a Dict containing global attributes and mode is the file type you want to create(NCnetCDF4, NCCLASSICMODEL or NC64BIT_OFFSET)."
},

{
    "location": "intermediate/#Miscellaneous-1",
    "page": "Medium-level interface",
    "title": "Miscellaneous",
    "category": "section",
    "text": "once you have finished reading, writing or editing your files you can close the file withNetCDF.close(nc)If you just want to synchronize your changes to the disk, runNetCDF.sync(nc)where nc is a netCDF file handler."
},

{
    "location": "intermediate/#NetCDF.NcDim",
    "page": "Medium-level interface",
    "title": "NetCDF.NcDim",
    "category": "type",
    "text": "NcDim\n\nRepresents a NetCDF dimension of name name optionally holding the dimension values.\n\n\n\n\n\n"
},

{
    "location": "intermediate/#NetCDF.NcVar",
    "page": "Medium-level interface",
    "title": "NetCDF.NcVar",
    "category": "type",
    "text": "NcVar\n\nNcVar{T,N,M} represents a NetCDF variable. It is a subtype of AbstractArray{T,N}, so normal indexing using [] will work for reading and writing data to and from a NetCDF file. NcVar objects are returned by NetCDF.open, by indexing an NcFile object (e.g. myfile[\"temperature\"]) or, when creating a new file, by its constructor. The type parameter M denotes the NetCDF data type of the variable, which may or may not correspond to the Julia Data Type.\n\n\n\n\n\n"
},

{
    "location": "intermediate/#NetCDF.create",
    "page": "Medium-level interface",
    "title": "NetCDF.create",
    "category": "function",
    "text": "NetCDF.create(name::String,varlist::Array{NcVar};gatts::Dict=Dict{Any,Any}(),mode::UInt16=NC_NETCDF4)\n\nCreates a new NetCDF file. Here, name  is the name of the file to be created and varlist an array of NcVar holding the variables that should appear in the file.\n\nKeyword arguments\n\ngatts a Dict containing global attributes of the NetCDF file\nmode NetCDF file type (NCNETCDF4, NCCLASSICMODEL or NC64BITOFFSET), defaults to NCNETCDF4\n\n\n\n\n\n"
},

{
    "location": "intermediate/#Interface-for-creating-files-1",
    "page": "Medium-level interface",
    "title": "Interface for creating files",
    "category": "section",
    "text": "NcDimNcVarNetCDF.create"
},

{
    "location": "strings/#",
    "page": "Short note on reading and writing NCCHAR and NCSTRING variables",
    "title": "Short note on reading and writing NCCHAR and NCSTRING variables",
    "category": "page",
    "text": ""
},

{
    "location": "strings/#Short-note-on-reading-and-writing-NC*CHAR-and-NC*STRING-variables-1",
    "page": "Short note on reading and writing NCCHAR and NCSTRING variables",
    "title": "Short note on reading and writing NCCHAR and NCSTRING variables",
    "category": "section",
    "text": "There are two common types for storing String data in NetCDF variables. The first is NC_CHAR, where a 1D array of strings is stored in a 2D char** array. Here the user must define the maximum string length and add a respective NetCDF dimension. Since NetCDF4 there is the NC_STRING data type that allows  the direct definition of String variables so that an N-dimensional String array directly maps to an N-dimensional  array in the NetCDF file structure."
},

{
    "location": "strings/#NC_STRING-variables-1",
    "page": "Short note on reading and writing NCCHAR and NCSTRING variables",
    "title": "NC_STRING variables",
    "category": "section",
    "text": "In this package, the Julia type String maps to the NC_STRING datatype, which means that creating a variable with any ofnccreate(filename, varname, dims..., t=String)orNcVar(varname,dims,t=String)will result in a NetCDF variable of type NC_STRING. You can directly write an Array{String} of matching shape to these variables. Similarly, calling ncread or NetCDF.readvar on any of these variables will return an Array{String}"
},

{
    "location": "strings/#NC_CHAR-variables-1",
    "page": "Short note on reading and writing NCCHAR and NCSTRING variables",
    "title": "NC_CHAR variables",
    "category": "section",
    "text": "Dealing with NC_CHAR variables is a bit more complicated. This has 2 reasons. First, the dimensions of the NetCDF variables do not match the dimensions of the resulting string array because of the additional str_len (or similar) axis that is introduced in the NetCDF file. So an n-dimensional String-Array maps to an (n+1)-dimensional NC_CHAR array.Second, historically the NC_CHAR type has been used to store compressed data, too. So it is not always desirable to automatically convert these char arrays to strings. Anyhow, here is how you can deal with these variable types:Assume you have a NetCDF variable of type NC_CHAR of dimensions (str_len: 10, axis2: 20). Calling x=ncread(...) or x=readvar(...) on this variable will return an Array{UInt8,2} with size (10,20) as it is represented on disk. If you You can either use this data directly (if it is numeric) or convert them to a Vector{String} by callingy=nc_char2string(x)which will return a string vector of length 20.An example for creating NC_CHAR and writing variables would be the following:nccreate(filename,varname,\"str_len\",20,\"DimValues\",5,t=NC_CHAR)\nxs = [\"a\",\"bb\",\"ccc\",\"dddd\",\"eeeee\"]\nncwrite(filename,varname,nc_string2char(xs))The call of string2char will convert the Vector{String} to a Matrix{UInt8}. which can be written to the NetCDF file."
},

]}
