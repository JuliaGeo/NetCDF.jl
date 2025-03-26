using Documenter, NetCDF

makedocs(
    modules = [NetCDF],
    format = Documenter.HTML(;
        prettyurls = get(ENV, "CI", "false") == "true",
        canonical = "https://juliageo.github.io/NetCDF.jl",
        assets = String[],
    ),
    sitename = "NetCDF.jl",
    authors = "Fabian Gans and contributors",
    pages = [
        "Home" => "index.md",
        "Manual" => ["quickstart.md", "highlevel.md", "intermediate.md", "strings.md"],
    ],
)

deploydocs(repo="github.com/meggart/NetCDF.jl")
