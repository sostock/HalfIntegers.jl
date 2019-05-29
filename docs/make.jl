using Documenter
using HalfIntegers

makedocs(
    sitename = "HalfIntegers.jl",
    format = Documenter.HTML(prettyurls = get(ENV, "CI", nothing) == "true"),
    modules = [HalfIntegers],
    pages = [
             "Home" => "index.md",
             "Manual" => "manual.md",
             "API documentation" => "api.md"
            ]
)

deploydocs(
    repo = "github.com/sostock/HalfIntegers.jl.git"
)
