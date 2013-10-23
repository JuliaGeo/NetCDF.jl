import Base.Test.@test

# Test Medium level Interface
# Test Dimension Creation
d1 = NcDim("Dim1",2;values=[5.0 10.0],atts={"units"=>"deg C"});
d2 = NcDim("Dim2",[1:10]);
d3 = NcDim("Dim3",20;values=[1.0:20.0],atts={"max"=>10});

# Test Variable 