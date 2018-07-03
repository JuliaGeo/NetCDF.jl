using NetCDF
using Base.Test

fnmiss  = tempname2()
nccreate(fnmiss,"v1","d1",collect(1:10),atts=Dict("missing_value"=>-9999.0))
x = Union{Float64,Missing}[1,2,3,4,missing,missing,7,8,9,10]
ncwrite(x,fnmiss,"v1")
@test ncread(fnmiss,"v1")==Float64[1,2,3,4,-9999,-9999,7,8,9,10]

x2 = ncread(fnmiss,"v1",replace_missing=true)
@test all(skipmissing(x2.==x))
@test all(ismissing,x2[5:6])

NetCDF.open(fnmiss,"v1") do v
  @test v[:]==Float64[1,2,3,4,-9999,-9999,7,8,9,10]
end
NetCDF.open(fnmiss,"v1",replace_missing=true) do v
  x2 = v[:]
  @test all(skipmissing(x2.==x))
  @test all(ismissing,x2[5:6])
  x2 = NetCDF.readvar(v,start=[1],count=[5])
  @test v[1:4]==1:4
  @test ismissing(v[5])
end
NetCDF.open(fnmiss,"v1",replace_missing=true, mode=NC_WRITE) do v
  v[5]=20
  v[7:10] .= missing
  @test v[5]==20.0
  @test all(ismissing,v[7:10])
end



# fnscale = tempname2()
# nccreate(fnscale,"v1","d1",collect(1:10),
# atts=Dict("scale_factor"=>1/255, "add_offset"=>-128.0),t=NC_UBYTE)
# ncwrite()
