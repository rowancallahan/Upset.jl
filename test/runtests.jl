using Upset
using Test

@testset "Upset.jl" begin
    test_dict1 = Dict(
               "list1" => ['l','t','A','B'],
               "list2" => ['l','t','A','B','C','l'],
    	       "list3" => ['l','t','A','B','C','D','m','n','l'],
    	 	   "list4" => ['l','t','A','B'],
    	       "list5" => ['l','t','A','B', 'z', 'x', 'n'],
    )
    test_result1 = [[4, 1, 1, 2, 2], ["list4", "list5", "list5", "list5", "list1", "list2", "list2", "list3", "list3", "list3", "list3"]]
export plot_upset

    test_dict2 = Dict(
               "list1" => ['l','t','A','B'],
               "list2" => ['l','t','A','B','C','l'])
    test_result2 = [[4, 1], ["list1", "list2", "list2"]]


    @test plot_upset(test_dict1)[2]==test_result1
    @test plot_upset(test_dict2)[2]==test_result2 


end


