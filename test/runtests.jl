import Base.Test.@test
using NetCDF
#First delete any existing nc-files
for fn in ("nc1.nc","nc2.nc","nc3.nc")
  if (isfile(fn))
    rm(fn)
  end
end

# Test Medium level Interface
# Test Dimension Creation
d1 = NcDim("Dim1",2;values=[5.0,10.0],atts={"units"=>"deg C"});
d2 = NcDim("Dim2",[1:10]);
d3 = NcDim("Dim3",20;atts={"max"=>10});

# Test Variable creation
v1 = NcVar("v1",[d1,d2,d3],compress=5) 						# With several dims in an Array, and compressed
v2 = NcVar("v2",[d1,d2,d3],atts={"a1"=>"varatts"})  # with given attributes
v3 = NcVar("v3",d1) 								# with a single dimension		
tlist = [Float64, Float32, Int32, Int16, Int8]
vt = Array(NcVar, length(tlist))
for i= 1:length(tlist)
  vt[i]=NcVar("vt$i",d2,t = tlist[i])
end

# Creating Files
nc1 = NetCDF.create("nc1.nc",v1,mode=NC_NETCDF4);
nc2 = NetCDF.create("nc2.nc",[v2,v3],gatts={"Some global attributes"=>2010},mode=NC_64BIT_OFFSET);
nc3 = NetCDF.create("nc3.nc",vt,mode=NC_CLASSIC_MODEL);

#Test Adding attributes
NetCDF.putatt(nc1,"v1",{"Additional String attribute"=>"att"})
NetCDF.putatt(nc1,"global",{"Additional global attribute"=>"gatt"})
NetCDF.putatt(nc1,"global",{"Additional Int8 attribute"=>int8(20),
							"Additional Int16 attribute"=>int16(20),
							"Additional Int32 attribute"=>int32(20),
							"Additional Float32 attribute"=>float32(20),
							"Additional Float64 attribute"=>float64(20)})
NetCDF.putatt(nc1,"v1",    {"Additional Int8 array attribute"=>int8([1:20]),
							"Additional Int16 array attribute"=>int16([1:20]),
							"Additional Int32 array attribute"=>int32([1:20]),
							"Additional Float32 array attribute"=>float32([1:20]),
							"Additional Float64 array attribute"=>float64([1:20])})


#Test writing data
#
#First generate the data
x1 = rand(2,10,20)
x2 = rand(2,10,20)
xt=Array(Any,length(tlist))
for i=1:length(tlist)
    xt[i]=rand(tlist[i],10)
end
#
# And write it
#
NetCDF.putvar(nc1,"v1",x1)
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
nc1 = NetCDF.open("nc1.nc",mode=NC_NOWRITE);
nc2 = NetCDF.open("nc2.nc",mode=NC_NOWRITE);
nc3 = NetCDF.open("nc3.nc",mode=NC_NOWRITE);

@test x1==NetCDF.readvar(nc1,"v1")
@test x2==NetCDF.readvar(nc2,"v2")
@test x4==NetCDF.readvar(nc2,"v3")

##High-level syntax
#First delete any existing nc-files
for fn in ("nc1.nc","nc2.nc","nc3.nc")
  if (isfile(fn))
    rm(fn)
  end
end

nccreate("nc1.nc","v1","Dim1",[1,2,3],{"units"=>"deg C"},"Dim2",[1:10],"Dim3",20,{"max"=>10},
mode=NC_NETCDF4)
nccreate("nc2.nc","v2","Dim1",[1,2,3],{"units"=>"deg C"},"Dim2",[1:10],"Dim3",20,{"max"=>10},
atts={"a1"=>"varatts"},gatts={"Some global attributes"=>2010},mode=NC_64BIT_OFFSET)
nccreate("nc2.nc","v3","Dim1",mode=NC_CLASSIC_MODEL)
tlist = [Float64, Float32, Int32, Int16, Int8]
for i = 1:length(tlist)
	nccreate("nc3.nc","vt$i","Dim2",[1:10],t=tlist[i])
end

ncputatt("nc1.nc","v1",{"Additional String attribute"=>"att"})
ncputatt("nc1.nc","global",{"Additional global attribute"=>"gatt"})
ncputatt("nc1.nc","global",{"Additional Int8 attribute"=>int8(20),
							"Additional Int16 attribute"=>int16(20),
							"Additional Int32 attribute"=>int32(20),
							"Additional Float32 attribute"=>float32(20),
							"Additional Float64 attribute"=>float64(20)})
ncputatt("nc1.nc","v1",    {"Additional Int8 array attribute"=>int8([1:20]),
							"Additional Int16 array attribute"=>int16([1:20]),
							"Additional Int32 array attribute"=>int32([1:20]),
							"Additional Float32 array attribute"=>float32([1:20]),
							"Additional Float64 array attribute"=>float64([1:20])})

#First generate the data
x1 = rand(2,10,20)
x2 = rand(2,10,20)
xt=Array(Any,length(tlist))
for i=1:length(tlist)
    xt[i]=rand(tlist[i],10)
end
#
# And write it
#
ncwrite(x1,"nc1.nc","v1")
#Test sequential writing along one dimension
for i=1:10
  ncwrite(x2[:,i,:],"nc2.nc","v2",start=[1,i,1],count=[-1,1,-1])
end
#Test automatic type conversion
x4=[1,2,3]
ncwrite(x4,"nc2.nc","v3")

for i=1:length(tlist)
  ncwrite(xt[i],"nc3.nc","vt$i")
end


ncclose()

