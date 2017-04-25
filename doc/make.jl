using Documenter, NetCDF


makedocs(
    modules = [NetCDF],
    clean   = false,
    format   = :html,
    sitename = "CABLAB.jl",
    authors = "Fabian Gans and contributors",
    pages    = Any[ # Compat: `Any` for 0.4 compat
      "Home" => "index.md",
      "Manual" => Any[
        "intro.md",
        "highlevel.md",
        "intermediate.md",
        "array-like.md",
        "strings.md"
      ]
    ]
)

deploydocs(
    #deps   = Deps.pip("mkdocs", "python-markdown-math"),
    repo   = "github.com/JuliaGeo/NetCDF.jl.git",
    julia  = "0.6",
    deps   = nothing,
    make   = nothing,
    target = "build"
)
