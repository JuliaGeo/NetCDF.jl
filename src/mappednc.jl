"""
The type `MappedNcVar{T,N}` represents a NetCDF variable. It is a subtype of AbstractArray{T,N}, so normal indexing using `[]`
will work for reding and writing data to and from a NetCDF file. `NcVar` objects can be returned by the `open` function , by
indexing an `NcFIle` object (e.g. `myfile["temperature"]`) or, when creating a new file, constructing it directly.
"""
type MappedNcVar{T,N} <: NcVars{T,N}
  ncid::Int32
  varid::Int32
  ndim::Int32
  natts::Int32
  nctype::Int32
  name::UTF8String
  dimids::Vector{Int32}
  dim::Vector{NcDim}
  atts::Dict
  compress::Int32
  perm::NTuple{N,Int}
  iperm::NTuple{N,Int}
  stride::Vector{Cptrdiff_t}
  imap::Vector{Cptrdiff_t}
  chunksize::NTuple{N,Int32}
end
function MappedNcVar{T,N}(v::NcVar{T,N},stride,perm,imap)
   stride=map(Cptrdiff_t,stride)
   imap=map(Cptrdiff_t,imap)
   iperm=getiperm(perm)
   MappedNcVar{T,N}(v.ncid,v.varid,v.ndim,v.natts,v.nctype,v.name,v.dimids,v.dim,v.atts,v.compress,perm,iperm,stride,imap,v.chunksize)
end
function getimap(sold,perm)
    imap=zeros(Int,length(sold))
    imap[perm[1]]=1
    for i=2:length(sold)
        imap[perm[i]]=imap[perm[i-1]]*sold[perm[i-1]]
        imap[perm[i]]=imap[perm[i-1]]*sold[perm[i-1]]
    end
    imap
end
function getiperm(perm)
    iperm = Array(Int,length(perm))
    for i = 1:length(perm)
        iperm[perm[i]] = i
    end
    return ntuple(i->iperm[i],length(iperm))
end
@generated function Base.size{T,N}(a::MappedNcVar{T,N})
  :(@ntuple($N,i->Int(a.dim[a.perm[i]].dimlen)))
end
Base.permutedims(v::NcVar,p)=MappedNcVar(v,ones(ndims(v)),p,getimap(size(v),p))




@generated function readvar!{T,N}(v::MappedNcVar{T,N}, retvalsa::Array,I::IndR...)

  N==length(I) || error("Dimension mismatch")

  quote
    checkbounds(v,I...)
    imap=v.imap
    iperm=v.iperm
    @nexprs $N i->gstart[v.ndim+1-i]=firsti(I[iperm[i]],v.dim[i].dimlen)
    @nexprs $N i->gcount[v.ndim+1-i]=counti(I[iperm[i]],v.dim[i].dimlen)
    p=1
    @nexprs $N i->p=p*gcount[v.ndim+1-i]
    length(retvalsa) != p && error(string("Size of output array ($(length(retvalsa))) does not equal number of elements to be read (",p,")!"))
    nc_get_varm_x!(v.ncid,v.varid,gstart,gcount,gstridea,reverse(imap),retvalsa)
    retvalsa
  end
end

@generated function readvar{T,N}(v::MappedNcVar{T,N},I::Integer...)
  N==length(I) || error("Dimension mismatch")
  quote
    Inew = @ntuple $N d->I[v.iperm[d]]
    checkbounds(v,I...)
    @nexprs $N i->gstart[v.ndim+1-i]=Inew[i]-1
    nc_get_var1_x(v.ncid,v.varid,gstart,T)::T
  end
end


function readvar!(v::MappedNcVar, retvalsa::Array;start::Vector=defaultstart(v),count::Vector=defaultcount(v))

  length(start) == v.ndim || error("Length of start ($(length(start))) must equal the number of variable dimensions ($(v.ndim))")
  length(count) == v.ndim || error("Length of start ($(length(count))) must equal the number of variable dimensions ($(v.ndim))")

  p=preparestartcount(start,count,v)

  length(retvalsa) != p && error("Size of output array ($(length(retvalsa))) does not equal number of elements to be read ($p)!")

  nc_get_varm_x!(v.ncid,v.varid,gstart,gcount,gstridea,reverse(v.imap),retvalsa)

  retvalsa
end

function readvar{T,N}(v::MappedNcVar{T,N},I::IndR...)
    count=ntuple(i->counti(I[i],v.dim[v.perm[i]].dimlen),length(I))
    retvalsa = zeros(T,count)
    readvar!(v, retvalsa, I...)
    return retvalsa
end

function readvar{T,N}(v::MappedNcVar{T,N};start::Vector=defaultstart(v),count::Vector=defaultcount(v))
    s = [count[i]==-1 ? size(v,i)-start[i]+1 : count[i] for i=1:length(count)]
    retvalsa = Array(T,s...)
    readvar!(v, retvalsa, start=start, count=count)
    return retvalsa
end

for (t,ending,arname) in funext
    fname = symbol("nc_get_varm_$ending")
    arsym=symbol(arname)
    @eval nc_get_varm_x!(ncid::Integer,varid::Integer,start::Vector{UInt},count::Vector{UInt},stride::Vector{Cptrdiff_t},imap::Vector{Cptrdiff_t},retvalsa::Array{$t})=$fname(ncid,varid,start,count,stride,imap,retvalsa)
end



function preparestartcount(start,count,v::MappedNcVar)

    length(start) == v.ndim || error("Length of start ($(length(start))) must equal the number of variable dimensions ($(v.ndim))")
    length(count) == v.ndim || error("Length of start ($(length(count))) must equal the number of variable dimensions ($(v.ndim))")

    p  = one(eltype(gcount))
    nd = length(start)

    for i=1:nd
        ci             = nd+1-i
        gstart[ci] = start[v.iperm[i]] - 1
        gcount[ci] = count[v.iperm[i]] < 0 ? v.dim[i].dimlen - gstart[ci] : count[v.iperm[i]]

        p=p*gcount[ci]
    end

    checkboundsNC(v)

    return p
end
