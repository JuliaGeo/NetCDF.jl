# Short note on reading and writing `NC_CHAR` and `NC_STRING` variables

There are two common types for storing String data in NetCDF variables. The first is `NC_CHAR`,
where a 1D array of strings is stored in a 2D `char**` array. Here the user must define the maximum
string length and add a respective NetCDF dimension. Since NetCDF4 there is the `NC_STRING` data type that allows
 the direct definition of String variables so that an N-dimensional String array directly maps to an N-dimensional
 array in the NetCDF file structure.

## `NC_STRING` variables

In this package, the Julia type `String` maps to the `NC_STRING` datatype, which means that creating a variable with any of

```
nccreate(filename, varname, dims..., t=String)
```

or

```
NcVar(varname,dims,t=String)
```

will result in a NetCDF variable of type `NC_STRING`. You can directly write an `Array{String}` of matching shape to these
variables. Similarly, calling `ncread` or `NetCDF.readvar` on any of these variables will return an `Array{String}`

## `NC_CHAR` variables

Dealing with `NC_CHAR` variables is a bit more complicated because of two reasons. First, the dimensions of the NetCDF variables
do not match the dimensions of the resulting string array because of the additional `str_len` (or similar) axis that is introduced in the
NetCDF file. So an n-dimensional String-Array maps to an (n+1)-dimensional `NC_CHAR` array.

Second, historically the `NC_CHAR` type has been used to store compressed data, too. So it is not always desirable to automatically convert
these char arrays to strings. Anyhow, here is how you can deal with these variable types:

Assume you have a NetCDF variable of type `NC_CHAR` of dimensions (str_len: 10, axis2: 20).
Calling `x=ncread(...)` or `x=readvar(...)` on this variable will return an `Array{ASCIIChar,2}` with size `(10,20)` as it is represented on disk. The `ASCIIChar` type is a small wrapper around `UInt8`, needed for dispatch. You can simply convert them to either `Char` or `UInt8` using the `convert` function. The returned array can either be used directly (if it is numeric maybe use `reinterpret(UInt8,x)`) or convert them to a `Vector{String}` by calling

    y=nc_char2string(x)

which will return a string vector of length 20.

An example for creating `NC_CHAR` and writing variables would be the following:

```
nccreate(filename,varname,"str_len",20,"DimValues",5,t=NC_CHAR)
xs = ["a","bb","ccc","dddd","eeeee"]
ncwrite(filename,varname,nc_string2char(xs))
```

The call of `string2char` will convert the `Vector{String}` to a `Matrix{UInt8}`. which
can be written to the NetCDF file.
