##High-level syntax
fn1 = tempname2()
fn2 = tempname2()
fn3 = tempname2()
fn4 = tempname2()
fn5 = tempname2()

nccreate(
    fn1,
    "v1",
    "Dim1",
    [1, 2],
    Dict("units" => "deg C"),
    "Dim2",
    collect(1:10),
    "Dim3",
    20,
    Dict("max" => 10),
    mode = NC_NETCDF4,
)
nccreate(fn1, "vstr", "Dim2", collect(1:10), t = String)
nccreate(fn1, "vchar", "DimChar", 20, "Dim2", t = NetCDF.NC_CHAR)
nccreate(
    fn2,
    "v2",
    "Dim1",
    [1, 2, 3],
    Dict("units" => "deg C"),
    "Dim2",
    collect(1:10),
    "Dim3",
    20,
    Dict("max" => 10),
    atts = Dict("a1" => "varatts"),
    gatts = Dict("Some global attributes" => 2010),
)
nccreate(fn3, "v3", "Dim1", 3)
for i = 1:length(tlist)
    nccreate(fn3, "vt$i", "Dim2", collect(1:10), t = tlist[i])
end

ncputatt(fn1, "v1", Dict("Additional String attribute" => "att"))
ncputatt(fn1, "global", Dict("Additional global attribute" => "gatt"))
numberatts = Dict{Any,Any}("Additional $t attribute" => t(20) for t in tlist)
numberatts["Additional String attribute"] = "string attribute"
arrayatts = Dict{Any,Any}("Additional $t attribute" => t[i for i = 1:20] for t in tlist)
arrayatts["Additional String array attribute"] = String[string("string attribute ", i) for i = 1:20]
ncputatt(fn1, "global", numberatts)
ncputatt(fn1, "v1", arrayatts)

#First generate the data
x1 = rand(2, 10, 20)
x2 = rand(2, 10, 20)
xt = [rand(tl, 10) for tl in tlist]
xs = [
    "a",
    "bb",
    "ccc",
    "dddd",
    "eeeee",
    "ffffff",
    "ggggggg",
    "hhhhhhhh",
    "iiiiiiiii",
    "jjjjjjjjjj",
]
#
# And write it
#
ncwrite(x1, fn1, "v1")
#Test sequential writing along one dimension
for i = 1:10
    ncwrite(x2[:, i, :], fn2, "v2", start = [1, i, 1], count = [-1, 1, -1])
end
ncwrite(xs, fn1, "vstr")
ncwrite(nc_string2char(xs), fn1, "vchar")

#Test automatic type conversion
x4 = [1, 2, 3]
ncwrite(x4, fn3, "v3")

for i = 1:length(tlist)
    ncwrite(xt[i], fn3, "vt$i")
end

# Test creating unlimited dimension file
nccreate(fn4, "myvar", "time", Inf)
nccreate(fn4, "myvar2", "dinf", Inf, "d1", 10, "d2", 20)
ncwrite(collect(1:10), fn4, "myvar")
ncwrite(collect(1:5), fn4, "myvar", start = [11;])
ncwrite(ones(5, 10, 20), fn4, "myvar2")
ncwrite(zeros(1, 10, 20), fn4, "myvar2")

# Test reading existing files
myvar2 = ones(5, 10, 20)
myvar2[1, :, :] .= 0.0
@test ncread(fn4, "myvar2") == myvar2
@test nc_char2string(ncread(fn1, "vchar")) == xs
@test_throws NetCDF.NetCDFError ncread("nonexistant file", "a var")

# Test creating 0-dimensional variable
nccreate(fn4, "scalar")
a = Array{Float64,0}(undef);
a[1] = 10.0;
ncwrite(a, fn4, "scalar")
@test ncread(fn4, "scalar")[1] == a[1]

# Test dimension variable type
nccreate(fn5, "x5_1", "dim1", collect(Int32, 1:4), Dict("units" => "m"))
nccreate(fn5, "x5_2", "dim2", collect(Float32, 1:4), Dict("units" => "m"))
@test typeof(ncread(fn5, "dim1")) == Array{Int32,1}
@test typeof(ncread(fn5, "dim2")) == Array{Float32,1}

# Open file by reading and create new variable
ncread(fn4, "myvar2")
nccreate(fn4, "myvar3", "time", Inf)
