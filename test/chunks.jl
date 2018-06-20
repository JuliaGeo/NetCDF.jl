#Tests for chunking
cfn1 = tempname2()
nccreate(cfn1, "v1", "d1", 10, "d2", 20, chunksize=(5, 5))
ncwrite(rand(10, 20), cfn1, "v1")
ncclose()
v = NetCDF.open(cfn1, "v1")
@test v.chunksize == (5, 5)
v = 0
ncclose()
