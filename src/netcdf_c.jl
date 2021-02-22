function nc_def_user_format(mode_flag, ispatch_table, agic_number, )
    check(ccall(
        (:nc_def_user_format, libnetcdf),
        Cint,
        (Cint, Ptr{Cvoid}, Ptr{Cchar}, ),
        mode_flag,
        ispatch_table,
        agic_number,
    ))
end
function nc_inq_user_format(mode_flag, dispatch_table, agic_number, )
    check(ccall(
        (:nc_inq_user_format, libnetcdf),
        Cint,
        (Cint, Ptr{Ptr{Cvoid}}, Ptr{Cchar}, ),
        mode_flag,
        dispatch_table,
        agic_number,
    ))
end
function nc__create(ath, cmode, initialsz, hunksizehintp, cidp, )
    check(ccall(
        (:nc__create, libnetcdf),
        Cint,
        (Ptr{Cchar}, Cint, Csize_t, Ptr{Csize_t}, Ptr{Cint}, ),
        ath,
        cmode,
        initialsz,
        hunksizehintp,
        cidp,
    ))
end
function nc_create(ath, cmode, cidp, )
    check(ccall(
        (:nc_create, libnetcdf),
        Cint,
        (Ptr{Cchar}, Cint, Ptr{Cint}, ),
        ath,
        cmode,
        cidp,
    ))
end
function nc__open(ath, mode, hunksizehintp, cidp, )
    check(ccall(
        (:nc__open, libnetcdf),
        Cint,
        (Ptr{Cchar}, Cint, Ptr{Csize_t}, Ptr{Cint}, ),
        ath,
        mode,
        hunksizehintp,
        cidp,
    ))
end
function nc_open(ath, mode, cidp, )
    check(ccall(
        (:nc_open, libnetcdf),
        Cint,
        (Ptr{Cchar}, Cint, Ptr{Cint}, ),
        ath,
        mode,
        cidp,
    ))
end
function nc_inq_path(ncid, athlen, ath, )
    check(ccall(
        (:nc_inq_path, libnetcdf),
        Cint,
        (Cint, Ptr{Csize_t}, Ptr{Cchar}, ),
        ncid,
        athlen,
        ath,
    ))
end
function nc_inq_ncid(ncid, ame, rp_ncid, )
    check(ccall(
        (:nc_inq_ncid, libnetcdf),
        Cint,
        (Cint, Ptr{Cchar}, Ptr{Cint}, ),
        ncid,
        ame,
        rp_ncid,
    ))
end
function nc_inq_grps(ncid, umgrps, cids, )
    check(ccall(
        (:nc_inq_grps, libnetcdf),
        Cint,
        (Cint, Ptr{Cint}, Ptr{Cint}, ),
        ncid,
        umgrps,
        cids,
    ))
end
function nc_inq_grpname(ncid, ame, )
    check(ccall(
        (:nc_inq_grpname, libnetcdf),
        Cint,
        (Cint, Ptr{Cchar}, ),
        ncid,
        ame,
    ))
end
function nc_inq_grpname_full(ncid, enp, ull_name, )
    check(ccall(
        (:nc_inq_grpname_full, libnetcdf),
        Cint,
        (Cint, Ptr{Csize_t}, Ptr{Cchar}, ),
        ncid,
        enp,
        ull_name,
    ))
end
function nc_inq_grpname_len(ncid, enp, )
    check(ccall(
        (:nc_inq_grpname_len, libnetcdf),
        Cint,
        (Cint, Ptr{Csize_t}, ),
        ncid,
        enp,
    ))
end
function nc_inq_grp_parent(ncid, arent_ncid, )
    check(ccall(
        (:nc_inq_grp_parent, libnetcdf),
        Cint,
        (Cint, Ptr{Cint}, ),
        ncid,
        arent_ncid,
    ))
end
function nc_inq_grp_ncid(ncid, rp_name, rp_ncid, )
    check(ccall(
        (:nc_inq_grp_ncid, libnetcdf),
        Cint,
        (Cint, Ptr{Cchar}, Ptr{Cint}, ),
        ncid,
        rp_name,
        rp_ncid,
    ))
end
function nc_inq_grp_full_ncid(ncid, ull_name, rp_ncid, )
    check(ccall(
        (:nc_inq_grp_full_ncid, libnetcdf),
        Cint,
        (Cint, Ptr{Cchar}, Ptr{Cint}, ),
        ncid,
        ull_name,
        rp_ncid,
    ))
end
function nc_inq_varids(ncid, vars, arids, )
    check(ccall(
        (:nc_inq_varids, libnetcdf),
        Cint,
        (Cint, Ptr{Cint}, Ptr{Cint}, ),
        ncid,
        vars,
        arids,
    ))
end
function nc_inq_dimids(ncid, dims, imids, include_parents, )
    check(ccall(
        (:nc_inq_dimids, libnetcdf),
        Cint,
        (Cint, Ptr{Cint}, Ptr{Cint}, Cint, ),
        ncid,
        dims,
        imids,
        include_parents,
    ))
end
function nc_inq_typeids(ncid, types, ypeids, )
    check(ccall(
        (:nc_inq_typeids, libnetcdf),
        Cint,
        (Cint, Ptr{Cint}, Ptr{Cint}, ),
        ncid,
        types,
        ypeids,
    ))
end
function nc_inq_type_equal(ncid1, typeid1, ncid2, typeid2, qual, )
    check(ccall(
        (:nc_inq_type_equal, libnetcdf),
        Cint,
        (Cint, Cint, Cint, Cint, Ptr{Cint}, ),
        ncid1,
        typeid1,
        ncid2,
        typeid2,
        qual,
    ))
end
function nc_def_grp(parent_ncid, ame, ew_ncid, )
    check(ccall(
        (:nc_def_grp, libnetcdf),
        Cint,
        (Cint, Ptr{Cchar}, Ptr{Cint}, ),
        parent_ncid,
        ame,
        ew_ncid,
    ))
end
function nc_rename_grp(grpid, ame, )
    check(ccall(
        (:nc_rename_grp, libnetcdf),
        Cint,
        (Cint, Ptr{Cchar}, ),
        grpid,
        ame,
    ))
end
function nc_def_compound(ncid, size, ame, ypeidp, )
    check(ccall(
        (:nc_def_compound, libnetcdf),
        Cint,
        (Cint, Csize_t, Ptr{Cchar}, Ptr{Cint}, ),
        ncid,
        size,
        ame,
        ypeidp,
    ))
end
function nc_insert_compound(ncid, xtype, ame, offset, field_typeid, )
    check(ccall(
        (:nc_insert_compound, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Cchar}, Csize_t, Cint, ),
        ncid,
        xtype,
        ame,
        offset,
        field_typeid,
    ))
end
function nc_insert_array_compound(ncid, xtype, ame, offset, field_typeid, ndims, im_sizes, )
    check(ccall(
        (:nc_insert_array_compound, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Cchar}, Csize_t, Cint, Cint, Ptr{Cint}, ),
        ncid,
        xtype,
        ame,
        offset,
        field_typeid,
        ndims,
        im_sizes,
    ))
end
function nc_inq_type(ncid, xtype, ame, ize, )
    check(ccall(
        (:nc_inq_type, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Cchar}, Ptr{Csize_t}, ),
        ncid,
        xtype,
        ame,
        ize,
    ))
end
function nc_inq_typeid(ncid, ame, ypeidp, )
    check(ccall(
        (:nc_inq_typeid, libnetcdf),
        Cint,
        (Cint, Ptr{Cchar}, Ptr{Cint}, ),
        ncid,
        ame,
        ypeidp,
    ))
end
function nc_inq_compound(ncid, xtype, ame, izep, fieldsp, )
    check(ccall(
        (:nc_inq_compound, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Cchar}, Ptr{Csize_t}, Ptr{Csize_t}, ),
        ncid,
        xtype,
        ame,
        izep,
        fieldsp,
    ))
end
function nc_inq_compound_name(ncid, xtype, ame, )
    check(ccall(
        (:nc_inq_compound_name, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Cchar}, ),
        ncid,
        xtype,
        ame,
    ))
end
function nc_inq_compound_size(ncid, xtype, izep, )
    check(ccall(
        (:nc_inq_compound_size, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Csize_t}, ),
        ncid,
        xtype,
        izep,
    ))
end
function nc_inq_compound_nfields(ncid, xtype, fieldsp, )
    check(ccall(
        (:nc_inq_compound_nfields, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Csize_t}, ),
        ncid,
        xtype,
        fieldsp,
    ))
end
function nc_inq_compound_field(ncid, xtype, fieldid, ame, ffsetp, ield_typeidp, dimsp, im_sizesp, )
    check(ccall(
        (:nc_inq_compound_field, libnetcdf),
        Cint,
        (Cint, Cint, Cint, Ptr{Cchar}, Ptr{Csize_t}, Ptr{Cint}, Ptr{Cint}, Ptr{Cint}, ),
        ncid,
        xtype,
        fieldid,
        ame,
        ffsetp,
        ield_typeidp,
        dimsp,
        im_sizesp,
    ))
end
function nc_inq_compound_fieldname(ncid, xtype, fieldid, ame, )
    check(ccall(
        (:nc_inq_compound_fieldname, libnetcdf),
        Cint,
        (Cint, Cint, Cint, Ptr{Cchar}, ),
        ncid,
        xtype,
        fieldid,
        ame,
    ))
end
function nc_inq_compound_fieldindex(ncid, xtype, ame, ieldidp, )
    check(ccall(
        (:nc_inq_compound_fieldindex, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Cchar}, Ptr{Cint}, ),
        ncid,
        xtype,
        ame,
        ieldidp,
    ))
end
function nc_inq_compound_fieldoffset(ncid, xtype, fieldid, ffsetp, )
    check(ccall(
        (:nc_inq_compound_fieldoffset, libnetcdf),
        Cint,
        (Cint, Cint, Cint, Ptr{Csize_t}, ),
        ncid,
        xtype,
        fieldid,
        ffsetp,
    ))
end
function nc_inq_compound_fieldtype(ncid, xtype, fieldid, ield_typeidp, )
    check(ccall(
        (:nc_inq_compound_fieldtype, libnetcdf),
        Cint,
        (Cint, Cint, Cint, Ptr{Cint}, ),
        ncid,
        xtype,
        fieldid,
        ield_typeidp,
    ))
end
function nc_inq_compound_fieldndims(ncid, xtype, fieldid, dimsp, )
    check(ccall(
        (:nc_inq_compound_fieldndims, libnetcdf),
        Cint,
        (Cint, Cint, Cint, Ptr{Cint}, ),
        ncid,
        xtype,
        fieldid,
        dimsp,
    ))
end
function nc_inq_compound_fielddim_sizes(ncid, xtype, fieldid, im_sizes, )
    check(ccall(
        (:nc_inq_compound_fielddim_sizes, libnetcdf),
        Cint,
        (Cint, Cint, Cint, Ptr{Cint}, ),
        ncid,
        xtype,
        fieldid,
        im_sizes,
    ))
end
function nc_def_vlen(ncid, ame, base_typeid, typep, )
    check(ccall(
        (:nc_def_vlen, libnetcdf),
        Cint,
        (Cint, Ptr{Cchar}, Cint, Ptr{Cint}, ),
        ncid,
        ame,
        base_typeid,
        typep,
    ))
end
function nc_inq_vlen(ncid, xtype, ame, atum_sizep, ase_nc_typep, )
    check(ccall(
        (:nc_inq_vlen, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Cchar}, Ptr{Csize_t}, Ptr{Cint}, ),
        ncid,
        xtype,
        ame,
        atum_sizep,
        ase_nc_typep,
    ))
end
function nc_free_vlen(l, )
    check(ccall(
        (:nc_free_vlen, libnetcdf),
        Cint,
        (Ptr{nc_vlen_t}, ),
        l,
    ))
end
function nc_free_vlens(len, lens, )
    check(ccall(
        (:nc_free_vlens, libnetcdf),
        Cint,
        (Csize_t, Ptr{nc_vlen_t}, ),
        len,
        lens,
    ))
end
function nc_put_vlen_element(ncid, typeid1, len_element, len, ata, )
    check(ccall(
        (:nc_put_vlen_element, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Cvoid}, Csize_t, Ptr{Cvoid}, ),
        ncid,
        typeid1,
        len_element,
        len,
        ata,
    ))
end
function nc_get_vlen_element(ncid, typeid1, len_element, en, ata, )
    check(ccall(
        (:nc_get_vlen_element, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Cvoid}, Ptr{Csize_t}, Ptr{Cvoid}, ),
        ncid,
        typeid1,
        len_element,
        en,
        ata,
    ))
end
function nc_free_string(len, data, )
    check(ccall(
        (:nc_free_string, libnetcdf),
        Cint,
        (Csize_t, Ptr{Ptr{Cchar}}, ),
        len,
        data,
    ))
end
function nc_inq_user_type(ncid, xtype, ame, ize, ase_nc_typep, fieldsp, lassp, )
    check(ccall(
        (:nc_inq_user_type, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Cchar}, Ptr{Csize_t}, Ptr{Cint}, Ptr{Csize_t}, Ptr{Cint}, ),
        ncid,
        xtype,
        ame,
        ize,
        ase_nc_typep,
        fieldsp,
        lassp,
    ))
end
function nc_put_att(ncid, varid, ame, xtype, len, p, )
    check(ccall(
        (:nc_put_att, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Cchar}, Cint, Csize_t, Ptr{Cvoid}, ),
        ncid,
        varid,
        ame,
        xtype,
        len,
        p,
    ))
end
function nc_get_att(ncid, varid, ame, p, )
    check(ccall(
        (:nc_get_att, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Cchar}, Ptr{Cvoid}, ),
        ncid,
        varid,
        ame,
        p,
    ))
end
function nc_def_enum(ncid, base_typeid, ame, ypeidp, )
    check(ccall(
        (:nc_def_enum, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Cchar}, Ptr{Cint}, ),
        ncid,
        base_typeid,
        ame,
        ypeidp,
    ))
end
function nc_insert_enum(ncid, xtype, ame, alue, )
    check(ccall(
        (:nc_insert_enum, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Cchar}, Ptr{Cvoid}, ),
        ncid,
        xtype,
        ame,
        alue,
    ))
end
function nc_inq_enum(ncid, xtype, ame, ase_nc_typep, ase_sizep, um_membersp, )
    check(ccall(
        (:nc_inq_enum, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Cchar}, Ptr{Cint}, Ptr{Csize_t}, Ptr{Csize_t}, ),
        ncid,
        xtype,
        ame,
        ase_nc_typep,
        ase_sizep,
        um_membersp,
    ))
end
function nc_inq_enum_member(ncid, xtype, idx, ame, alue, )
    check(ccall(
        (:nc_inq_enum_member, libnetcdf),
        Cint,
        (Cint, Cint, Cint, Ptr{Cchar}, Ptr{Cvoid}, ),
        ncid,
        xtype,
        idx,
        ame,
        alue,
    ))
end
function nc_inq_enum_ident(ncid, xtype, value, dentifier, )
    check(ccall(
        (:nc_inq_enum_ident, libnetcdf),
        Cint,
        (Cint, Cint, Clonglong, Ptr{Cchar}, ),
        ncid,
        xtype,
        value,
        dentifier,
    ))
end
function nc_def_opaque(ncid, size, ame, typep, )
    check(ccall(
        (:nc_def_opaque, libnetcdf),
        Cint,
        (Cint, Csize_t, Ptr{Cchar}, Ptr{Cint}, ),
        ncid,
        size,
        ame,
        typep,
    ))
end
function nc_inq_opaque(ncid, xtype, ame, izep, )
    check(ccall(
        (:nc_inq_opaque, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Cchar}, Ptr{Csize_t}, ),
        ncid,
        xtype,
        ame,
        izep,
    ))
end
function nc_put_var(ncid, varid, p, )
    check(ccall(
        (:nc_put_var, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Cvoid}, ),
        ncid,
        varid,
        p,
    ))
end
function nc_get_var(ncid, varid, p, )
    check(ccall(
        (:nc_get_var, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Cvoid}, ),
        ncid,
        varid,
        p,
    ))
end
function nc_put_var1(ncid, varid, ndexp, p, )
    check(ccall(
        (:nc_put_var1, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Csize_t}, Ptr{Cvoid}, ),
        ncid,
        varid,
        ndexp,
        p,
    ))
end
function nc_get_var1(ncid, varid, ndexp, p, )
    check(ccall(
        (:nc_get_var1, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Csize_t}, Ptr{Cvoid}, ),
        ncid,
        varid,
        ndexp,
        p,
    ))
end
function nc_put_vara(ncid, varid, tartp, ountp, p, )
    check(ccall(
        (:nc_put_vara, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{Cvoid}, ),
        ncid,
        varid,
        tartp,
        ountp,
        p,
    ))
end
function nc_get_vara(ncid, varid, tartp, ountp, p, )
    check(ccall(
        (:nc_get_vara, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{Cvoid}, ),
        ncid,
        varid,
        tartp,
        ountp,
        p,
    ))
end
function nc_put_vars(ncid, varid, tartp, ountp, tridep, p, )
    check(ccall(
        (:nc_put_vars, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{Cptrdiff_t}, Ptr{Cvoid}, ),
        ncid,
        varid,
        tartp,
        ountp,
        tridep,
        p,
    ))
end
function nc_get_vars(ncid, varid, tartp, ountp, tridep, p, )
    check(ccall(
        (:nc_get_vars, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{Cptrdiff_t}, Ptr{Cvoid}, ),
        ncid,
        varid,
        tartp,
        ountp,
        tridep,
        p,
    ))
end
function nc_put_varm(ncid, varid, tartp, ountp, tridep, mapp, p, )
    check(ccall(
        (:nc_put_varm, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{Cptrdiff_t}, Ptr{Cptrdiff_t}, Ptr{Cvoid}, ),
        ncid,
        varid,
        tartp,
        ountp,
        tridep,
        mapp,
        p,
    ))
end
function nc_get_varm(ncid, varid, tartp, ountp, tridep, mapp, p, )
    check(ccall(
        (:nc_get_varm, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{Cptrdiff_t}, Ptr{Cptrdiff_t}, Ptr{Cvoid}, ),
        ncid,
        varid,
        tartp,
        ountp,
        tridep,
        mapp,
        p,
    ))
end
function nc_def_var_deflate(ncid, varid, shuffle, deflate, deflate_level, )
    check(ccall(
        (:nc_def_var_deflate, libnetcdf),
        Cint,
        (Cint, Cint, Cint, Cint, Cint, ),
        ncid,
        varid,
        shuffle,
        deflate,
        deflate_level,
    ))
end
function nc_inq_var_deflate(ncid, varid, hufflep, eflatep, eflate_levelp, )
    check(ccall(
        (:nc_inq_var_deflate, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Cint}, Ptr{Cint}, Ptr{Cint}, ),
        ncid,
        varid,
        hufflep,
        eflatep,
        eflate_levelp,
    ))
end
function nc_def_var_szip(ncid, varid, options_mask, pixels_per_block, )
    check(ccall(
        (:nc_def_var_szip, libnetcdf),
        Cint,
        (Cint, Cint, Cint, Cint, ),
        ncid,
        varid,
        options_mask,
        pixels_per_block,
    ))
end
function nc_inq_var_szip(ncid, varid, ptions_maskp, ixels_per_blockp, )
    check(ccall(
        (:nc_inq_var_szip, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Cint}, Ptr{Cint}, ),
        ncid,
        varid,
        ptions_maskp,
        ixels_per_blockp,
    ))
end
function nc_def_var_fletcher32(ncid, varid, fletcher32, )
    check(ccall(
        (:nc_def_var_fletcher32, libnetcdf),
        Cint,
        (Cint, Cint, Cint, ),
        ncid,
        varid,
        fletcher32,
    ))
end
function nc_inq_var_fletcher32(ncid, varid, letcher32p, )
    check(ccall(
        (:nc_inq_var_fletcher32, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Cint}, ),
        ncid,
        varid,
        letcher32p,
    ))
end
function nc_def_var_chunking(ncid, varid, storage, hunksizesp, )
    check(ccall(
        (:nc_def_var_chunking, libnetcdf),
        Cint,
        (Cint, Cint, Cint, Ptr{Csize_t}, ),
        ncid,
        varid,
        storage,
        hunksizesp,
    ))
end
function nc_inq_var_chunking(ncid, varid, toragep, hunksizesp, )
    check(ccall(
        (:nc_inq_var_chunking, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Cint}, Ptr{Csize_t}, ),
        ncid,
        varid,
        toragep,
        hunksizesp,
    ))
end
function nc_def_var_fill(ncid, varid, no_fill, ill_value, )
    check(ccall(
        (:nc_def_var_fill, libnetcdf),
        Cint,
        (Cint, Cint, Cint, Ptr{Cvoid}, ),
        ncid,
        varid,
        no_fill,
        ill_value,
    ))
end
function nc_inq_var_fill(ncid, varid, o_fill, ill_valuep, )
    check(ccall(
        (:nc_inq_var_fill, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Cint}, Ptr{Cvoid}, ),
        ncid,
        varid,
        o_fill,
        ill_valuep,
    ))
end
function nc_def_var_endian(ncid, varid, endian, )
    check(ccall(
        (:nc_def_var_endian, libnetcdf),
        Cint,
        (Cint, Cint, Cint, ),
        ncid,
        varid,
        endian,
    ))
end
function nc_inq_var_endian(ncid, varid, ndianp, )
    check(ccall(
        (:nc_inq_var_endian, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Cint}, ),
        ncid,
        varid,
        ndianp,
    ))
end
function nc_def_var_filter(ncid, varid, id, nparams, arms, )
    check(ccall(
        (:nc_def_var_filter, libnetcdf),
        Cint,
        (Cint, Cint, Cuint, Csize_t, Ptr{Cuint}, ),
        ncid,
        varid,
        id,
        nparams,
        arms,
    ))
end
function nc_inq_var_filter(ncid, varid, dp, params, arams, )
    check(ccall(
        (:nc_inq_var_filter, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Cuint}, Ptr{Csize_t}, Ptr{Cuint}, ),
        ncid,
        varid,
        dp,
        params,
        arams,
    ))
end
function nc_set_fill(ncid, fillmode, ld_modep, )
    check(ccall(
        (:nc_set_fill, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Cint}, ),
        ncid,
        fillmode,
        ld_modep,
    ))
end
function nc_set_default_format(format, ld_formatp, )
    check(ccall(
        (:nc_set_default_format, libnetcdf),
        Cint,
        (Cint, Ptr{Cint}, ),
        format,
        ld_formatp,
    ))
end
function nc_set_chunk_cache(size, nelems, preemption, )
    check(ccall(
        (:nc_set_chunk_cache, libnetcdf),
        Cint,
        (Csize_t, Csize_t, Cfloat, ),
        size,
        nelems,
        preemption,
    ))
end
function nc_get_chunk_cache(izep, elemsp, reemptionp, )
    check(ccall(
        (:nc_get_chunk_cache, libnetcdf),
        Cint,
        (Ptr{Csize_t}, Ptr{Csize_t}, Ptr{Cfloat}, ),
        izep,
        elemsp,
        reemptionp,
    ))
end
function nc_set_var_chunk_cache(ncid, varid, size, nelems, preemption, )
    check(ccall(
        (:nc_set_var_chunk_cache, libnetcdf),
        Cint,
        (Cint, Cint, Csize_t, Csize_t, Cfloat, ),
        ncid,
        varid,
        size,
        nelems,
        preemption,
    ))
end
function nc_get_var_chunk_cache(ncid, varid, izep, elemsp, reemptionp, )
    check(ccall(
        (:nc_get_var_chunk_cache, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{Cfloat}, ),
        ncid,
        varid,
        izep,
        elemsp,
        reemptionp,
    ))
end
function nc_redef(ncid, )
    check(ccall(
        (:nc_redef, libnetcdf),
        Cint,
        (Cint, ),
        ncid,
    ))
end
function nc__enddef(ncid, h_minfree, v_align, v_minfree, r_align, )
    check(ccall(
        (:nc__enddef, libnetcdf),
        Cint,
        (Cint, Csize_t, Csize_t, Csize_t, Csize_t, ),
        ncid,
        h_minfree,
        v_align,
        v_minfree,
        r_align,
    ))
end
function nc_enddef(ncid, )
    check(ccall(
        (:nc_enddef, libnetcdf),
        Cint,
        (Cint, ),
        ncid,
    ))
end
function nc_sync(ncid, )
    check(ccall(
        (:nc_sync, libnetcdf),
        Cint,
        (Cint, ),
        ncid,
    ))
end
function nc_abort(ncid, )
    check(ccall(
        (:nc_abort, libnetcdf),
        Cint,
        (Cint, ),
        ncid,
    ))
end
function nc_close(ncid, )
    check(ccall(
        (:nc_close, libnetcdf),
        Cint,
        (Cint, ),
        ncid,
    ))
end
function nc_inq(ncid, dimsp, varsp, attsp, nlimdimidp, )
    check(ccall(
        (:nc_inq, libnetcdf),
        Cint,
        (Cint, Ptr{Cint}, Ptr{Cint}, Ptr{Cint}, Ptr{Cint}, ),
        ncid,
        dimsp,
        varsp,
        attsp,
        nlimdimidp,
    ))
end
function nc_inq_ndims(ncid, dimsp, )
    check(ccall(
        (:nc_inq_ndims, libnetcdf),
        Cint,
        (Cint, Ptr{Cint}, ),
        ncid,
        dimsp,
    ))
end
function nc_inq_nvars(ncid, varsp, )
    check(ccall(
        (:nc_inq_nvars, libnetcdf),
        Cint,
        (Cint, Ptr{Cint}, ),
        ncid,
        varsp,
    ))
end
function nc_inq_natts(ncid, attsp, )
    check(ccall(
        (:nc_inq_natts, libnetcdf),
        Cint,
        (Cint, Ptr{Cint}, ),
        ncid,
        attsp,
    ))
end
function nc_inq_unlimdim(ncid, nlimdimidp, )
    check(ccall(
        (:nc_inq_unlimdim, libnetcdf),
        Cint,
        (Cint, Ptr{Cint}, ),
        ncid,
        nlimdimidp,
    ))
end
function nc_inq_unlimdims(ncid, unlimdimsp, nlimdimidsp, )
    check(ccall(
        (:nc_inq_unlimdims, libnetcdf),
        Cint,
        (Cint, Ptr{Cint}, Ptr{Cint}, ),
        ncid,
        unlimdimsp,
        nlimdimidsp,
    ))
end
function nc_inq_format(ncid, ormatp, )
    check(ccall(
        (:nc_inq_format, libnetcdf),
        Cint,
        (Cint, Ptr{Cint}, ),
        ncid,
        ormatp,
    ))
end
function nc_inq_format_extended(ncid, ormatp, odep, )
    check(ccall(
        (:nc_inq_format_extended, libnetcdf),
        Cint,
        (Cint, Ptr{Cint}, Ptr{Cint}, ),
        ncid,
        ormatp,
        odep,
    ))
end
function nc_def_dim(ncid, ame, len, dp, )
    check(ccall(
        (:nc_def_dim, libnetcdf),
        Cint,
        (Cint, Ptr{Cchar}, Csize_t, Ptr{Cint}, ),
        ncid,
        ame,
        len,
        dp,
    ))
end
function nc_inq_dimid(ncid, ame, dp, )
    check(ccall(
        (:nc_inq_dimid, libnetcdf),
        Cint,
        (Cint, Ptr{Cchar}, Ptr{Cint}, ),
        ncid,
        ame,
        dp,
    ))
end
function nc_inq_dim(ncid, dimid, ame, enp, )
    check(ccall(
        (:nc_inq_dim, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Cchar}, Ptr{Csize_t}, ),
        ncid,
        dimid,
        ame,
        enp,
    ))
end
function nc_inq_dimname(ncid, dimid, ame, )
    check(ccall(
        (:nc_inq_dimname, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Cchar}, ),
        ncid,
        dimid,
        ame,
    ))
end
function nc_inq_dimlen(ncid, dimid, enp, )
    check(ccall(
        (:nc_inq_dimlen, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Csize_t}, ),
        ncid,
        dimid,
        enp,
    ))
end
function nc_rename_dim(ncid, dimid, ame, )
    check(ccall(
        (:nc_rename_dim, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Cchar}, ),
        ncid,
        dimid,
        ame,
    ))
end
function nc_inq_att(ncid, varid, ame, typep, enp, )
    check(ccall(
        (:nc_inq_att, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Cchar}, Ptr{Cint}, Ptr{Csize_t}, ),
        ncid,
        varid,
        ame,
        typep,
        enp,
    ))
end
function nc_inq_attid(ncid, varid, ame, dp, )
    check(ccall(
        (:nc_inq_attid, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Cchar}, Ptr{Cint}, ),
        ncid,
        varid,
        ame,
        dp,
    ))
end
function nc_inq_atttype(ncid, varid, ame, typep, )
    check(ccall(
        (:nc_inq_atttype, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Cchar}, Ptr{Cint}, ),
        ncid,
        varid,
        ame,
        typep,
    ))
end
function nc_inq_attlen(ncid, varid, ame, enp, )
    check(ccall(
        (:nc_inq_attlen, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Cchar}, Ptr{Csize_t}, ),
        ncid,
        varid,
        ame,
        enp,
    ))
end
function nc_inq_attname(ncid, varid, attnum, ame, )
    check(ccall(
        (:nc_inq_attname, libnetcdf),
        Cint,
        (Cint, Cint, Cint, Ptr{Cchar}, ),
        ncid,
        varid,
        attnum,
        ame,
    ))
end
function nc_copy_att(ncid_in, varid_in, ame, ncid_out, varid_out, )
    check(ccall(
        (:nc_copy_att, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Cchar}, Cint, Cint, ),
        ncid_in,
        varid_in,
        ame,
        ncid_out,
        varid_out,
    ))
end
function nc_rename_att(ncid, varid, ame, ewname, )
    check(ccall(
        (:nc_rename_att, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Cchar}, Ptr{Cchar}, ),
        ncid,
        varid,
        ame,
        ewname,
    ))
end
function nc_del_att(ncid, varid, ame, )
    check(ccall(
        (:nc_del_att, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Cchar}, ),
        ncid,
        varid,
        ame,
    ))
end
function nc_put_att_text(ncid, varid, ame, len, p, )
    check(ccall(
        (:nc_put_att_text, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Cchar}, Csize_t, Ptr{Cchar}, ),
        ncid,
        varid,
        ame,
        len,
        p,
    ))
end
function nc_get_att_text(ncid, varid, ame, p, )
    check(ccall(
        (:nc_get_att_text, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Cchar}, Ptr{Cchar}, ),
        ncid,
        varid,
        ame,
        p,
    ))
end
function nc_put_att_string(ncid, varid, ame, len, op, )
    check(ccall(
        (:nc_put_att_string, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Cchar}, Csize_t, Ptr{Ptr{Cchar}}, ),
        ncid,
        varid,
        ame,
        len,
        op,
    ))
end
function nc_get_att_string(ncid, varid, ame, ip, )
    check(ccall(
        (:nc_get_att_string, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Cchar}, Ptr{Ptr{Cchar}}, ),
        ncid,
        varid,
        ame,
        ip,
    ))
end
function nc_put_att_uchar(ncid, varid, ame, xtype, len, p, )
    check(ccall(
        (:nc_put_att_uchar, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Cchar}, Cint, Csize_t, Ptr{Cuchar}, ),
        ncid,
        varid,
        ame,
        xtype,
        len,
        p,
    ))
end
function nc_get_att_uchar(ncid, varid, ame, p, )
    check(ccall(
        (:nc_get_att_uchar, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Cchar}, Ptr{Cuchar}, ),
        ncid,
        varid,
        ame,
        p,
    ))
end
function nc_put_att_schar(ncid, varid, ame, xtype, len, p, )
    check(ccall(
        (:nc_put_att_schar, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Cchar}, Cint, Csize_t, Ptr{Cchar}, ),
        ncid,
        varid,
        ame,
        xtype,
        len,
        p,
    ))
end
function nc_get_att_schar(ncid, varid, ame, p, )
    check(ccall(
        (:nc_get_att_schar, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Cchar}, Ptr{Cchar}, ),
        ncid,
        varid,
        ame,
        p,
    ))
end
function nc_put_att_short(ncid, varid, ame, xtype, len, p, )
    check(ccall(
        (:nc_put_att_short, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Cchar}, Cint, Csize_t, Ptr{Cshort}, ),
        ncid,
        varid,
        ame,
        xtype,
        len,
        p,
    ))
end
function nc_get_att_short(ncid, varid, ame, p, )
    check(ccall(
        (:nc_get_att_short, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Cchar}, Ptr{Cshort}, ),
        ncid,
        varid,
        ame,
        p,
    ))
end
function nc_put_att_int(ncid, varid, ame, xtype, len, p, )
    check(ccall(
        (:nc_put_att_int, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Cchar}, Cint, Csize_t, Ptr{Cint}, ),
        ncid,
        varid,
        ame,
        xtype,
        len,
        p,
    ))
end
function nc_get_att_int(ncid, varid, ame, p, )
    check(ccall(
        (:nc_get_att_int, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Cchar}, Ptr{Cint}, ),
        ncid,
        varid,
        ame,
        p,
    ))
end
function nc_put_att_long(ncid, varid, ame, xtype, len, p, )
    check(ccall(
        (:nc_put_att_long, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Cchar}, Cint, Csize_t, Ptr{Clong}, ),
        ncid,
        varid,
        ame,
        xtype,
        len,
        p,
    ))
end
function nc_get_att_long(ncid, varid, ame, p, )
    check(ccall(
        (:nc_get_att_long, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Cchar}, Ptr{Clong}, ),
        ncid,
        varid,
        ame,
        p,
    ))
end
function nc_put_att_float(ncid, varid, ame, xtype, len, p, )
    check(ccall(
        (:nc_put_att_float, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Cchar}, Cint, Csize_t, Ptr{Cfloat}, ),
        ncid,
        varid,
        ame,
        xtype,
        len,
        p,
    ))
end
function nc_get_att_float(ncid, varid, ame, p, )
    check(ccall(
        (:nc_get_att_float, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Cchar}, Ptr{Cfloat}, ),
        ncid,
        varid,
        ame,
        p,
    ))
end
function nc_put_att_double(ncid, varid, ame, xtype, len, p, )
    check(ccall(
        (:nc_put_att_double, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Cchar}, Cint, Csize_t, Ptr{Cdouble}, ),
        ncid,
        varid,
        ame,
        xtype,
        len,
        p,
    ))
end
function nc_get_att_double(ncid, varid, ame, p, )
    check(ccall(
        (:nc_get_att_double, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Cchar}, Ptr{Cdouble}, ),
        ncid,
        varid,
        ame,
        p,
    ))
end
function nc_put_att_ushort(ncid, varid, ame, xtype, len, p, )
    check(ccall(
        (:nc_put_att_ushort, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Cchar}, Cint, Csize_t, Ptr{Cushort}, ),
        ncid,
        varid,
        ame,
        xtype,
        len,
        p,
    ))
end
function nc_get_att_ushort(ncid, varid, ame, p, )
    check(ccall(
        (:nc_get_att_ushort, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Cchar}, Ptr{Cushort}, ),
        ncid,
        varid,
        ame,
        p,
    ))
end
function nc_put_att_uint(ncid, varid, ame, xtype, len, p, )
    check(ccall(
        (:nc_put_att_uint, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Cchar}, Cint, Csize_t, Ptr{Cuint}, ),
        ncid,
        varid,
        ame,
        xtype,
        len,
        p,
    ))
end
function nc_get_att_uint(ncid, varid, ame, p, )
    check(ccall(
        (:nc_get_att_uint, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Cchar}, Ptr{Cuint}, ),
        ncid,
        varid,
        ame,
        p,
    ))
end
function nc_put_att_longlong(ncid, varid, ame, xtype, len, p, )
    check(ccall(
        (:nc_put_att_longlong, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Cchar}, Cint, Csize_t, Ptr{Clonglong}, ),
        ncid,
        varid,
        ame,
        xtype,
        len,
        p,
    ))
end
function nc_get_att_longlong(ncid, varid, ame, p, )
    check(ccall(
        (:nc_get_att_longlong, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Cchar}, Ptr{Clonglong}, ),
        ncid,
        varid,
        ame,
        p,
    ))
end
function nc_put_att_ulonglong(ncid, varid, ame, xtype, len, p, )
    check(ccall(
        (:nc_put_att_ulonglong, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Cchar}, Cint, Csize_t, Ptr{Culonglong}, ),
        ncid,
        varid,
        ame,
        xtype,
        len,
        p,
    ))
end
function nc_get_att_ulonglong(ncid, varid, ame, p, )
    check(ccall(
        (:nc_get_att_ulonglong, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Cchar}, Ptr{Culonglong}, ),
        ncid,
        varid,
        ame,
        p,
    ))
end
function nc_def_var(ncid, ame, xtype, ndims, imidsp, aridp, )
    check(ccall(
        (:nc_def_var, libnetcdf),
        Cint,
        (Cint, Ptr{Cchar}, Cint, Cint, Ptr{Cint}, Ptr{Cint}, ),
        ncid,
        ame,
        xtype,
        ndims,
        imidsp,
        aridp,
    ))
end
function nc_inq_var(ncid, varid, ame, typep, dimsp, imidsp, attsp, )
    check(ccall(
        (:nc_inq_var, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Cchar}, Ptr{Cint}, Ptr{Cint}, Ptr{Cint}, Ptr{Cint}, ),
        ncid,
        varid,
        ame,
        typep,
        dimsp,
        imidsp,
        attsp,
    ))
end
function nc_inq_varid(ncid, ame, aridp, )
    check(ccall(
        (:nc_inq_varid, libnetcdf),
        Cint,
        (Cint, Ptr{Cchar}, Ptr{Cint}, ),
        ncid,
        ame,
        aridp,
    ))
end
function nc_inq_varname(ncid, varid, ame, )
    check(ccall(
        (:nc_inq_varname, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Cchar}, ),
        ncid,
        varid,
        ame,
    ))
end
function nc_inq_vartype(ncid, varid, typep, )
    check(ccall(
        (:nc_inq_vartype, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Cint}, ),
        ncid,
        varid,
        typep,
    ))
end
function nc_inq_varndims(ncid, varid, dimsp, )
    check(ccall(
        (:nc_inq_varndims, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Cint}, ),
        ncid,
        varid,
        dimsp,
    ))
end
function nc_inq_vardimid(ncid, varid, imidsp, )
    check(ccall(
        (:nc_inq_vardimid, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Cint}, ),
        ncid,
        varid,
        imidsp,
    ))
end
function nc_inq_varnatts(ncid, varid, attsp, )
    check(ccall(
        (:nc_inq_varnatts, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Cint}, ),
        ncid,
        varid,
        attsp,
    ))
end
function nc_rename_var(ncid, varid, ame, )
    check(ccall(
        (:nc_rename_var, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Cchar}, ),
        ncid,
        varid,
        ame,
    ))
end
function nc_copy_var(ncid_in, varid, ncid_out, )
    check(ccall(
        (:nc_copy_var, libnetcdf),
        Cint,
        (Cint, Cint, Cint, ),
        ncid_in,
        varid,
        ncid_out,
    ))
end
function nc_put_var1_text(ncid, varid, ndexp, p, )
    check(ccall(
        (:nc_put_var1_text, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Csize_t}, Ptr{Cchar}, ),
        ncid,
        varid,
        ndexp,
        p,
    ))
end
function nc_get_var1_text(ncid, varid, ndexp, p, )
    check(ccall(
        (:nc_get_var1_text, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Csize_t}, Ptr{Cchar}, ),
        ncid,
        varid,
        ndexp,
        p,
    ))
end
function nc_put_var1_uchar(ncid, varid, ndexp, p, )
    check(ccall(
        (:nc_put_var1_uchar, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Csize_t}, Ptr{Cuchar}, ),
        ncid,
        varid,
        ndexp,
        p,
    ))
end
function nc_get_var1_uchar(ncid, varid, ndexp, p, )
    check(ccall(
        (:nc_get_var1_uchar, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Csize_t}, Ptr{Cuchar}, ),
        ncid,
        varid,
        ndexp,
        p,
    ))
end
function nc_put_var1_schar(ncid, varid, ndexp, p, )
    check(ccall(
        (:nc_put_var1_schar, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Csize_t}, Ptr{Cchar}, ),
        ncid,
        varid,
        ndexp,
        p,
    ))
end
function nc_get_var1_schar(ncid, varid, ndexp, p, )
    check(ccall(
        (:nc_get_var1_schar, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Csize_t}, Ptr{Cchar}, ),
        ncid,
        varid,
        ndexp,
        p,
    ))
end
function nc_put_var1_short(ncid, varid, ndexp, p, )
    check(ccall(
        (:nc_put_var1_short, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Csize_t}, Ptr{Cshort}, ),
        ncid,
        varid,
        ndexp,
        p,
    ))
end
function nc_get_var1_short(ncid, varid, ndexp, p, )
    check(ccall(
        (:nc_get_var1_short, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Csize_t}, Ptr{Cshort}, ),
        ncid,
        varid,
        ndexp,
        p,
    ))
end
function nc_put_var1_int(ncid, varid, ndexp, p, )
    check(ccall(
        (:nc_put_var1_int, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Csize_t}, Ptr{Cint}, ),
        ncid,
        varid,
        ndexp,
        p,
    ))
end
function nc_get_var1_int(ncid, varid, ndexp, p, )
    check(ccall(
        (:nc_get_var1_int, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Csize_t}, Ptr{Cint}, ),
        ncid,
        varid,
        ndexp,
        p,
    ))
end
function nc_put_var1_long(ncid, varid, ndexp, p, )
    check(ccall(
        (:nc_put_var1_long, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Csize_t}, Ptr{Clong}, ),
        ncid,
        varid,
        ndexp,
        p,
    ))
end
function nc_get_var1_long(ncid, varid, ndexp, p, )
    check(ccall(
        (:nc_get_var1_long, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Csize_t}, Ptr{Clong}, ),
        ncid,
        varid,
        ndexp,
        p,
    ))
end
function nc_put_var1_float(ncid, varid, ndexp, p, )
    check(ccall(
        (:nc_put_var1_float, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Csize_t}, Ptr{Cfloat}, ),
        ncid,
        varid,
        ndexp,
        p,
    ))
end
function nc_get_var1_float(ncid, varid, ndexp, p, )
    check(ccall(
        (:nc_get_var1_float, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Csize_t}, Ptr{Cfloat}, ),
        ncid,
        varid,
        ndexp,
        p,
    ))
end
function nc_put_var1_double(ncid, varid, ndexp, p, )
    check(ccall(
        (:nc_put_var1_double, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Csize_t}, Ptr{Cdouble}, ),
        ncid,
        varid,
        ndexp,
        p,
    ))
end
function nc_get_var1_double(ncid, varid, ndexp, p, )
    check(ccall(
        (:nc_get_var1_double, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Csize_t}, Ptr{Cdouble}, ),
        ncid,
        varid,
        ndexp,
        p,
    ))
end
function nc_put_var1_ushort(ncid, varid, ndexp, p, )
    check(ccall(
        (:nc_put_var1_ushort, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Csize_t}, Ptr{Cushort}, ),
        ncid,
        varid,
        ndexp,
        p,
    ))
end
function nc_get_var1_ushort(ncid, varid, ndexp, p, )
    check(ccall(
        (:nc_get_var1_ushort, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Csize_t}, Ptr{Cushort}, ),
        ncid,
        varid,
        ndexp,
        p,
    ))
end
function nc_put_var1_uint(ncid, varid, ndexp, p, )
    check(ccall(
        (:nc_put_var1_uint, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Csize_t}, Ptr{Cuint}, ),
        ncid,
        varid,
        ndexp,
        p,
    ))
end
function nc_get_var1_uint(ncid, varid, ndexp, p, )
    check(ccall(
        (:nc_get_var1_uint, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Csize_t}, Ptr{Cuint}, ),
        ncid,
        varid,
        ndexp,
        p,
    ))
end
function nc_put_var1_longlong(ncid, varid, ndexp, p, )
    check(ccall(
        (:nc_put_var1_longlong, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Csize_t}, Ptr{Clonglong}, ),
        ncid,
        varid,
        ndexp,
        p,
    ))
end
function nc_get_var1_longlong(ncid, varid, ndexp, p, )
    check(ccall(
        (:nc_get_var1_longlong, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Csize_t}, Ptr{Clonglong}, ),
        ncid,
        varid,
        ndexp,
        p,
    ))
end
function nc_put_var1_ulonglong(ncid, varid, ndexp, p, )
    check(ccall(
        (:nc_put_var1_ulonglong, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Csize_t}, Ptr{Culonglong}, ),
        ncid,
        varid,
        ndexp,
        p,
    ))
end
function nc_get_var1_ulonglong(ncid, varid, ndexp, p, )
    check(ccall(
        (:nc_get_var1_ulonglong, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Csize_t}, Ptr{Culonglong}, ),
        ncid,
        varid,
        ndexp,
        p,
    ))
end
function nc_put_var1_string(ncid, varid, ndexp, op, )
    check(ccall(
        (:nc_put_var1_string, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Csize_t}, Ptr{Ptr{Cchar}}, ),
        ncid,
        varid,
        ndexp,
        op,
    ))
end
function nc_get_var1_string(ncid, varid, ndexp, ip, )
    check(ccall(
        (:nc_get_var1_string, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Csize_t}, Ptr{Ptr{Cchar}}, ),
        ncid,
        varid,
        ndexp,
        ip,
    ))
end
function nc_put_vara_text(ncid, varid, tartp, ountp, p, )
    check(ccall(
        (:nc_put_vara_text, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{Cchar}, ),
        ncid,
        varid,
        tartp,
        ountp,
        p,
    ))
end
function nc_get_vara_text(ncid, varid, tartp, ountp, p, )
    check(ccall(
        (:nc_get_vara_text, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{Cchar}, ),
        ncid,
        varid,
        tartp,
        ountp,
        p,
    ))
end
function nc_put_vara_uchar(ncid, varid, tartp, ountp, p, )
    check(ccall(
        (:nc_put_vara_uchar, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{Cuchar}, ),
        ncid,
        varid,
        tartp,
        ountp,
        p,
    ))
end
function nc_get_vara_uchar(ncid, varid, tartp, ountp, p, )
    check(ccall(
        (:nc_get_vara_uchar, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{Cuchar}, ),
        ncid,
        varid,
        tartp,
        ountp,
        p,
    ))
end
function nc_put_vara_schar(ncid, varid, tartp, ountp, p, )
    check(ccall(
        (:nc_put_vara_schar, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{Cchar}, ),
        ncid,
        varid,
        tartp,
        ountp,
        p,
    ))
end
function nc_get_vara_schar(ncid, varid, tartp, ountp, p, )
    check(ccall(
        (:nc_get_vara_schar, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{Cchar}, ),
        ncid,
        varid,
        tartp,
        ountp,
        p,
    ))
end
function nc_put_vara_short(ncid, varid, tartp, ountp, p, )
    check(ccall(
        (:nc_put_vara_short, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{Cshort}, ),
        ncid,
        varid,
        tartp,
        ountp,
        p,
    ))
end
function nc_get_vara_short(ncid, varid, tartp, ountp, p, )
    check(ccall(
        (:nc_get_vara_short, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{Cshort}, ),
        ncid,
        varid,
        tartp,
        ountp,
        p,
    ))
end
function nc_put_vara_int(ncid, varid, tartp, ountp, p, )
    check(ccall(
        (:nc_put_vara_int, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{Cint}, ),
        ncid,
        varid,
        tartp,
        ountp,
        p,
    ))
end
function nc_get_vara_int(ncid, varid, tartp, ountp, p, )
    check(ccall(
        (:nc_get_vara_int, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{Cint}, ),
        ncid,
        varid,
        tartp,
        ountp,
        p,
    ))
end
function nc_put_vara_long(ncid, varid, tartp, ountp, p, )
    check(ccall(
        (:nc_put_vara_long, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{Clong}, ),
        ncid,
        varid,
        tartp,
        ountp,
        p,
    ))
end
function nc_get_vara_long(ncid, varid, tartp, ountp, p, )
    check(ccall(
        (:nc_get_vara_long, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{Clong}, ),
        ncid,
        varid,
        tartp,
        ountp,
        p,
    ))
end
function nc_put_vara_float(ncid, varid, tartp, ountp, p, )
    check(ccall(
        (:nc_put_vara_float, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{Cfloat}, ),
        ncid,
        varid,
        tartp,
        ountp,
        p,
    ))
end
function nc_get_vara_float(ncid, varid, tartp, ountp, p, )
    check(ccall(
        (:nc_get_vara_float, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{Cfloat}, ),
        ncid,
        varid,
        tartp,
        ountp,
        p,
    ))
end
function nc_put_vara_double(ncid, varid, tartp, ountp, p, )
    check(ccall(
        (:nc_put_vara_double, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{Cdouble}, ),
        ncid,
        varid,
        tartp,
        ountp,
        p,
    ))
end
function nc_get_vara_double(ncid, varid, tartp, ountp, p, )
    check(ccall(
        (:nc_get_vara_double, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{Cdouble}, ),
        ncid,
        varid,
        tartp,
        ountp,
        p,
    ))
end
function nc_put_vara_ushort(ncid, varid, tartp, ountp, p, )
    check(ccall(
        (:nc_put_vara_ushort, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{Cushort}, ),
        ncid,
        varid,
        tartp,
        ountp,
        p,
    ))
end
function nc_get_vara_ushort(ncid, varid, tartp, ountp, p, )
    check(ccall(
        (:nc_get_vara_ushort, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{Cushort}, ),
        ncid,
        varid,
        tartp,
        ountp,
        p,
    ))
end
function nc_put_vara_uint(ncid, varid, tartp, ountp, p, )
    check(ccall(
        (:nc_put_vara_uint, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{Cuint}, ),
        ncid,
        varid,
        tartp,
        ountp,
        p,
    ))
end
function nc_get_vara_uint(ncid, varid, tartp, ountp, p, )
    check(ccall(
        (:nc_get_vara_uint, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{Cuint}, ),
        ncid,
        varid,
        tartp,
        ountp,
        p,
    ))
end
function nc_put_vara_longlong(ncid, varid, tartp, ountp, p, )
    check(ccall(
        (:nc_put_vara_longlong, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{Clonglong}, ),
        ncid,
        varid,
        tartp,
        ountp,
        p,
    ))
end
function nc_get_vara_longlong(ncid, varid, tartp, ountp, p, )
    check(ccall(
        (:nc_get_vara_longlong, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{Clonglong}, ),
        ncid,
        varid,
        tartp,
        ountp,
        p,
    ))
end
function nc_put_vara_ulonglong(ncid, varid, tartp, ountp, p, )
    check(ccall(
        (:nc_put_vara_ulonglong, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{Culonglong}, ),
        ncid,
        varid,
        tartp,
        ountp,
        p,
    ))
end
function nc_get_vara_ulonglong(ncid, varid, tartp, ountp, p, )
    check(ccall(
        (:nc_get_vara_ulonglong, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{Culonglong}, ),
        ncid,
        varid,
        tartp,
        ountp,
        p,
    ))
end
function nc_put_vara_string(ncid, varid, tartp, ountp, op, )
    check(ccall(
        (:nc_put_vara_string, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{Ptr{Cchar}}, ),
        ncid,
        varid,
        tartp,
        ountp,
        op,
    ))
end
function nc_get_vara_string(ncid, varid, tartp, ountp, ip, )
    check(ccall(
        (:nc_get_vara_string, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{Ptr{Cchar}}, ),
        ncid,
        varid,
        tartp,
        ountp,
        ip,
    ))
end
function nc_put_vars_text(ncid, varid, tartp, ountp, tridep, p, )
    check(ccall(
        (:nc_put_vars_text, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{Cptrdiff_t}, Ptr{Cchar}, ),
        ncid,
        varid,
        tartp,
        ountp,
        tridep,
        p,
    ))
end
function nc_get_vars_text(ncid, varid, tartp, ountp, tridep, p, )
    check(ccall(
        (:nc_get_vars_text, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{Cptrdiff_t}, Ptr{Cchar}, ),
        ncid,
        varid,
        tartp,
        ountp,
        tridep,
        p,
    ))
end
function nc_put_vars_uchar(ncid, varid, tartp, ountp, tridep, p, )
    check(ccall(
        (:nc_put_vars_uchar, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{Cptrdiff_t}, Ptr{Cuchar}, ),
        ncid,
        varid,
        tartp,
        ountp,
        tridep,
        p,
    ))
end
function nc_get_vars_uchar(ncid, varid, tartp, ountp, tridep, p, )
    check(ccall(
        (:nc_get_vars_uchar, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{Cptrdiff_t}, Ptr{Cuchar}, ),
        ncid,
        varid,
        tartp,
        ountp,
        tridep,
        p,
    ))
end
function nc_put_vars_schar(ncid, varid, tartp, ountp, tridep, p, )
    check(ccall(
        (:nc_put_vars_schar, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{Cptrdiff_t}, Ptr{Cchar}, ),
        ncid,
        varid,
        tartp,
        ountp,
        tridep,
        p,
    ))
end
function nc_get_vars_schar(ncid, varid, tartp, ountp, tridep, p, )
    check(ccall(
        (:nc_get_vars_schar, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{Cptrdiff_t}, Ptr{Cchar}, ),
        ncid,
        varid,
        tartp,
        ountp,
        tridep,
        p,
    ))
end
function nc_put_vars_short(ncid, varid, tartp, ountp, tridep, p, )
    check(ccall(
        (:nc_put_vars_short, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{Cptrdiff_t}, Ptr{Cshort}, ),
        ncid,
        varid,
        tartp,
        ountp,
        tridep,
        p,
    ))
end
function nc_get_vars_short(ncid, varid, tartp, ountp, tridep, p, )
    check(ccall(
        (:nc_get_vars_short, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{Cptrdiff_t}, Ptr{Cshort}, ),
        ncid,
        varid,
        tartp,
        ountp,
        tridep,
        p,
    ))
end
function nc_put_vars_int(ncid, varid, tartp, ountp, tridep, p, )
    check(ccall(
        (:nc_put_vars_int, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{Cptrdiff_t}, Ptr{Cint}, ),
        ncid,
        varid,
        tartp,
        ountp,
        tridep,
        p,
    ))
end
function nc_get_vars_int(ncid, varid, tartp, ountp, tridep, p, )
    check(ccall(
        (:nc_get_vars_int, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{Cptrdiff_t}, Ptr{Cint}, ),
        ncid,
        varid,
        tartp,
        ountp,
        tridep,
        p,
    ))
end
function nc_put_vars_long(ncid, varid, tartp, ountp, tridep, p, )
    check(ccall(
        (:nc_put_vars_long, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{Cptrdiff_t}, Ptr{Clong}, ),
        ncid,
        varid,
        tartp,
        ountp,
        tridep,
        p,
    ))
end
function nc_get_vars_long(ncid, varid, tartp, ountp, tridep, p, )
    check(ccall(
        (:nc_get_vars_long, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{Cptrdiff_t}, Ptr{Clong}, ),
        ncid,
        varid,
        tartp,
        ountp,
        tridep,
        p,
    ))
end
function nc_put_vars_float(ncid, varid, tartp, ountp, tridep, p, )
    check(ccall(
        (:nc_put_vars_float, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{Cptrdiff_t}, Ptr{Cfloat}, ),
        ncid,
        varid,
        tartp,
        ountp,
        tridep,
        p,
    ))
end
function nc_get_vars_float(ncid, varid, tartp, ountp, tridep, p, )
    check(ccall(
        (:nc_get_vars_float, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{Cptrdiff_t}, Ptr{Cfloat}, ),
        ncid,
        varid,
        tartp,
        ountp,
        tridep,
        p,
    ))
end
function nc_put_vars_double(ncid, varid, tartp, ountp, tridep, p, )
    check(ccall(
        (:nc_put_vars_double, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{Cptrdiff_t}, Ptr{Cdouble}, ),
        ncid,
        varid,
        tartp,
        ountp,
        tridep,
        p,
    ))
end
function nc_get_vars_double(ncid, varid, tartp, ountp, tridep, p, )
    check(ccall(
        (:nc_get_vars_double, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{Cptrdiff_t}, Ptr{Cdouble}, ),
        ncid,
        varid,
        tartp,
        ountp,
        tridep,
        p,
    ))
end
function nc_put_vars_ushort(ncid, varid, tartp, ountp, tridep, p, )
    check(ccall(
        (:nc_put_vars_ushort, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{Cptrdiff_t}, Ptr{Cushort}, ),
        ncid,
        varid,
        tartp,
        ountp,
        tridep,
        p,
    ))
end
function nc_get_vars_ushort(ncid, varid, tartp, ountp, tridep, p, )
    check(ccall(
        (:nc_get_vars_ushort, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{Cptrdiff_t}, Ptr{Cushort}, ),
        ncid,
        varid,
        tartp,
        ountp,
        tridep,
        p,
    ))
end
function nc_put_vars_uint(ncid, varid, tartp, ountp, tridep, p, )
    check(ccall(
        (:nc_put_vars_uint, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{Cptrdiff_t}, Ptr{Cuint}, ),
        ncid,
        varid,
        tartp,
        ountp,
        tridep,
        p,
    ))
end
function nc_get_vars_uint(ncid, varid, tartp, ountp, tridep, p, )
    check(ccall(
        (:nc_get_vars_uint, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{Cptrdiff_t}, Ptr{Cuint}, ),
        ncid,
        varid,
        tartp,
        ountp,
        tridep,
        p,
    ))
end
function nc_put_vars_longlong(ncid, varid, tartp, ountp, tridep, p, )
    check(ccall(
        (:nc_put_vars_longlong, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{Cptrdiff_t}, Ptr{Clonglong}, ),
        ncid,
        varid,
        tartp,
        ountp,
        tridep,
        p,
    ))
end
function nc_get_vars_longlong(ncid, varid, tartp, ountp, tridep, p, )
    check(ccall(
        (:nc_get_vars_longlong, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{Cptrdiff_t}, Ptr{Clonglong}, ),
        ncid,
        varid,
        tartp,
        ountp,
        tridep,
        p,
    ))
end
function nc_put_vars_ulonglong(ncid, varid, tartp, ountp, tridep, p, )
    check(ccall(
        (:nc_put_vars_ulonglong, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{Cptrdiff_t}, Ptr{Culonglong}, ),
        ncid,
        varid,
        tartp,
        ountp,
        tridep,
        p,
    ))
end
function nc_get_vars_ulonglong(ncid, varid, tartp, ountp, tridep, p, )
    check(ccall(
        (:nc_get_vars_ulonglong, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{Cptrdiff_t}, Ptr{Culonglong}, ),
        ncid,
        varid,
        tartp,
        ountp,
        tridep,
        p,
    ))
end
function nc_put_vars_string(ncid, varid, tartp, ountp, tridep, op, )
    check(ccall(
        (:nc_put_vars_string, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{Cptrdiff_t}, Ptr{Ptr{Cchar}}, ),
        ncid,
        varid,
        tartp,
        ountp,
        tridep,
        op,
    ))
end
function nc_get_vars_string(ncid, varid, tartp, ountp, tridep, ip, )
    check(ccall(
        (:nc_get_vars_string, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{Cptrdiff_t}, Ptr{Ptr{Cchar}}, ),
        ncid,
        varid,
        tartp,
        ountp,
        tridep,
        ip,
    ))
end
function nc_put_varm_text(ncid, varid, tartp, ountp, tridep, mapp, p, )
    check(ccall(
        (:nc_put_varm_text, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{Cptrdiff_t}, Ptr{Cptrdiff_t}, Ptr{Cchar}, ),
        ncid,
        varid,
        tartp,
        ountp,
        tridep,
        mapp,
        p,
    ))
end
function nc_get_varm_text(ncid, varid, tartp, ountp, tridep, mapp, p, )
    check(ccall(
        (:nc_get_varm_text, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{Cptrdiff_t}, Ptr{Cptrdiff_t}, Ptr{Cchar}, ),
        ncid,
        varid,
        tartp,
        ountp,
        tridep,
        mapp,
        p,
    ))
end
function nc_put_varm_uchar(ncid, varid, tartp, ountp, tridep, mapp, p, )
    check(ccall(
        (:nc_put_varm_uchar, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{Cptrdiff_t}, Ptr{Cptrdiff_t}, Ptr{Cuchar}, ),
        ncid,
        varid,
        tartp,
        ountp,
        tridep,
        mapp,
        p,
    ))
end
function nc_get_varm_uchar(ncid, varid, tartp, ountp, tridep, mapp, p, )
    check(ccall(
        (:nc_get_varm_uchar, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{Cptrdiff_t}, Ptr{Cptrdiff_t}, Ptr{Cuchar}, ),
        ncid,
        varid,
        tartp,
        ountp,
        tridep,
        mapp,
        p,
    ))
end
function nc_put_varm_schar(ncid, varid, tartp, ountp, tridep, mapp, p, )
    check(ccall(
        (:nc_put_varm_schar, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{Cptrdiff_t}, Ptr{Cptrdiff_t}, Ptr{Cchar}, ),
        ncid,
        varid,
        tartp,
        ountp,
        tridep,
        mapp,
        p,
    ))
end
function nc_get_varm_schar(ncid, varid, tartp, ountp, tridep, mapp, p, )
    check(ccall(
        (:nc_get_varm_schar, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{Cptrdiff_t}, Ptr{Cptrdiff_t}, Ptr{Cchar}, ),
        ncid,
        varid,
        tartp,
        ountp,
        tridep,
        mapp,
        p,
    ))
end
function nc_put_varm_short(ncid, varid, tartp, ountp, tridep, mapp, p, )
    check(ccall(
        (:nc_put_varm_short, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{Cptrdiff_t}, Ptr{Cptrdiff_t}, Ptr{Cshort}, ),
        ncid,
        varid,
        tartp,
        ountp,
        tridep,
        mapp,
        p,
    ))
end
function nc_get_varm_short(ncid, varid, tartp, ountp, tridep, mapp, p, )
    check(ccall(
        (:nc_get_varm_short, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{Cptrdiff_t}, Ptr{Cptrdiff_t}, Ptr{Cshort}, ),
        ncid,
        varid,
        tartp,
        ountp,
        tridep,
        mapp,
        p,
    ))
end
function nc_put_varm_int(ncid, varid, tartp, ountp, tridep, mapp, p, )
    check(ccall(
        (:nc_put_varm_int, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{Cptrdiff_t}, Ptr{Cptrdiff_t}, Ptr{Cint}, ),
        ncid,
        varid,
        tartp,
        ountp,
        tridep,
        mapp,
        p,
    ))
end
function nc_get_varm_int(ncid, varid, tartp, ountp, tridep, mapp, p, )
    check(ccall(
        (:nc_get_varm_int, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{Cptrdiff_t}, Ptr{Cptrdiff_t}, Ptr{Cint}, ),
        ncid,
        varid,
        tartp,
        ountp,
        tridep,
        mapp,
        p,
    ))
end
function nc_put_varm_long(ncid, varid, tartp, ountp, tridep, mapp, p, )
    check(ccall(
        (:nc_put_varm_long, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{Cptrdiff_t}, Ptr{Cptrdiff_t}, Ptr{Clong}, ),
        ncid,
        varid,
        tartp,
        ountp,
        tridep,
        mapp,
        p,
    ))
end
function nc_get_varm_long(ncid, varid, tartp, ountp, tridep, mapp, p, )
    check(ccall(
        (:nc_get_varm_long, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{Cptrdiff_t}, Ptr{Cptrdiff_t}, Ptr{Clong}, ),
        ncid,
        varid,
        tartp,
        ountp,
        tridep,
        mapp,
        p,
    ))
end
function nc_put_varm_float(ncid, varid, tartp, ountp, tridep, mapp, p, )
    check(ccall(
        (:nc_put_varm_float, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{Cptrdiff_t}, Ptr{Cptrdiff_t}, Ptr{Cfloat}, ),
        ncid,
        varid,
        tartp,
        ountp,
        tridep,
        mapp,
        p,
    ))
end
function nc_get_varm_float(ncid, varid, tartp, ountp, tridep, mapp, p, )
    check(ccall(
        (:nc_get_varm_float, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{Cptrdiff_t}, Ptr{Cptrdiff_t}, Ptr{Cfloat}, ),
        ncid,
        varid,
        tartp,
        ountp,
        tridep,
        mapp,
        p,
    ))
end
function nc_put_varm_double(ncid, varid, tartp, ountp, tridep, mapp, p, )
    check(ccall(
        (:nc_put_varm_double, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{Cptrdiff_t}, Ptr{Cptrdiff_t}, Ptr{Cdouble}, ),
        ncid,
        varid,
        tartp,
        ountp,
        tridep,
        mapp,
        p,
    ))
end
function nc_get_varm_double(ncid, varid, tartp, ountp, tridep, mapp, p, )
    check(ccall(
        (:nc_get_varm_double, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{Cptrdiff_t}, Ptr{Cptrdiff_t}, Ptr{Cdouble}, ),
        ncid,
        varid,
        tartp,
        ountp,
        tridep,
        mapp,
        p,
    ))
end
function nc_put_varm_ushort(ncid, varid, tartp, ountp, tridep, mapp, p, )
    check(ccall(
        (:nc_put_varm_ushort, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{Cptrdiff_t}, Ptr{Cptrdiff_t}, Ptr{Cushort}, ),
        ncid,
        varid,
        tartp,
        ountp,
        tridep,
        mapp,
        p,
    ))
end
function nc_get_varm_ushort(ncid, varid, tartp, ountp, tridep, mapp, p, )
    check(ccall(
        (:nc_get_varm_ushort, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{Cptrdiff_t}, Ptr{Cptrdiff_t}, Ptr{Cushort}, ),
        ncid,
        varid,
        tartp,
        ountp,
        tridep,
        mapp,
        p,
    ))
end
function nc_put_varm_uint(ncid, varid, tartp, ountp, tridep, mapp, p, )
    check(ccall(
        (:nc_put_varm_uint, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{Cptrdiff_t}, Ptr{Cptrdiff_t}, Ptr{Cuint}, ),
        ncid,
        varid,
        tartp,
        ountp,
        tridep,
        mapp,
        p,
    ))
end
function nc_get_varm_uint(ncid, varid, tartp, ountp, tridep, mapp, p, )
    check(ccall(
        (:nc_get_varm_uint, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{Cptrdiff_t}, Ptr{Cptrdiff_t}, Ptr{Cuint}, ),
        ncid,
        varid,
        tartp,
        ountp,
        tridep,
        mapp,
        p,
    ))
end
function nc_put_varm_longlong(ncid, varid, tartp, ountp, tridep, mapp, p, )
    check(ccall(
        (:nc_put_varm_longlong, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{Cptrdiff_t}, Ptr{Cptrdiff_t}, Ptr{Clonglong}, ),
        ncid,
        varid,
        tartp,
        ountp,
        tridep,
        mapp,
        p,
    ))
end
function nc_get_varm_longlong(ncid, varid, tartp, ountp, tridep, mapp, p, )
    check(ccall(
        (:nc_get_varm_longlong, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{Cptrdiff_t}, Ptr{Cptrdiff_t}, Ptr{Clonglong}, ),
        ncid,
        varid,
        tartp,
        ountp,
        tridep,
        mapp,
        p,
    ))
end
function nc_put_varm_ulonglong(ncid, varid, tartp, ountp, tridep, mapp, p, )
    check(ccall(
        (:nc_put_varm_ulonglong, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{Cptrdiff_t}, Ptr{Cptrdiff_t}, Ptr{Culonglong}, ),
        ncid,
        varid,
        tartp,
        ountp,
        tridep,
        mapp,
        p,
    ))
end
function nc_get_varm_ulonglong(ncid, varid, tartp, ountp, tridep, mapp, p, )
    check(ccall(
        (:nc_get_varm_ulonglong, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{Cptrdiff_t}, Ptr{Cptrdiff_t}, Ptr{Culonglong}, ),
        ncid,
        varid,
        tartp,
        ountp,
        tridep,
        mapp,
        p,
    ))
end
function nc_put_varm_string(ncid, varid, tartp, ountp, tridep, mapp, op, )
    check(ccall(
        (:nc_put_varm_string, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{Cptrdiff_t}, Ptr{Cptrdiff_t}, Ptr{Ptr{Cchar}}, ),
        ncid,
        varid,
        tartp,
        ountp,
        tridep,
        mapp,
        op,
    ))
end
function nc_get_varm_string(ncid, varid, tartp, ountp, tridep, mapp, ip, )
    check(ccall(
        (:nc_get_varm_string, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{Cptrdiff_t}, Ptr{Cptrdiff_t}, Ptr{Ptr{Cchar}}, ),
        ncid,
        varid,
        tartp,
        ountp,
        tridep,
        mapp,
        ip,
    ))
end
function nc_put_var_text(ncid, varid, p, )
    check(ccall(
        (:nc_put_var_text, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Cchar}, ),
        ncid,
        varid,
        p,
    ))
end
function nc_get_var_text(ncid, varid, p, )
    check(ccall(
        (:nc_get_var_text, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Cchar}, ),
        ncid,
        varid,
        p,
    ))
end
function nc_put_var_uchar(ncid, varid, p, )
    check(ccall(
        (:nc_put_var_uchar, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Cuchar}, ),
        ncid,
        varid,
        p,
    ))
end
function nc_get_var_uchar(ncid, varid, p, )
    check(ccall(
        (:nc_get_var_uchar, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Cuchar}, ),
        ncid,
        varid,
        p,
    ))
end
function nc_put_var_schar(ncid, varid, p, )
    check(ccall(
        (:nc_put_var_schar, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Cchar}, ),
        ncid,
        varid,
        p,
    ))
end
function nc_get_var_schar(ncid, varid, p, )
    check(ccall(
        (:nc_get_var_schar, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Cchar}, ),
        ncid,
        varid,
        p,
    ))
end
function nc_put_var_short(ncid, varid, p, )
    check(ccall(
        (:nc_put_var_short, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Cshort}, ),
        ncid,
        varid,
        p,
    ))
end
function nc_get_var_short(ncid, varid, p, )
    check(ccall(
        (:nc_get_var_short, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Cshort}, ),
        ncid,
        varid,
        p,
    ))
end
function nc_put_var_int(ncid, varid, p, )
    check(ccall(
        (:nc_put_var_int, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Cint}, ),
        ncid,
        varid,
        p,
    ))
end
function nc_get_var_int(ncid, varid, p, )
    check(ccall(
        (:nc_get_var_int, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Cint}, ),
        ncid,
        varid,
        p,
    ))
end
function nc_put_var_long(ncid, varid, p, )
    check(ccall(
        (:nc_put_var_long, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Clong}, ),
        ncid,
        varid,
        p,
    ))
end
function nc_get_var_long(ncid, varid, p, )
    check(ccall(
        (:nc_get_var_long, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Clong}, ),
        ncid,
        varid,
        p,
    ))
end
function nc_put_var_float(ncid, varid, p, )
    check(ccall(
        (:nc_put_var_float, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Cfloat}, ),
        ncid,
        varid,
        p,
    ))
end
function nc_get_var_float(ncid, varid, p, )
    check(ccall(
        (:nc_get_var_float, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Cfloat}, ),
        ncid,
        varid,
        p,
    ))
end
function nc_put_var_double(ncid, varid, p, )
    check(ccall(
        (:nc_put_var_double, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Cdouble}, ),
        ncid,
        varid,
        p,
    ))
end
function nc_get_var_double(ncid, varid, p, )
    check(ccall(
        (:nc_get_var_double, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Cdouble}, ),
        ncid,
        varid,
        p,
    ))
end
function nc_put_var_ushort(ncid, varid, p, )
    check(ccall(
        (:nc_put_var_ushort, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Cushort}, ),
        ncid,
        varid,
        p,
    ))
end
function nc_get_var_ushort(ncid, varid, p, )
    check(ccall(
        (:nc_get_var_ushort, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Cushort}, ),
        ncid,
        varid,
        p,
    ))
end
function nc_put_var_uint(ncid, varid, p, )
    check(ccall(
        (:nc_put_var_uint, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Cuint}, ),
        ncid,
        varid,
        p,
    ))
end
function nc_get_var_uint(ncid, varid, p, )
    check(ccall(
        (:nc_get_var_uint, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Cuint}, ),
        ncid,
        varid,
        p,
    ))
end
function nc_put_var_longlong(ncid, varid, p, )
    check(ccall(
        (:nc_put_var_longlong, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Clonglong}, ),
        ncid,
        varid,
        p,
    ))
end
function nc_get_var_longlong(ncid, varid, p, )
    check(ccall(
        (:nc_get_var_longlong, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Clonglong}, ),
        ncid,
        varid,
        p,
    ))
end
function nc_put_var_ulonglong(ncid, varid, p, )
    check(ccall(
        (:nc_put_var_ulonglong, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Culonglong}, ),
        ncid,
        varid,
        p,
    ))
end
function nc_get_var_ulonglong(ncid, varid, p, )
    check(ccall(
        (:nc_get_var_ulonglong, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Culonglong}, ),
        ncid,
        varid,
        p,
    ))
end
function nc_put_var_string(ncid, varid, op, )
    check(ccall(
        (:nc_put_var_string, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Ptr{Cchar}}, ),
        ncid,
        varid,
        op,
    ))
end
function nc_get_var_string(ncid, varid, ip, )
    check(ccall(
        (:nc_get_var_string, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Ptr{Cchar}}, ),
        ncid,
        varid,
        ip,
    ))
end
function nc_put_att_ubyte(ncid, varid, ame, xtype, len, p, )
    check(ccall(
        (:nc_put_att_ubyte, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Cchar}, Cint, Csize_t, Ptr{Cuchar}, ),
        ncid,
        varid,
        ame,
        xtype,
        len,
        p,
    ))
end
function nc_get_att_ubyte(ncid, varid, ame, p, )
    check(ccall(
        (:nc_get_att_ubyte, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Cchar}, Ptr{Cuchar}, ),
        ncid,
        varid,
        ame,
        p,
    ))
end
function nc_put_var1_ubyte(ncid, varid, ndexp, p, )
    check(ccall(
        (:nc_put_var1_ubyte, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Csize_t}, Ptr{Cuchar}, ),
        ncid,
        varid,
        ndexp,
        p,
    ))
end
function nc_get_var1_ubyte(ncid, varid, ndexp, p, )
    check(ccall(
        (:nc_get_var1_ubyte, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Csize_t}, Ptr{Cuchar}, ),
        ncid,
        varid,
        ndexp,
        p,
    ))
end
function nc_put_vara_ubyte(ncid, varid, tartp, ountp, p, )
    check(ccall(
        (:nc_put_vara_ubyte, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{Cuchar}, ),
        ncid,
        varid,
        tartp,
        ountp,
        p,
    ))
end
function nc_get_vara_ubyte(ncid, varid, tartp, ountp, p, )
    check(ccall(
        (:nc_get_vara_ubyte, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{Cuchar}, ),
        ncid,
        varid,
        tartp,
        ountp,
        p,
    ))
end
function nc_put_vars_ubyte(ncid, varid, tartp, ountp, tridep, p, )
    check(ccall(
        (:nc_put_vars_ubyte, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{Cptrdiff_t}, Ptr{Cuchar}, ),
        ncid,
        varid,
        tartp,
        ountp,
        tridep,
        p,
    ))
end
function nc_get_vars_ubyte(ncid, varid, tartp, ountp, tridep, p, )
    check(ccall(
        (:nc_get_vars_ubyte, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{Cptrdiff_t}, Ptr{Cuchar}, ),
        ncid,
        varid,
        tartp,
        ountp,
        tridep,
        p,
    ))
end
function nc_put_varm_ubyte(ncid, varid, tartp, ountp, tridep, mapp, p, )
    check(ccall(
        (:nc_put_varm_ubyte, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{Cptrdiff_t}, Ptr{Cptrdiff_t}, Ptr{Cuchar}, ),
        ncid,
        varid,
        tartp,
        ountp,
        tridep,
        mapp,
        p,
    ))
end
function nc_get_varm_ubyte(ncid, varid, tartp, ountp, tridep, mapp, p, )
    check(ccall(
        (:nc_get_varm_ubyte, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Csize_t}, Ptr{Csize_t}, Ptr{Cptrdiff_t}, Ptr{Cptrdiff_t}, Ptr{Cuchar}, ),
        ncid,
        varid,
        tartp,
        ountp,
        tridep,
        mapp,
        p,
    ))
end
function nc_put_var_ubyte(ncid, varid, p, )
    check(ccall(
        (:nc_put_var_ubyte, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Cuchar}, ),
        ncid,
        varid,
        p,
    ))
end
function nc_get_var_ubyte(ncid, varid, p, )
    check(ccall(
        (:nc_get_var_ubyte, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Cuchar}, ),
        ncid,
        varid,
        p,
    ))
end
function nc_set_log_level(new_level, )
    check(ccall(
        (:nc_set_log_level, libnetcdf),
        Cint,
        (Cint, ),
        new_level,
    ))
end
function nc_show_metadata(ncid, )
    check(ccall(
        (:nc_show_metadata, libnetcdf),
        Cint,
        (Cint, ),
        ncid,
    ))
end
function nc_delete(ath, )
    check(ccall(
        (:nc_delete, libnetcdf),
        Cint,
        (Ptr{Cchar}, ),
        ath,
    ))
end
function nc__create_mp(ath, cmode, initialsz, basepe, hunksizehintp, cidp, )
    check(ccall(
        (:nc__create_mp, libnetcdf),
        Cint,
        (Ptr{Cchar}, Cint, Csize_t, Cint, Ptr{Csize_t}, Ptr{Cint}, ),
        ath,
        cmode,
        initialsz,
        basepe,
        hunksizehintp,
        cidp,
    ))
end
function nc__open_mp(ath, mode, basepe, hunksizehintp, cidp, )
    check(ccall(
        (:nc__open_mp, libnetcdf),
        Cint,
        (Ptr{Cchar}, Cint, Cint, Ptr{Csize_t}, Ptr{Cint}, ),
        ath,
        mode,
        basepe,
        hunksizehintp,
        cidp,
    ))
end
function nc_delete_mp(ath, basepe, )
    check(ccall(
        (:nc_delete_mp, libnetcdf),
        Cint,
        (Ptr{Cchar}, Cint, ),
        ath,
        basepe,
    ))
end
function nc_set_base_pe(ncid, pe, )
    check(ccall(
        (:nc_set_base_pe, libnetcdf),
        Cint,
        (Cint, Cint, ),
        ncid,
        pe,
    ))
end
function nc_inq_base_pe(ncid, e, )
    check(ccall(
        (:nc_inq_base_pe, libnetcdf),
        Cint,
        (Cint, Ptr{Cint}, ),
        ncid,
        e,
    ))
end
function nctypelen(datatype, )
    check(ccall(
        (:nctypelen, libnetcdf),
        Cint,
        (Cint, ),
        datatype,
    ))
end
function nccreate(ath, cmode, )
    check(ccall(
        (:nccreate, libnetcdf),
        Cint,
        (Ptr{Cchar}, Cint, ),
        ath,
        cmode,
    ))
end
function ncopen(ath, mode, )
    check(ccall(
        (:ncopen, libnetcdf),
        Cint,
        (Ptr{Cchar}, Cint, ),
        ath,
        mode,
    ))
end
function ncsetfill(ncid, fillmode, )
    check(ccall(
        (:ncsetfill, libnetcdf),
        Cint,
        (Cint, Cint, ),
        ncid,
        fillmode,
    ))
end
function ncredef(ncid, )
    check(ccall(
        (:ncredef, libnetcdf),
        Cint,
        (Cint, ),
        ncid,
    ))
end
function ncendef(ncid, )
    check(ccall(
        (:ncendef, libnetcdf),
        Cint,
        (Cint, ),
        ncid,
    ))
end
function ncsync(ncid, )
    check(ccall(
        (:ncsync, libnetcdf),
        Cint,
        (Cint, ),
        ncid,
    ))
end
function ncabort(ncid, )
    check(ccall(
        (:ncabort, libnetcdf),
        Cint,
        (Cint, ),
        ncid,
    ))
end
function ncclose(ncid, )
    check(ccall(
        (:ncclose, libnetcdf),
        Cint,
        (Cint, ),
        ncid,
    ))
end
function ncinquire(ncid, dimsp, varsp, attsp, nlimdimp, )
    check(ccall(
        (:ncinquire, libnetcdf),
        Cint,
        (Cint, Ptr{Cint}, Ptr{Cint}, Ptr{Cint}, Ptr{Cint}, ),
        ncid,
        dimsp,
        varsp,
        attsp,
        nlimdimp,
    ))
end
function ncdimdef(ncid, ame, len, )
    check(ccall(
        (:ncdimdef, libnetcdf),
        Cint,
        (Cint, Ptr{Cchar}, Clong, ),
        ncid,
        ame,
        len,
    ))
end
function ncdimid(ncid, ame, )
    check(ccall(
        (:ncdimid, libnetcdf),
        Cint,
        (Cint, Ptr{Cchar}, ),
        ncid,
        ame,
    ))
end
function ncdiminq(ncid, dimid, ame, enp, )
    check(ccall(
        (:ncdiminq, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Cchar}, Ptr{Clong}, ),
        ncid,
        dimid,
        ame,
        enp,
    ))
end
function ncdimrename(ncid, dimid, ame, )
    check(ccall(
        (:ncdimrename, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Cchar}, ),
        ncid,
        dimid,
        ame,
    ))
end
function ncattput(ncid, varid, ame, xtype, len, p, )
    check(ccall(
        (:ncattput, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Cchar}, Cint, Cint, Ptr{Cvoid}, ),
        ncid,
        varid,
        ame,
        xtype,
        len,
        p,
    ))
end
function ncattinq(ncid, varid, ame, typep, enp, )
    check(ccall(
        (:ncattinq, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Cchar}, Ptr{Cint}, Ptr{Cint}, ),
        ncid,
        varid,
        ame,
        typep,
        enp,
    ))
end
function ncattget(ncid, varid, ame, p, )
    check(ccall(
        (:ncattget, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Cchar}, Ptr{Cvoid}, ),
        ncid,
        varid,
        ame,
        p,
    ))
end
function ncattcopy(ncid_in, varid_in, ame, ncid_out, varid_out, )
    check(ccall(
        (:ncattcopy, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Cchar}, Cint, Cint, ),
        ncid_in,
        varid_in,
        ame,
        ncid_out,
        varid_out,
    ))
end
function ncattname(ncid, varid, attnum, ame, )
    check(ccall(
        (:ncattname, libnetcdf),
        Cint,
        (Cint, Cint, Cint, Ptr{Cchar}, ),
        ncid,
        varid,
        attnum,
        ame,
    ))
end
function ncattrename(ncid, varid, ame, ewname, )
    check(ccall(
        (:ncattrename, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Cchar}, Ptr{Cchar}, ),
        ncid,
        varid,
        ame,
        ewname,
    ))
end
function ncattdel(ncid, varid, ame, )
    check(ccall(
        (:ncattdel, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Cchar}, ),
        ncid,
        varid,
        ame,
    ))
end
function ncvardef(ncid, ame, xtype, ndims, imidsp, )
    check(ccall(
        (:ncvardef, libnetcdf),
        Cint,
        (Cint, Ptr{Cchar}, Cint, Cint, Ptr{Cint}, ),
        ncid,
        ame,
        xtype,
        ndims,
        imidsp,
    ))
end
function ncvarid(ncid, ame, )
    check(ccall(
        (:ncvarid, libnetcdf),
        Cint,
        (Cint, Ptr{Cchar}, ),
        ncid,
        ame,
    ))
end
function ncvarinq(ncid, varid, ame, typep, dimsp, imidsp, attsp, )
    check(ccall(
        (:ncvarinq, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Cchar}, Ptr{Cint}, Ptr{Cint}, Ptr{Cint}, Ptr{Cint}, ),
        ncid,
        varid,
        ame,
        typep,
        dimsp,
        imidsp,
        attsp,
    ))
end
function ncvarput1(ncid, varid, ndexp, p, )
    check(ccall(
        (:ncvarput1, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Clong}, Ptr{Cvoid}, ),
        ncid,
        varid,
        ndexp,
        p,
    ))
end
function ncvarget1(ncid, varid, ndexp, p, )
    check(ccall(
        (:ncvarget1, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Clong}, Ptr{Cvoid}, ),
        ncid,
        varid,
        ndexp,
        p,
    ))
end
function ncvarput(ncid, varid, tartp, ountp, p, )
    check(ccall(
        (:ncvarput, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Clong}, Ptr{Clong}, Ptr{Cvoid}, ),
        ncid,
        varid,
        tartp,
        ountp,
        p,
    ))
end
function ncvarget(ncid, varid, tartp, ountp, p, )
    check(ccall(
        (:ncvarget, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Clong}, Ptr{Clong}, Ptr{Cvoid}, ),
        ncid,
        varid,
        tartp,
        ountp,
        p,
    ))
end
function ncvarputs(ncid, varid, tartp, ountp, tridep, p, )
    check(ccall(
        (:ncvarputs, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Clong}, Ptr{Clong}, Ptr{Clong}, Ptr{Cvoid}, ),
        ncid,
        varid,
        tartp,
        ountp,
        tridep,
        p,
    ))
end
function ncvargets(ncid, varid, tartp, ountp, tridep, p, )
    check(ccall(
        (:ncvargets, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Clong}, Ptr{Clong}, Ptr{Clong}, Ptr{Cvoid}, ),
        ncid,
        varid,
        tartp,
        ountp,
        tridep,
        p,
    ))
end
function ncvarputg(ncid, varid, tartp, ountp, tridep, mapp, p, )
    check(ccall(
        (:ncvarputg, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Clong}, Ptr{Clong}, Ptr{Clong}, Ptr{Clong}, Ptr{Cvoid}, ),
        ncid,
        varid,
        tartp,
        ountp,
        tridep,
        mapp,
        p,
    ))
end
function ncvargetg(ncid, varid, tartp, ountp, tridep, mapp, p, )
    check(ccall(
        (:ncvargetg, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Clong}, Ptr{Clong}, Ptr{Clong}, Ptr{Clong}, Ptr{Cvoid}, ),
        ncid,
        varid,
        tartp,
        ountp,
        tridep,
        mapp,
        p,
    ))
end
function ncvarrename(ncid, varid, ame, )
    check(ccall(
        (:ncvarrename, libnetcdf),
        Cint,
        (Cint, Cint, Ptr{Cchar}, ),
        ncid,
        varid,
        ame,
    ))
end
function ncrecinq(ncid, recvarsp, ecvaridsp, ecsizesp, )
    check(ccall(
        (:ncrecinq, libnetcdf),
        Cint,
        (Cint, Ptr{Cint}, Ptr{Cint}, Ptr{Clong}, ),
        ncid,
        recvarsp,
        ecvaridsp,
        ecsizesp,
    ))
end
function ncrecget(ncid, recnum, datap, )
    check(ccall(
        (:ncrecget, libnetcdf),
        Cint,
        (Cint, Clong, Ptr{Ptr{Cvoid}}, ),
        ncid,
        recnum,
        datap,
    ))
end
function ncrecput(ncid, recnum, datap, )
    check(ccall(
        (:ncrecput, libnetcdf),
        Cint,
        (Cint, Clong, Ptr{Ptr{Cvoid}}, ),
        ncid,
        recnum,
        datap,
    ))
end
function nc_initialize(x, )
    check(ccall(
        (:nc_initialize, libnetcdf),
        Cint,
        (Cvoid, ),
        x,
    ))
end
function nc_finalize(x, )
    check(ccall(
        (:nc_finalize, libnetcdf),
        Cint,
        (Cvoid, ),
        x,
    ))
end
