# Julia wrapper for header: /usr/include/netcdf.h
# Automatically generated using Clang.jl wrap_c, version 0.0.0


function nc_inq_libvers()
    ccall((:nc_inq_libvers, libnetcdf), Cstring, ())
end

function nc_strerror(ncerr::Cint)
    ccall((:nc_strerror, libnetcdf), Cstring, (Cint,), ncerr)
end

function nc__create(path, cmode::Cint, initialsz::Csize_t, chunksizehintp, ncidp)
    ccall((:nc__create, libnetcdf), Cint, (Cstring, Cint, Csize_t, Ptr{Csize_t}, Ptr{Cint}), path, cmode, initialsz, chunksizehintp, ncidp)
end

function nc_create(path, cmode::Cint, ncidp)
    ccall((:nc_create, libnetcdf), Cint, (Cstring, Cint, Ptr{Cint}), path, cmode, ncidp)
end

function nc__open(path, mode::Cint, chunksizehintp, ncidp)
    ccall((:nc__open, libnetcdf), Cint, (Cstring, Cint, Ptr{Csize_t}, Ptr{Cint}), path, mode, chunksizehintp, ncidp)
end

function nc_open(path, mode::Cint, ncidp)
    ccall((:nc_open, libnetcdf), Cint, (Cstring, Cint, Ptr{Cint}), path, mode, ncidp)
end

function nc_inq_path(ncid::Cint, pathlen, path)
    ccall((:nc_inq_path, libnetcdf), Cint, (Cint, Ptr{Csize_t}, Cstring), ncid, pathlen, path)
end

function nc_inq_ncid(ncid::Cint, name, grp_ncid)
    ccall((:nc_inq_ncid, libnetcdf), Cint, (Cint, Cstring, Ptr{Cint}), ncid, name, grp_ncid)
end

function nc_inq_grps(ncid::Cint, numgrps, ncids)
    ccall((:nc_inq_grps, libnetcdf), Cint, (Cint, Ptr{Cint}, Ptr{Cint}), ncid, numgrps, ncids)
end

function nc_inq_grpname(ncid::Cint, name)
    ccall((:nc_inq_grpname, libnetcdf), Cint, (Cint, Cstring), ncid, name)
end

function nc_inq_grpname_full(ncid::Cint, lenp, full_name)
    ccall((:nc_inq_grpname_full, libnetcdf), Cint, (Cint, Ptr{Csize_t}, Cstring), ncid, lenp, full_name)
end

function nc_inq_grpname_len(ncid::Cint, lenp)
    ccall((:nc_inq_grpname_len, libnetcdf), Cint, (Cint, Ptr{Csize_t}), ncid, lenp)
end

function nc_inq_grp_parent(ncid::Cint, parent_ncid)
    ccall((:nc_inq_grp_parent, libnetcdf), Cint, (Cint, Ptr{Cint}), ncid, parent_ncid)
end

function nc_inq_grp_ncid(ncid::Cint, grp_name, grp_ncid)
    ccall((:nc_inq_grp_ncid, libnetcdf), Cint, (Cint, Cstring, Ptr{Cint}), ncid, grp_name, grp_ncid)
end

function nc_inq_grp_full_ncid(ncid::Cint, full_name, grp_ncid)
    ccall((:nc_inq_grp_full_ncid, libnetcdf), Cint, (Cint, Cstring, Ptr{Cint}), ncid, full_name, grp_ncid)
end

function nc_inq_varids(ncid::Cint, nvars, varids)
    ccall((:nc_inq_varids, libnetcdf), Cint, (Cint, Ptr{Cint}, Ptr{Cint}), ncid, nvars, varids)
end

function nc_inq_dimids(ncid::Cint, ndims, dimids, include_parents::Cint)
    ccall((:nc_inq_dimids, libnetcdf), Cint, (Cint, Ptr{Cint}, Ptr{Cint}, Cint), ncid, ndims, dimids, include_parents)
end

function nc_inq_typeids(ncid::Cint, ntypes, typeids)
    ccall((:nc_inq_typeids, libnetcdf), Cint, (Cint, Ptr{Cint}, Ptr{Cint}), ncid, ntypes, typeids)
end

function nc_inq_type_equal(ncid1::Cint, typeid1::nc_type, ncid2::Cint, typeid2::nc_type, equal)
    ccall((:nc_inq_type_equal, libnetcdf), Cint, (Cint, nc_type, Cint, nc_type, Ptr{Cint}), ncid1, typeid1, ncid2, typeid2, equal)
end

function nc_def_grp(parent_ncid::Cint, name, new_ncid)
    ccall((:nc_def_grp, libnetcdf), Cint, (Cint, Cstring, Ptr{Cint}), parent_ncid, name, new_ncid)
end

function nc_rename_grp(grpid::Cint, name)
    ccall((:nc_rename_grp, libnetcdf), Cint, (Cint, Cstring), grpid, name)
end

function nc_def_compound(ncid::Cint, size::Csize_t, name, typeidp)
    ccall((:nc_def_compound, libnetcdf), Cint, (Cint, Csize_t, Cstring, Ptr{nc_type}), ncid, size, name, typeidp)
end

function nc_insert_compound(ncid::Cint, xtype::nc_type, name, offset::Csize_t, field_typeid::nc_type)
    ccall((:nc_insert_compound, libnetcdf), Cint, (Cint, nc_type, Cstring, Csize_t, nc_type), ncid, xtype, name, offset, field_typeid)
end

function nc_insert_array_compound(ncid::Cint, xtype::nc_type, name, offset::Csize_t, field_typeid::nc_type, ndims::Cint, dim_sizes)
    ccall((:nc_insert_array_compound, libnetcdf), Cint, (Cint, nc_type, Cstring, Csize_t, nc_type, Cint, Ptr{Cint}), ncid, xtype, name, offset, field_typeid, ndims, dim_sizes)
end

function nc_inq_type(ncid::Cint, xtype::nc_type, name, size)
    ccall((:nc_inq_type, libnetcdf), Cint, (Cint, nc_type, Cstring, Ptr{Csize_t}), ncid, xtype, name, size)
end

function nc_inq_typeid(ncid::Cint, name, typeidp)
    ccall((:nc_inq_typeid, libnetcdf), Cint, (Cint, Cstring, Ptr{nc_type}), ncid, name, typeidp)
end

function nc_inq_compound(ncid::Cint, xtype::nc_type, name, sizep, nfieldsp)
    ccall((:nc_inq_compound, libnetcdf), Cint, (Cint, nc_type, Cstring, Ptr{Csize_t}, Ptr{Csize_t}), ncid, xtype, name, sizep, nfieldsp)
end

function nc_inq_compound_name(ncid::Cint, xtype::nc_type, name)
    ccall((:nc_inq_compound_name, libnetcdf), Cint, (Cint, nc_type, Cstring), ncid, xtype, name)
end

function nc_inq_compound_size(ncid::Cint, xtype::nc_type, sizep)
    ccall((:nc_inq_compound_size, libnetcdf), Cint, (Cint, nc_type, Ptr{Csize_t}), ncid, xtype, sizep)
end

function nc_inq_compound_nfields(ncid::Cint, xtype::nc_type, nfieldsp)
    ccall((:nc_inq_compound_nfields, libnetcdf), Cint, (Cint, nc_type, Ptr{Csize_t}), ncid, xtype, nfieldsp)
end

function nc_inq_compound_field(ncid::Cint, xtype::nc_type, fieldid::Cint, name, offsetp, field_typeidp, ndimsp, dim_sizesp)
    ccall((:nc_inq_compound_field, libnetcdf), Cint, (Cint, nc_type, Cint, Cstring, Ptr{Csize_t}, Ptr{nc_type}, Ptr{Cint}, Ptr{Cint}), ncid, xtype, fieldid, name, offsetp, field_typeidp, ndimsp, dim_sizesp)
end

function nc_inq_compound_fieldname(ncid::Cint, xtype::nc_type, fieldid::Cint, name)
    ccall((:nc_inq_compound_fieldname, libnetcdf), Cint, (Cint, nc_type, Cint, Cstring), ncid, xtype, fieldid, name)
end

function nc_inq_compound_fieldindex(ncid::Cint, xtype::nc_type, name, fieldidp)
    ccall((:nc_inq_compound_fieldindex, libnetcdf), Cint, (Cint, nc_type, Cstring, Ptr{Cint}), ncid, xtype, name, fieldidp)
end

function nc_inq_compound_fieldoffset(ncid::Cint, xtype::nc_type, fieldid::Cint, offsetp)
    ccall((:nc_inq_compound_fieldoffset, libnetcdf), Cint, (Cint, nc_type, Cint, Ptr{Csize_t}), ncid, xtype, fieldid, offsetp)
end

function nc_inq_compound_fieldtype(ncid::Cint, xtype::nc_type, fieldid::Cint, field_typeidp)
    ccall((:nc_inq_compound_fieldtype, libnetcdf), Cint, (Cint, nc_type, Cint, Ptr{nc_type}), ncid, xtype, fieldid, field_typeidp)
end

function nc_inq_compound_fieldndims(ncid::Cint, xtype::nc_type, fieldid::Cint, ndimsp)
    ccall((:nc_inq_compound_fieldndims, libnetcdf), Cint, (Cint, nc_type, Cint, Ptr{Cint}), ncid, xtype, fieldid, ndimsp)
end

function nc_inq_compound_fielddim_sizes(ncid::Cint, xtype::nc_type, fieldid::Cint, dim_sizes)
    ccall((:nc_inq_compound_fielddim_sizes, libnetcdf), Cint, (Cint, nc_type, Cint, Ptr{Cint}), ncid, xtype, fieldid, dim_sizes)
end

function nc_def_vlen(ncid::Cint, name, base_typeid::nc_type, xtypep)
    ccall((:nc_def_vlen, libnetcdf), Cint, (Cint, Cstring, nc_type, Ptr{nc_type}), ncid, name, base_typeid, xtypep)
end

function nc_inq_vlen(ncid::Cint, xtype::nc_type, name, datum_sizep, base_nc_typep)
    ccall((:nc_inq_vlen, libnetcdf), Cint, (Cint, nc_type, Cstring, Ptr{Csize_t}, Ptr{nc_type}), ncid, xtype, name, datum_sizep, base_nc_typep)
end

function nc_free_vlen(vl)
    ccall((:nc_free_vlen, libnetcdf), Cint, (Ptr{nc_vlen_t},), vl)
end

function nc_free_vlens(len::Csize_t, vlens)
    ccall((:nc_free_vlens, libnetcdf), Cint, (Csize_t, Ptr{nc_vlen_t}), len, vlens)
end

function nc_put_vlen_element(ncid::Cint, typeid1::Cint, vlen_element, len::Csize_t, data)
    ccall((:nc_put_vlen_element, libnetcdf), Cint, (Cint, Cint, Ptr{Void}, Csize_t, Ptr{Void}), ncid, typeid1, vlen_element, len, data)
end

function nc_get_vlen_element(ncid::Cint, typeid1::Cint, vlen_element, len, data)
    ccall((:nc_get_vlen_element, libnetcdf), Cint, (Cint, Cint, Ptr{Void}, Ptr{Csize_t}, Ptr{Void}), ncid, typeid1, vlen_element, len, data)
end

function nc_free_string(len::Csize_t, data)
    ccall((:nc_free_string, libnetcdf), Cint, (Csize_t, Ptr{Cstring}), len, data)
end

function nc_inq_user_type(ncid::Cint, xtype::nc_type, name, size, base_nc_typep, nfieldsp, classp)
    ccall((:nc_inq_user_type, libnetcdf), Cint, (Cint, nc_type, Cstring, Ptr{Csize_t}, Ptr{nc_type}, Ptr{Csize_t}, Ptr{Cint}), ncid, xtype, name, size, base_nc_typep, nfieldsp, classp)
end

function nc_put_att(ncid::Cint, varid::Cint, name, xtype::nc_type, len::Csize_t, op)
    ccall((:nc_put_att, libnetcdf), Cint, (Cint, Cint, Cstring, nc_type, Csize_t, Ptr{Void}), ncid, varid, name, xtype, len, op)
end

function nc_get_att(ncid::Cint, varid::Cint, name, ip)
    ccall((:nc_get_att, libnetcdf), Cint, (Cint, Cint, Cstring, Ptr{Void}), ncid, varid, name, ip)
end

function nc_def_enum(ncid::Cint, base_typeid::nc_type, name, typeidp)
    ccall((:nc_def_enum, libnetcdf), Cint, (Cint, nc_type, Cstring, Ptr{nc_type}), ncid, base_typeid, name, typeidp)
end

function nc_insert_enum(ncid::Cint, xtype::nc_type, name, value)
    ccall((:nc_insert_enum, libnetcdf), Cint, (Cint, nc_type, Cstring, Ptr{Void}), ncid, xtype, name, value)
end

function nc_inq_enum(ncid::Cint, xtype::nc_type, name, base_nc_typep, base_sizep, num_membersp)
    ccall((:nc_inq_enum, libnetcdf), Cint, (Cint, nc_type, Cstring, Ptr{nc_type}, Ptr{Csize_t}, Ptr{Csize_t}), ncid, xtype, name, base_nc_typep, base_sizep, num_membersp)
end

function nc_inq_enum_member(ncid::Cint, xtype::nc_type, idx::Cint, name, value)
    ccall((:nc_inq_enum_member, libnetcdf), Cint, (Cint, nc_type, Cint, Cstring, Ptr{Void}), ncid, xtype, idx, name, value)
end

function nc_inq_enum_ident(ncid::Cint, xtype::nc_type, value::Clonglong, identifier)
    ccall((:nc_inq_enum_ident, libnetcdf), Cint, (Cint, nc_type, Clonglong, Cstring), ncid, xtype, value, identifier)
end

function nc_def_opaque(ncid::Cint, size::Csize_t, name, xtypep)
    ccall((:nc_def_opaque, libnetcdf), Cint, (Cint, Csize_t, Cstring, Ptr{nc_type}), ncid, size, name, xtypep)
end

function nc_inq_opaque(ncid::Cint, xtype::nc_type, name, sizep)
    ccall((:nc_inq_opaque, libnetcdf), Cint, (Cint, nc_type, Cstring, Ptr{Csize_t}), ncid, xtype, name, sizep)
end

function nc_put_var(ncid::Cint, varid::Cint, op)
    ccall((:nc_put_var, libnetcdf), Cint, (Cint, Cint, Ptr{Void}), ncid, varid, op)
end

function nc_get_var(ncid::Cint, varid::Cint, ip)
    ccall((:nc_get_var, libnetcdf), Cint, (Cint, Cint, Ptr{Void}), ncid, varid, ip)
end

function nc_put_var1(ncid::Cint, varid::Cint, indexp, op)
    ccall((:nc_put_var1, libnetcdf), Cint, (Cint, Cint, Ptr{Csize_t}, Ptr{Void}), ncid, varid, indexp, op)
end

function nc_get_var1(ncid::Cint, varid::Cint, indexp, ip)
    ccall((:nc_get_var1, libnetcdf), Cint, (Cint, Cint, Ptr{Csize_t}, Ptr{Void}), ncid, varid, indexp, ip)
end

function nc_put_vara(ncid::Cint, varid::Cint, startp, countp, op)
    ccall((:nc_put_vara, libnetcdf), Cint, (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{Void}), ncid, varid, startp, countp, op)
end

function nc_get_vara(ncid::Cint, varid::Cint, startp, countp, ip)
    ccall((:nc_get_vara, libnetcdf), Cint, (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{Void}), ncid, varid, startp, countp, ip)
end

function nc_put_vars(ncid::Cint, varid::Cint, startp, countp, stridep, op)
    ccall((:nc_put_vars, libnetcdf), Cint, (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{Cptrdiff_t}, Ptr{Void}), ncid, varid, startp, countp, stridep, op)
end

function nc_get_vars(ncid::Cint, varid::Cint, startp, countp, stridep, ip)
    ccall((:nc_get_vars, libnetcdf), Cint, (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{Cptrdiff_t}, Ptr{Void}), ncid, varid, startp, countp, stridep, ip)
end

function nc_put_varm(ncid::Cint, varid::Cint, startp, countp, stridep, imapp, op)
    ccall((:nc_put_varm, libnetcdf), Cint, (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{Cptrdiff_t}, Ptr{Cptrdiff_t}, Ptr{Void}), ncid, varid, startp, countp, stridep, imapp, op)
end

function nc_get_varm(ncid::Cint, varid::Cint, startp, countp, stridep, imapp, ip)
    ccall((:nc_get_varm, libnetcdf), Cint, (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{Cptrdiff_t}, Ptr{Cptrdiff_t}, Ptr{Void}), ncid, varid, startp, countp, stridep, imapp, ip)
end

function nc_def_var_deflate(ncid::Cint, varid::Cint, shuffle::Cint, deflate::Cint, deflate_level::Cint)
    ccall((:nc_def_var_deflate, libnetcdf), Cint, (Cint, Cint, Cint, Cint, Cint), ncid, varid, shuffle, deflate, deflate_level)
end

function nc_inq_var_deflate(ncid::Cint, varid::Cint, shufflep, deflatep, deflate_levelp)
    ccall((:nc_inq_var_deflate, libnetcdf), Cint, (Cint, Cint, Ptr{Cint}, Ptr{Cint}, Ptr{Cint}), ncid, varid, shufflep, deflatep, deflate_levelp)
end

function nc_inq_var_szip(ncid::Cint, varid::Cint, options_maskp, pixels_per_blockp)
    ccall((:nc_inq_var_szip, libnetcdf), Cint, (Cint, Cint, Ptr{Cint}, Ptr{Cint}), ncid, varid, options_maskp, pixels_per_blockp)
end

function nc_def_var_fletcher32(ncid::Cint, varid::Cint, fletcher32::Cint)
    ccall((:nc_def_var_fletcher32, libnetcdf), Cint, (Cint, Cint, Cint), ncid, varid, fletcher32)
end

function nc_inq_var_fletcher32(ncid::Cint, varid::Cint, fletcher32p)
    ccall((:nc_inq_var_fletcher32, libnetcdf), Cint, (Cint, Cint, Ptr{Cint}), ncid, varid, fletcher32p)
end

function nc_def_var_chunking(ncid::Cint, varid::Cint, storage::Cint, chunksizesp)
    ccall((:nc_def_var_chunking, libnetcdf), Cint, (Cint, Cint, Cint, Ptr{Csize_t}), ncid, varid, storage, chunksizesp)
end

function nc_inq_var_chunking(ncid::Cint, varid::Cint, storagep, chunksizesp)
    ccall((:nc_inq_var_chunking, libnetcdf), Cint, (Cint, Cint, Ptr{Cint}, Ptr{Csize_t}), ncid, varid, storagep, chunksizesp)
end

function nc_def_var_fill(ncid::Cint, varid::Cint, no_fill::Cint, fill_value)
    ccall((:nc_def_var_fill, libnetcdf), Cint, (Cint, Cint, Cint, Ptr{Void}), ncid, varid, no_fill, fill_value)
end

function nc_inq_var_fill(ncid::Cint, varid::Cint, no_fill, fill_valuep)
    ccall((:nc_inq_var_fill, libnetcdf), Cint, (Cint, Cint, Ptr{Cint}, Ptr{Void}), ncid, varid, no_fill, fill_valuep)
end

function nc_def_var_endian(ncid::Cint, varid::Cint, endian::Cint)
    ccall((:nc_def_var_endian, libnetcdf), Cint, (Cint, Cint, Cint), ncid, varid, endian)
end

function nc_inq_var_endian(ncid::Cint, varid::Cint, endianp)
    ccall((:nc_inq_var_endian, libnetcdf), Cint, (Cint, Cint, Ptr{Cint}), ncid, varid, endianp)
end

function nc_set_fill(ncid::Cint, fillmode::Cint, old_modep)
    ccall((:nc_set_fill, libnetcdf), Cint, (Cint, Cint, Ptr{Cint}), ncid, fillmode, old_modep)
end

function nc_set_default_format(format::Cint, old_formatp)
    ccall((:nc_set_default_format, libnetcdf), Cint, (Cint, Ptr{Cint}), format, old_formatp)
end

function nc_set_chunk_cache(size::Csize_t, nelems::Csize_t, preemption::Cfloat)
    ccall((:nc_set_chunk_cache, libnetcdf), Cint, (Csize_t, Csize_t, Cfloat), size, nelems, preemption)
end

function nc_get_chunk_cache(sizep, nelemsp, preemptionp)
    ccall((:nc_get_chunk_cache, libnetcdf), Cint, (Ptr{Csize_t}, Ptr{Csize_t}, Ptr{Cfloat}), sizep, nelemsp, preemptionp)
end

function nc_set_var_chunk_cache(ncid::Cint, varid::Cint, size::Csize_t, nelems::Csize_t, preemption::Cfloat)
    ccall((:nc_set_var_chunk_cache, libnetcdf), Cint, (Cint, Cint, Csize_t, Csize_t, Cfloat), ncid, varid, size, nelems, preemption)
end

function nc_get_var_chunk_cache(ncid::Cint, varid::Cint, sizep, nelemsp, preemptionp)
    ccall((:nc_get_var_chunk_cache, libnetcdf), Cint, (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{Cfloat}), ncid, varid, sizep, nelemsp, preemptionp)
end

function nc_redef(ncid::Cint)
    ccall((:nc_redef, libnetcdf), Cint, (Cint,), ncid)
end

function nc__enddef(ncid::Cint, h_minfree::Csize_t, v_align::Csize_t, v_minfree::Csize_t, r_align::Csize_t)
    ccall((:nc__enddef, libnetcdf), Cint, (Cint, Csize_t, Csize_t, Csize_t, Csize_t), ncid, h_minfree, v_align, v_minfree, r_align)
end

function nc_enddef(ncid::Cint)
    ccall((:nc_enddef, libnetcdf), Cint, (Cint,), ncid)
end

function nc_sync(ncid::Cint)
    ccall((:nc_sync, libnetcdf), Cint, (Cint,), ncid)
end

function nc_abort(ncid::Cint)
    ccall((:nc_abort, libnetcdf), Cint, (Cint,), ncid)
end

function nc_close(ncid::Cint)
    ccall((:nc_close, libnetcdf), Cint, (Cint,), ncid)
end

function nc_inq(ncid::Cint, ndimsp, nvarsp, nattsp, unlimdimidp)
    ccall((:nc_inq, libnetcdf), Cint, (Cint, Ptr{Cint}, Ptr{Cint}, Ptr{Cint}, Ptr{Cint}), ncid, ndimsp, nvarsp, nattsp, unlimdimidp)
end

function nc_inq_ndims(ncid::Cint, ndimsp)
    ccall((:nc_inq_ndims, libnetcdf), Cint, (Cint, Ptr{Cint}), ncid, ndimsp)
end

function nc_inq_nvars(ncid::Cint, nvarsp)
    ccall((:nc_inq_nvars, libnetcdf), Cint, (Cint, Ptr{Cint}), ncid, nvarsp)
end

function nc_inq_natts(ncid::Cint, nattsp)
    ccall((:nc_inq_natts, libnetcdf), Cint, (Cint, Ptr{Cint}), ncid, nattsp)
end

function nc_inq_unlimdim(ncid::Cint, unlimdimidp)
    ccall((:nc_inq_unlimdim, libnetcdf), Cint, (Cint, Ptr{Cint}), ncid, unlimdimidp)
end

function nc_inq_unlimdims(ncid::Cint, nunlimdimsp, unlimdimidsp)
    ccall((:nc_inq_unlimdims, libnetcdf), Cint, (Cint, Ptr{Cint}, Ptr{Cint}), ncid, nunlimdimsp, unlimdimidsp)
end

function nc_inq_format(ncid::Cint, formatp)
    ccall((:nc_inq_format, libnetcdf), Cint, (Cint, Ptr{Cint}), ncid, formatp)
end

function nc_inq_format_extended(ncid::Cint, formatp, modep)
    ccall((:nc_inq_format_extended, libnetcdf), Cint, (Cint, Ptr{Cint}, Ptr{Cint}), ncid, formatp, modep)
end

function nc_def_dim(ncid::Cint, name, len::Csize_t, idp)
    ccall((:nc_def_dim, libnetcdf), Cint, (Cint, Cstring, Csize_t, Ptr{Cint}), ncid, name, len, idp)
end

function nc_inq_dimid(ncid::Cint, name, idp)
    ccall((:nc_inq_dimid, libnetcdf), Cint, (Cint, Cstring, Ptr{Cint}), ncid, name, idp)
end

function nc_inq_dim(ncid::Cint, dimid::Cint, name, lenp)
    ccall((:nc_inq_dim, libnetcdf), Cint, (Cint, Cint, Cstring, Ptr{Csize_t}), ncid, dimid, name, lenp)
end

function nc_inq_dimname(ncid::Cint, dimid::Cint, name)
    ccall((:nc_inq_dimname, libnetcdf), Cint, (Cint, Cint, Cstring), ncid, dimid, name)
end

function nc_inq_dimlen(ncid::Cint, dimid::Cint, lenp)
    ccall((:nc_inq_dimlen, libnetcdf), Cint, (Cint, Cint, Ptr{Csize_t}), ncid, dimid, lenp)
end

function nc_rename_dim(ncid::Cint, dimid::Cint, name)
    ccall((:nc_rename_dim, libnetcdf), Cint, (Cint, Cint, Cstring), ncid, dimid, name)
end

function nc_inq_att(ncid::Cint, varid::Cint, name, xtypep, lenp)
    ccall((:nc_inq_att, libnetcdf), Cint, (Cint, Cint, Cstring, Ptr{nc_type}, Ptr{Csize_t}), ncid, varid, name, xtypep, lenp)
end

function nc_inq_attid(ncid::Cint, varid::Cint, name, idp)
    ccall((:nc_inq_attid, libnetcdf), Cint, (Cint, Cint, Cstring, Ptr{Cint}), ncid, varid, name, idp)
end

function nc_inq_atttype(ncid::Cint, varid::Cint, name, xtypep)
    ccall((:nc_inq_atttype, libnetcdf), Cint, (Cint, Cint, Cstring, Ptr{nc_type}), ncid, varid, name, xtypep)
end

function nc_inq_attlen(ncid::Cint, varid::Cint, name, lenp)
    ccall((:nc_inq_attlen, libnetcdf), Cint, (Cint, Cint, Cstring, Ptr{Csize_t}), ncid, varid, name, lenp)
end

function nc_inq_attname(ncid::Cint, varid::Cint, attnum::Cint, name)
    ccall((:nc_inq_attname, libnetcdf), Cint, (Cint, Cint, Cint, Cstring), ncid, varid, attnum, name)
end

function nc_copy_att(ncid_in::Cint, varid_in::Cint, name, ncid_out::Cint, varid_out::Cint)
    ccall((:nc_copy_att, libnetcdf), Cint, (Cint, Cint, Cstring, Cint, Cint), ncid_in, varid_in, name, ncid_out, varid_out)
end

function nc_rename_att(ncid::Cint, varid::Cint, name, newname)
    ccall((:nc_rename_att, libnetcdf), Cint, (Cint, Cint, Cstring, Cstring), ncid, varid, name, newname)
end

function nc_del_att(ncid::Cint, varid::Cint, name)
    ccall((:nc_del_att, libnetcdf), Cint, (Cint, Cint, Cstring), ncid, varid, name)
end

function nc_put_att_text(ncid::Cint, varid::Cint, name, len::Csize_t, op)
    ccall((:nc_put_att_text, libnetcdf), Cint, (Cint, Cint, Cstring, Csize_t, Cstring), ncid, varid, name, len, op)
end

function nc_get_att_text(ncid::Cint, varid::Cint, name, ip)
    ccall((:nc_get_att_text, libnetcdf), Cint, (Cint, Cint, Cstring, Cstring), ncid, varid, name, ip)
end

function nc_put_att_string(ncid::Cint, varid::Cint, name, len::Csize_t, op)
    ccall((:nc_put_att_string, libnetcdf), Cint, (Cint, Cint, Cstring, Csize_t, Ptr{Cstring}), ncid, varid, name, len, op)
end

function nc_get_att_string(ncid::Cint, varid::Cint, name, ip)
    ccall((:nc_get_att_string, libnetcdf), Cint, (Cint, Cint, Cstring, Ptr{Cstring}), ncid, varid, name, ip)
end

function nc_put_att_uchar(ncid::Cint, varid::Cint, name, xtype::nc_type, len::Csize_t, op)
    ccall((:nc_put_att_uchar, libnetcdf), Cint, (Cint, Cint, Cstring, nc_type, Csize_t, Ptr{Cuchar}), ncid, varid, name, xtype, len, op)
end

function nc_get_att_uchar(ncid::Cint, varid::Cint, name, ip)
    ccall((:nc_get_att_uchar, libnetcdf), Cint, (Cint, Cint, Cstring, Ptr{Cuchar}), ncid, varid, name, ip)
end

function nc_put_att_schar(ncid::Cint, varid::Cint, name, xtype::nc_type, len::Csize_t, op)
    ccall((:nc_put_att_schar, libnetcdf), Cint, (Cint, Cint, Cstring, nc_type, Csize_t, Ptr{UInt8}), ncid, varid, name, xtype, len, op)
end

function nc_get_att_schar(ncid::Cint, varid::Cint, name, ip)
    ccall((:nc_get_att_schar, libnetcdf), Cint, (Cint, Cint, Cstring, Ptr{UInt8}), ncid, varid, name, ip)
end

function nc_put_att_short(ncid::Cint, varid::Cint, name, xtype::nc_type, len::Csize_t, op)
    ccall((:nc_put_att_short, libnetcdf), Cint, (Cint, Cint, Cstring, nc_type, Csize_t, Ptr{Int16}), ncid, varid, name, xtype, len, op)
end

function nc_get_att_short(ncid::Cint, varid::Cint, name, ip)
    ccall((:nc_get_att_short, libnetcdf), Cint, (Cint, Cint, Cstring, Ptr{Int16}), ncid, varid, name, ip)
end

function nc_put_att_int(ncid::Cint, varid::Cint, name, xtype::nc_type, len::Csize_t, op)
    ccall((:nc_put_att_int, libnetcdf), Cint, (Cint, Cint, Cstring, nc_type, Csize_t, Ptr{Cint}), ncid, varid, name, xtype, len, op)
end

function nc_get_att_int(ncid::Cint, varid::Cint, name, ip)
    ccall((:nc_get_att_int, libnetcdf), Cint, (Cint, Cint, Cstring, Ptr{Cint}), ncid, varid, name, ip)
end

function nc_put_att_long(ncid::Cint, varid::Cint, name, xtype::nc_type, len::Csize_t, op)
    ccall((:nc_put_att_long, libnetcdf), Cint, (Cint, Cint, Cstring, nc_type, Csize_t, Ptr{Clong}), ncid, varid, name, xtype, len, op)
end

function nc_get_att_long(ncid::Cint, varid::Cint, name, ip)
    ccall((:nc_get_att_long, libnetcdf), Cint, (Cint, Cint, Cstring, Ptr{Clong}), ncid, varid, name, ip)
end

function nc_put_att_float(ncid::Cint, varid::Cint, name, xtype::nc_type, len::Csize_t, op)
    ccall((:nc_put_att_float, libnetcdf), Cint, (Cint, Cint, Cstring, nc_type, Csize_t, Ptr{Cfloat}), ncid, varid, name, xtype, len, op)
end

function nc_get_att_float(ncid::Cint, varid::Cint, name, ip)
    ccall((:nc_get_att_float, libnetcdf), Cint, (Cint, Cint, Cstring, Ptr{Cfloat}), ncid, varid, name, ip)
end

function nc_put_att_double(ncid::Cint, varid::Cint, name, xtype::nc_type, len::Csize_t, op)
    ccall((:nc_put_att_double, libnetcdf), Cint, (Cint, Cint, Cstring, nc_type, Csize_t, Ptr{Cdouble}), ncid, varid, name, xtype, len, op)
end

function nc_get_att_double(ncid::Cint, varid::Cint, name, ip)
    ccall((:nc_get_att_double, libnetcdf), Cint, (Cint, Cint, Cstring, Ptr{Cdouble}), ncid, varid, name, ip)
end

function nc_put_att_ushort(ncid::Cint, varid::Cint, name, xtype::nc_type, len::Csize_t, op)
    ccall((:nc_put_att_ushort, libnetcdf), Cint, (Cint, Cint, Cstring, nc_type, Csize_t, Ptr{UInt16}), ncid, varid, name, xtype, len, op)
end

function nc_get_att_ushort(ncid::Cint, varid::Cint, name, ip)
    ccall((:nc_get_att_ushort, libnetcdf), Cint, (Cint, Cint, Cstring, Ptr{UInt16}), ncid, varid, name, ip)
end

function nc_put_att_uint(ncid::Cint, varid::Cint, name, xtype::nc_type, len::Csize_t, op)
    ccall((:nc_put_att_uint, libnetcdf), Cint, (Cint, Cint, Cstring, nc_type, Csize_t, Ptr{UInt32}), ncid, varid, name, xtype, len, op)
end

function nc_get_att_uint(ncid::Cint, varid::Cint, name, ip)
    ccall((:nc_get_att_uint, libnetcdf), Cint, (Cint, Cint, Cstring, Ptr{UInt32}), ncid, varid, name, ip)
end

function nc_put_att_longlong(ncid::Cint, varid::Cint, name, xtype::nc_type, len::Csize_t, op)
    ccall((:nc_put_att_longlong, libnetcdf), Cint, (Cint, Cint, Cstring, nc_type, Csize_t, Ptr{Clonglong}), ncid, varid, name, xtype, len, op)
end

function nc_get_att_longlong(ncid::Cint, varid::Cint, name, ip)
    ccall((:nc_get_att_longlong, libnetcdf), Cint, (Cint, Cint, Cstring, Ptr{Clonglong}), ncid, varid, name, ip)
end

function nc_put_att_ulonglong(ncid::Cint, varid::Cint, name, xtype::nc_type, len::Csize_t, op)
    ccall((:nc_put_att_ulonglong, libnetcdf), Cint, (Cint, Cint, Cstring, nc_type, Csize_t, Ptr{Culonglong}), ncid, varid, name, xtype, len, op)
end

function nc_get_att_ulonglong(ncid::Cint, varid::Cint, name, ip)
    ccall((:nc_get_att_ulonglong, libnetcdf), Cint, (Cint, Cint, Cstring, Ptr{Culonglong}), ncid, varid, name, ip)
end

function nc_def_var(ncid::Cint, name, xtype::nc_type, ndims::Cint, dimidsp, varidp)
    ccall((:nc_def_var, libnetcdf), Cint, (Cint, Cstring, nc_type, Cint, Ptr{Cint}, Ptr{Cint}), ncid, name, xtype, ndims, dimidsp, varidp)
end

function nc_inq_var(ncid::Cint, varid::Cint, name, xtypep, ndimsp, dimidsp, nattsp)
    ccall((:nc_inq_var, libnetcdf), Cint, (Cint, Cint, Cstring, Ptr{nc_type}, Ptr{Cint}, Ptr{Cint}, Ptr{Cint}), ncid, varid, name, xtypep, ndimsp, dimidsp, nattsp)
end

function nc_inq_varid(ncid::Cint, name, varidp)
    ccall((:nc_inq_varid, libnetcdf), Cint, (Cint, Cstring, Ptr{Cint}), ncid, name, varidp)
end

function nc_inq_varname(ncid::Cint, varid::Cint, name)
    ccall((:nc_inq_varname, libnetcdf), Cint, (Cint, Cint, Cstring), ncid, varid, name)
end

function nc_inq_vartype(ncid::Cint, varid::Cint, xtypep)
    ccall((:nc_inq_vartype, libnetcdf), Cint, (Cint, Cint, Ptr{nc_type}), ncid, varid, xtypep)
end

function nc_inq_varndims(ncid::Cint, varid::Cint, ndimsp)
    ccall((:nc_inq_varndims, libnetcdf), Cint, (Cint, Cint, Ptr{Cint}), ncid, varid, ndimsp)
end

function nc_inq_vardimid(ncid::Cint, varid::Cint, dimidsp)
    ccall((:nc_inq_vardimid, libnetcdf), Cint, (Cint, Cint, Ptr{Cint}), ncid, varid, dimidsp)
end

function nc_inq_varnatts(ncid::Cint, varid::Cint, nattsp)
    ccall((:nc_inq_varnatts, libnetcdf), Cint, (Cint, Cint, Ptr{Cint}), ncid, varid, nattsp)
end

function nc_rename_var(ncid::Cint, varid::Cint, name)
    ccall((:nc_rename_var, libnetcdf), Cint, (Cint, Cint, Cstring), ncid, varid, name)
end

function nc_copy_var(ncid_in::Cint, varid::Cint, ncid_out::Cint)
    ccall((:nc_copy_var, libnetcdf), Cint, (Cint, Cint, Cint), ncid_in, varid, ncid_out)
end

function nc_put_var1_text(ncid::Cint, varid::Cint, indexp, op)
    ccall((:nc_put_var1_text, libnetcdf), Cint, (Cint, Cint, Ptr{Csize_t}, Cstring), ncid, varid, indexp, op)
end

function nc_get_var1_text(ncid::Cint, varid::Cint, indexp, ip)
    ccall((:nc_get_var1_text, libnetcdf), Cint, (Cint, Cint, Ptr{Csize_t}, Cstring), ncid, varid, indexp, ip)
end

function nc_put_var1_uchar(ncid::Cint, varid::Cint, indexp, op)
    ccall((:nc_put_var1_uchar, libnetcdf), Cint, (Cint, Cint, Ptr{Csize_t}, Ptr{Cuchar}), ncid, varid, indexp, op)
end

function nc_get_var1_uchar(ncid::Cint, varid::Cint, indexp, ip)
    ccall((:nc_get_var1_uchar, libnetcdf), Cint, (Cint, Cint, Ptr{Csize_t}, Ptr{Cuchar}), ncid, varid, indexp, ip)
end

function nc_put_var1_schar(ncid::Cint, varid::Cint, indexp, op)
    ccall((:nc_put_var1_schar, libnetcdf), Cint, (Cint, Cint, Ptr{Csize_t}, Ptr{UInt8}), ncid, varid, indexp, op)
end

function nc_get_var1_schar(ncid::Cint, varid::Cint, indexp, ip)
    ccall((:nc_get_var1_schar, libnetcdf), Cint, (Cint, Cint, Ptr{Csize_t}, Ptr{UInt8}), ncid, varid, indexp, ip)
end

function nc_put_var1_short(ncid::Cint, varid::Cint, indexp, op)
    ccall((:nc_put_var1_short, libnetcdf), Cint, (Cint, Cint, Ptr{Csize_t}, Ptr{Int16}), ncid, varid, indexp, op)
end

function nc_get_var1_short(ncid::Cint, varid::Cint, indexp, ip)
    ccall((:nc_get_var1_short, libnetcdf), Cint, (Cint, Cint, Ptr{Csize_t}, Ptr{Int16}), ncid, varid, indexp, ip)
end

function nc_put_var1_int(ncid::Cint, varid::Cint, indexp, op)
    ccall((:nc_put_var1_int, libnetcdf), Cint, (Cint, Cint, Ptr{Csize_t}, Ptr{Cint}), ncid, varid, indexp, op)
end

function nc_get_var1_int(ncid::Cint, varid::Cint, indexp, ip)
    ccall((:nc_get_var1_int, libnetcdf), Cint, (Cint, Cint, Ptr{Csize_t}, Ptr{Cint}), ncid, varid, indexp, ip)
end

function nc_put_var1_long(ncid::Cint, varid::Cint, indexp, op)
    ccall((:nc_put_var1_long, libnetcdf), Cint, (Cint, Cint, Ptr{Csize_t}, Ptr{Clong}), ncid, varid, indexp, op)
end

function nc_get_var1_long(ncid::Cint, varid::Cint, indexp, ip)
    ccall((:nc_get_var1_long, libnetcdf), Cint, (Cint, Cint, Ptr{Csize_t}, Ptr{Clong}), ncid, varid, indexp, ip)
end

function nc_put_var1_float(ncid::Cint, varid::Cint, indexp, op)
    ccall((:nc_put_var1_float, libnetcdf), Cint, (Cint, Cint, Ptr{Csize_t}, Ptr{Cfloat}), ncid, varid, indexp, op)
end

function nc_get_var1_float(ncid::Cint, varid::Cint, indexp, ip)
    ccall((:nc_get_var1_float, libnetcdf), Cint, (Cint, Cint, Ptr{Csize_t}, Ptr{Cfloat}), ncid, varid, indexp, ip)
end

function nc_put_var1_double(ncid::Cint, varid::Cint, indexp, op)
    ccall((:nc_put_var1_double, libnetcdf), Cint, (Cint, Cint, Ptr{Csize_t}, Ptr{Cdouble}), ncid, varid, indexp, op)
end

function nc_get_var1_double(ncid::Cint, varid::Cint, indexp, ip)
    ccall((:nc_get_var1_double, libnetcdf), Cint, (Cint, Cint, Ptr{Csize_t}, Ptr{Cdouble}), ncid, varid, indexp, ip)
end

function nc_put_var1_ushort(ncid::Cint, varid::Cint, indexp, op)
    ccall((:nc_put_var1_ushort, libnetcdf), Cint, (Cint, Cint, Ptr{Csize_t}, Ptr{UInt16}), ncid, varid, indexp, op)
end

function nc_get_var1_ushort(ncid::Cint, varid::Cint, indexp, ip)
    ccall((:nc_get_var1_ushort, libnetcdf), Cint, (Cint, Cint, Ptr{Csize_t}, Ptr{UInt16}), ncid, varid, indexp, ip)
end

function nc_put_var1_uint(ncid::Cint, varid::Cint, indexp, op)
    ccall((:nc_put_var1_uint, libnetcdf), Cint, (Cint, Cint, Ptr{Csize_t}, Ptr{UInt32}), ncid, varid, indexp, op)
end

function nc_get_var1_uint(ncid::Cint, varid::Cint, indexp, ip)
    ccall((:nc_get_var1_uint, libnetcdf), Cint, (Cint, Cint, Ptr{Csize_t}, Ptr{UInt32}), ncid, varid, indexp, ip)
end

function nc_put_var1_longlong(ncid::Cint, varid::Cint, indexp, op)
    ccall((:nc_put_var1_longlong, libnetcdf), Cint, (Cint, Cint, Ptr{Csize_t}, Ptr{Clonglong}), ncid, varid, indexp, op)
end

function nc_get_var1_longlong(ncid::Cint, varid::Cint, indexp, ip)
    ccall((:nc_get_var1_longlong, libnetcdf), Cint, (Cint, Cint, Ptr{Csize_t}, Ptr{Clonglong}), ncid, varid, indexp, ip)
end

function nc_put_var1_ulonglong(ncid::Cint, varid::Cint, indexp, op)
    ccall((:nc_put_var1_ulonglong, libnetcdf), Cint, (Cint, Cint, Ptr{Csize_t}, Ptr{Culonglong}), ncid, varid, indexp, op)
end

function nc_get_var1_ulonglong(ncid::Cint, varid::Cint, indexp, ip)
    ccall((:nc_get_var1_ulonglong, libnetcdf), Cint, (Cint, Cint, Ptr{Csize_t}, Ptr{Culonglong}), ncid, varid, indexp, ip)
end

function nc_put_var1_string(ncid::Cint, varid::Cint, indexp, op)
    ccall((:nc_put_var1_string, libnetcdf), Cint, (Cint, Cint, Ptr{Csize_t}, Ptr{Cstring}), ncid, varid, indexp, op)
end

function nc_get_var1_string(ncid::Cint, varid::Cint, indexp, ip)
    ccall((:nc_get_var1_string, libnetcdf), Cint, (Cint, Cint, Ptr{Csize_t}, Ptr{Cstring}), ncid, varid, indexp, ip)
end

function nc_put_vara_text(ncid::Cint, varid::Cint, startp, countp, op)
    ccall((:nc_put_vara_text, libnetcdf), Cint, (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Cstring), ncid, varid, startp, countp, op)
end

function nc_get_vara_text(ncid::Cint, varid::Cint, startp, countp, ip)
    ccall((:nc_get_vara_text, libnetcdf), Cint, (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Cstring), ncid, varid, startp, countp, ip)
end

function nc_put_vara_uchar(ncid::Cint, varid::Cint, startp, countp, op)
    ccall((:nc_put_vara_uchar, libnetcdf), Cint, (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{Cuchar}), ncid, varid, startp, countp, op)
end

function nc_get_vara_uchar(ncid::Cint, varid::Cint, startp, countp, ip)
    ccall((:nc_get_vara_uchar, libnetcdf), Cint, (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{Cuchar}), ncid, varid, startp, countp, ip)
end

function nc_put_vara_schar(ncid::Cint, varid::Cint, startp, countp, op)
    ccall((:nc_put_vara_schar, libnetcdf), Cint, (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{UInt8}), ncid, varid, startp, countp, op)
end

function nc_get_vara_schar(ncid::Cint, varid::Cint, startp, countp, ip)
    ccall((:nc_get_vara_schar, libnetcdf), Cint, (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{UInt8}), ncid, varid, startp, countp, ip)
end

function nc_put_vara_short(ncid::Cint, varid::Cint, startp, countp, op)
    ccall((:nc_put_vara_short, libnetcdf), Cint, (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{Int16}), ncid, varid, startp, countp, op)
end

function nc_get_vara_short(ncid::Cint, varid::Cint, startp, countp, ip)
    ccall((:nc_get_vara_short, libnetcdf), Cint, (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{Int16}), ncid, varid, startp, countp, ip)
end

function nc_put_vara_int(ncid::Cint, varid::Cint, startp, countp, op)
    ccall((:nc_put_vara_int, libnetcdf), Cint, (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{Cint}), ncid, varid, startp, countp, op)
end

function nc_get_vara_int(ncid::Cint, varid::Cint, startp, countp, ip)
    ccall((:nc_get_vara_int, libnetcdf), Cint, (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{Cint}), ncid, varid, startp, countp, ip)
end

function nc_put_vara_long(ncid::Cint, varid::Cint, startp, countp, op)
    ccall((:nc_put_vara_long, libnetcdf), Cint, (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{Clong}), ncid, varid, startp, countp, op)
end

function nc_get_vara_long(ncid::Cint, varid::Cint, startp, countp, ip)
    ccall((:nc_get_vara_long, libnetcdf), Cint, (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{Clong}), ncid, varid, startp, countp, ip)
end

function nc_put_vara_float(ncid::Cint, varid::Cint, startp, countp, op)
    ccall((:nc_put_vara_float, libnetcdf), Cint, (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{Cfloat}), ncid, varid, startp, countp, op)
end

function nc_get_vara_float(ncid::Cint, varid::Cint, startp, countp, ip)
    ccall((:nc_get_vara_float, libnetcdf), Cint, (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{Cfloat}), ncid, varid, startp, countp, ip)
end

function nc_put_vara_double(ncid::Cint, varid::Cint, startp, countp, op)
    ccall((:nc_put_vara_double, libnetcdf), Cint, (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{Cdouble}), ncid, varid, startp, countp, op)
end

function nc_get_vara_double(ncid::Cint, varid::Cint, startp, countp, ip)
    ccall((:nc_get_vara_double, libnetcdf), Cint, (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{Cdouble}), ncid, varid, startp, countp, ip)
end

function nc_put_vara_ushort(ncid::Cint, varid::Cint, startp, countp, op)
    ccall((:nc_put_vara_ushort, libnetcdf), Cint, (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{UInt16}), ncid, varid, startp, countp, op)
end

function nc_get_vara_ushort(ncid::Cint, varid::Cint, startp, countp, ip)
    ccall((:nc_get_vara_ushort, libnetcdf), Cint, (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{UInt16}), ncid, varid, startp, countp, ip)
end

function nc_put_vara_uint(ncid::Cint, varid::Cint, startp, countp, op)
    ccall((:nc_put_vara_uint, libnetcdf), Cint, (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{UInt32}), ncid, varid, startp, countp, op)
end

function nc_get_vara_uint(ncid::Cint, varid::Cint, startp, countp, ip)
    ccall((:nc_get_vara_uint, libnetcdf), Cint, (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{UInt32}), ncid, varid, startp, countp, ip)
end

function nc_put_vara_longlong(ncid::Cint, varid::Cint, startp, countp, op)
    ccall((:nc_put_vara_longlong, libnetcdf), Cint, (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{Clonglong}), ncid, varid, startp, countp, op)
end

function nc_get_vara_longlong(ncid::Cint, varid::Cint, startp, countp, ip)
    ccall((:nc_get_vara_longlong, libnetcdf), Cint, (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{Clonglong}), ncid, varid, startp, countp, ip)
end

function nc_put_vara_ulonglong(ncid::Cint, varid::Cint, startp, countp, op)
    ccall((:nc_put_vara_ulonglong, libnetcdf), Cint, (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{Culonglong}), ncid, varid, startp, countp, op)
end

function nc_get_vara_ulonglong(ncid::Cint, varid::Cint, startp, countp, ip)
    ccall((:nc_get_vara_ulonglong, libnetcdf), Cint, (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{Culonglong}), ncid, varid, startp, countp, ip)
end

function nc_put_vara_string(ncid::Cint, varid::Cint, startp, countp, op)
    ccall((:nc_put_vara_string, libnetcdf), Cint, (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{Cstring}), ncid, varid, startp, countp, op)
end

function nc_get_vara_string(ncid::Cint, varid::Cint, startp, countp, ip)
    ccall((:nc_get_vara_string, libnetcdf), Cint, (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{Cstring}), ncid, varid, startp, countp, ip)
end

function nc_put_vars_text(ncid::Cint, varid::Cint, startp, countp, stridep, op)
    ccall((:nc_put_vars_text, libnetcdf), Cint, (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{Cptrdiff_t}, Cstring), ncid, varid, startp, countp, stridep, op)
end

function nc_get_vars_text(ncid::Cint, varid::Cint, startp, countp, stridep, ip)
    ccall((:nc_get_vars_text, libnetcdf), Cint, (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{Cptrdiff_t}, Cstring), ncid, varid, startp, countp, stridep, ip)
end

function nc_put_vars_uchar(ncid::Cint, varid::Cint, startp, countp, stridep, op)
    ccall((:nc_put_vars_uchar, libnetcdf), Cint, (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{Cptrdiff_t}, Ptr{Cuchar}), ncid, varid, startp, countp, stridep, op)
end

function nc_get_vars_uchar(ncid::Cint, varid::Cint, startp, countp, stridep, ip)
    ccall((:nc_get_vars_uchar, libnetcdf), Cint, (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{Cptrdiff_t}, Ptr{Cuchar}), ncid, varid, startp, countp, stridep, ip)
end

function nc_put_vars_schar(ncid::Cint, varid::Cint, startp, countp, stridep, op)
    ccall((:nc_put_vars_schar, libnetcdf), Cint, (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{Cptrdiff_t}, Ptr{UInt8}), ncid, varid, startp, countp, stridep, op)
end

function nc_get_vars_schar(ncid::Cint, varid::Cint, startp, countp, stridep, ip)
    ccall((:nc_get_vars_schar, libnetcdf), Cint, (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{Cptrdiff_t}, Ptr{UInt8}), ncid, varid, startp, countp, stridep, ip)
end

function nc_put_vars_short(ncid::Cint, varid::Cint, startp, countp, stridep, op)
    ccall((:nc_put_vars_short, libnetcdf), Cint, (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{Cptrdiff_t}, Ptr{Int16}), ncid, varid, startp, countp, stridep, op)
end

function nc_get_vars_short(ncid::Cint, varid::Cint, startp, countp, stridep, ip)
    ccall((:nc_get_vars_short, libnetcdf), Cint, (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{Cptrdiff_t}, Ptr{Int16}), ncid, varid, startp, countp, stridep, ip)
end

function nc_put_vars_int(ncid::Cint, varid::Cint, startp, countp, stridep, op)
    ccall((:nc_put_vars_int, libnetcdf), Cint, (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{Cptrdiff_t}, Ptr{Cint}), ncid, varid, startp, countp, stridep, op)
end

function nc_get_vars_int(ncid::Cint, varid::Cint, startp, countp, stridep, ip)
    ccall((:nc_get_vars_int, libnetcdf), Cint, (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{Cptrdiff_t}, Ptr{Cint}), ncid, varid, startp, countp, stridep, ip)
end

function nc_put_vars_long(ncid::Cint, varid::Cint, startp, countp, stridep, op)
    ccall((:nc_put_vars_long, libnetcdf), Cint, (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{Cptrdiff_t}, Ptr{Clong}), ncid, varid, startp, countp, stridep, op)
end

function nc_get_vars_long(ncid::Cint, varid::Cint, startp, countp, stridep, ip)
    ccall((:nc_get_vars_long, libnetcdf), Cint, (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{Cptrdiff_t}, Ptr{Clong}), ncid, varid, startp, countp, stridep, ip)
end

function nc_put_vars_float(ncid::Cint, varid::Cint, startp, countp, stridep, op)
    ccall((:nc_put_vars_float, libnetcdf), Cint, (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{Cptrdiff_t}, Ptr{Cfloat}), ncid, varid, startp, countp, stridep, op)
end

function nc_get_vars_float(ncid::Cint, varid::Cint, startp, countp, stridep, ip)
    ccall((:nc_get_vars_float, libnetcdf), Cint, (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{Cptrdiff_t}, Ptr{Cfloat}), ncid, varid, startp, countp, stridep, ip)
end

function nc_put_vars_double(ncid::Cint, varid::Cint, startp, countp, stridep, op)
    ccall((:nc_put_vars_double, libnetcdf), Cint, (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{Cptrdiff_t}, Ptr{Cdouble}), ncid, varid, startp, countp, stridep, op)
end

function nc_get_vars_double(ncid::Cint, varid::Cint, startp, countp, stridep, ip)
    ccall((:nc_get_vars_double, libnetcdf), Cint, (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{Cptrdiff_t}, Ptr{Cdouble}), ncid, varid, startp, countp, stridep, ip)
end

function nc_put_vars_ushort(ncid::Cint, varid::Cint, startp, countp, stridep, op)
    ccall((:nc_put_vars_ushort, libnetcdf), Cint, (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{Cptrdiff_t}, Ptr{UInt16}), ncid, varid, startp, countp, stridep, op)
end

function nc_get_vars_ushort(ncid::Cint, varid::Cint, startp, countp, stridep, ip)
    ccall((:nc_get_vars_ushort, libnetcdf), Cint, (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{Cptrdiff_t}, Ptr{UInt16}), ncid, varid, startp, countp, stridep, ip)
end

function nc_put_vars_uint(ncid::Cint, varid::Cint, startp, countp, stridep, op)
    ccall((:nc_put_vars_uint, libnetcdf), Cint, (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{Cptrdiff_t}, Ptr{UInt32}), ncid, varid, startp, countp, stridep, op)
end

function nc_get_vars_uint(ncid::Cint, varid::Cint, startp, countp, stridep, ip)
    ccall((:nc_get_vars_uint, libnetcdf), Cint, (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{Cptrdiff_t}, Ptr{UInt32}), ncid, varid, startp, countp, stridep, ip)
end

function nc_put_vars_longlong(ncid::Cint, varid::Cint, startp, countp, stridep, op)
    ccall((:nc_put_vars_longlong, libnetcdf), Cint, (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{Cptrdiff_t}, Ptr{Clonglong}), ncid, varid, startp, countp, stridep, op)
end

function nc_get_vars_longlong(ncid::Cint, varid::Cint, startp, countp, stridep, ip)
    ccall((:nc_get_vars_longlong, libnetcdf), Cint, (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{Cptrdiff_t}, Ptr{Clonglong}), ncid, varid, startp, countp, stridep, ip)
end

function nc_put_vars_ulonglong(ncid::Cint, varid::Cint, startp, countp, stridep, op)
    ccall((:nc_put_vars_ulonglong, libnetcdf), Cint, (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{Cptrdiff_t}, Ptr{Culonglong}), ncid, varid, startp, countp, stridep, op)
end

function nc_get_vars_ulonglong(ncid::Cint, varid::Cint, startp, countp, stridep, ip)
    ccall((:nc_get_vars_ulonglong, libnetcdf), Cint, (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{Cptrdiff_t}, Ptr{Culonglong}), ncid, varid, startp, countp, stridep, ip)
end

function nc_put_vars_string(ncid::Cint, varid::Cint, startp, countp, stridep, op)
    ccall((:nc_put_vars_string, libnetcdf), Cint, (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{Cptrdiff_t}, Ptr{Cstring}), ncid, varid, startp, countp, stridep, op)
end

function nc_get_vars_string(ncid::Cint, varid::Cint, startp, countp, stridep, ip)
    ccall((:nc_get_vars_string, libnetcdf), Cint, (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{Cptrdiff_t}, Ptr{Cstring}), ncid, varid, startp, countp, stridep, ip)
end

function nc_put_varm_text(ncid::Cint, varid::Cint, startp, countp, stridep, imapp, op)
    ccall((:nc_put_varm_text, libnetcdf), Cint, (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{Cptrdiff_t}, Ptr{Cptrdiff_t}, Cstring), ncid, varid, startp, countp, stridep, imapp, op)
end

function nc_get_varm_text(ncid::Cint, varid::Cint, startp, countp, stridep, imapp, ip)
    ccall((:nc_get_varm_text, libnetcdf), Cint, (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{Cptrdiff_t}, Ptr{Cptrdiff_t}, Cstring), ncid, varid, startp, countp, stridep, imapp, ip)
end

function nc_put_varm_uchar(ncid::Cint, varid::Cint, startp, countp, stridep, imapp, op)
    ccall((:nc_put_varm_uchar, libnetcdf), Cint, (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{Cptrdiff_t}, Ptr{Cptrdiff_t}, Ptr{Cuchar}), ncid, varid, startp, countp, stridep, imapp, op)
end

function nc_get_varm_uchar(ncid::Cint, varid::Cint, startp, countp, stridep, imapp, ip)
    ccall((:nc_get_varm_uchar, libnetcdf), Cint, (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{Cptrdiff_t}, Ptr{Cptrdiff_t}, Ptr{Cuchar}), ncid, varid, startp, countp, stridep, imapp, ip)
end

function nc_put_varm_schar(ncid::Cint, varid::Cint, startp, countp, stridep, imapp, op)
    ccall((:nc_put_varm_schar, libnetcdf), Cint, (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{Cptrdiff_t}, Ptr{Cptrdiff_t}, Ptr{UInt8}), ncid, varid, startp, countp, stridep, imapp, op)
end

function nc_get_varm_schar(ncid::Cint, varid::Cint, startp, countp, stridep, imapp, ip)
    ccall((:nc_get_varm_schar, libnetcdf), Cint, (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{Cptrdiff_t}, Ptr{Cptrdiff_t}, Ptr{UInt8}), ncid, varid, startp, countp, stridep, imapp, ip)
end

function nc_put_varm_short(ncid::Cint, varid::Cint, startp, countp, stridep, imapp, op)
    ccall((:nc_put_varm_short, libnetcdf), Cint, (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{Cptrdiff_t}, Ptr{Cptrdiff_t}, Ptr{Int16}), ncid, varid, startp, countp, stridep, imapp, op)
end

function nc_get_varm_short(ncid::Cint, varid::Cint, startp, countp, stridep, imapp, ip)
    ccall((:nc_get_varm_short, libnetcdf), Cint, (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{Cptrdiff_t}, Ptr{Cptrdiff_t}, Ptr{Int16}), ncid, varid, startp, countp, stridep, imapp, ip)
end

function nc_put_varm_int(ncid::Cint, varid::Cint, startp, countp, stridep, imapp, op)
    ccall((:nc_put_varm_int, libnetcdf), Cint, (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{Cptrdiff_t}, Ptr{Cptrdiff_t}, Ptr{Cint}), ncid, varid, startp, countp, stridep, imapp, op)
end

function nc_get_varm_int(ncid::Cint, varid::Cint, startp, countp, stridep, imapp, ip)
    ccall((:nc_get_varm_int, libnetcdf), Cint, (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{Cptrdiff_t}, Ptr{Cptrdiff_t}, Ptr{Cint}), ncid, varid, startp, countp, stridep, imapp, ip)
end

function nc_put_varm_long(ncid::Cint, varid::Cint, startp, countp, stridep, imapp, op)
    ccall((:nc_put_varm_long, libnetcdf), Cint, (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{Cptrdiff_t}, Ptr{Cptrdiff_t}, Ptr{Clong}), ncid, varid, startp, countp, stridep, imapp, op)
end

function nc_get_varm_long(ncid::Cint, varid::Cint, startp, countp, stridep, imapp, ip)
    ccall((:nc_get_varm_long, libnetcdf), Cint, (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{Cptrdiff_t}, Ptr{Cptrdiff_t}, Ptr{Clong}), ncid, varid, startp, countp, stridep, imapp, ip)
end

function nc_put_varm_float(ncid::Cint, varid::Cint, startp, countp, stridep, imapp, op)
    ccall((:nc_put_varm_float, libnetcdf), Cint, (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{Cptrdiff_t}, Ptr{Cptrdiff_t}, Ptr{Cfloat}), ncid, varid, startp, countp, stridep, imapp, op)
end

function nc_get_varm_float(ncid::Cint, varid::Cint, startp, countp, stridep, imapp, ip)
    ccall((:nc_get_varm_float, libnetcdf), Cint, (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{Cptrdiff_t}, Ptr{Cptrdiff_t}, Ptr{Cfloat}), ncid, varid, startp, countp, stridep, imapp, ip)
end

function nc_put_varm_double(ncid::Cint, varid::Cint, startp, countp, stridep, imapp, op)
    ccall((:nc_put_varm_double, libnetcdf), Cint, (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{Cptrdiff_t}, Ptr{Cptrdiff_t}, Ptr{Cdouble}), ncid, varid, startp, countp, stridep, imapp, op)
end

function nc_get_varm_double(ncid::Cint, varid::Cint, startp, countp, stridep, imapp, ip)
    ccall((:nc_get_varm_double, libnetcdf), Cint, (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{Cptrdiff_t}, Ptr{Cptrdiff_t}, Ptr{Cdouble}), ncid, varid, startp, countp, stridep, imapp, ip)
end

function nc_put_varm_ushort(ncid::Cint, varid::Cint, startp, countp, stridep, imapp, op)
    ccall((:nc_put_varm_ushort, libnetcdf), Cint, (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{Cptrdiff_t}, Ptr{Cptrdiff_t}, Ptr{UInt16}), ncid, varid, startp, countp, stridep, imapp, op)
end

function nc_get_varm_ushort(ncid::Cint, varid::Cint, startp, countp, stridep, imapp, ip)
    ccall((:nc_get_varm_ushort, libnetcdf), Cint, (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{Cptrdiff_t}, Ptr{Cptrdiff_t}, Ptr{UInt16}), ncid, varid, startp, countp, stridep, imapp, ip)
end

function nc_put_varm_uint(ncid::Cint, varid::Cint, startp, countp, stridep, imapp, op)
    ccall((:nc_put_varm_uint, libnetcdf), Cint, (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{Cptrdiff_t}, Ptr{Cptrdiff_t}, Ptr{UInt32}), ncid, varid, startp, countp, stridep, imapp, op)
end

function nc_get_varm_uint(ncid::Cint, varid::Cint, startp, countp, stridep, imapp, ip)
    ccall((:nc_get_varm_uint, libnetcdf), Cint, (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{Cptrdiff_t}, Ptr{Cptrdiff_t}, Ptr{UInt32}), ncid, varid, startp, countp, stridep, imapp, ip)
end

function nc_put_varm_longlong(ncid::Cint, varid::Cint, startp, countp, stridep, imapp, op)
    ccall((:nc_put_varm_longlong, libnetcdf), Cint, (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{Cptrdiff_t}, Ptr{Cptrdiff_t}, Ptr{Clonglong}), ncid, varid, startp, countp, stridep, imapp, op)
end

function nc_get_varm_longlong(ncid::Cint, varid::Cint, startp, countp, stridep, imapp, ip)
    ccall((:nc_get_varm_longlong, libnetcdf), Cint, (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{Cptrdiff_t}, Ptr{Cptrdiff_t}, Ptr{Clonglong}), ncid, varid, startp, countp, stridep, imapp, ip)
end

function nc_put_varm_ulonglong(ncid::Cint, varid::Cint, startp, countp, stridep, imapp, op)
    ccall((:nc_put_varm_ulonglong, libnetcdf), Cint, (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{Cptrdiff_t}, Ptr{Cptrdiff_t}, Ptr{Culonglong}), ncid, varid, startp, countp, stridep, imapp, op)
end

function nc_get_varm_ulonglong(ncid::Cint, varid::Cint, startp, countp, stridep, imapp, ip)
    ccall((:nc_get_varm_ulonglong, libnetcdf), Cint, (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{Cptrdiff_t}, Ptr{Cptrdiff_t}, Ptr{Culonglong}), ncid, varid, startp, countp, stridep, imapp, ip)
end

function nc_put_varm_string(ncid::Cint, varid::Cint, startp, countp, stridep, imapp, op)
    ccall((:nc_put_varm_string, libnetcdf), Cint, (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{Cptrdiff_t}, Ptr{Cptrdiff_t}, Ptr{Cstring}), ncid, varid, startp, countp, stridep, imapp, op)
end

function nc_get_varm_string(ncid::Cint, varid::Cint, startp, countp, stridep, imapp, ip)
    ccall((:nc_get_varm_string, libnetcdf), Cint, (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{Cptrdiff_t}, Ptr{Cptrdiff_t}, Ptr{Cstring}), ncid, varid, startp, countp, stridep, imapp, ip)
end

function nc_put_var_text(ncid::Cint, varid::Cint, op)
    ccall((:nc_put_var_text, libnetcdf), Cint, (Cint, Cint, Cstring), ncid, varid, op)
end

function nc_get_var_text(ncid::Cint, varid::Cint, ip)
    ccall((:nc_get_var_text, libnetcdf), Cint, (Cint, Cint, Cstring), ncid, varid, ip)
end

function nc_put_var_uchar(ncid::Cint, varid::Cint, op)
    ccall((:nc_put_var_uchar, libnetcdf), Cint, (Cint, Cint, Ptr{Cuchar}), ncid, varid, op)
end

function nc_get_var_uchar(ncid::Cint, varid::Cint, ip)
    ccall((:nc_get_var_uchar, libnetcdf), Cint, (Cint, Cint, Ptr{Cuchar}), ncid, varid, ip)
end

function nc_put_var_schar(ncid::Cint, varid::Cint, op)
    ccall((:nc_put_var_schar, libnetcdf), Cint, (Cint, Cint, Ptr{UInt8}), ncid, varid, op)
end

function nc_get_var_schar(ncid::Cint, varid::Cint, ip)
    ccall((:nc_get_var_schar, libnetcdf), Cint, (Cint, Cint, Ptr{UInt8}), ncid, varid, ip)
end

function nc_put_var_short(ncid::Cint, varid::Cint, op)
    ccall((:nc_put_var_short, libnetcdf), Cint, (Cint, Cint, Ptr{Int16}), ncid, varid, op)
end

function nc_get_var_short(ncid::Cint, varid::Cint, ip)
    ccall((:nc_get_var_short, libnetcdf), Cint, (Cint, Cint, Ptr{Int16}), ncid, varid, ip)
end

function nc_put_var_int(ncid::Cint, varid::Cint, op)
    ccall((:nc_put_var_int, libnetcdf), Cint, (Cint, Cint, Ptr{Cint}), ncid, varid, op)
end

function nc_get_var_int(ncid::Cint, varid::Cint, ip)
    ccall((:nc_get_var_int, libnetcdf), Cint, (Cint, Cint, Ptr{Cint}), ncid, varid, ip)
end

function nc_put_var_long(ncid::Cint, varid::Cint, op)
    ccall((:nc_put_var_long, libnetcdf), Cint, (Cint, Cint, Ptr{Clong}), ncid, varid, op)
end

function nc_get_var_long(ncid::Cint, varid::Cint, ip)
    ccall((:nc_get_var_long, libnetcdf), Cint, (Cint, Cint, Ptr{Clong}), ncid, varid, ip)
end

function nc_put_var_float(ncid::Cint, varid::Cint, op)
    ccall((:nc_put_var_float, libnetcdf), Cint, (Cint, Cint, Ptr{Cfloat}), ncid, varid, op)
end

function nc_get_var_float(ncid::Cint, varid::Cint, ip)
    ccall((:nc_get_var_float, libnetcdf), Cint, (Cint, Cint, Ptr{Cfloat}), ncid, varid, ip)
end

function nc_put_var_double(ncid::Cint, varid::Cint, op)
    ccall((:nc_put_var_double, libnetcdf), Cint, (Cint, Cint, Ptr{Cdouble}), ncid, varid, op)
end

function nc_get_var_double(ncid::Cint, varid::Cint, ip)
    ccall((:nc_get_var_double, libnetcdf), Cint, (Cint, Cint, Ptr{Cdouble}), ncid, varid, ip)
end

function nc_put_var_ushort(ncid::Cint, varid::Cint, op)
    ccall((:nc_put_var_ushort, libnetcdf), Cint, (Cint, Cint, Ptr{UInt16}), ncid, varid, op)
end

function nc_get_var_ushort(ncid::Cint, varid::Cint, ip)
    ccall((:nc_get_var_ushort, libnetcdf), Cint, (Cint, Cint, Ptr{UInt16}), ncid, varid, ip)
end

function nc_put_var_uint(ncid::Cint, varid::Cint, op)
    ccall((:nc_put_var_uint, libnetcdf), Cint, (Cint, Cint, Ptr{UInt32}), ncid, varid, op)
end

function nc_get_var_uint(ncid::Cint, varid::Cint, ip)
    ccall((:nc_get_var_uint, libnetcdf), Cint, (Cint, Cint, Ptr{UInt32}), ncid, varid, ip)
end

function nc_put_var_longlong(ncid::Cint, varid::Cint, op)
    ccall((:nc_put_var_longlong, libnetcdf), Cint, (Cint, Cint, Ptr{Clonglong}), ncid, varid, op)
end

function nc_get_var_longlong(ncid::Cint, varid::Cint, ip)
    ccall((:nc_get_var_longlong, libnetcdf), Cint, (Cint, Cint, Ptr{Clonglong}), ncid, varid, ip)
end

function nc_put_var_ulonglong(ncid::Cint, varid::Cint, op)
    ccall((:nc_put_var_ulonglong, libnetcdf), Cint, (Cint, Cint, Ptr{Culonglong}), ncid, varid, op)
end

function nc_get_var_ulonglong(ncid::Cint, varid::Cint, ip)
    ccall((:nc_get_var_ulonglong, libnetcdf), Cint, (Cint, Cint, Ptr{Culonglong}), ncid, varid, ip)
end

function nc_put_var_string(ncid::Cint, varid::Cint, op)
    ccall((:nc_put_var_string, libnetcdf), Cint, (Cint, Cint, Ptr{Cstring}), ncid, varid, op)
end

function nc_get_var_string(ncid::Cint, varid::Cint, ip)
    ccall((:nc_get_var_string, libnetcdf), Cint, (Cint, Cint, Ptr{Cstring}), ncid, varid, ip)
end

function nc_put_att_ubyte(ncid::Cint, varid::Cint, name, xtype::nc_type, len::Csize_t, op)
    ccall((:nc_put_att_ubyte, libnetcdf), Cint, (Cint, Cint, Cstring, nc_type, Csize_t, Ptr{Cuchar}), ncid, varid, name, xtype, len, op)
end

function nc_get_att_ubyte(ncid::Cint, varid::Cint, name, ip)
    ccall((:nc_get_att_ubyte, libnetcdf), Cint, (Cint, Cint, Cstring, Ptr{Cuchar}), ncid, varid, name, ip)
end

function nc_put_var1_ubyte(ncid::Cint, varid::Cint, indexp, op)
    ccall((:nc_put_var1_ubyte, libnetcdf), Cint, (Cint, Cint, Ptr{Csize_t}, Ptr{Cuchar}), ncid, varid, indexp, op)
end

function nc_get_var1_ubyte(ncid::Cint, varid::Cint, indexp, ip)
    ccall((:nc_get_var1_ubyte, libnetcdf), Cint, (Cint, Cint, Ptr{Csize_t}, Ptr{Cuchar}), ncid, varid, indexp, ip)
end

function nc_put_vara_ubyte(ncid::Cint, varid::Cint, startp, countp, op)
    ccall((:nc_put_vara_ubyte, libnetcdf), Cint, (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{Cuchar}), ncid, varid, startp, countp, op)
end

function nc_get_vara_ubyte(ncid::Cint, varid::Cint, startp, countp, ip)
    ccall((:nc_get_vara_ubyte, libnetcdf), Cint, (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{Cuchar}), ncid, varid, startp, countp, ip)
end

function nc_put_vars_ubyte(ncid::Cint, varid::Cint, startp, countp, stridep, op)
    ccall((:nc_put_vars_ubyte, libnetcdf), Cint, (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{Cptrdiff_t}, Ptr{Cuchar}), ncid, varid, startp, countp, stridep, op)
end

function nc_get_vars_ubyte(ncid::Cint, varid::Cint, startp, countp, stridep, ip)
    ccall((:nc_get_vars_ubyte, libnetcdf), Cint, (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{Cptrdiff_t}, Ptr{Cuchar}), ncid, varid, startp, countp, stridep, ip)
end

function nc_put_varm_ubyte(ncid::Cint, varid::Cint, startp, countp, stridep, imapp, op)
    ccall((:nc_put_varm_ubyte, libnetcdf), Cint, (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{Cptrdiff_t}, Ptr{Cptrdiff_t}, Ptr{Cuchar}), ncid, varid, startp, countp, stridep, imapp, op)
end

function nc_get_varm_ubyte(ncid::Cint, varid::Cint, startp, countp, stridep, imapp, ip)
    ccall((:nc_get_varm_ubyte, libnetcdf), Cint, (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{Cptrdiff_t}, Ptr{Cptrdiff_t}, Ptr{Cuchar}), ncid, varid, startp, countp, stridep, imapp, ip)
end

function nc_put_var_ubyte(ncid::Cint, varid::Cint, op)
    ccall((:nc_put_var_ubyte, libnetcdf), Cint, (Cint, Cint, Ptr{Cuchar}), ncid, varid, op)
end

function nc_get_var_ubyte(ncid::Cint, varid::Cint, ip)
    ccall((:nc_get_var_ubyte, libnetcdf), Cint, (Cint, Cint, Ptr{Cuchar}), ncid, varid, ip)
end

function nc_show_metadata(ncid::Cint)
    ccall((:nc_show_metadata, libnetcdf), Cint, (Cint,), ncid)
end

function nc__create_mp(path, cmode::Cint, initialsz::Csize_t, basepe::Cint, chunksizehintp, ncidp)
    ccall((:nc__create_mp, libnetcdf), Cint, (Cstring, Cint, Csize_t, Cint, Ptr{Csize_t}, Ptr{Cint}), path, cmode, initialsz, basepe, chunksizehintp, ncidp)
end

function nc__open_mp(path, mode::Cint, basepe::Cint, chunksizehintp, ncidp)
    ccall((:nc__open_mp, libnetcdf), Cint, (Cstring, Cint, Cint, Ptr{Csize_t}, Ptr{Cint}), path, mode, basepe, chunksizehintp, ncidp)
end

function nc_delete(path)
    ccall((:nc_delete, libnetcdf), Cint, (Cstring,), path)
end

function nc_delete_mp(path, basepe::Cint)
    ccall((:nc_delete_mp, libnetcdf), Cint, (Cstring, Cint), path, basepe)
end

function nc_set_base_pe(ncid::Cint, pe::Cint)
    ccall((:nc_set_base_pe, libnetcdf), Cint, (Cint, Cint), ncid, pe)
end

function nc_inq_base_pe(ncid::Cint, pe)
    ccall((:nc_inq_base_pe, libnetcdf), Cint, (Cint, Ptr{Cint}), ncid, pe)
end

function nctypelen(datatype::nc_type)
    ccall((:nctypelen, libnetcdf), Cint, (nc_type,), datatype)
end

function nccreate(path, cmode::Cint)
    ccall((:nccreate, libnetcdf), Cint, (Cstring, Cint), path, cmode)
end

function ncopen(path, mode::Cint)
    ccall((:ncopen, libnetcdf), Cint, (Cstring, Cint), path, mode)
end

function ncsetfill(ncid::Cint, fillmode::Cint)
    ccall((:ncsetfill, libnetcdf), Cint, (Cint, Cint), ncid, fillmode)
end

function ncredef(ncid::Cint)
    ccall((:ncredef, libnetcdf), Cint, (Cint,), ncid)
end

function ncendef(ncid::Cint)
    ccall((:ncendef, libnetcdf), Cint, (Cint,), ncid)
end

function ncsync(ncid::Cint)
    ccall((:ncsync, libnetcdf), Cint, (Cint,), ncid)
end

function ncabort(ncid::Cint)
    ccall((:ncabort, libnetcdf), Cint, (Cint,), ncid)
end

function ncclose(ncid::Cint)
    ccall((:ncclose, libnetcdf), Cint, (Cint,), ncid)
end

function ncinquire(ncid::Cint, ndimsp, nvarsp, nattsp, unlimdimp)
    ccall((:ncinquire, libnetcdf), Cint, (Cint, Ptr{Cint}, Ptr{Cint}, Ptr{Cint}, Ptr{Cint}), ncid, ndimsp, nvarsp, nattsp, unlimdimp)
end

function ncdimdef(ncid::Cint, name, len::Clong)
    ccall((:ncdimdef, libnetcdf), Cint, (Cint, Cstring, Clong), ncid, name, len)
end

function ncdimid(ncid::Cint, name)
    ccall((:ncdimid, libnetcdf), Cint, (Cint, Cstring), ncid, name)
end

function ncdiminq(ncid::Cint, dimid::Cint, name, lenp)
    ccall((:ncdiminq, libnetcdf), Cint, (Cint, Cint, Cstring, Ptr{Clong}), ncid, dimid, name, lenp)
end

function ncdimrename(ncid::Cint, dimid::Cint, name)
    ccall((:ncdimrename, libnetcdf), Cint, (Cint, Cint, Cstring), ncid, dimid, name)
end

function ncattput(ncid::Cint, varid::Cint, name, xtype::nc_type, len::Cint, op)
    ccall((:ncattput, libnetcdf), Cint, (Cint, Cint, Cstring, nc_type, Cint, Ptr{Void}), ncid, varid, name, xtype, len, op)
end

function ncattinq(ncid::Cint, varid::Cint, name, xtypep, lenp)
    ccall((:ncattinq, libnetcdf), Cint, (Cint, Cint, Cstring, Ptr{nc_type}, Ptr{Cint}), ncid, varid, name, xtypep, lenp)
end

function ncattget(ncid::Cint, varid::Cint, name, ip)
    ccall((:ncattget, libnetcdf), Cint, (Cint, Cint, Cstring, Ptr{Void}), ncid, varid, name, ip)
end

function ncattcopy(ncid_in::Cint, varid_in::Cint, name, ncid_out::Cint, varid_out::Cint)
    ccall((:ncattcopy, libnetcdf), Cint, (Cint, Cint, Cstring, Cint, Cint), ncid_in, varid_in, name, ncid_out, varid_out)
end

function ncattname(ncid::Cint, varid::Cint, attnum::Cint, name)
    ccall((:ncattname, libnetcdf), Cint, (Cint, Cint, Cint, Cstring), ncid, varid, attnum, name)
end

function ncattrename(ncid::Cint, varid::Cint, name, newname)
    ccall((:ncattrename, libnetcdf), Cint, (Cint, Cint, Cstring, Cstring), ncid, varid, name, newname)
end

function ncattdel(ncid::Cint, varid::Cint, name)
    ccall((:ncattdel, libnetcdf), Cint, (Cint, Cint, Cstring), ncid, varid, name)
end

function ncvardef(ncid::Cint, name, xtype::nc_type, ndims::Cint, dimidsp)
    ccall((:ncvardef, libnetcdf), Cint, (Cint, Cstring, nc_type, Cint, Ptr{Cint}), ncid, name, xtype, ndims, dimidsp)
end

function ncvarid(ncid::Cint, name)
    ccall((:ncvarid, libnetcdf), Cint, (Cint, Cstring), ncid, name)
end

function ncvarinq(ncid::Cint, varid::Cint, name, xtypep, ndimsp, dimidsp, nattsp)
    ccall((:ncvarinq, libnetcdf), Cint, (Cint, Cint, Cstring, Ptr{nc_type}, Ptr{Cint}, Ptr{Cint}, Ptr{Cint}), ncid, varid, name, xtypep, ndimsp, dimidsp, nattsp)
end

function ncvarput1(ncid::Cint, varid::Cint, indexp, op)
    ccall((:ncvarput1, libnetcdf), Cint, (Cint, Cint, Ptr{Clong}, Ptr{Void}), ncid, varid, indexp, op)
end

function ncvarget1(ncid::Cint, varid::Cint, indexp, ip)
    ccall((:ncvarget1, libnetcdf), Cint, (Cint, Cint, Ptr{Clong}, Ptr{Void}), ncid, varid, indexp, ip)
end

function ncvarput(ncid::Cint, varid::Cint, startp, countp, op)
    ccall((:ncvarput, libnetcdf), Cint, (Cint, Cint, Ptr{Clong}, Ptr{Clong}, Ptr{Void}), ncid, varid, startp, countp, op)
end

function ncvarget(ncid::Cint, varid::Cint, startp, countp, ip)
    ccall((:ncvarget, libnetcdf), Cint, (Cint, Cint, Ptr{Clong}, Ptr{Clong}, Ptr{Void}), ncid, varid, startp, countp, ip)
end

function ncvarputs(ncid::Cint, varid::Cint, startp, countp, stridep, op)
    ccall((:ncvarputs, libnetcdf), Cint, (Cint, Cint, Ptr{Clong}, Ptr{Clong}, Ptr{Clong}, Ptr{Void}), ncid, varid, startp, countp, stridep, op)
end

function ncvargets(ncid::Cint, varid::Cint, startp, countp, stridep, ip)
    ccall((:ncvargets, libnetcdf), Cint, (Cint, Cint, Ptr{Clong}, Ptr{Clong}, Ptr{Clong}, Ptr{Void}), ncid, varid, startp, countp, stridep, ip)
end

function ncvarputg(ncid::Cint, varid::Cint, startp, countp, stridep, imapp, op)
    ccall((:ncvarputg, libnetcdf), Cint, (Cint, Cint, Ptr{Clong}, Ptr{Clong}, Ptr{Clong}, Ptr{Clong}, Ptr{Void}), ncid, varid, startp, countp, stridep, imapp, op)
end

function ncvargetg(ncid::Cint, varid::Cint, startp, countp, stridep, imapp, ip)
    ccall((:ncvargetg, libnetcdf), Cint, (Cint, Cint, Ptr{Clong}, Ptr{Clong}, Ptr{Clong}, Ptr{Clong}, Ptr{Void}), ncid, varid, startp, countp, stridep, imapp, ip)
end

function ncvarrename(ncid::Cint, varid::Cint, name)
    ccall((:ncvarrename, libnetcdf), Cint, (Cint, Cint, Cstring), ncid, varid, name)
end

function ncrecinq(ncid::Cint, nrecvarsp, recvaridsp, recsizesp)
    ccall((:ncrecinq, libnetcdf), Cint, (Cint, Ptr{Cint}, Ptr{Cint}, Ptr{Clong}), ncid, nrecvarsp, recvaridsp, recsizesp)
end

function ncrecget(ncid::Cint, recnum::Clong, datap)
    ccall((:ncrecget, libnetcdf), Cint, (Cint, Clong, Ptr{Ptr{Void}}), ncid, recnum, datap)
end

function ncrecput(ncid::Cint, recnum::Clong, datap)
    ccall((:ncrecput, libnetcdf), Cint, (Cint, Clong, Ptr{Ptr{Void}}), ncid, recnum, datap)
end
