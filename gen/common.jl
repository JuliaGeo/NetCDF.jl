# Automatically generated using Clang.jl wrap_c, version 0.0.0

using Compat

const unix = 1
const linux = 1

# Skipping MacroDefinition: NULL ( ( void * ) 0 ) #
# Skipping MacroDefinition: offsetof ( t , d ) __builtin_offsetof ( t , d ) #

const ptrdiff_t = Clong
const size_t = Culong
const wchar_t = Cint

mutable struct max_align_t
    __clang_max_align_nonce1::Clonglong
    __clang_max_align_nonce2::Float64
end

const EPERM = 1
const ENOENT = 2
const ESRCH = 3
const EINTR = 4
const EIO = 5
const ENXIO = 6
const E2BIG = 7
const ENOEXEC = 8
const EBADF = 9
const ECHILD = 10
const EAGAIN = 11
const ENOMEM = 12
const EACCES = 13
const EFAULT = 14
const ENOTBLK = 15
const EBUSY = 16
const EEXIST = 17
const EXDEV = 18
const ENODEV = 19
const ENOTDIR = 20
const EISDIR = 21
const EINVAL = 22
const ENFILE = 23
const EMFILE = 24
const ENOTTY = 25
const ETXTBSY = 26
const EFBIG = 27
const ENOSPC = 28
const ESPIPE = 29
const EROFS = 30
const EMLINK = 31
const EPIPE = 32
const EDOM = 33
const ERANGE = 34
const EDEADLK = 35
const ENAMETOOLONG = 36
const ENOLCK = 37
const ENOSYS = 38
const ENOTEMPTY = 39
const ELOOP = 40
const EWOULDBLOCK = EAGAIN
const ENOMSG = 42
const EIDRM = 43
const ECHRNG = 44
const EL2NSYNC = 45
const EL3HLT = 46
const EL3RST = 47
const ELNRNG = 48
const EUNATCH = 49
const ENOCSI = 50
const EL2HLT = 51
const EBADE = 52
const EBADR = 53
const EXFULL = 54
const ENOANO = 55
const EBADRQC = 56
const EBADSLT = 57
const EDEADLOCK = EDEADLK
const EBFONT = 59
const ENOSTR = 60
const ENODATA = 61
const ETIME = 62
const ENOSR = 63
const ENONET = 64
const ENOPKG = 65
const EREMOTE = 66
const ENOLINK = 67
const EADV = 68
const ESRMNT = 69
const ECOMM = 70
const EPROTO = 71
const EMULTIHOP = 72
const EDOTDOT = 73
const EBADMSG = 74
const EOVERFLOW = 75
const ENOTUNIQ = 76
const EBADFD = 77
const EREMCHG = 78
const ELIBACC = 79
const ELIBBAD = 80
const ELIBSCN = 81
const ELIBMAX = 82
const ELIBEXEC = 83
const EILSEQ = 84
const ERESTART = 85
const ESTRPIPE = 86
const EUSERS = 87
const ENOTSOCK = 88
const EDESTADDRREQ = 89
const EMSGSIZE = 90
const EPROTOTYPE = 91
const ENOPROTOOPT = 92
const EPROTONOSUPPORT = 93
const ESOCKTNOSUPPORT = 94
const EOPNOTSUPP = 95
const EPFNOSUPPORT = 96
const EAFNOSUPPORT = 97
const EADDRINUSE = 98
const EADDRNOTAVAIL = 99
const ENETDOWN = 100
const ENETUNREACH = 101
const ENETRESET = 102
const ECONNABORTED = 103
const ECONNRESET = 104
const ENOBUFS = 105
const EISCONN = 106
const ENOTCONN = 107
const ESHUTDOWN = 108
const ETOOMANYREFS = 109
const ETIMEDOUT = 110
const ECONNREFUSED = 111
const EHOSTDOWN = 112
const EHOSTUNREACH = 113
const EALREADY = 114
const EINPROGRESS = 115
const ESTALE = 116
const EUCLEAN = 117
const ENOTNAM = 118
const ENAVAIL = 119
const EISNAM = 120
const EREMOTEIO = 121
const EDQUOT = 122
const ENOMEDIUM = 123
const EMEDIUMTYPE = 124
const ECANCELED = 125
const ENOKEY = 126
const EKEYEXPIRED = 127
const EKEYREVOKED = 128
const EKEYREJECTED = 129
const EOWNERDEAD = 130
const ENOTRECOVERABLE = 131
const ERFKILL = 132
const EHWPOISON = 133
const NC_NAT = 0
const NC_BYTE = 1
const NC_CHAR = 2
const NC_SHORT = 3
const NC_INT = 4
const NC_LONG = NC_INT
const NC_FLOAT = 5
const NC_DOUBLE = 6
const NC_UBYTE = 7
const NC_USHORT = 8
const NC_UINT = 9
const NC_INT64 = 10
const NC_UINT64 = 11
const NC_STRING = 12
const NC_MAX_ATOMIC_TYPE = NC_STRING
const NC_VLEN = 13
const NC_OPAQUE = 14
const NC_ENUM = 15
const NC_COMPOUND = 16
const NC_FIRSTUSERTYPEID = 32

# Skipping MacroDefinition: NC_FILL_BYTE ( ( signed char ) - 127 ) #
# Skipping MacroDefinition: NC_FILL_CHAR ( ( char ) 0 ) #
# Skipping MacroDefinition: NC_FILL_SHORT ( ( short ) - 32767 ) #
# Skipping MacroDefinition: NC_FILL_INT ( - 2147483647L ) #
# Skipping MacroDefinition: NC_FILL_FLOAT ( 9.9692099683868690e+36f ) /* near 15 * 2^119 */
# Skipping MacroDefinition: NC_FILL_DOUBLE ( 9.9692099683868690e+36 ) #
# Skipping MacroDefinition: NC_FILL_UBYTE ( 255 ) #
# Skipping MacroDefinition: NC_FILL_USHORT ( 65535 ) #
# Skipping MacroDefinition: NC_FILL_UINT ( 4294967295U ) #
# Skipping MacroDefinition: NC_FILL_INT64 ( ( long long ) - 9223372036854775806LL ) #
# Skipping MacroDefinition: NC_FILL_UINT64 ( ( unsigned long long ) 18446744073709551614ULL ) #
# Skipping MacroDefinition: NC_FILL_STRING ( ( char * ) "" ) /**@}*/

const NC_MAX_BYTE = 127

# Skipping MacroDefinition: NC_MIN_BYTE ( - NC_MAX_BYTE - 1 ) #

const NC_MAX_CHAR = 255
const NC_MAX_SHORT = 32767

# Skipping MacroDefinition: NC_MIN_SHORT ( - NC_MAX_SHORT - 1 ) #

const NC_MAX_INT = 2147483647

# Skipping MacroDefinition: NC_MIN_INT ( - NC_MAX_INT - 1 ) #

const NC_MAX_FLOAT = Float32(3.402823466e38)

# Skipping MacroDefinition: NC_MIN_FLOAT ( - NC_MAX_FLOAT ) #

const NC_MAX_DOUBLE = 1.7976931348623157e308

# Skipping MacroDefinition: NC_MIN_DOUBLE ( - NC_MAX_DOUBLE ) #

const NC_MAX_UBYTE = NC_MAX_CHAR
const NC_MAX_USHORT = UInt32(65535)
const NC_MAX_UINT = UInt32(4294967295)

# Skipping MacroDefinition: NC_MAX_INT64 ( 9223372036854775807LL ) #
# Skipping MacroDefinition: NC_MIN_INT64 ( - 9223372036854775807LL - 1 ) #
# Skipping MacroDefinition: NC_MAX_UINT64 ( 18446744073709551615ULL ) #
# Skipping MacroDefinition: X_INT64_MAX ( 9223372036854775807LL ) #
# Skipping MacroDefinition: X_INT64_MIN ( - X_INT64_MAX - 1 ) #
# Skipping MacroDefinition: X_UINT64_MAX ( 18446744073709551615ULL ) /**@}*/

const NC_FILL = 0
const NC_NOFILL = 0x0100
const NC_NOWRITE = 0x0000
const NC_WRITE = 0x0001
const NC_CLOBBER = 0x0000
const NC_NOCLOBBER = 0x0004
const NC_DISKLESS = 0x0008
const NC_MMAP = 0x0010
const NC_64BIT_DATA = 0x0020
const NC_CDF5 = NC_64BIT_DATA
const NC_CLASSIC_MODEL = 0x0100
const NC_64BIT_OFFSET = 0x0200
const NC_LOCK = 0x0400
const NC_SHARE = 0x0800
const NC_NETCDF4 = 0x1000
const NC_MPIIO = 0x2000
const NC_MPIPOSIX = 0x4000
const NC_INMEMORY = 0x8000

# Skipping MacroDefinition: NC_PNETCDF ( NC_MPIIO ) /**< Use parallel-netcdf library; alias for NC_MPIIO. */
# Skipping MacroDefinition: NC_FORMAT_CLASSIC ( 1 ) /* After adding CDF5 support, this flag
#   is somewhat confusing. So, it is renamed.
#   Note that the name in the contributed code
#   NC_FORMAT_64BIT was renamed to NC_FORMAT_CDF2
#*/
# Skipping MacroDefinition: NC_FORMAT_64BIT_OFFSET ( 2 ) #
# Skipping MacroDefinition: NC_FORMAT_64BIT ( NC_FORMAT_64BIT_OFFSET ) /**< \deprecated Saved for compatibility.  Use NC_FORMAT_64BIT_OFFSET or NC_FORMAT_64BIT_DATA, from netCDF 4.4.0 onwards. */
# Skipping MacroDefinition: NC_FORMAT_NETCDF4 ( 3 ) #
# Skipping MacroDefinition: NC_FORMAT_NETCDF4_CLASSIC ( 4 ) #
# Skipping MacroDefinition: NC_FORMAT_64BIT_DATA ( 5 ) /* Alias */

const NC_FORMAT_CDF5 = NC_FORMAT_64BIT_DATA

# Skipping MacroDefinition: NC_FORMATX_NC3 ( 1 ) #
# Skipping MacroDefinition: NC_FORMATX_NC_HDF5 ( 2 ) /**< netCDF-4 subset of HDF5 */

const NC_FORMATX_NC4 = NC_FORMATX_NC_HDF5

# Skipping MacroDefinition: NC_FORMATX_NC_HDF4 ( 3 ) /**< netCDF-4 subset of HDF4 */
# Skipping MacroDefinition: NC_FORMATX_PNETCDF ( 4 ) #
# Skipping MacroDefinition: NC_FORMATX_DAP2 ( 5 ) #
# Skipping MacroDefinition: NC_FORMATX_DAP4 ( 6 ) #
# Skipping MacroDefinition: NC_FORMATX_UNDEFINED ( 0 ) /* To avoid breaking compatibility (such as in the python library),
#   we need to retain the NC_FORMAT_xxx format as well. This may come
#  out eventually, as the NC_FORMATX is more clear that it's an extended
#  format specifier.*/

const NC_FORMAT_NC3 = NC_FORMATX_NC3
const NC_FORMAT_NC_HDF5 = NC_FORMATX_NC_HDF5
const NC_FORMAT_NC4 = NC_FORMATX_NC4
const NC_FORMAT_NC_HDF4 = NC_FORMATX_NC_HDF4
const NC_FORMAT_PNETCDF = NC_FORMATX_PNETCDF
const NC_FORMAT_DAP2 = NC_FORMATX_DAP2
const NC_FORMAT_DAP4 = NC_FORMATX_DAP4
const NC_FORMAT_UNDEFINED = NC_FORMATX_UNDEFINED
const NC_SIZEHINT_DEFAULT = 0

# Skipping MacroDefinition: NC_ALIGN_CHUNK ( ( size_t ) ( - 1 ) ) /** Size argument to nc_def_dim() for an unlimited dimension. */

const NC_UNLIMITED = Int32(0)
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

# Skipping MacroDefinition: NC_ISSYSERR ( err ) ( ( err ) > 0 ) #

const NC_NOERR = 0

# Skipping MacroDefinition: NC2_ERR ( - 1 ) /**< Returned for all errors in the v2 API. */
# Skipping MacroDefinition: NC_EBADID ( - 33 ) #
# Skipping MacroDefinition: NC_ENFILE ( - 34 ) /**< Too many netcdfs open */
# Skipping MacroDefinition: NC_EEXIST ( - 35 ) /**< netcdf file exists && NC_NOCLOBBER */
# Skipping MacroDefinition: NC_EINVAL ( - 36 ) /**< Invalid Argument */
# Skipping MacroDefinition: NC_EPERM ( - 37 ) /**< Write to read only */
# Skipping MacroDefinition: NC_ENOTINDEFINE ( - 38 ) /** Operation not allowed in define mode.
#
#The specified netCDF is in define mode rather than data mode.
#
#With netCDF-4/HDF5 files, this error will not occur, unless
#::NC_CLASSIC_MODEL was used in nc_create().
# */
# Skipping MacroDefinition: NC_EINDEFINE ( - 39 ) /** Index exceeds dimension bound.
#
#The specified corner indices were out of range for the rank of the
#specified variable. For example, a negative index or an index that is
#larger than the corresponding dimension length will cause an error. */
# Skipping MacroDefinition: NC_EINVALCOORDS ( - 40 ) /** NC_MAX_DIMS exceeded. Max number of dimensions exceeded in a
#classic or 64-bit offset file, or an netCDF-4 file with
#::NC_CLASSIC_MODEL on. */
# Skipping MacroDefinition: NC_EMAXDIMS ( - 41 ) #
# Skipping MacroDefinition: NC_ENAMEINUSE ( - 42 ) /**< String match to name in use */
# Skipping MacroDefinition: NC_ENOTATT ( - 43 ) /**< Attribute not found */
# Skipping MacroDefinition: NC_EMAXATTS ( - 44 ) /**< NC_MAX_ATTRS exceeded */
# Skipping MacroDefinition: NC_EBADTYPE ( - 45 ) /**< Not a netcdf data type */
# Skipping MacroDefinition: NC_EBADDIM ( - 46 ) /**< Invalid dimension id or name */
# Skipping MacroDefinition: NC_EUNLIMPOS ( - 47 ) /**< NC_UNLIMITED in the wrong index */
# Skipping MacroDefinition: NC_EMAXVARS ( - 48 ) /** Variable not found.
#
#The variable ID is invalid for the specified netCDF dataset. */
# Skipping MacroDefinition: NC_ENOTVAR ( - 49 ) #
# Skipping MacroDefinition: NC_EGLOBAL ( - 50 ) /**< Action prohibited on NC_GLOBAL varid */
# Skipping MacroDefinition: NC_ENOTNC ( - 51 ) /**< Not a netcdf file */
# Skipping MacroDefinition: NC_ESTS ( - 52 ) /**< In Fortran, string too short */
# Skipping MacroDefinition: NC_EMAXNAME ( - 53 ) /**< NC_MAX_NAME exceeded */
# Skipping MacroDefinition: NC_EUNLIMIT ( - 54 ) /**< NC_UNLIMITED size already in use */
# Skipping MacroDefinition: NC_ENORECVARS ( - 55 ) /**< nc_rec op when there are no record vars */
# Skipping MacroDefinition: NC_ECHAR ( - 56 ) /**< Attempt to convert between text & numbers */
# Skipping MacroDefinition: NC_EEDGE ( - 57 ) #
# Skipping MacroDefinition: NC_ESTRIDE ( - 58 ) /**< Illegal stride */
# Skipping MacroDefinition: NC_EBADNAME ( - 59 ) /**< Attribute or variable name contains illegal characters */
# Skipping MacroDefinition: NC_ERANGE ( - 60 ) #
# Skipping MacroDefinition: NC_ENOMEM ( - 61 ) /**< Memory allocation (malloc) failure */
# Skipping MacroDefinition: NC_EVARSIZE ( - 62 ) /**< One or more variable sizes violate format constraints */
# Skipping MacroDefinition: NC_EDIMSIZE ( - 63 ) /**< Invalid dimension size */
# Skipping MacroDefinition: NC_ETRUNC ( - 64 ) /**< File likely truncated or possibly corrupted */
# Skipping MacroDefinition: NC_EAXISTYPE ( - 65 ) /**< Unknown axis type. */
# Skipping MacroDefinition: NC_EDAP ( - 66 ) /**< Generic DAP error */
# Skipping MacroDefinition: NC_ECURL ( - 67 ) /**< Generic libcurl error */
# Skipping MacroDefinition: NC_EIO ( - 68 ) /**< Generic IO error */
# Skipping MacroDefinition: NC_ENODATA ( - 69 ) /**< Attempt to access variable with no data */
# Skipping MacroDefinition: NC_EDAPSVC ( - 70 ) /**< DAP server error */
# Skipping MacroDefinition: NC_EDAS ( - 71 ) /**< Malformed or inaccessible DAS */
# Skipping MacroDefinition: NC_EDDS ( - 72 ) /**< Malformed or inaccessible DDS */
# Skipping MacroDefinition: NC_EDATADDS ( - 73 ) /**< Malformed or inaccessible DATADDS */
# Skipping MacroDefinition: NC_EDAPURL ( - 74 ) /**< Malformed DAP URL */
# Skipping MacroDefinition: NC_EDAPCONSTRAINT ( - 75 ) /**< Malformed DAP Constraint*/
# Skipping MacroDefinition: NC_ETRANSLATION ( - 76 ) /**< Untranslatable construct */
# Skipping MacroDefinition: NC_EACCESS ( - 77 ) /**< Access Failure */
# Skipping MacroDefinition: NC_EAUTH ( - 78 ) /**< Authorization Failure */
# Skipping MacroDefinition: NC_ENOTFOUND ( - 90 ) /**< No such file */
# Skipping MacroDefinition: NC_ECANTREMOVE ( - 91 ) /**< Can't remove file */
# Skipping MacroDefinition: NC4_FIRST_ERROR ( - 100 ) /** Error at HDF5 layer. */
# Skipping MacroDefinition: NC_EHDFERR ( - 101 ) #
# Skipping MacroDefinition: NC_ECANTREAD ( - 102 ) /**< Can't read. */
# Skipping MacroDefinition: NC_ECANTWRITE ( - 103 ) /**< Can't write. */
# Skipping MacroDefinition: NC_ECANTCREATE ( - 104 ) /**< Can't create. */
# Skipping MacroDefinition: NC_EFILEMETA ( - 105 ) /**< Problem with file metadata. */
# Skipping MacroDefinition: NC_EDIMMETA ( - 106 ) /**< Problem with dimension metadata. */
# Skipping MacroDefinition: NC_EATTMETA ( - 107 ) /**< Problem with attribute metadata. */
# Skipping MacroDefinition: NC_EVARMETA ( - 108 ) /**< Problem with variable metadata. */
# Skipping MacroDefinition: NC_ENOCOMPOUND ( - 109 ) /**< Not a compound type. */
# Skipping MacroDefinition: NC_EATTEXISTS ( - 110 ) /**< Attribute already exists. */
# Skipping MacroDefinition: NC_ENOTNC4 ( - 111 ) /**< Attempting netcdf-4 operation on netcdf-3 file. */
# Skipping MacroDefinition: NC_ESTRICTNC3 ( - 112 ) #
# Skipping MacroDefinition: NC_ENOTNC3 ( - 113 ) /**< Attempting netcdf-3 operation on netcdf-4 file. */
# Skipping MacroDefinition: NC_ENOPAR ( - 114 ) /**< Parallel operation on file opened for non-parallel access. */
# Skipping MacroDefinition: NC_EPARINIT ( - 115 ) /**< Error initializing for parallel access. */
# Skipping MacroDefinition: NC_EBADGRPID ( - 116 ) /**< Bad group ID. */
# Skipping MacroDefinition: NC_EBADTYPID ( - 117 ) /**< Bad type ID. */
# Skipping MacroDefinition: NC_ETYPDEFINED ( - 118 ) /**< Type has already been defined and may not be edited. */
# Skipping MacroDefinition: NC_EBADFIELD ( - 119 ) /**< Bad field ID. */
# Skipping MacroDefinition: NC_EBADCLASS ( - 120 ) /**< Bad class. */
# Skipping MacroDefinition: NC_EMAPTYPE ( - 121 ) /**< Mapped access for atomic types only. */
# Skipping MacroDefinition: NC_ELATEFILL ( - 122 ) /**< Attempt to define fill value when data already exists. */
# Skipping MacroDefinition: NC_ELATEDEF ( - 123 ) /**< Attempt to define var properties, like deflate, after enddef. */
# Skipping MacroDefinition: NC_EDIMSCALE ( - 124 ) /**< Problem with HDF5 dimscales. */
# Skipping MacroDefinition: NC_ENOGRP ( - 125 ) /**< No group found. */
# Skipping MacroDefinition: NC_ESTORAGE ( - 126 ) /**< Can't specify both contiguous and chunking. */
# Skipping MacroDefinition: NC_EBADCHUNK ( - 127 ) /**< Bad chunksize. */
# Skipping MacroDefinition: NC_ENOTBUILT ( - 128 ) /**< Attempt to use feature that was not turned on when netCDF was built. */
# Skipping MacroDefinition: NC_EDISKLESS ( - 129 ) /**< Error in using diskless  access. */
# Skipping MacroDefinition: NC_ECANTEXTEND ( - 130 ) /**< Attempt to extend dataset during ind. I/O operation. */
# Skipping MacroDefinition: NC_EMPI ( - 131 ) /**< MPI operation failed. */
# Skipping MacroDefinition: NC4_LAST_ERROR ( - 131 ) /* This is used in netCDF-4 files for dimensions without coordinate
# * vars. */

const DIM_WITHOUT_VARIABLE = "This is a netCDF dimension but not a netCDF variable."
const NC_HAVE_NEW_CHUNKING_API = 1

# Skipping MacroDefinition: NC_EURL ( NC_EDAPURL ) /* Malformed URL */
# Skipping MacroDefinition: NC_ECONSTRAINT ( NC_EDAPCONSTRAINT ) /* Malformed Constraint*/
# Skipping MacroDefinition: EXTERNL MSC_EXTRA extern #
# Skipping MacroDefinition: NC_COMPOUND_OFFSET ( S , M ) ( offsetof ( S , M ) ) /* Create a variable length type. */
# Skipping MacroDefinition: ncvarcpy ( ncid_in , varid , ncid_out ) ncvarcopy ( ( ncid_in ) , ( varid ) , ( ncid_out ) ) #
# Skipping MacroDefinition: nc_set_log_level ( e ) #

const FILL_BYTE = NC_FILL_BYTE
const FILL_CHAR = NC_FILL_CHAR
const FILL_SHORT = NC_FILL_SHORT
const FILL_LONG = NC_FILL_INT
const FILL_FLOAT = NC_FILL_FLOAT
const FILL_DOUBLE = NC_FILL_DOUBLE
const MAX_NC_DIMS = NC_MAX_DIMS
const MAX_NC_ATTRS = NC_MAX_ATTRS
const MAX_NC_VARS = NC_MAX_VARS
const MAX_NC_NAME = NC_MAX_NAME
const MAX_VAR_DIMS = NC_MAX_VAR_DIMS
const NC_ENTOOL = NC_EMAXNAME

# Skipping MacroDefinition: NC_EXDR ( - 32 ) /* */
# Skipping MacroDefinition: NC_SYSERR ( - 31 ) /*
# * Global options variable.
# * Used to determine behavior of error handler.
# */

const NC_FATAL = 1
const NC_VERBOSE = 2

# Skipping MacroDefinition: END_OF_MAIN ( ) #

const nc_type = Cint

mutable struct nc_vlen_t
    len::Csize_t
    p::Ptr{Void}
end

const nclong = Cint
