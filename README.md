## Upset.jl

![Screenshot 2024-08-01 at 4 57 19 PM](https://github.com/user-attachments/assets/5ad706ef-8462-4466-a2fc-5f191c5cbbc3)

Implementation of the Upset graphing technique a la UpsetR.
Still incomplete and missing features, should be enough if you need to make preliminary
 graphs in Julia.
Currently takes in a list of dictionar

Installable using

`add https://github.com/rowancallahan/Upset.jl.git`

Not added to the main registry yet but will potentially be added in the next few months.


## Example Usage

```julia-repl

julia> a =    input_dict = Dict(
               "list1" => ['l','t','A','B'],
               "list2" => ['l','t','A','B','C','l'])

Dict{String, Vector{Char}} with 2 entries:
  "list1" => ['l', 't', 'A', 'B']
  "list2" => ['l', 't', 'A', 'B', 'C', 'l']

julia> result = plot_upset(a) 

2-element Vector{Any}:
 Plot{Plots.GRBackend() n=8}
Captured extra kwargs:
  Series{3}:
    series_annotations_align: right
  Series{4}:
    series_annotations_align: right

 Vector{Any}[[4, 1], ["list1", "list2", "list2"]]

```


