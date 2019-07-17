#First delete any existing nc-files
fn1 = tempname2()
fn2 = tempname2()
fn3 = tempname2()
fn4 = tempname2()
fn5 = tempname2()

# Test Medium level Interface
# Test Dimension Creation
d1 = NcDim("Dim1", 2;values = [5.0,10.0],atts = Dict("units" => "deg C"));
d2 = NcDim("Dim2", collect(1:10));
d3 = NcDim("Dim3", 20;atts = Dict("max" => 10));
d4 = NcDim("DimUnlim", 0, unlimited = true)
d5 = NcDim("str_len", 15)

# Test Variable creation
v1 = NcVar("v1", [d1,d2,d3], compress = 5)  # With several dims in an Array, and compressed
v2 = NcVar("v2", [d1,d2,d3], atts = Dict("a1" => "varatts"))  # with given attributes
v3 = NcVar("v3", d1)
vs = NcVar("vstr", d2, t = String)
vc = NcVar("vchar", [d5,d2], t = NetCDF.NC_CHAR)
vscal = NcVar("vscal", NcDim[])

vt = Array{NcVar}(undef, length(tlist))
for i = 1:length(tlist)
    vt[i] = NcVar("vt$i", d2, t = tlist[i])
end
vunlim = NcVar("vunlim", d4, t = Float64)

# Creating Files
nc1 = NetCDF.create(fn1, [v1,vs,vc], mode = NC_NETCDF4);
nc2 = NetCDF.create(fn2, NcVar[v2,v3,vscal], gatts = Dict("Some global attributes" => 2010));
nc3 = NetCDF.create(fn3, vt);
ncunlim = NetCDF.create(fn4, vunlim)

numberatts = Dict{Any,Any}("Additional $t attribute" => t(20) for t in tlist)
numberatts["Additional String attribute"] = "string attribute"
arrayatts  = Dict{Any,Any}("Additional $t attribute" => t[i for i in 1:20] for t in tlist)
arrayatts["Additional String attribute"] = String[string("string attribute ", i) for i in 1:20]

#Test Adding attributes
NetCDF.putatt(nc1, "v1", Dict("Additional String attribute" => "att"))
NetCDF.putatt(nc1, "global", Dict("Additional global attribute" => "gatt"))
NetCDF.putatt(nc1, "global", numberatts)
NetCDF.putatt(nc1, "v1", arrayatts)


#Test writing data
#
#First generate the data
x1 = rand(2, 10, 20)
x2 = rand(2, 10, 20)
xt = [rand(tl, 10) for tl in tlist]
xs = ["a","bb","ccc","dddd","eeeee","ffffff","ggggggg","hhhhhhhh","iiiiiiiii","jjjjjjjjjj"]
xscal = Array{Float64,0}(undef);xscal[1] = 2.5
#
# And write it
#
NetCDF.putvar(nc1, "v1", x1)
NetCDF.putvar(nc1, "vstr", xs)
NetCDF.putvar(nc1, "vchar", nc_string2char(xs))
#Test sequential writing along one dimension
for i = 1:10
    NetCDF.putvar(nc2, "v2", x2[:,i,:], start = [1,i,1], count = [-1,1,-1])
end
#Test automatic type conversion
x4 = [1,2]
NetCDF.putvar(nc2, "v3", x4)

NetCDF.putvar(nc2, "vscal", xscal)

for i = 1:length(tlist)
    NetCDF.putvar(nc3, "vt$i", xt[i])
end

NetCDF.putvar(ncunlim, "vunlim", collect(1:10))

NetCDF.close(nc1)
NetCDF.close(nc2)
NetCDF.close(nc3)

##Read the data back and compare
nc1 = NetCDF.open(fn1, mode = NC_NOWRITE);
nc2 = NetCDF.open(fn2, mode = NC_NOWRITE);
nc3 = NetCDF.open(fn3, mode = NC_NOWRITE);

@test x1 == NetCDF.readvar(nc1, "v1")
@test xs == NetCDF.readvar(nc1, "vstr")
@test x2 == NetCDF.readvar(nc2, "v2")
@test x4 == NetCDF.readvar(nc2, "v3")
@test xscal == NetCDF.readvar(nc2, "vscal")

@test xs == NetCDF.nc_char2string(NetCDF.readvar(nc1, "vchar"))


#Test -1 reading full dimension
NetCDF.readvar(nc1, "v1", start = [1,1,1], count = [-1,-1,-1])

#Test dimension variables type
dim1 = NcDim("dim1", 4, atts = Dict("units" => "m"), values = collect(Int32, 1:4))
x5_1 = NcVar("x5_1", [dim1], atts = Dict("units" => "m"), t = Int32)

dim2 = NcDim("dim2", 4, atts = Dict("units" => "m"), values = collect(Float32, 1:4))
x5_2 = NcVar("x5_2", [dim2], atts = Dict("units" => "m"), t = Int32)

nc5 = NetCDF.create(fn5, Array{NcVar,1}([x5_1, x5_2]))
NetCDF.close(nc5)

nc5 = NetCDF.open(fn5)
@test typeof(NetCDF.readvar(nc5, "dim1")) == Array{Int32,1}
@test typeof(NetCDF.readvar(nc5, "dim2")) == Array{Float32,1}
