using Test, NetCDF, Random

"Function that returns a valid file name of a non-existing file for all OSs"
function tempname2()
    f, h = mktemp()
    close(h)
    rm(f)
    f
end
tlist = [Int8, UInt8, Int16, UInt16, Int32,UInt32, Int64,UInt64, Float32, Float64]

include("intermediate.jl")
include("high.jl")
include("array-like.jl")
include("chunks.jl")
nothing
