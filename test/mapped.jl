using NetCDF
using Base.Test
fnmapped=tempname()
ndim=4
dims=NcDim[NcDim(string("d",i),i+1) for i=1:4]
a=zeros(collect(2:(ndim+1))...)
copy!(a,1:length(a))
v=NcVar(string("v",ndim),dims[1:ndim])
NetCDF.create(fnmapped,v)
NetCDF.putvar(v,a)
perm=(4,3,2,1)
v=NetCDF.open(fnmapped,string("v",ndim))
vp=permutedims(v,perm)
ap=permutedims(a,perm)
@test getindex(vp,:,:,:,:)==getindex(ap,:,:,:,:)
@test getindex(vp,1,:,:,:)==getindex(ap,1,:,:,:)
@test getindex(vp,2,:,:,:)==getindex(ap,2,:,:,:)
