##High-level syntax
#First delete any existing nc-files
for fn in (fn1,fn2,fn3,fn4)
  if (isfile(fn))
    rm(fn)
  end
end

nccreate(fn1,"v1","Dim1",[1,2],@Compat.AnyDict("units"=>"deg C"),"Dim2",collect(1:10),"Dim3",20,@Compat.AnyDict("max"=>10),
mode=NC_NETCDF4)
nccreate(fn1,"vstr","Dim2",collect(1:10),t=ASCIIString)
nccreate(fn2,"v2","Dim1",[1,2,3],@Compat.AnyDict("units"=>"deg C"),"Dim2",collect(1:10),"Dim3",20,@Compat.AnyDict("max"=>10),
atts=@Compat.AnyDict("a1"=>"varatts"),gatts=@Compat.AnyDict("Some global attributes"=>2010),mode=NC_64BIT_OFFSET)
nccreate(fn3,"v3","Dim1",3,mode=NC_CLASSIC_MODEL)
tlist = [Float64, Float32, Int32, Int16, Int8]
for i = 1:length(tlist)
	nccreate(fn3,"vt$i","Dim2",collect(1:10),t=tlist[i])
end

ncputatt(fn1,"v1",@Compat.Dict("Additional String attribute"=>"att"))
ncputatt(fn1,"global",@Compat.Dict("Additional global attribute"=>"gatt"))
ncputatt(fn1,"global",@Compat.Dict("Additional Int8 attribute"=>Int8(20),
							"Additional Int16 attribute"=>Int16(20),
							"Additional Int32 attribute"=>Int32(20),
							"Additional Float32 attribute"=>Float32(20),
							"Additional Float64 attribute"=>Float64(20)))
ncputatt(fn1,"v1",    @Compat.Dict("Additional Int8 array attribute"=>Int8[i for i in 1:20],
							"Additional Int16 array attribute"=>Int16[i for i in 1:20],
							"Additional Int32 array attribute"=>Int32[i for i in 1:20],
							"Additional Float32 array attribute"=>Float32[i for i in 1:20],
							"Additional Float64 array attribute"=>Float64[i for i in 1:20]))

#First generate the data
x1 = rand(2,10,20)
x2 = rand(2,10,20)
xt=Array(Any,length(tlist))
for i=1:length(tlist)
    xt[i]=rand(tlist[i],10)
end
xs=Array(AbstractString,10)
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
ncwrite(x1,fn1,"v1")
#Test sequential writing along one dimension
for i=1:10
  ncwrite(x2[:,i,:],fn2,"v2",start=[1,i,1],count=[-1,1,-1])
end
ncwrite(xs,fn1,"vstr")
#Test automatic type conversion
x4=[1,2,3]
ncwrite(x4,fn3,"v3")

for i=1:length(tlist)
  ncwrite(xt[i],fn3,"vt$i")
end

# Test creating unlimited dimension file
nccreate(fn4,"myvar","time",Inf)
nccreate(fn4,"myvar2","dinf",Inf,"d1",10,"d2",20)
ncwrite(collect(1:10),fn4,"myvar")
ncwrite(collect(1:5),fn4,"myvar",start=[11;])
ncwrite(ones(5,10,20),fn4,"myvar2")
ncwrite(zeros(1,10,20),fn4,"myvar2")

ncclose()
