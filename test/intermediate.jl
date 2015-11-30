#First delete any existing nc-files
fn1=tempname()
fn2=tempname()
fn3=tempname()
fn4=tempname()

# Test Medium level Interface
# Test Dimension Creation
d1 = NcDim("Dim1",2;values=[5.0,10.0],atts=@Compat.AnyDict("units"=>"deg C"));
d2 = NcDim("Dim2",collect(1:10));
d3 = NcDim("Dim3",20;atts=@Compat.AnyDict("max"=>10));
d4 = NcDim("DimUnlim")

# Test Variable creation
v1 = NcVar("v1",[d1,d2,d3],compress=5) 						# With several dims in an Array, and compressed
v2 = NcVar("v2",[d1,d2,d3],atts=@Compat.AnyDict("a1"=>"varatts"))  # with given attributes
v3 = NcVar("v3",d1)
vs = NcVar("vstr",d2,t=ASCIIString) 								# with a single dimension
tlist = [Float64, Float32, Int32, Int16, Int8]
vt = Array(NcVar, length(tlist))
for i= 1:length(tlist)
  vt[i]=NcVar("vt$i",d2,t = tlist[i])
end

# Creating Files
nc1 = NetCDF.create(fn1,v1,vs,mode=NC_NETCDF4);
nc2 = NetCDF.create(fn2,v2,v3,gatts=@Compat.AnyDict("Some global attributes"=>2010),mode=NC_64BIT_OFFSET);
nc3 = NetCDF.create(fn3,vt,mode=NC_CLASSIC_MODEL);

#Test Adding attributes
NetCDF.putatt(nc1,"v1",@Compat.Dict("Additional String attribute"=>"att"))
NetCDF.putatt(nc1,"global",@Compat.Dict("Additional global attribute"=>"gatt"))
NetCDF.putatt(nc1,"global",@Compat.Dict("Additional Int8 attribute"=>Int8(20),
							"Additional Int16 attribute"=>Int16(20),
							"Additional Int32 attribute"=>Int32(20),
							"Additional Float32 attribute"=>Float32(20),
							"Additional Float64 attribute"=>Float64(20)))
NetCDF.putatt(nc1,"v1",    @Compat.Dict("Additional Int8 array attribute"=>Int8[i for i in 1:20],
							"Additional Int16 array attribute"=>Int16[i for i in 1:20],
							"Additional Int32 array attribute"=>Int32[i for i in 1:20],
							"Additional Float32 array attribute"=>Float32[i for i in 1:20],
							"Additional Float64 array attribute"=>Float64[i for i in 1:20]))


#Test writing data
#
#First generate the data
x1 = rand(2,10,20)
x2 = rand(2,10,20)
xt=Array(Any,length(tlist))
for i=1:length(tlist)
    xt[i]=rand(tlist[i],10)
end
xs=Array(ASCIIString,10)
xs[1]="a"
xs[2]="bb"
xs[3]="ccc"
xs[4]="dddd"
xs[5]="eeeee"
xs[6]="ffffff"
xs[7]="ggggggg"
xs[8]="hhhhhhhh"
xs[9]="iiiiiiiii"
xs[10]="jjjjjjjjjj"
#
# And write it
#
NetCDF.putvar(nc1,"v1",x1)
NetCDF.putvar(nc1,"vstr",xs)
#Test sequential writing along one dimension
for i=1:10
  NetCDF.putvar(nc2,"v2",x2[:,i,:],start=[1,i,1],count=[-1,1,-1])
end
#Test automatic type conversion
x4=[1,2]
NetCDF.putvar(nc2,"v3",x4)

for i=1:length(tlist)
  NetCDF.putvar(nc3,"vt$i",xt[i])
end


NetCDF.close(nc1)
NetCDF.close(nc2)
NetCDF.close(nc3)

##Read the data back and compare
nc1 = NetCDF.open(fn1,mode=NC_NOWRITE);
nc2 = NetCDF.open(fn2,mode=NC_NOWRITE);
nc3 = NetCDF.open(fn3,mode=NC_NOWRITE);

@test x1==NetCDF.readvar(nc1,"v1")
@test xs==NetCDF.readvar(nc1,"vstr")
@test x2==NetCDF.readvar(nc2,"v2")
@test x4==NetCDF.readvar(nc2,"v3")

#Test -1 reading full dimension
NetCDF.readvar(nc1,"v1",start=[1,1,1],count=[-1,-1,-1])
