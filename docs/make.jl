using Documenter, Upset

makedocs(sitename="Upset.jl Documentation", build="build")

deploydocs(repo="github.com/rowancallahan/Upset.jl.git", 
	   target="build",
	   branch="gh-pages"
	   )
