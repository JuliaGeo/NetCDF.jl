#Tests for chunking
cfn1 = tempname2()
nccreate(cfn1, "v1", "d1", 10, "d2", 20, chunksize = (5, 2))
ncwrite(rand(10, 20), cfn1, "v1")
v = NetCDF.open(cfn1, "v1")
@test v.chunksize == (2, 5)
@test NetCDF.eachchunk(v) == NetCDF.GridChunks((10,20),(5,2))

