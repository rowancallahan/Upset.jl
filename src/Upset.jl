module Upset
import Combinatorics
import Plots
export plot_upset
export to_presence_dict




function presence_matrix(list_in, lengths_list)
    all_elements = unique(vcat(list_in...))
    out_mat = Matrix{Int}(undef, 0, length(all_elements))

    for i in 1:length(list_in)
        if lengths_list[i] > 0
            sublist = list_in[i]
            new_row = [elem in sublist ? 1 : 0 for elem in all_elements]
            out_mat = vcat(out_mat, new_row')
        end
    end

    return out_mat
end


"""
 to_presence_dict(count_matrix, row_names)

Creates a presence dictionary from a counts matrix of different items.
Given a count matrix with rows being groups and columns items calculate the a dictionary that has the items that are present within  

# Examples

```julia-repl

julia> count_matrix = hcat([1,1,1],[0,1,1],[0,0,0])
3×3 Matrix{Int64}:
 1  0  0
 1  1  0
 1  1  0

julia> result = to_presence_dict(count_matrix, row_names) 

```
"""
function to_presence_dict(count_matrix, row_names{Vector{String}})
    #create a presence dictionary that we want to feed in later
    presence_dict= Dict{String, Vector{String}}()
    ##TODO create different backends accessible for plotting
    for (row_index,row) in enumerate(eachrow(named_df))
         presence_list = String[]
         for (index,value) in enumerate(row)
             if value>0
               push!(presence_list, names(named_df)[index])
             end
         end
	 presence_dict[row_names[row_index]] = presence_list
    end

    return(presence_dict)
end


"""
 plot_upset(dict_in)

Compute an upset plot giving a dictionary of lists. Each list in the dictionary is a list of the unique elements that are present in a set. Used for comparing presence of unique items across groups.

Requires that there exists more than one list in the dictionary in order to look for overlap.

Also requires that at least one list has one item present in it.

# Examples

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
"""
function plot_upset(my_dict)
    keys_list = collect(keys(my_dict))
    #have to make sure its in both of a and none of everything else
    #this might make things a little harder
    #below lists just when it is in both of them.
    begin
        combinations_list = []
        intersection_lengths = []

        for c in Combinatorics.combinations(collect(keys(my_dict)))
                   not_used = setdiff(collect(keys(my_dict)), c)
                   all_not_used = Set()

                   if length(not_used) >=1
                       combined_not_used = map(x-> getindex(my_dict, x), not_used)   
                       not_used_elements = map(Set, combined_not_used)
                       all_not_used = union(not_used_elements...)
                   end


                   combined = map(x-> getindex(my_dict, x), c)
                   set_changed = map(Set, combined)
                   intersected = intersect(set_changed...)
                   not_in_main = setdiff(intersected, all_not_used)

                   push!(intersection_lengths, length(not_in_main))
                   push!(combinations_list, c)


        end
    end


    presence_matrix_calced = presence_matrix(combinations_list, intersection_lengths)
    output_list = findall(x -> x != 0, presence_matrix_calced)
    number_of_el = size(presence_matrix_calced)[1]
    x_index = [(number_of_el+1)-(cart_index[1] ) for cart_index in output_list]
    y_index = [cart_index[2] for cart_index in output_list]
    source_group = [keys_list[i] for i in y_index]


    dot_plot = Plots.scatter(
        x_index,
        y_index,
        marker = :circle,
        markersize = 7,
        legend = false,
        grid = true,
        axis = false,
        ticks = false,
    )

    reverse_intersection_length = reverse(intersection_lengths)
    filtered_intersection_lengths = filter(x -> x != 0, reverse_intersection_length)

    barplot_number = Plots.bar(
        filtered_intersection_lengths,
        legend=false,
        linecolor = :black,
        linewidth = 4.0,
        fillcolor = :black,
        framestyle = :box,
        xticks = [],
        bar_width=0.60,
    )

    blank_plot1 = Plots.plot(framestyle = :none, grid = false, xlims = (0, 10), ylims = (0, 10), legend = false, axis = false, ticks = false)

    label_plot = Plots.scatter(
        zeros(maximum(y_index)).+7,
        1:maximum(y_index),
        marker = :circle,
        markersize = 0,
        group = unique(source_group),
        series_annotations = unique(source_group),
        series_annotations_align = :right,
        legend = false,
        grid = false,
        axis = false,
        ticks = false,
        xlims = (0, 7),
    )
    
    length_x = length(filtered_intersection_lengths)
    height_y = maximum(y_index)
    rectangle(w, h, x, y) = Plots.Shape(x .+ [0,w,w,0], y .+ [0,0,h,h])
    
    combined_plot_side =Plots.plot(blank_plot1, barplot_number, label_plot, dot_plot, layout=(2,2), link= :both)
    
    for i in 1:height_y
        if i%2 == 0
            Plots.plot!(rectangle(length_x+0.5,1,0,i-0.5), subplot=4, opacity=0.5, color=:lightgray, linewidth=0)
        end
    end
    
    for i in 1:length_x
        Plots.plot!( [i,i], [0.75, height_y], subplot=4, opacity=0.3, linecolor=:black, linewidth=4)
    end
    
    
    for i in 1:length(filtered_intersection_lengths)
        Plots.annotate!(i, filtered_intersection_lengths[i] + 5.0, subplot=2, Plots.text(filtered_intersection_lengths[i], :center))
    end
    return [combined_plot_side, [filtered_intersection_lengths, source_group]] 
    
end


end # module Upset
