module Upset


import Combinatorics
import Plots

greet() = print("Hello World! we are doing hte tutorial")

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
        group = source_group,
        legend = false,
        grid = true,
        axis = false,
        ticks = false,
    )

    reverse_intersection_length = reverse(intersection_lengths)
    filtered_intersection_lengths = filter(x -> x != 0, reverse_intersection_length)
    

    # ╔═╡ 0c4df824-643b-405d-9652-f4ae053a2beb
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

    # ╔═╡ 49b93f21-cf33-444f-86da-30cd738e49fd
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
    return combined_plot_side
    
end



end # module Upset
