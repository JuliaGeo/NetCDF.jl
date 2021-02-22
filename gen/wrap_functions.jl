#This is an additional wrapper to generate julia function definitions 
# from the netcdf.h header file. This is necessary because it looks like
# Clang.jl had problems translating size_t and ptrdiff_t to the correct 
# Julia types

#A small translator for c types:
tdict = Dict(
    "int"=>"Cint",
    "size_t"=>"Csize_t",
    "char"=>"Cchar",
    "NC_Dispatch"=>"Cvoid",
    "nc_type"=>"Cint",
    "nc_vlen_t"=>"nc_vlen_t",
    "void"=>"Cvoid",
    "long long"=>"Clonglong",
    "ptrdiff_t"=>"Cptrdiff_t",
    "unsigned int"=>"Cuint",
    "float"=>"Cfloat",
    "unsigned char"=>"Cuchar",
    "signed char"=>"Cchar",
    "short"=>"Cshort",
    "long"=>"Clong",
    "double"=>"Cdouble",
    "unsigned short"=>"Cushort",
    "unsigned long"=>"Culong",
    "unsigned long long"=>"Culonglong",
)

"Parses the signature from the c function argument and returns the Julia type as well as the argument name"
function parsesig(s,tdict)
    s = strip(replace(s,"const"=>""))
    nstar = count(isequal('*'),s)
    s = replace(s,"*"=>"")
    if endswith(s,"[]")
        nstar += 1
        s = replace(s,"[]"=>"")
    end
    spl = split(strip(s)," ", keepempty=false)
    if length(spl) == 1
        return tdict[spl[1]],"x"
    end
    if length(spl)>2
        spl = (join(spl[1:end-1]," "), spl[end])
    end
    t, argname = spl
    if nstar == 2
        return "Ptr{Ptr{$(tdict[t])}}", argname
    elseif nstar == 1
        return "Ptr{$(tdict[t])}", argname[2:end]
    else
        return tdict[t], argname
    end
end

"Write the function with name `fname` and signature `sig` to the IO stream `outp`"
function writefun(outp,fname,sig)
    print(outp,"function ")
    print(outp,fname)
    print(outp,"(")
    for (t,name) in sig
        print(outp,name)
#         if parse(t) <: Integer
#             print(outp,"::Integer")
#         end
        print(outp,", ")
    end
    print(outp, ")\n")
    println(outp, "    check(ccall(")
    println(outp, "        (:$(fname), libnetcdf),")
    println(outp, "        Cint,")
    print(outp, "        (")
    foreach(i->print(outp,string(i[1],", ")),sig)
    println(outp,"),")
    foreach(i->println(outp,"        $(i[2]),"),sig)
    println(outp, "    ))")
    println(outp, "end")
end

include(joinpath(@__DIR__,"..","src","netcdf_constants.jl"))

function parseheader(input, output)
    cheader = eachline(input) |> collect;
    open(output,"w") do outp
        ii = 1
        while true
        i1 = findnext(startswith("EXTERNL int"), cheader,ii)
        i1 === nothing && break
        i2 = findnext(contains(";"), cheader,i1)
        cdef = join(cheader[i1:i2])
        sig = match(r"int\s*(\w+)\((.*)\)",cdef)
        if sig !== nothing
            fname = sig.captures[1]
            sig = parsesig.(split(sig.captures[2],","), Ref(tdict))
            writefun(outp,fname,sig)
        end
        ii = i2+1
        end
    end
end

input = eachline(`locate netcdf.h`) |> first
output = joinpath(@__DIR__, "..", "src","netcdf_c.jl")
parseheader(input, output) 