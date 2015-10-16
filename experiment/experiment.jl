# using PathDistribution, Gadfly

using LsqFit, Gadfly
include("../src/misc.jl")
include("../src/monte_carlo.jl")
include("../src/path_distribution_estimate.jl")




function do_exp(filename, origin, destination, start_node, end_node, link_length, beta_fit)

    N1 = 5000
    N2 = 20000


    number_paths, x_data, y_data =
        monte_carlo_path_distribution(origin, destination, start_node, end_node, link_length, N1, N2)

    println("$filename, origin=$origin, destination=$destination")
    println("number of paths estimate: $number_paths")

    beta_est = path_distribution_fitting(x_data, y_data)

    println("beta_fit = $beta_fit")
    println("beta_est = $beta_est")

    x_fit = 0.3*beta_fit[2] : 1 : 2*beta_fit[2]
    y_fit = cumulative_model(x_fit, beta_fit)
    y_est = cumulative_model(x_fit, beta_est)

    title = @sprintf("RED fitted: beta = [%f, %f, %f]\nBLUE estimated: beta = [%f, %f, %f]",
                    beta_fit[1], beta_fit[2], beta_fit[3], beta_est[1], beta_est[2], beta_est[3])

    fit_plot =
        plot(
            layer(x=x_fit, y=y_fit, Geom.line, Theme(default_color=colorant"red") ) ,
            layer(x=x_fit, y=y_est, Geom.line, Theme(default_color=colorant"blue") ) ,
            Guide.xlabel("Path Length"), Guide.ylabel("Cumulative Count"),
            Guide.title(title),
        )

    draw(PDF("$(filename)-$origin-$destination.pdf", 10inch, 6inch), fit_plot)

end



filename = "Buffalo-Data"
data = readcsv("$(filename).csv", header=true) # 405,094
origin = 1
destination = 84
beta_fit = [401103.602284; 61.890097; 9.811411]
start_node = round(Int64, data[1][:,1])
end_node = round(Int64, data[1][:,2])
link_length = data[1][:,3]
do_exp(filename, origin, destination, start_node, end_node, link_length, beta_fit)


filename = "Albany-Data"
data = readcsv("$(filename).csv", header=true) #3,551
origin = 1
destination = 12
beta_fit = [3504.287463; 71.552699; 6.485460]
start_node = round(Int64, data[1][:,1])
end_node = round(Int64, data[1][:,2])
link_length = data[1][:,3]
do_exp(filename, origin, destination, start_node, end_node, link_length, beta_fit)



filename = "Sioux-Falls"
data = readcsv("$(filename).csv", header=true) #3,705
start_node = round(Int64, data[1][:,1])
end_node = round(Int64, data[1][:,2])
link_length = data[1][:,3]

origin = 2
destination = 13
beta_fit = [4559.889822; 235.971248; 6.032994]
do_exp(filename, origin, destination, start_node, end_node, link_length, beta_fit)

origin = 3
destination = 19
beta_fit = [3627.177263; 220.070292; 5.327236]
do_exp(filename, origin, destination, start_node, end_node, link_length, beta_fit)

origin = 10
destination = 21
beta_fit = [2777.234877; 239.599660; 4.416381]
do_exp(filename, origin, destination, start_node, end_node, link_length, beta_fit)



#
# start_node_un = round(Int64, data[1][:,1])
# end_node_un = round(Int64, data[1][:,2])
# link_length_un = data[1][:,3]
# start_node = [start_node_un; end_node_un]
# end_node = [end_node_un; start_node_un]
# link_length = [link_length_un; link_length_un]
