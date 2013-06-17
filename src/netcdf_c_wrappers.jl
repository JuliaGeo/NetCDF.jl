#
#  CCall wrapper functions, thanks to TimHoly, copied from the HDF5-package
#
#
#
const NC_NOERR=0

const NC_MAX_NAME=256
const NC_VERBOSE=false
const NC_BYTE=1
const NC_CHAR =2
const NC_SHORT =3
const NC_INT =4
const NC_FLOAT=5
const NC_LONG=4
const NC_DOUBLE =6
const NC_GLOBAL=-1
const NC_CLOBBER=0x0000
const NC_NOCLOBBER=0x0004
const NC_NOWRITE=0x0000	
const NC_WRITE=0x0001	

const libnetcdf = dlopen("libnetcdf")

function ccallexpr(ccallsym::Symbol, outtype, argtypes::Tuple, argsyms::Tuple)
    ccallargs = Any[Expr(:quote, ccallsym), outtype, Expr(:tuple, argtypes...)]
    ccallargs = ccallsyms(ccallargs, length(argtypes), argsyms)
    Expr(:ccall, ccallargs...)
end

function ccallexpr(lib::Ptr, ccallsym::Symbol, outtype, argtypes::Tuple, argsyms::Tuple)
    ccallargs = Any[Expr(:call, :dlsym, lib, Expr(:quote, ccallsym)), outtype, Expr(:tuple, argtypes...)]
    ccallargs = ccallsyms(ccallargs, length(argtypes), argsyms)
    Expr(:ccall, ccallargs...)
end

function ccallsyms(ccallargs, n, argsyms)
    if n > 0
        if length(argsyms) == n
            ccallargs = Any[ccallargs..., argsyms...]
        else
            for i = 1:length(argsyms)-1
                push!(ccallargs, argsyms[i])
            end
            for i = 1:n-length(argsyms)+1
                push!(ccallargs, Expr(:getindex, argsyms[end], i))
            end
        end
    end
    ccallargs
end

function funcdecexpr(funcsym, n::Int, argsyms)
    if length(argsyms) == n
        return Expr(:call, funcsym, argsyms...)
    else
        exargs = Any[funcsym, argsyms[1:end-1]...]
        push!(exargs, Expr(:..., argsyms[end]))
        return Expr(:call, exargs...)
    end
end

# Functions returning a single argument, and/or with more complex
# error messages
for (jlname, h5name, outtype, argtypes, argsyms, ex_error) in
    ( (:_nc_open_c, :nc_open, Int32, (Ptr{Uint8}, Int32, Ptr{Int32}), (:fname,:omode,:ida), :(error("Error Opening file ", fname))),
      (:_nc_inq_dim_c,:nc_inq_dim,Int32,(Int32,Int32,Ptr{Uint8},Ptr{Int32}),(:id,:idim,:namea,:lengtha),:(error("Error inquiring dimension information"))),
      (:_nc_inq_dimid_c,:nc_inq_dimid,Int32,(Int32,Ptr{Uint8},Ptr{Int32}),(:id,:namea,:dimida),:(error("Error inquiring dimension id"))),
      (:_nc_inq_c,:nc_inq,Int32,(Int32,Ptr{Int32},Ptr{Int32},Ptr{Int32},Ptr{Int32}),(:id,:ndima,:nvara,:ngatta,:nunlimdimida),:(error("Error inquiring file information"))),
      (:_nc_inq_attname_c,:nc_inq_attname,Int32,(Int32,Int32,Int32,Ptr{Uint8}),(:ncid,:varid,:attnum,:namea),:(error("Error inquiring attribute name"))),
      (:_nc_inq_att_c,:nc_inq_att,Int32,(Int32,Int32,Ptr{Uint8},Ptr{Int32},Ptr{Int32}),(:ncid,:varid,:name,:typea,:nvals),:(error("Error inquiring attribute properties"))),
      
      (:_nc_get_att_text_c,:nc_get_att_text,Int32,(Int32,Int32,Ptr{Uint8},Ptr{Uint8}),(:ncid,:varid,:name,:valsa),:(error("Error reading attribute"))),
      (:_nc_get_att_short_c,:nc_get_att_short,Int32,(Int32,Int32,Ptr{Uint8},Ptr{Int16}),(:ncid,:varid,:name,:valsa),:(error("Error reading attribute"))),
      (:_nc_get_att_int_c,:nc_get_att_int,Int32,(Int32,Int32,Ptr{Uint8},Ptr{Int32}),(:ncid,:varid,:name,:valsa),:(error("Error reading attribute"))),
      (:_nc_get_att_float_c,:nc_get_att_float,Int32,(Int32,Int32,Ptr{Uint8},Ptr{Float32}),(:ncid,:varid,:name,:valsa),:(error("Error reading attribute"))),
      (:_nc_get_att_double_c,:nc_get_att_double,Int32,(Int32,Int32,Ptr{Uint8},Ptr{Float64}),(:ncid,:varid,:name,:valsa),:(error("Error reading attribute"))),
      (:_nc_get_att_ubyte_c,:nc_get_att_ubyte,Int32,(Int32,Int32,Ptr{Uint8},Ptr{Uint8}),(:ncid,:varid,:name,:valsa),:(error("Error reading attribute"))),
      (:_nc_inq_var_c,:nc_inq_var,Int32,(Int32,Int32,Ptr{Int32},Ptr{Int32},Ptr{Int32},Ptr{Int32},Ptr{Int32}),(:id,:varid,:namea,:xtypea,:ndimsa,:dimida,:natta),:(error("Error reading variable information"))),
      
      (:_nc_put_att_text_c,:nc_put_att_text,Int32,(Int32,Int32,Ptr{Uint8},Int32,Ptr{Uint8}),(:ncid,:varid,:name,:size,:valsa),:(error("Error writing attribute"))),
      (:_nc_put_att_short_c,:nc_put_att_short,Int32,(Int32,Int32,Ptr{Uint8},Int32,Int32,Ptr{Int16}),(:ncid,:varid,:name,:nctype,:size,:valsa),:(error("Error writing attribute"))),
      (:_nc_put_att_int_c,:nc_put_att_int,Int32,(Int32,Int32,Ptr{Uint8},Int32,Int32,Ptr{Int32}),(:ncid,:varid,:name,:nctype,:size,:valsa),:(error("Error writing attribute"))),
      (:_nc_put_att_long_c,:nc_put_att_int,Int32,(Int32,Int32,Ptr{Uint8},Int32,Int32,Ptr{Int64}),(:ncid,:varid,:name,:nctype,:size,:valsa),:(error("Error writing attribute"))),
      (:_nc_put_att_float_c,:nc_put_att_float,Int32,(Int32,Int32,Ptr{Uint8},Int32,Int32,Ptr{Float32}),(:ncid,:varid,:nctype,:size,:name,:valsa),:(error("Error writing attribute"))),
      (:_nc_put_att_double_c,:nc_put_att_int,Int32,(Int32,Int32,Ptr{Uint8},Int32,Int32,Ptr{Float64}),(:ncid,:varid,:name,:nctype,:size,:valsa),:(error("Error writing attribute"))),
      
      (:_nc_get_vara_double_c,:nc_get_vara_double,Int32,(Int32,Int32,Ptr{Int32},Ptr{Int32},Ptr{Float64}),(:ncid,:varid,:start,:count,:retvalsa),:(error("Error reading variable"))),
      (:_nc_get_vara_float_c,:nc_get_vara_float,Int32,(Int32,Int32,Ptr{Int32},Ptr{Int32},Ptr{Float32}),(:ncid,:varid,:start,:count,:retvalsa),:(error("Error reading variable"))),
      (:_nc_get_vara_int_c,:nc_get_vara_int,Int32,(Int32,Int32,Ptr{Int32},Ptr{Int32},Ptr{Int32}),(:ncid,:varid,:start,:count,:retvalsa),:(error("Error reading variable"))),
      (:_nc_get_vara_short_c,:nc_get_vara_short,Int32,(Int32,Int32,Ptr{Int32},Ptr{Int32},Ptr{Int16}),(:ncid,:varid,:start,:count,:retvalsa),:(error("Error reading variable"))),
      (:_nc_get_vara_text_c,:nc_get_vara_text,Int32,(Int32,Int32,Ptr{Int32},Ptr{Int32},Ptr{Uint8}),(:ncid,:varid,:start,:count,:retvalsa),:(error("Error reading variable"))),
      
      (:_nc_put_vara_text_c,:nc_put_vara_text,Int32,(Int32,Int32,Ptr{Int32},Ptr{Int32},Ptr{Uint8}),(:ncid,:varid,:start,:count,:retvalsa),:(error("Error writing variable"))),
      (:_nc_put_vara_double_c,:nc_put_vara_double,Int32,(Int32,Int32,Ptr{Int32},Ptr{Int32},Ptr{Float64}),(:ncid,:varid,:start,:count,:retvalsa),:(error("Error writing variable"))),
      (:_nc_put_vara_float_c,:nc_put_vara_float,Int32,(Int32,Int32,Ptr{Int32},Ptr{Int32},Ptr{Float32}),(:ncid,:varid,:start,:count,:retvalsa),:(error("Error writing variable"))),
      (:_nc_put_vara_int_c,:nc_put_vara_int,Int32,(Int32,Int32,Ptr{Int32},Ptr{Int32},Ptr{Int32}),(:ncid,:varid,:start,:count,:retvalsa),:(error("Error writing variable"))),
      (:_nc_put_vara_short_c,:nc_put_vara_short,Int32,(Int32,Int32,Ptr{Int32},Ptr{Int32},Ptr{Int16}),(:ncid,:varid,:start,:count,:retvalsa),:(error("Error writing variable"))),
      (:_nc_close_c,:nc_close,Int32,(Int32,),(:ncid,),:(error("Error closing variable"))),
      (:_nc_enddef_c,:nc_enddef,Int32,(Int32,),(:ncid,),:(error("Error leaving define mode"))),
      (:_nc_redef_c,:nc_redef,Int32,(Int32,),(:ncid,),:(error("Error entering define mode"))),
      (:_nc_sync_c,:nc_sync,Int32,(Int32,),(:ncid,),:(error("Error syncing file"))),
      (:_nc_create_c,:nc_create,Int32,(Ptr{Uint8},Int32,Ptr{Int32}),(:path,:comde,:ncida),:(error("Error creating netcdf file"))),
      (:_nc_def_dim_c,:nc_def_dim,Int32,(Int32,Ptr{Uint8},Int32,Ptr{Int32}),(:ncid,:name,:len,:dimida),:(error("Error creating dimension"))),
      (:_nc_def_var_c,:nc_def_var,Int32,(Int32,Ptr{Uint8},Int32,Int32,Ptr{Int32},Ptr{Int32}),(:ncid,:name,:xtype,:ndims,:dimida,:varida),:(error("Error creating variable"))),
     )
     
     
    
    ex_dec = funcdecexpr(jlname, length(argtypes), argsyms)
    ex_ccall = ccallexpr(libnetcdf, h5name, outtype, argtypes, argsyms)
    ex_body = quote
        ret = $ex_ccall
        if ret != 0
            println(ret)
            $ex_error
        end
        return ret
    end
    ex_func = Expr(:function, ex_dec, ex_body)
    @eval begin
        $ex_func
    end
end
