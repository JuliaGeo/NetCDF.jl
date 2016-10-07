ncclose()
v1=NetCDF.open(fn1,"v1",mode=NC_WRITE)
@test isa(v1,NetCDF.NcVar{Float64,3,6})
@test v1[1,1,1]==x1[1,1,1]

@test squeeze(v1[2,:,2],(1,3))==x1[2,:,2]

@test squeeze(v1[1:end,3,1],(2,3))==x1[1:end,3,1]
inds=bitrand(size(x1))
@test v1[inds]==x1[inds]

xnew=rand(size(x1))
v1[:,:,:]=xnew
@test v1==xnew
