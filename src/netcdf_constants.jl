# This file is based on automatically generated code from gen/wrap.jl

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
const NC_PNETCDF = NC_MPIIO
const NC_FORMAT_CLASSIC = 1
const NC_FORMAT_64BIT_OFFSET = 2
const NC_FORMAT_64BIT = NC_FORMAT_64BIT_OFFSET
const NC_FORMAT_NETCDF4 = 3
const NC_FORMAT_NETCDF4_CLASSIC = 4
const NC_FORMAT_64BIT_DATA = 5
const NC_FORMAT_CDF5 = NC_FORMAT_64BIT_DATA
const NC_FORMATX_NC3 = 1
const NC_FORMATX_NC_HDF5 = 2
const NC_FORMATX_NC4 = NC_FORMATX_NC_HDF5
const NC_FORMATX_NC_HDF4 = 3
const NC_FORMATX_PNETCDF = 4
const NC_FORMATX_DAP2 = 5
const NC_FORMATX_DAP4 = 6
const NC_FORMATX_UNDEFINED = 0
const NC_FORMAT_NC3 = NC_FORMATX_NC3
const NC_FORMAT_NC_HDF5 = NC_FORMATX_NC_HDF5
const NC_FORMAT_NC4 = NC_FORMATX_NC4
const NC_FORMAT_NC_HDF4 = NC_FORMATX_NC_HDF4
const NC_FORMAT_PNETCDF = NC_FORMATX_PNETCDF
const NC_FORMAT_DAP2 = NC_FORMATX_DAP2
const NC_FORMAT_DAP4 = NC_FORMATX_DAP4
const NC_FORMAT_UNDEFINED = NC_FORMATX_UNDEFINED
const NC_SIZEHINT_DEFAULT = 0

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

const NC_NOERR = 0
const NC2_ERR = -1
const NC_EBADID = -33
const NC_ENFILE = -34
const NC_EEXIST = -35
const NC_EINVAL = -36
const NC_EPERM = -37
const NC_ENOTINDEFINE = -38
const NC_EINDEFINE = -39
const NC_EINVALCOORDS = -40
const NC_EMAXDIMS = -41
const NC_ENAMEINUSE = -42
const NC_ENOTATT = -43
const NC_EMAXATTS = -44
const NC_EBADTYPE = -45
const NC_EBADDIM = -46
const NC_EUNLIMPOS = -47
const NC_EMAXVARS = -48
const NC_ENOTVAR = -49
const NC_EGLOBAL = -50
const NC_ENOTNC = -51
const NC_ESTS = -52
const NC_EMAXNAME = -53
const NC_EUNLIMIT = -54
const NC_ENORECVARS = -55
const NC_ECHAR = -56
const NC_EEDGE = -57
const NC_ESTRIDE = -58
const NC_EBADNAME = -59
const NC_ERANGE = -60
const NC_ENOMEM = -61
const NC_EVARSIZE = -62
const NC_EDIMSIZE = -63
const NC_ETRUNC = -64
const NC_EAXISTYPE = -65
const NC_EDAP = -66
const NC_ECURL = -67
const NC_EIO = -68
const NC_ENODATA = -69
const NC_EDAPSVC = -70
const NC_EDAS = -71
const NC_EDDS = -72
const NC_EDATADDS = -73
const NC_EDAPURL = -74
const NC_EDAPCONSTRAINT = -75
const NC_ETRANSLATION = -76
const NC_EACCESS = -77
const NC_EAUTH = -78
const NC_ENOTFOUND = -90
const NC_ECANTREMOVE = -91
const NC4_FIRST_ERROR = -100
const NC_EHDFERR = -101
const NC_ECANTREAD = -102
const NC_ECANTWRITE = -103
const NC_ECANTCREATE = -104
const NC_EFILEMETA = -105
const NC_EDIMMETA = -106
const NC_EATTMETA = -107
const NC_EVARMETA = -108
const NC_ENOCOMPOUND = -109
const NC_EATTEXISTS = -110
const NC_ENOTNC4 = -111
const NC_ESTRICTNC3 = -112
const NC_ENOTNC3 = -113
const NC_ENOPAR = -114
const NC_EPARINIT = -115
const NC_EBADGRPID = -116
const NC_EBADTYPID = -117
const NC_ETYPDEFINED = -118
const NC_EBADFIELD = -119
const NC_EBADCLASS = -120
const NC_EMAPTYPE = -121
const NC_ELATEFILL = -122
const NC_ELATEDEF = -123
const NC_EDIMSCALE = -124
const NC_ENOGRP = -125
const NC_ESTORAGE = -126
const NC_EBADCHUNK = -127
const NC_ENOTBUILT = -128
const NC_EDISKLESS = -129
const NC_ECANTEXTEND = -130
const NC_EMPI = -131
const NC4_LAST_ERROR = -131
const DIM_WITHOUT_VARIABLE = "This is a netCDF dimension but not a netCDF variable."
const NC_HAVE_NEW_CHUNKING_API = 1
const NC_EURL = NC_EDAPURL
const NC_ECONSTRAINT = NC_EDAPCONSTRAINT

const NC_ENTOOL = NC_EMAXNAME
const NC_EXDR = -32
const NC_SYSERR = -31
const NC_FATAL = 1

const nc_type = Cint

mutable struct nc_vlen_t
    len::Integer
    p::Ptr{Cvoid}
end

const nclong = Cint


function nc_inq_libvers()
    ccall((:nc_inq_libvers, libnetcdf), Ptr{UInt8}, ())
end

function nc_strerror(ncerr::Integer)
    ccall((:nc_strerror, libnetcdf), Ptr{UInt8}, (Cint,), ncerr)
end

