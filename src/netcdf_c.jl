# Julia wrapper for header: /opt/local/include/netcdf.h
# Automatically generated using Clang.jl wrap_c, version 0.0.0
macro c(ret_type, func, arg_types, lib)
    local args_in = Any[ symbol(string('a',x)) for x in 1:length(arg_types.args) ]
    quote
        function $(esc(func))($(args_in...))
            retval=ccall( Libdl.dlsym(libnc,$(Expr(:quote,func))), $ret_type, $arg_types, $(args_in...) )
            if retval!=NC_NOERR
                haskey(error_description,retval) ? error("NetCDF library error: $(error_description[retval])") : error("NetCDF library error: $(retval)")
            end
        end
    end
end

using BinDeps
@BinDeps.load_dependencies [:libnetcdf]
const libnc = Libdl.dlopen(libnetcdf[1][2])

const NC_NAT = 0
const NC_BYTE = 1
const NC_CHAR = 2
const NC_SHORT = 3
const NC_INT = 4
const NC_LONG =
const NC_FLOAT = 5
const NC_DOUBLE = 6
const NC_UBYTE = 7
const NC_USHORT = 8
const NC_UINT = 9
const NC_INT64 = 10
const NC_UINT64 = 11
const NC_STRING = 12
const NC_MAX_ATOMIC_TYPE =
const NC_VLEN = 13
const NC_OPAQUE = 14
const NC_ENUM = 15
const NC_COMPOUND = 16
const NC_FIRSTUSERTYPEID = 32


const NC_FILL = 0
const NC_NOFILL = 0x100
const NC_NOWRITE = 0x0000
const NC_WRITE = 0x0001
const NC_CLOBBER = 0x0000
const NC_NOCLOBBER = 0x0004
const NC_DISKLESS = 0x0008
const NC_MMAP = 0x0010
const NC_CLASSIC_MODEL = 0x0100
const NC_64BIT_OFFSET = 0x0200
const NC_LOCK = 0x0400
const NC_SHARE = 0x0800
const NC_NETCDF4 = 0x1000
const NC_MPIIO = 0x2000
const NC_MPIPOSIX = 0x4000
const NC_PNETCDF = 0x8000
const NC_FORMAT_CLASSIC = (1)
const NC_FORMAT_64BIT = (2)
const NC_FORMAT_NETCDF4 = (3)
const NC_FORMAT_NETCDF4_CLASSIC = (4)
const NC_SIZEHINT_DEFAULT = 0
# Skipping MacroDefinition: NC_ALIGN_CHUNK((size_t)(-1))
const NC_UNLIMITED = 0
const NC_GLOBAL = -1
const NC_MAX_DIMS = 1024
const NC_MAX_ATTRS = 8192
const NC_MAX_VARS = 8192
const NC_MAX_NAME = 256
const NC_MAX_VAR_DIMS = 1024
const NC_MAX_HDF4_NAME = 64
const NC_ENDIAN_NATIVE = 0
const NC_ENDIAN_LITTLE = 1
const NC_ENDIAN_BIG = 2
const NC_CHUNKED = 0
const NC_CONTIGUOUS = 1
const NC_NOCHECKSUM = 0
const NC_FLETCHER32 = 1
const NC_NOSHUFFLE = 0
const NC_SHUFFLE = 1
# Skipping MacroDefinition: NC_ISSYSERR(err)((err)>0)
const NC_NOERR = 0
const NC2_ERR = (-1)
const NC_EBADID = (-33)
const NC_ENFILE = (-34)
const NC_EEXIST = (-35)
const NC_EINVAL = (-36)
const NC_EPERM = (-37)
const NC_ENOTINDEFINE = (-38)
const NC_EINDEFINE = (-39)
const NC_EINVALCOORDS = (-40)
const NC_EMAXDIMS = (-41)
const NC_ENAMEINUSE = (-42)
const NC_ENOTATT = (-43)
const NC_EMAXATTS = (-44)
const NC_EBADTYPE = (-45)
const NC_EBADDIM = (-46)
const NC_EUNLIMPOS = (-47)
const NC_EMAXVARS = (-48)
const NC_ENOTVAR = (-49)
const NC_EGLOBAL = (-50)
const NC_ENOTNC = (-51)
const NC_ESTS = (-52)
const NC_EMAXNAME = (-53)
const NC_EUNLIMIT = (-54)
const NC_ENORECVARS = (-55)
const NC_ECHAR = (-56)
const NC_EEDGE = (-57)
const NC_ESTRIDE = (-58)
const NC_EBADNAME = (-59)
const NC_ERANGE = (-60)
const NC_ENOMEM = (-61)
const NC_EVARSIZE = (-62)
const NC_EDIMSIZE = (-63)
const NC_ETRUNC = (-64)
const NC_EAXISTYPE = (-65)
const NC_EDAP = (-66)
const NC_ECURL = (-67)
const NC_EIO = (-68)
const NC_ENODATA = (-69)
const NC_EDAPSVC = (-70)
const NC_EDAS = (-71)
const NC_EDDS = (-72)
const NC_EDATADDS = (-73)
const NC_EDAPURL = (-74)
const NC_EDAPCONSTRAINT = (-75)
const NC_ETRANSLATION = (-76)
const NC4_FIRST_ERROR = (-100)
const NC_EHDFERR = (-101)
const NC_ECANTREAD = (-102)
const NC_ECANTWRITE = (-103)
const NC_ECANTCREATE = (-104)
const NC_EFILEMETA = (-105)
const NC_EDIMMETA = (-106)
const NC_EATTMETA = (-107)
const NC_EVARMETA = (-108)
const NC_ENOCOMPOUND = (-109)
const NC_EATTEXISTS = (-110)
const NC_ENOTNC4 = (-111)
const NC_ESTRICTNC3 = (-112)
const NC_ENOTNC3 = (-113)
const NC_ENOPAR = (-114)
const NC_EPARINIT = (-115)
const NC_EBADGRPID = (-116)
const NC_EBADTYPID = (-117)
const NC_ETYPDEFINED = (-118)
const NC_EBADFIELD = (-119)
const NC_EBADCLASS = (-120)
const NC_EMAPTYPE = (-121)
const NC_ELATEFILL = (-122)
const NC_ELATEDEF = (-123)
const NC_EDIMSCALE = (-124)
const NC_ENOGRP = (-125)
const NC_ESTORAGE = (-126)
const NC_EBADCHUNK = (-127)
const NC_ENOTBUILT = (-128)
const NC_EDISKLESS = (-129)
const NC4_LAST_ERROR = (-129)
const DIM_WITHOUT_VARIABLE = "This is a netCDF dimension but not a netCDF variable."
const NC_HAVE_NEW_CHUNKING_API = 1
# Skipping MacroDefinition: NC_EURL(NC_EDAPURL)
# Skipping MacroDefinition: NC_ECONSTRAINT(NC_EDAPCONSTRAINT)
const NC_INDEPENDENT = 0
const NC_COLLECTIVE = 1
# Skipping MacroDefinition: NC_COMPOUND_OFFSET(S,M)(offsetof(S,M))
# Skipping MacroDefinition: ncvarcpy(ncid_in,varid,ncid_out)ncvarcopy((ncid_in),(varid),(ncid_out))
# Skipping MacroDefinition: nc_set_log_level(e)

typealias nc_type Cint
typealias nclong Cint

@c Ptr{UInt8} nc_inq_libvers () libnetcdf
@c Ptr{UInt8} nc_strerror (Cint,) libnetcdf
@c Cint nc__create (Ptr{UInt8}, Cint, Csize_t, Ptr{Csize_t}, Ptr{Cint}) libnetcdf
@c Cint nc_create (Ptr{UInt8}, Cint, Ptr{Cint}) libnetcdf
@c Cint nc__open (Ptr{UInt8}, Cint, Ptr{Csize_t}, Ptr{Cint}) libnetcdf
@c Cint nc_open (Ptr{UInt8}, Cint, Ptr{Cint}) libnetcdf
@c Cint nc_inq_path (Cint, Ptr{Csize_t}, Ptr{UInt8}) libnetcdf
@c Cint nc_var_par_access (Cint, Cint, Cint) libnetcdf
@c Cint nc_inq_ncid (Cint, Ptr{UInt8}, Ptr{Cint}) libnetcdf
@c Cint nc_inq_grps (Cint, Ptr{Cint}, Ptr{Cint}) libnetcdf
@c Cint nc_inq_grpname (Cint, Ptr{UInt8}) libnetcdf
@c Cint nc_inq_grpname_full (Cint, Ptr{Csize_t}, Ptr{UInt8}) libnetcdf
@c Cint nc_inq_grpname_len (Cint, Ptr{Csize_t}) libnetcdf
@c Cint nc_inq_grp_parent (Cint, Ptr{Cint}) libnetcdf
@c Cint nc_inq_grp_ncid (Cint, Ptr{UInt8}, Ptr{Cint}) libnetcdf
@c Cint nc_inq_grp_full_ncid (Cint, Ptr{UInt8}, Ptr{Cint}) libnetcdf
@c Cint nc_inq_varids (Cint, Ptr{Cint}, Ptr{Cint}) libnetcdf
@c Cint nc_inq_dimids (Cint, Ptr{Cint}, Ptr{Cint}, Cint) libnetcdf
@c Cint nc_inq_typeids (Cint, Ptr{Cint}, Ptr{Cint}) libnetcdf
@c Cint nc_inq_type_equal (Cint, nc_type, Cint, nc_type, Ptr{Cint}) libnetcdf
@c Cint nc_def_grp (Cint, Ptr{UInt8}, Ptr{Cint}) libnetcdf
@c Cint nc_def_compound (Cint, Csize_t, Ptr{UInt8}, Ptr{nc_type}) libnetcdf
@c Cint nc_insert_compound (Cint, nc_type, Ptr{UInt8}, Csize_t, nc_type) libnetcdf
@c Cint nc_insert_array_compound (Cint, nc_type, Ptr{UInt8}, Csize_t, nc_type, Cint, Ptr{Cint}) libnetcdf
@c Cint nc_inq_type (Cint, nc_type, Ptr{UInt8}, Ptr{Csize_t}) libnetcdf
@c Cint nc_inq_typeid (Cint, Ptr{UInt8}, Ptr{nc_type}) libnetcdf
@c Cint nc_inq_compound (Cint, nc_type, Ptr{UInt8}, Ptr{Csize_t}, Ptr{Csize_t}) libnetcdf
@c Cint nc_inq_compound_name (Cint, nc_type, Ptr{UInt8}) libnetcdf
@c Cint nc_inq_compound_size (Cint, nc_type, Ptr{Csize_t}) libnetcdf
@c Cint nc_inq_compound_nfields (Cint, nc_type, Ptr{Csize_t}) libnetcdf
@c Cint nc_inq_compound_field (Cint, nc_type, Cint, Ptr{UInt8}, Ptr{Csize_t}, Ptr{nc_type}, Ptr{Cint}, Ptr{Cint}) libnetcdf
@c Cint nc_inq_compound_fieldname (Cint, nc_type, Cint, Ptr{UInt8}) libnetcdf
@c Cint nc_inq_compound_fieldindex (Cint, nc_type, Ptr{UInt8}, Ptr{Cint}) libnetcdf
@c Cint nc_inq_compound_fieldoffset (Cint, nc_type, Cint, Ptr{Csize_t}) libnetcdf
@c Cint nc_inq_compound_fieldtype (Cint, nc_type, Cint, Ptr{nc_type}) libnetcdf
@c Cint nc_inq_compound_fieldndims (Cint, nc_type, Cint, Ptr{Cint}) libnetcdf
@c Cint nc_inq_compound_fielddim_sizes (Cint, nc_type, Cint, Ptr{Cint}) libnetcdf
@c Cint nc_def_vlen (Cint, Ptr{UInt8}, nc_type, Ptr{nc_type}) libnetcdf
@c Cint nc_inq_vlen (Cint, nc_type, Ptr{UInt8}, Ptr{Csize_t}, Ptr{nc_type}) libnetcdf
@c Cint nc_free_vlen (Ptr{nc_vlen_t},) libnetcdf
@c Cint nc_free_vlens (Csize_t, Ptr{nc_vlen_t}) libnetcdf
@c Cint nc_put_vlen_element (Cint, Cint, Ptr{Void}, Csize_t, Ptr{Void}) libnetcdf
@c Cint nc_get_vlen_element (Cint, Cint, Ptr{Void}, Ptr{Csize_t}, Ptr{Void}) libnetcdf
@c Cint nc_free_string (Csize_t, Ptr{Ptr{UInt8}}) libnetcdf
@c Cint nc_inq_user_type (Cint, nc_type, Ptr{UInt8}, Ptr{Csize_t}, Ptr{nc_type}, Ptr{Csize_t}, Ptr{Cint}) libnetcdf
@c Cint nc_put_att (Cint, Cint, Ptr{UInt8}, nc_type, Csize_t, Ptr{Void}) libnetcdf
@c Cint nc_get_att (Cint, Cint, Ptr{UInt8}, Ptr{Void}) libnetcdf
@c Cint nc_def_enum (Cint, nc_type, Ptr{UInt8}, Ptr{nc_type}) libnetcdf
@c Cint nc_insert_enum (Cint, nc_type, Ptr{UInt8}, Ptr{Void}) libnetcdf
@c Cint nc_inq_enum (Cint, nc_type, Ptr{UInt8}, Ptr{nc_type}, Ptr{Csize_t}, Ptr{Csize_t}) libnetcdf
@c Cint nc_inq_enum_member (Cint, nc_type, Cint, Ptr{UInt8}, Ptr{Void}) libnetcdf
@c Cint nc_inq_enum_ident (Cint, nc_type, Clonglong, Ptr{UInt8}) libnetcdf
@c Cint nc_def_opaque (Cint, Csize_t, Ptr{UInt8}, Ptr{nc_type}) libnetcdf
@c Cint nc_inq_opaque (Cint, nc_type, Ptr{UInt8}, Ptr{Csize_t}) libnetcdf
@c Cint nc_put_var (Cint, Cint, Ptr{Void}) libnetcdf
@c Cint nc_get_var (Cint, Cint, Ptr{Void}) libnetcdf
@c Cint nc_put_var1 (Cint, Cint, Ptr{Csize_t}, Ptr{Void}) libnetcdf
@c Cint nc_get_var1 (Cint, Cint, Ptr{Csize_t}, Ptr{Void}) libnetcdf
@c Cint nc_put_vara (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{Void}) libnetcdf
@c Cint nc_get_vara (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{Void}) libnetcdf
@c Cint nc_put_vars (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{ptrdiff_t}, Ptr{Void}) libnetcdf
@c Cint nc_get_vars (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{ptrdiff_t}, Ptr{Void}) libnetcdf
@c Cint nc_put_varm (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{ptrdiff_t}, Ptr{ptrdiff_t}, Ptr{Void}) libnetcdf
@c Cint nc_get_varm (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{ptrdiff_t}, Ptr{ptrdiff_t}, Ptr{Void}) libnetcdf
@c Cint nc_def_var_deflate (Cint, Cint, Cint, Cint, Cint) libnetcdf
@c Cint nc_inq_var_deflate (Cint, Cint, Ptr{Cint}, Ptr{Cint}, Ptr{Cint}) libnetcdf
@c Cint nc_inq_var_szip (Cint, Cint, Ptr{Cint}, Ptr{Cint}) libnetcdf
@c Cint nc_def_var_fletcher32 (Cint, Cint, Cint) libnetcdf
@c Cint nc_inq_var_fletcher32 (Cint, Cint, Ptr{Cint}) libnetcdf
@c Cint nc_def_var_chunking (Cint, Cint, Cint, Ptr{Csize_t}) libnetcdf
@c Cint nc_inq_var_chunking (Cint, Cint, Ptr{Cint}, Ptr{Csize_t}) libnetcdf
@c Cint nc_def_var_fill (Cint, Cint, Cint, Ptr{Void}) libnetcdf
@c Cint nc_inq_var_fill (Cint, Cint, Ptr{Cint}, Ptr{Void}) libnetcdf
@c Cint nc_def_var_endian (Cint, Cint, Cint) libnetcdf
@c Cint nc_inq_var_endian (Cint, Cint, Ptr{Cint}) libnetcdf
@c Cint nc_set_fill (Cint, Cint, Ptr{Cint}) libnetcdf
@c Cint nc_set_default_format (Cint, Ptr{Cint}) libnetcdf
@c Cint nc_set_chunk_cache (Csize_t, Csize_t, Cfloat) libnetcdf
@c Cint nc_get_chunk_cache (Ptr{Csize_t}, Ptr{Csize_t}, Ptr{Cfloat}) libnetcdf
@c Cint nc_set_var_chunk_cache (Cint, Cint, Csize_t, Csize_t, Cfloat) libnetcdf
@c Cint nc_get_var_chunk_cache (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{Cfloat}) libnetcdf
@c Cint nc_redef (Cint,) libnetcdf
@c Cint nc__enddef (Cint, Csize_t, Csize_t, Csize_t, Csize_t) libnetcdf
@c Cint nc_enddef (Cint,) libnetcdf
@c Cint nc_sync (Cint,) libnetcdf
@c Cint nc_abort (Cint,) libnetcdf
@c Cint nc_close (Cint,) libnetcdf
@c Cint nc_inq (Cint, Ptr{Cint}, Ptr{Cint}, Ptr{Cint}, Ptr{Cint}) libnetcdf
@c Cint nc_inq_ndims (Cint, Ptr{Cint}) libnetcdf
@c Cint nc_inq_nvars (Cint, Ptr{Cint}) libnetcdf
@c Cint nc_inq_natts (Cint, Ptr{Cint}) libnetcdf
@c Cint nc_inq_unlimdim (Cint, Ptr{Cint}) libnetcdf
@c Cint nc_inq_unlimdims (Cint, Ptr{Cint}, Ptr{Cint}) libnetcdf
@c Cint nc_inq_format (Cint, Ptr{Cint}) libnetcdf
@c Cint nc_def_dim (Cint, Ptr{UInt8}, Csize_t, Ptr{Cint}) libnetcdf
@c Cint nc_inq_dimid (Cint, Ptr{UInt8}, Ptr{Cint}) libnetcdf
@c Cint nc_inq_dim (Cint, Cint, Ptr{UInt8}, Ptr{Csize_t}) libnetcdf
@c Cint nc_inq_dimname (Cint, Cint, Ptr{UInt8}) libnetcdf
@c Cint nc_inq_dimlen (Cint, Cint, Ptr{Csize_t}) libnetcdf
@c Cint nc_rename_dim (Cint, Cint, Ptr{UInt8}) libnetcdf
@c Cint nc_inq_att (Cint, Cint, Ptr{UInt8}, Ptr{nc_type}, Ptr{Csize_t}) libnetcdf
@c Cint nc_inq_attid (Cint, Cint, Ptr{UInt8}, Ptr{Cint}) libnetcdf
@c Cint nc_inq_atttype (Cint, Cint, Ptr{UInt8}, Ptr{nc_type}) libnetcdf
@c Cint nc_inq_attlen (Cint, Cint, Ptr{UInt8}, Ptr{Csize_t}) libnetcdf
@c Cint nc_inq_attname (Cint, Cint, Cint, Ptr{UInt8}) libnetcdf
@c Cint nc_copy_att (Cint, Cint, Ptr{UInt8}, Cint, Cint) libnetcdf
@c Cint nc_rename_att (Cint, Cint, Ptr{UInt8}, Ptr{UInt8}) libnetcdf
@c Cint nc_del_att (Cint, Cint, Ptr{UInt8}) libnetcdf
@c Cint nc_put_att_text (Cint, Cint, Ptr{UInt8}, Csize_t, Ptr{UInt8}) libnetcdf
@c Cint nc_get_att_text (Cint, Cint, Ptr{UInt8}, Ptr{UInt8}) libnetcdf
@c Cint nc_put_att_uchar (Cint, Cint, Ptr{UInt8}, nc_type, Csize_t, Ptr{Cuchar}) libnetcdf
@c Cint nc_get_att_uchar (Cint, Cint, Ptr{UInt8}, Ptr{Cuchar}) libnetcdf
@c Cint nc_put_att_schar (Cint, Cint, Ptr{UInt8}, nc_type, Csize_t, Ptr{Int8}) libnetcdf
@c Cint nc_get_att_schar (Cint, Cint, Ptr{UInt8}, Ptr{Int8}) libnetcdf
@c Cint nc_put_att_short (Cint, Cint, Ptr{UInt8}, nc_type, Csize_t, Ptr{Int16}) libnetcdf
@c Cint nc_get_att_short (Cint, Cint, Ptr{UInt8}, Ptr{Int16}) libnetcdf
@c Cint nc_put_att_int (Cint, Cint, Ptr{UInt8}, nc_type, Csize_t, Ptr{Cint}) libnetcdf
@c Cint nc_get_att_int (Cint, Cint, Ptr{UInt8}, Ptr{Cint}) libnetcdf
@c Cint nc_put_att_long (Cint, Cint, Ptr{UInt8}, nc_type, Csize_t, Ptr{Clong}) libnetcdf
@c Cint nc_get_att_long (Cint, Cint, Ptr{UInt8}, Ptr{Clong}) libnetcdf
@c Cint nc_put_att_float (Cint, Cint, Ptr{UInt8}, nc_type, Csize_t, Ptr{Cfloat}) libnetcdf
@c Cint nc_get_att_float (Cint, Cint, Ptr{UInt8}, Ptr{Cfloat}) libnetcdf
@c Cint nc_put_att_double (Cint, Cint, Ptr{UInt8}, nc_type, Csize_t, Ptr{Cdouble}) libnetcdf
@c Cint nc_get_att_double (Cint, Cint, Ptr{UInt8}, Ptr{Cdouble}) libnetcdf
@c Cint nc_put_att_ushort (Cint, Cint, Ptr{UInt8}, nc_type, Csize_t, Ptr{UInt16}) libnetcdf
@c Cint nc_get_att_ushort (Cint, Cint, Ptr{UInt8}, Ptr{UInt16}) libnetcdf
@c Cint nc_put_att_uint (Cint, Cint, Ptr{UInt8}, nc_type, Csize_t, Ptr{UInt32}) libnetcdf
@c Cint nc_get_att_uint (Cint, Cint, Ptr{UInt8}, Ptr{UInt32}) libnetcdf
@c Cint nc_put_att_longlong (Cint, Cint, Ptr{UInt8}, nc_type, Csize_t, Ptr{Clonglong}) libnetcdf
@c Cint nc_get_att_longlong (Cint, Cint, Ptr{UInt8}, Ptr{Clonglong}) libnetcdf
@c Cint nc_put_att_ulonglong (Cint, Cint, Ptr{UInt8}, nc_type, Csize_t, Ptr{Culonglong}) libnetcdf
@c Cint nc_get_att_ulonglong (Cint, Cint, Ptr{UInt8}, Ptr{Culonglong}) libnetcdf
@c Cint nc_put_att_string (Cint, Cint, Ptr{UInt8}, Csize_t, Ptr{Ptr{UInt8}}) libnetcdf
@c Cint nc_get_att_string (Cint, Cint, Ptr{UInt8}, Ptr{Ptr{UInt8}}) libnetcdf
@c Cint nc_def_var (Cint, Ptr{UInt8}, nc_type, Cint, Ptr{Cint}, Ptr{Cint}) libnetcdf
@c Cint nc_inq_var (Cint, Cint, Ptr{UInt8}, Ptr{nc_type}, Ptr{Cint}, Ptr{Cint}, Ptr{Cint}) libnetcdf
@c Cint nc_inq_varid (Cint, Ptr{UInt8}, Ptr{Cint}) libnetcdf
@c Cint nc_inq_varname (Cint, Cint, Ptr{UInt8}) libnetcdf
@c Cint nc_inq_vartype (Cint, Cint, Ptr{nc_type}) libnetcdf
@c Cint nc_inq_varndims (Cint, Cint, Ptr{Cint}) libnetcdf
@c Cint nc_inq_vardimid (Cint, Cint, Ptr{Cint}) libnetcdf
@c Cint nc_inq_varnatts (Cint, Cint, Ptr{Cint}) libnetcdf
@c Cint nc_rename_var (Cint, Cint, Ptr{UInt8}) libnetcdf
@c Cint nc_copy_var (Cint, Cint, Cint) libnetcdf
@c Cint nc_put_var1_text (Cint, Cint, Ptr{Csize_t}, Ptr{UInt8}) libnetcdf
@c Cint nc_get_var1_text (Cint, Cint, Ptr{Csize_t}, Ptr{UInt8}) libnetcdf
@c Cint nc_put_var1_uchar (Cint, Cint, Ptr{Csize_t}, Ptr{Cuchar}) libnetcdf
@c Cint nc_get_var1_uchar (Cint, Cint, Ptr{Csize_t}, Ptr{Cuchar}) libnetcdf
@c Cint nc_put_var1_schar (Cint, Cint, Ptr{Csize_t}, Ptr{UInt8}) libnetcdf
@c Cint nc_get_var1_schar (Cint, Cint, Ptr{Csize_t}, Ptr{UInt8}) libnetcdf
@c Cint nc_put_var1_short (Cint, Cint, Ptr{Csize_t}, Ptr{Int16}) libnetcdf
@c Cint nc_get_var1_short (Cint, Cint, Ptr{Csize_t}, Ptr{Int16}) libnetcdf
@c Cint nc_put_var1_int (Cint, Cint, Ptr{Csize_t}, Ptr{Cint}) libnetcdf
@c Cint nc_get_var1_int (Cint, Cint, Ptr{Csize_t}, Ptr{Cint}) libnetcdf
@c Cint nc_put_var1_long (Cint, Cint, Ptr{Csize_t}, Ptr{Clong}) libnetcdf
@c Cint nc_get_var1_long (Cint, Cint, Ptr{Csize_t}, Ptr{Clong}) libnetcdf
@c Cint nc_put_var1_float (Cint, Cint, Ptr{Csize_t}, Ptr{Cfloat}) libnetcdf
@c Cint nc_get_var1_float (Cint, Cint, Ptr{Csize_t}, Ptr{Cfloat}) libnetcdf
@c Cint nc_put_var1_double (Cint, Cint, Ptr{Csize_t}, Ptr{Cdouble}) libnetcdf
@c Cint nc_get_var1_double (Cint, Cint, Ptr{Csize_t}, Ptr{Cdouble}) libnetcdf
@c Cint nc_put_var1_ushort (Cint, Cint, Ptr{Csize_t}, Ptr{UInt16}) libnetcdf
@c Cint nc_get_var1_ushort (Cint, Cint, Ptr{Csize_t}, Ptr{UInt16}) libnetcdf
@c Cint nc_put_var1_uint (Cint, Cint, Ptr{Csize_t}, Ptr{UInt32}) libnetcdf
@c Cint nc_get_var1_uint (Cint, Cint, Ptr{Csize_t}, Ptr{UInt32}) libnetcdf
@c Cint nc_put_var1_longlong (Cint, Cint, Ptr{Csize_t}, Ptr{Clonglong}) libnetcdf
@c Cint nc_get_var1_longlong (Cint, Cint, Ptr{Csize_t}, Ptr{Clonglong}) libnetcdf
@c Cint nc_put_var1_ulonglong (Cint, Cint, Ptr{Csize_t}, Ptr{Culonglong}) libnetcdf
@c Cint nc_get_var1_ulonglong (Cint, Cint, Ptr{Csize_t}, Ptr{Culonglong}) libnetcdf
@c Cint nc_put_var1_string (Cint, Cint, Ptr{Csize_t}, Ptr{Ptr{UInt8}}) libnetcdf
@c Cint nc_get_var1_string (Cint, Cint, Ptr{Csize_t}, Ptr{Ptr{UInt8}}) libnetcdf
@c Cint nc_put_vara_text (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{UInt8}) libnetcdf
@c Cint nc_get_vara_text (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{UInt8}) libnetcdf
@c Cint nc_put_vara_uchar (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{Cuchar}) libnetcdf
@c Cint nc_get_vara_uchar (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{Cuchar}) libnetcdf
@c Cint nc_put_vara_schar (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{Int8}) libnetcdf
@c Cint nc_get_vara_schar (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{Int8}) libnetcdf
@c Cint nc_put_vara_short (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{Int16}) libnetcdf
@c Cint nc_get_vara_short (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{Int16}) libnetcdf
@c Cint nc_put_vara_int (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{Cint}) libnetcdf
@c Cint nc_get_vara_int (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{Cint}) libnetcdf
@c Cint nc_put_vara_long (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{Clong}) libnetcdf
@c Cint nc_get_vara_long (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{Clong}) libnetcdf
@c Cint nc_put_vara_float (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{Cfloat}) libnetcdf
@c Cint nc_get_vara_float (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{Cfloat}) libnetcdf
@c Cint nc_put_vara_double (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{Cdouble}) libnetcdf
@c Cint nc_get_vara_double (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{Cdouble}) libnetcdf
@c Cint nc_put_vara_ushort (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{UInt16}) libnetcdf
@c Cint nc_get_vara_ushort (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{UInt16}) libnetcdf
@c Cint nc_put_vara_uint (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{UInt32}) libnetcdf
@c Cint nc_get_vara_uint (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{UInt32}) libnetcdf
@c Cint nc_put_vara_longlong (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{Clonglong}) libnetcdf
@c Cint nc_get_vara_longlong (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{Clonglong}) libnetcdf
@c Cint nc_put_vara_ulonglong (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{Culonglong}) libnetcdf
@c Cint nc_get_vara_ulonglong (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{Culonglong}) libnetcdf
@c Cint nc_put_vara_string (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{Ptr{UInt8}}) libnetcdf
@c Cint nc_get_vara_string (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{Ptr{UInt8}}) libnetcdf
@c Cint nc_put_vars_text (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{ptrdiff_t}, Ptr{UInt8}) libnetcdf
@c Cint nc_get_vars_text (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{ptrdiff_t}, Ptr{UInt8}) libnetcdf
@c Cint nc_put_vars_uchar (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{ptrdiff_t}, Ptr{Cuchar}) libnetcdf
@c Cint nc_get_vars_uchar (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{ptrdiff_t}, Ptr{Cuchar}) libnetcdf
@c Cint nc_put_vars_schar (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{ptrdiff_t}, Ptr{UInt8}) libnetcdf
@c Cint nc_get_vars_schar (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{ptrdiff_t}, Ptr{UInt8}) libnetcdf
@c Cint nc_put_vars_short (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{ptrdiff_t}, Ptr{Int16}) libnetcdf
@c Cint nc_get_vars_short (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{ptrdiff_t}, Ptr{Int16}) libnetcdf
@c Cint nc_put_vars_int (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{ptrdiff_t}, Ptr{Cint}) libnetcdf
@c Cint nc_get_vars_int (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{ptrdiff_t}, Ptr{Cint}) libnetcdf
@c Cint nc_put_vars_long (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{ptrdiff_t}, Ptr{Clong}) libnetcdf
@c Cint nc_get_vars_long (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{ptrdiff_t}, Ptr{Clong}) libnetcdf
@c Cint nc_put_vars_float (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{ptrdiff_t}, Ptr{Cfloat}) libnetcdf
@c Cint nc_get_vars_float (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{ptrdiff_t}, Ptr{Cfloat}) libnetcdf
@c Cint nc_put_vars_double (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{ptrdiff_t}, Ptr{Cdouble}) libnetcdf
@c Cint nc_get_vars_double (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{ptrdiff_t}, Ptr{Cdouble}) libnetcdf
@c Cint nc_put_vars_ushort (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{ptrdiff_t}, Ptr{UInt16}) libnetcdf
@c Cint nc_get_vars_ushort (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{ptrdiff_t}, Ptr{UInt16}) libnetcdf
@c Cint nc_put_vars_uint (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{ptrdiff_t}, Ptr{UInt32}) libnetcdf
@c Cint nc_get_vars_uint (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{ptrdiff_t}, Ptr{UInt32}) libnetcdf
@c Cint nc_put_vars_longlong (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{ptrdiff_t}, Ptr{Clonglong}) libnetcdf
@c Cint nc_get_vars_longlong (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{ptrdiff_t}, Ptr{Clonglong}) libnetcdf
@c Cint nc_put_vars_ulonglong (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{ptrdiff_t}, Ptr{Culonglong}) libnetcdf
@c Cint nc_get_vars_ulonglong (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{ptrdiff_t}, Ptr{Culonglong}) libnetcdf
@c Cint nc_put_vars_string (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{ptrdiff_t}, Ptr{Ptr{UInt8}}) libnetcdf
@c Cint nc_get_vars_string (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{ptrdiff_t}, Ptr{Ptr{UInt8}}) libnetcdf
@c Cint nc_put_varm_text (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{ptrdiff_t}, Ptr{ptrdiff_t}, Ptr{UInt8}) libnetcdf
@c Cint nc_get_varm_text (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{ptrdiff_t}, Ptr{ptrdiff_t}, Ptr{UInt8}) libnetcdf
@c Cint nc_put_varm_uchar (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{ptrdiff_t}, Ptr{ptrdiff_t}, Ptr{Cuchar}) libnetcdf
@c Cint nc_get_varm_uchar (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{ptrdiff_t}, Ptr{ptrdiff_t}, Ptr{Cuchar}) libnetcdf
@c Cint nc_put_varm_schar (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{ptrdiff_t}, Ptr{ptrdiff_t}, Ptr{UInt8}) libnetcdf
@c Cint nc_get_varm_schar (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{ptrdiff_t}, Ptr{ptrdiff_t}, Ptr{UInt8}) libnetcdf
@c Cint nc_put_varm_short (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{ptrdiff_t}, Ptr{ptrdiff_t}, Ptr{Int16}) libnetcdf
@c Cint nc_get_varm_short (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{ptrdiff_t}, Ptr{ptrdiff_t}, Ptr{Int16}) libnetcdf
@c Cint nc_put_varm_int (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{ptrdiff_t}, Ptr{ptrdiff_t}, Ptr{Cint}) libnetcdf
@c Cint nc_get_varm_int (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{ptrdiff_t}, Ptr{ptrdiff_t}, Ptr{Cint}) libnetcdf
@c Cint nc_put_varm_long (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{ptrdiff_t}, Ptr{ptrdiff_t}, Ptr{Clong}) libnetcdf
@c Cint nc_get_varm_long (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{ptrdiff_t}, Ptr{ptrdiff_t}, Ptr{Clong}) libnetcdf
@c Cint nc_put_varm_float (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{ptrdiff_t}, Ptr{ptrdiff_t}, Ptr{Cfloat}) libnetcdf
@c Cint nc_get_varm_float (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{ptrdiff_t}, Ptr{ptrdiff_t}, Ptr{Cfloat}) libnetcdf
@c Cint nc_put_varm_double (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{ptrdiff_t}, Ptr{ptrdiff_t}, Ptr{Cdouble}) libnetcdf
@c Cint nc_get_varm_double (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{ptrdiff_t}, Ptr{ptrdiff_t}, Ptr{Cdouble}) libnetcdf
@c Cint nc_put_varm_ushort (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{ptrdiff_t}, Ptr{ptrdiff_t}, Ptr{UInt16}) libnetcdf
@c Cint nc_get_varm_ushort (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{ptrdiff_t}, Ptr{ptrdiff_t}, Ptr{UInt16}) libnetcdf
@c Cint nc_put_varm_uint (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{ptrdiff_t}, Ptr{ptrdiff_t}, Ptr{UInt32}) libnetcdf
@c Cint nc_get_varm_uint (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{ptrdiff_t}, Ptr{ptrdiff_t}, Ptr{UInt32}) libnetcdf
@c Cint nc_put_varm_longlong (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{ptrdiff_t}, Ptr{ptrdiff_t}, Ptr{Clonglong}) libnetcdf
@c Cint nc_get_varm_longlong (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{ptrdiff_t}, Ptr{ptrdiff_t}, Ptr{Clonglong}) libnetcdf
@c Cint nc_put_varm_ulonglong (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{ptrdiff_t}, Ptr{ptrdiff_t}, Ptr{Culonglong}) libnetcdf
@c Cint nc_get_varm_ulonglong (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{ptrdiff_t}, Ptr{ptrdiff_t}, Ptr{Culonglong}) libnetcdf
@c Cint nc_put_varm_string (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{ptrdiff_t}, Ptr{ptrdiff_t}, Ptr{Ptr{UInt8}}) libnetcdf
@c Cint nc_get_varm_string (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{ptrdiff_t}, Ptr{ptrdiff_t}, Ptr{Ptr{UInt8}}) libnetcdf
@c Cint nc_put_var_text (Cint, Cint, Ptr{UInt8}) libnetcdf
@c Cint nc_get_var_text (Cint, Cint, Ptr{UInt8}) libnetcdf
@c Cint nc_put_var_uchar (Cint, Cint, Ptr{Cuchar}) libnetcdf
@c Cint nc_get_var_uchar (Cint, Cint, Ptr{Cuchar}) libnetcdf
@c Cint nc_put_var_schar (Cint, Cint, Ptr{UInt8}) libnetcdf
@c Cint nc_get_var_schar (Cint, Cint, Ptr{UInt8}) libnetcdf
@c Cint nc_put_var_short (Cint, Cint, Ptr{Int16}) libnetcdf
@c Cint nc_get_var_short (Cint, Cint, Ptr{Int16}) libnetcdf
@c Cint nc_put_var_int (Cint, Cint, Ptr{Cint}) libnetcdf
@c Cint nc_get_var_int (Cint, Cint, Ptr{Cint}) libnetcdf
@c Cint nc_put_var_long (Cint, Cint, Ptr{Clong}) libnetcdf
@c Cint nc_get_var_long (Cint, Cint, Ptr{Clong}) libnetcdf
@c Cint nc_put_var_float (Cint, Cint, Ptr{Cfloat}) libnetcdf
@c Cint nc_get_var_float (Cint, Cint, Ptr{Cfloat}) libnetcdf
@c Cint nc_put_var_double (Cint, Cint, Ptr{Cdouble}) libnetcdf
@c Cint nc_get_var_double (Cint, Cint, Ptr{Cdouble}) libnetcdf
@c Cint nc_put_var_ushort (Cint, Cint, Ptr{UInt16}) libnetcdf
@c Cint nc_get_var_ushort (Cint, Cint, Ptr{UInt16}) libnetcdf
@c Cint nc_put_var_uint (Cint, Cint, Ptr{UInt32}) libnetcdf
@c Cint nc_get_var_uint (Cint, Cint, Ptr{UInt32}) libnetcdf
@c Cint nc_put_var_longlong (Cint, Cint, Ptr{Clonglong}) libnetcdf
@c Cint nc_get_var_longlong (Cint, Cint, Ptr{Clonglong}) libnetcdf
@c Cint nc_put_var_ulonglong (Cint, Cint, Ptr{Culonglong}) libnetcdf
@c Cint nc_get_var_ulonglong (Cint, Cint, Ptr{Culonglong}) libnetcdf
@c Cint nc_put_var_string (Cint, Cint, Ptr{Ptr{UInt8}}) libnetcdf
@c Cint nc_get_var_string (Cint, Cint, Ptr{Ptr{UInt8}}) libnetcdf
@c Cint nc_put_att_ubyte (Cint, Cint, Ptr{UInt8}, nc_type, Csize_t, Ptr{Cuchar}) libnetcdf
@c Cint nc_get_att_ubyte (Cint, Cint, Ptr{UInt8}, Ptr{Cuchar}) libnetcdf
@c Cint nc_put_var1_ubyte (Cint, Cint, Ptr{Csize_t}, Ptr{Cuchar}) libnetcdf
@c Cint nc_get_var1_ubyte (Cint, Cint, Ptr{Csize_t}, Ptr{Cuchar}) libnetcdf
@c Cint nc_put_vara_ubyte (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{Cuchar}) libnetcdf
@c Cint nc_get_vara_ubyte (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{Cuchar}) libnetcdf
@c Cint nc_put_vars_ubyte (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{ptrdiff_t}, Ptr{Cuchar}) libnetcdf
@c Cint nc_get_vars_ubyte (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{ptrdiff_t}, Ptr{Cuchar}) libnetcdf
@c Cint nc_put_varm_ubyte (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{ptrdiff_t}, Ptr{ptrdiff_t}, Ptr{Cuchar}) libnetcdf
@c Cint nc_get_varm_ubyte (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{ptrdiff_t}, Ptr{ptrdiff_t}, Ptr{Cuchar}) libnetcdf
@c Cint nc_put_var_ubyte (Cint, Cint, Ptr{Cuchar}) libnetcdf
@c Cint nc_get_var_ubyte (Cint, Cint, Ptr{Cuchar}) libnetcdf
@c Cint nc_show_metadata (Cint,) libnetcdf
@c Cint nc__create_mp (Ptr{UInt8}, Cint, Csize_t, Cint, Ptr{Csize_t}, Ptr{Cint}) libnetcdf
@c Cint nc__open_mp (Ptr{UInt8}, Cint, Cint, Ptr{Csize_t}, Ptr{Cint}) libnetcdf
@c Cint nc_delete (Ptr{UInt8},) libnetcdf
@c Cint nc_delete_mp (Ptr{UInt8}, Cint) libnetcdf
@c Cint nc_set_base_pe (Cint, Cint) libnetcdf
@c Cint nc_inq_base_pe (Cint, Ptr{Cint}) libnetcdf
@c Cint nctypelen (nc_type,) libnetcdf
@c None nc_advise (Ptr{UInt8}, Cint, Ptr{UInt8}) libnetcdf
@c Cint nccreate (Ptr{UInt8}, Cint) libnetcdf
@c Cint ncopen (Ptr{UInt8}, Cint) libnetcdf
@c Cint ncsetfill (Cint, Cint) libnetcdf
@c Cint ncredef (Cint,) libnetcdf
@c Cint ncendef (Cint,) libnetcdf
@c Cint ncsync (Cint,) libnetcdf
@c Cint ncabort (Cint,) libnetcdf
@c Cint ncclose (Cint,) libnetcdf
@c Cint ncinquire (Cint, Ptr{Cint}, Ptr{Cint}, Ptr{Cint}, Ptr{Cint}) libnetcdf
@c Cint ncdimdef (Cint, Ptr{UInt8}, Clong) libnetcdf
@c Cint ncdimid (Cint, Ptr{UInt8}) libnetcdf
@c Cint ncdiminq (Cint, Cint, Ptr{UInt8}, Ptr{Clong}) libnetcdf
@c Cint ncdimrename (Cint, Cint, Ptr{UInt8}) libnetcdf
@c Cint ncattput (Cint, Cint, Ptr{UInt8}, nc_type, Cint, Ptr{Void}) libnetcdf
@c Cint ncattinq (Cint, Cint, Ptr{UInt8}, Ptr{nc_type}, Ptr{Cint}) libnetcdf
@c Cint ncattget (Cint, Cint, Ptr{UInt8}, Ptr{Void}) libnetcdf
@c Cint ncattcopy (Cint, Cint, Ptr{UInt8}, Cint, Cint) libnetcdf
@c Cint ncattname (Cint, Cint, Cint, Ptr{UInt8}) libnetcdf
@c Cint ncattrename (Cint, Cint, Ptr{UInt8}, Ptr{UInt8}) libnetcdf
@c Cint ncattdel (Cint, Cint, Ptr{UInt8}) libnetcdf
@c Cint ncvardef (Cint, Ptr{UInt8}, nc_type, Cint, Ptr{Cint}) libnetcdf
@c Cint ncvarid (Cint, Ptr{UInt8}) libnetcdf
@c Cint ncvarinq (Cint, Cint, Ptr{UInt8}, Ptr{nc_type}, Ptr{Cint}, Ptr{Cint}, Ptr{Cint}) libnetcdf
@c Cint ncvarput1 (Cint, Cint, Ptr{Clong}, Ptr{Void}) libnetcdf
@c Cint ncvarget1 (Cint, Cint, Ptr{Clong}, Ptr{Void}) libnetcdf
@c Cint ncvarput (Cint, Cint, Ptr{Clong}, Ptr{Clong}, Ptr{Void}) libnetcdf
@c Cint ncvarget (Cint, Cint, Ptr{Clong}, Ptr{Clong}, Ptr{Void}) libnetcdf
@c Cint ncvarputs (Cint, Cint, Ptr{Clong}, Ptr{Clong}, Ptr{Clong}, Ptr{Void}) libnetcdf
@c Cint ncvargets (Cint, Cint, Ptr{Clong}, Ptr{Clong}, Ptr{Clong}, Ptr{Void}) libnetcdf
@c Cint ncvarputg (Cint, Cint, Ptr{Clong}, Ptr{Clong}, Ptr{Clong}, Ptr{Clong}, Ptr{Void}) libnetcdf
@c Cint ncvargetg (Cint, Cint, Ptr{Clong}, Ptr{Clong}, Ptr{Clong}, Ptr{Clong}, Ptr{Void}) libnetcdf
@c Cint ncvarrename (Cint, Cint, Ptr{UInt8}) libnetcdf
@c Cint ncrecinq (Cint, Ptr{Cint}, Ptr{Cint}, Ptr{Clong}) libnetcdf
@c Cint ncrecget (Cint, Clong, Ptr{Ptr{Void}}) libnetcdf
@c Cint ncrecput (Cint, Clong, Ptr{Ptr{Void}}) libnetcdf
