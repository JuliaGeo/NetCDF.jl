using Documenter, NetCDF

makedocs(
    modules = [NetCDF],
    clean   = false,
    format   = :html,
    sitename = "NetCDF.jl",
    authors = "Fabian Gans and contributors",
    pages = [
      "Home" => "index.md",
      "Manual" => [
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
    julia  = "1.0",
    deps   = nothing,
    make   = nothing,
    target = "build"
)
