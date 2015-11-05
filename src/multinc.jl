using Base.Cartesian

immutable NcMultiVar{T,N} <: AbstractArray{T,N}
    ncvars::Vector{NcVar{T,N}}
    size::NTuple{N,Int}
    stride::Int
end

function NcMultiVar{T,N}(v::Vector{NcVar{T,N}})
    #Do some consistency checks
    s=size(v[min(length(v),2)])
    nvars=length(v)
    for iv in v
        size(iv)==s || error("size of Files must be consistent")
    end
    snew=ntuple(i->i==N ? s[i]*nvars : s[i],N)
    NcMultiVar(v,snew,s[N])
end
Base.size(v::NcMultiVar)=v.size
Base.linearindexing(::NcMultiVar)=Base.LinearSlow()
typealias IndR Union{Integer,UnitRange,Colon}

for N=1:6
funcheade=Expr(:call,:(Base.getindex{T}),:(v::NcMultiVar{T,3}))
checke=Expr(:call,:checkbounds,:v)
readvare=Expr(:call,:(NetCDF.readvar),:(v.ncvars[ifile+1]))
zeroe=Expr(:call,:zeros,:T)
getindexe=:(getindex(v))
imsize=1
for i=1:N
    curi=parse("i_$i")
    push!(funcheade.args,:($(curi)::IndR))
    push!(checke.args,curi)
    push!(readvare.args,curi)
    push!(zeroe.args,curi)
    push!(getindexe.args,curi)
    i<N && (imsize=:($imsize*$curi))
end
funcheade.args[end]=:(ilast::Int)
readvare.args[end]=:(its+1)
zeroe.args[end]=:(length(ilast))
checke.args[end]=:(ilast)
getindexe.args[end]=:(1:size(v,ndims(v)))
egetindex_int=quote
    $funcheade=begin
        $checke
        ifile,its=divrem(ilast-1,v.stride)
        $readvare
    end
end
eval(egetindex_int)

funcheade.args[end]=:(ilast::UnitRange)
readvare.args[1]=:(NetCDF.readvar!)
readvare.args[end]=:(tc1:tc2)
insert!(readvare.args,3,:(outarsub))
egetindex_range=macroexpand(quote
    #For Ranges
    $funcheade=begin
        $checke
        tstart,tend=extrema(ilast)
        ifile1,its1=divrem(tstart-1,v.stride)
        ifile2,its2=divrem(tend-1,v.stride)
        @nexprs $(N-1) k->(l_k = isa(i_k,Colon) ? v.size[k] : length(i_k))
        outar=$zeroe
        imsize=$imsize
        ppos=1
        for ifile in ifile1:ifile2
            tc1 = ifile==ifile1 ? its1+1 : 1
            tc2 = ifile==ifile2 ? its2+1 : v.stride
            outarsub = pointer_to_array(pointer(outar,ppos),imsize*length(tc1:tc2))
            $readvare
            ppos     += imsize*length(tc1:tc2)
        end
        outar
    end
end)
eval(egetindex_range)

funcheade.args[end]=:(ilast::Colon)
egetindex_colon=:($funcheade=$getindexe)
eval(egetindex_colon)
end

function NetCDF.open{T<:AbstractString}(flist::AbstractVector{T},varname::AbstractString)
    nct=typeof(NetCDF.open(flist[1],varname));
    NcMultiVar(nct[NetCDF.open(flist[i],varname) for i=1:length(flist)])
end
