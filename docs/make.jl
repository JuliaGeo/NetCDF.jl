using Documenter, NetCDF

makedocs(
    modules = [NetCDF],
    clean   = false,
    format   = :html,
    sitename = "NetCDF.jl",
    authors = "Fabian Gans and contributors",
    pages    = Any[
      "Home" => "index.md",
      "Manual" => Any[
        "quickstart.md",
        "highlevel.md",
        "intermediate.md",
        "strings.md"
      ]
    ]
)

deploydocs(
    #deps   = Deps.pip("mkdocs", "python-markdown-math"),
    repo   = "github.com/JuliaGeo/NetCDF.jl.git",
    julia  = "0.7",
    deps   = nothing,
    make   = nothing,
    target = "build"
)
