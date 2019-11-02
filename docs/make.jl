using Documenter, NetCDF

makedocs(
    modules = [NetCDF],
    format = Documenter.HTML(),
    sitename = "NetCDF.jl",
    authors = "Fabian Gans and contributors",
    pages = [
        "Home" => "index.md",
        "Manual" => ["quickstart.md", "highlevel.md", "intermediate.md", "strings.md"],
    ],
)

deploydocs(repo = "github.com/JuliaGeo/NetCDF.jl.git")
