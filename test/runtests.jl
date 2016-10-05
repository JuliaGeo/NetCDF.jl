using Base.Test
using NetCDF
"Function that returns a valid file name of a non-existing file for all OSs"
function tempname2()
  f,h=mktemp()
  close(h)
  rm(f)
  f
end
include("intermediate.jl")
include("high.jl")
include("array-like.jl")
include("chunks.jl")
