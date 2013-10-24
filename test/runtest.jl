import Base.Test.@test
using NetCDF

# Test Medium level Interface
# Test Dimension Creation
d1 = NcDim("Dim1",2;values=[5.0 10.0],atts={"units"=>"deg C"});
d2 = NcDim("Dim2",[1:10]);
d3 = NcDim("Dim3",20;values=[1.0:20.0],atts={"max"=>10});

# Test Variable creation
v1 = NcVar("v1",[d1,d2,d3]) 						# With several dims in an Array
v2 = NcVar("v1",[d1,d2,d3],atts={"a1"=>"varatts"})  # with given attributes
v3 = NcVar("v1",d1) 								# with a single dimension		
tlist = [Float64, Float32, Int32, Int16, Int8]
vt = Array(NcVar, length(tlist))
for i= 1:length(tlist)
  vt[i]=NcVar("vt$i",d2,jltype = tlist[i])
end

# Creating Files
nc1 = NetCDF.create("nc1.nc",v1);
nc2 = 
  
  