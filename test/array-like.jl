NetCDF.open(fn1, "v1", mode = NC_WRITE) do v1
    @test isa(v1, NetCDF.NcVar{Float64,3,6})
    @test v1[1, 1, 1] == x1[1, 1, 1]

  @test v1[2,:,2] == x1[2,:,2]

  @test v1[:,3,1] == x1[:,3,1]
  inds = bitrand(size(x1))
  @test v1[inds] == x1[inds]

  xnew = rand(Float64,size(x1))
  v1[:,:,:] = xnew
  @test v1[:,:,:] == xnew
end

v = NetCDF.open(fn1, "v1")
ncid = v.ncid
v = nothing
GC.gc()
@test_throws NetCDF.NetCDFError NetCDF.nc_close(ncid)
