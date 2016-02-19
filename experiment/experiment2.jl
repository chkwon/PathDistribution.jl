# using PathDistribution, Gadfly
#
# using LsqFit, Gadfly
# include("../src/misc.jl")
# include("../src/monte_carlo.jl")
# include("../src/fitting.jl")

using PathDistribution



function do_exp(filename, origin, destination, start_node, end_node, link_length, beta_fit)

    N1 = 5000
    N2 = 20000

    samples = monte_carlo_path_sampling(origin, destination, start_node, end_node, link_length, N1, N2)

    option = :unique
    x_data, y_data = estimate_cumulative_count(samples, option)

    writecsv("$(filename)-$origin-$destination.csv", [x_data y_data])

    println("$filename, origin=$origin, destination=$destination")
    println("number of paths estimate: $(y_data[end])")


end



filename = "Buffalo-Data"
data = readcsv("$(filename).csv", header=true) # 405,094
origin = 1
destination = 84
beta_fit = [401103.602284; 61.890097; 9.811411]
start_node = round(Int64, data[1][:,1])
end_node = round(Int64, data[1][:,2])
link_length = data[1][:,3]
@time do_exp(filename, origin, destination, start_node, end_node, link_length, beta_fit)

#
# filename = "Albany-Data"
# data = readcsv("$(filename).csv", header=true) #3,551
# origin = 1
# destination = 12
# beta_fit = [3504.287463; 71.552699; 6.485460]
# start_node = round(Int64, data[1][:,1])
# end_node = round(Int64, data[1][:,2])
# link_length = data[1][:,3]
# @time do_exp(filename, origin, destination, start_node, end_node, link_length, beta_fit)
#
#
#
# filename = "Sioux-Falls"
# data = readcsv("$(filename).csv", header=true) #3,705
# start_node = round(Int64, data[1][:,1])
# end_node = round(Int64, data[1][:,2])
# link_length = data[1][:,3]
#
# origin = 2
# destination = 13
# beta_fit = [4559.889822; 235.971248; 6.032994]
# @time do_exp(filename, origin, destination, start_node, end_node, link_length, beta_fit)
#
# origin = 3
# destination = 19
# beta_fit = [3627.177263; 220.070292; 5.327236]
# @time do_exp(filename, origin, destination, start_node, end_node, link_length, beta_fit)
#
# origin = 10
# destination = 21
# beta_fit = [2777.234877; 239.599660; 4.416381]
# @time do_exp(filename, origin, destination, start_node, end_node, link_length, beta_fit)



#
# start_node_un = round(Int64, data[1][:,1])
# end_node_un = round(Int64, data[1][:,2])
# link_length_un = data[1][:,3]
# start_node = [start_node_un; end_node_un]
# end_node = [end_node_un; start_node_un]
# link_length = [link_length_un; link_length_un]
