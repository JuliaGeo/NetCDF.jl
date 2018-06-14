# Wrap netcdf.h header file using Clang.jl
# This produces two files, common.jl and netcdf.jl
#
# common.jl is filtered manually, leaving out constants not starting with the NC_ prefix
# or otherwise unneccesary or invalid lines
# the manually selected constant and wrapped types are then copied into src/netcdf_c.jl
#
# from netcdf.jl first ::Cint and ::nc_type in the type signature are loosened to ::Integer
# then Cstring is replaced with Ptr{UInt8}
# then it is copied entirely to the end of src/netcdf_c.jl
# then all ccalls that return an error code are wrapped in the `check` function

using Clang

workdir = dirname(@__FILE__)
srcdir = joinpath(workdir, "../src")

headerpath = ["/home/fgans/.julia/v0.6/Cxx/deps/src/clang-3.9.1/lib/Headers/stddef.h","/usr/include/netcdf.h"]
includedirs = ["/home/fgans/.julia/v0.6/Cxx/deps/src/clang-3.9.1/lib/Headers","/usr/include","/usr/include/linux"]

size_tsave = []

context=wrap_c.init(headers=headerpath,
                    output_dir=workdir,
                    common_file="common.jl",
                    clang_includes=includedirs,
                    header_library=x->"libnetcdf")

run(context)

# Now run the rewriter
corrlist = [(r"\dULL$",3,"UInt64"),(r"\dLL$",2,"Int64"),(r"\dL$",1,Int),(r"\dU$",1,UInt),(r"\df$",1,"Float32")]
correct_postfix(s) = map(split(s," ")) do i
  ifound = findfirst(j->ismatch(first(j),i),corrlist)
  ifound > 0 ?
  string(last(corrlist[ifound]),"(",i[1:end-corrlist[ifound][2]],")") :
  i
end |> i->join(i," ")
correct_void(s) = replace(s,"Void","Nothing")
correct_cstring(s) = replace(s,"Cstring","Ptr{UInt8}")
macroreg = r"(NC_[\w_]+) \( \( ([\w\s]+) \) ([\w\s-+fe.]+) \)"
macroreg2 = r"(NC_[\w_]+) \( ([\w\s-+fe.]+) \)"
outfile = joinpath(workdir,"..","src","netcdf_c.jl")
open(outfile,"w") do f
  println(f,"""const depfile = joinpath(dirname(@__FILE__), "..", "deps", "deps.jl")
  if isfile(depfile)
      include(depfile)
  else
      error("libnetcdf not properly installed. Please run Pkg.build(\\\"NetCDF\\\")")
  end
  macro checked_call(ex)
    body = ex.args[2]
    ex.args[2] = quote
      ret = \$(body)
      ret == NC_NOERR || throw(NetCDFException(ret))
      nothing
    end
    ex
  end""")
  println(f,"const err=-1")
  println(f,"const nc_type=Cint")
  for s in readlines(joinpath(workdir,"common.jl"))
    mmacro = match(macroreg,s)
    mmacro2 = match(macroreg2,s)
    mconstdef = match(r"const ([\w_]+) =",s)
    #capture types macro definitions
    if mmacro!=nothing
      println(f,string("const ",mmacro.captures[1], " = ", mmacro.captures[3] |> correct_postfix) |> correct_void)
    # capture untyped macro definitions
    elseif mmacro2!=nothing
      println(f,string("const ",mmacro2.captures[1], " = ", mmacro2.captures[2] |> correct_postfix) |> correct_void)
    #Only print constants that start with NC_
    elseif mconstdef!=nothing
      if startswith(mconstdef.captures[1],"NC_")
        println(f,s |> correct_void )
      end
    elseif s=="using Compat"
      nothing
    else
      println(f,s |> correct_void)
    end
  end
  funcmatch = r"^function ([\w_]+)\(([,\w\s{}:]+)\)"
  argtdict = Dict("Cint"=>"Integer","nc_type"=>"Integer","UInt64"=>"Integer",
  "Csize_t"=>"Integer")
  for s in readlines(joinpath(workdir,"netcdf.jl"))
    fm = match(funcmatch,s)
    ccallm = match(r"ccall\(",s)
    if fm !=nothing
      s2 = map(split(fm.captures[2],", ")) do arg
        aspl = split(arg,"::")
        if length(aspl)==1
          return arg
        else
          return string(aspl[1],"::",get(argtdict,aspl[2],aspl[2]))
        end
      end |> i->join(i,", ")
      println(f,string("@checked_call function ",fm.captures[1],"(",s2,")") |> correct_cstring)
    else
      println(f,s |> correct_void |> correct_cstring)
    end
  end
end
