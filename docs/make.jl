using Documenter, NetCDF

makedocs(modules=[NetCDF],
    clean=false,
    format=:html,
    sitename="NetCDF.jl",
    authors="Fabian Gans and contributors",
    pages=Any[ # Compat: `Any` for 0.4 compat
      "Home" => "index.md",
      "Manual" => Any[
        "quickstart.md",
        "highlevel.md",
        "intermediate.md",
        "strings.md"
      ]
    ])

deploydocs(repo="github.com/JuliaGeo/NetCDF.jl.git",
    julia="0.5",
    deps=nothing,
    make=nothing,
    target="build")
