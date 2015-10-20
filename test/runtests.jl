using PathDistribution

# Datasets from
# Roberts, B., & Kroese, D. P. (2007). Estimating the Number of st Paths in a Graph. J. Graph Algorithms Appl., 11(1), 195-214.
# http://dx.doi.org/10.7155/jgaa.00142


# Case 1
adj_mtx =[  0 1 1 1 0 1 1 1 ;
            1 0 0 0 1 1 1 0 ;
            1 0 0 1 1 1 1 1 ;
            1 0 1 0 1 1 1 1 ;
            0 1 1 1 0 1 0 0 ;
            1 1 1 1 1 0 1 1 ;
            1 1 1 1 0 1 0 1 ;
            1 0 1 1 0 1 1 0     ]
# true_num = 397

# Full Enumeration
path_enums = path_enumeration(1, size(adj_mtx,1), adj_mtx)
x_data, y_data = actual_cumulative_count(path_enums, :unique)
beta = path_distribution_fitting(x_data, y_data)

# Monte Carlo Sampling
samples = monte_carlo_path_sampling(1, size(adj_mtx,1), adj_mtx)
x_data_est, y_data_est = estimate_cumulative_count(samples, :unique)
beta_est = path_distribution_fitting(x_data_est, y_data_est)

println("The total number of paths = $(length(path_enums)).")
println("The estimated number      = $(y_data_est[end])")


# using Gadfly
#
# x_fit = linspace(minimum(x_data),maximum(x_data),100)
# y_fit = cumulative_model(x_fit, beta)
#
# x_fit_est = linspace(minimum(x_data),maximum(x_data),100)
# y_fit_est = cumulative_model(x_fit_est, beta_est)
#
# fit_plot =
# plot(
#     # layer(x=x_fit, y=y_fit, Geom.line, Theme(default_color=colorant"red") ) ,
#     layer(x=x_data, y=y_data, Geom.step, Theme(default_color=colorant"red") ) ,
#     layer(x=x_fit_est, y=y_fit_est, Geom.line, Theme(default_color=colorant"blue") ) ,
#     # layer(x=x_data_est, y=y_data_est, Geom.point, Theme(default_color=colorant"blue") ) ,
#     Guide.xlabel("Path Length"), Guide.ylabel("Cumulative Count"),
#     Guide.title("Path Length Distribution"),
#     Guide.manual_color_key("Legend", ["Actual", "Estimated"], ["red", "blue"])
# )
#
# draw(PNG("case1.png", 6inch, 4inch), fit_plot)




# Other ways of using Monte Carlo Sampling
N1 = 500
N2 = 1000

samples = monte_carlo_path_sampling(1, size(adj_mtx,1), adj_mtx)
x_data_est, y_data_est = estimate_cumulative_count(samples)
println("Case 1: $(y_data_est[end]) (true value = $(length(path_enums)))")

samples = monte_carlo_path_sampling(1, size(adj_mtx,1), adj_mtx, N1, N2)
x_data_est, y_data_est = estimate_cumulative_count(samples)
println("Case 1: $(y_data_est[end]) (true value = $(length(path_enums)))")

samples = monte_carlo_path_sampling(1, size(adj_mtx,1), adj_mtx, N1, N2)
x_data_est, y_data_est = estimate_cumulative_count(samples, :first_quarter)
println("Case 1: $(y_data_est[end]) (true value = $(length(path_enums)))")

samples = monte_carlo_path_sampling(1, size(adj_mtx,1), adj_mtx, N1, N2)
x_data_est, y_data_est = estimate_cumulative_count(samples, :unique)
println("Case 1: $(y_data_est[end]) (true value = $(length(path_enums)))")

# When you just need the path number estimator
no_path_est = monte_carlo_path_number(1, size(adj_mtx,1), adj_mtx, N1, N2)
println("Case 1: $(no_path_est) (true value = $(length(path_enums)))")

# for enum in path_enums
#     println("Length = $(enum.length) : $(enum.path)")
# end
# println("The total number of paths is $(length(path_enums))")





# adj_mtx = [ 0 1 1 1 1 1 1 0 1 1 1 1;
#             1 0 1 1 1 1 1 1 1 1 1 1;
#             1 1 0 1 1 1 1 1 1 0 1 1;
#             1 1 1 0 1 1 1 1 1 1 0 1;
#             1 1 1 0 0 1 1 1 0 1 1 1;
#             1 1 1 1 1 0 1 1 1 1 1 0;
#             1 1 1 1 1 1 0 1 1 1 1 1;
#             1 1 1 1 1 1 1 0 1 1 1 1;
#             1 1 1 1 1 1 1 1 0 1 1 1;
#             1 1 1 1 1 1 1 1 1 0 1 0;
#             1 1 1 1 1 1 1 1 1 1 0 1;
#             1 1 1 1 1 1 1 1 1 1 1 0  ]
#
# adj_mtx = [ 0 1 1 0 0 1 0 0 1 0 0 0 0 0 0 0;
#             0 0 1 1 0 0 0 1 1 0 0 1 0 1 1 1;
#             1 0 0 0 0 0 0 0 0 1 1 0 0 0 0 1;
#             1 1 0 0 1 1 1 1 0 1 1 0 1 0 0 1;
#             0 1 0 0 0 0 1 0 0 1 1 0 0 0 1 0;
#             1 0 0 0 0 0 0 0 1 0 0 1 0 0 0 0;
#             0 0 0 1 0 1 0 0 1 0 0 0 0 1 0 1;
#             1 0 0 0 0 0 0 0 1 1 1 0 0 1 0 0;
#             1 1 0 0 1 0 0 0 0 0 1 0 0 1 0 0;
#             1 1 0 0 1 1 0 0 1 0 0 0 1 0 1 0;
#             0 0 1 0 0 0 0 0 0 1 0 0 0 0 0 1;
#             0 0 1 1 1 1 0 1 0 0 1 0 1 1 0 1;
#             1 1 0 0 1 1 0 0 0 0 0 0 0 1 0 0;
#             0 0 1 0 1 1 1 0 1 0 0 1 0 0 1 0;
#             1 0 0 0 0 0 0 0 0 0 0 1 1 0 0 1;
#             1 1 0 1 0 0 0 1 0 0 1 0 0 0 0 0 ]
#
# adj_mtx = [ 0 0 0 1 0 0 0 0 0 0 0 1 0 0 1 1 1 0 1 1 0 0 0 0;
#             0 0 0 0 0 0 0 0 0 0 1 0 1 1 1 0 0 0 0 0 0 1 0 0;
#             0 0 0 0 1 0 1 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0;
#             1 0 0 0 0 0 1 0 0 0 0 1 0 0 0 0 1 0 1 0 0 0 0 0;
#             0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 1 1 0 1 0 0 0 0 0;
#             0 0 0 0 0 0 1 0 0 0 1 0 1 0 1 0 0 0 0 0 0 0 0 0;
#             0 0 1 1 0 1 0 0 1 0 0 1 1 0 0 0 1 0 0 0 0 0 0 0;
#             0 0 0 0 0 0 0 0 1 1 0 0 0 1 0 0 1 0 0 0 0 0 0 0;
#             0 0 0 0 0 0 1 1 0 0 0 0 0 0 0 1 1 0 0 0 0 1 0 0;
#             0 0 0 0 0 0 0 1 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0;
#             0 1 0 0 0 1 0 0 0 0 0 0 0 0 0 1 1 0 0 1 1 0 0 0;
#             1 0 0 1 0 0 1 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 1 0;
#             0 1 1 0 0 1 1 0 0 0 0 1 0 0 0 0 0 0 1 0 1 0 1 0;
#             0 1 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0;
#             1 1 0 0 0 1 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0;
#             1 0 0 0 1 0 0 0 1 0 1 0 0 0 0 0 0 0 0 1 0 0 1 1;
#             1 0 0 1 1 0 1 1 1 0 1 0 0 0 0 0 0 0 1 1 0 0 1 0;
#             0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 0;
#             1 0 0 1 1 0 0 0 0 0 0 0 1 1 0 0 1 0 0 0 0 0 0 0;
#             1 0 0 0 0 0 0 0 0 0 1 0 0 0 0 1 1 0 0 0 0 0 1 0;
#             0 0 0 0 0 0 0 0 0 0 1 0 1 0 0 0 0 0 0 0 0 0 0 0;
#             0 1 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0;
#             0 0 0 0 0 0 0 0 0 0 0 1 1 0 0 1 1 1 0 1 0 0 0 1;
#             0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 1 0 ]






# ---------------

# Another example in README.md

data = [
 1   4  79.0 ;
 1   2  59.0 ;
 2   4  31.0 ;
 2   3  90.0 ;
 2   5   9.0 ;
 2   6  32.0 ;
 3   9  89.0 ;
 3   8  66.0 ;
 3   6  68.0 ;
 3   7  47.0 ;
 4   3  14.0 ;
 4   9  95.0 ;
 4   8  88.0 ;
 5   3  44.0 ;
 5   6  83.0 ;
 6   7  33.0 ;
 6   8  37.0 ;
 7  11  79.0 ;
 7  12  10.0 ;
 8   7  95.0 ;
 8  10   0.0 ;
 8  12  30.0 ;
 9  10   5.0 ;
 9  11  44.0 ;
10  13  79.0 ;
10  14  91.0 ;
11  14  53.0 ;
11  15  80.0 ;
11  13  56.0 ;
12  15  75.0 ;
12  14   1.0 ;
13  14  48.0 ;
14  15  25.0 ;
]

st = round(Int, data[:,1]) #first column of data
en = round(Int, data[:,2]) #second column of data
len = data[:,3] #third

# Double them for two-ways.
start_node = [st; en]
end_node = [en; st]
link_length = [len; len]

origin = 1
destination = 15

# Path enumeration test
# path_enums = path_enumeration(origin, destination, start_node, end_node, link_length)
# for enum in path_enums
#     println("Length = $(enum.length) : $(enum.path)")
# end
# println("The total number of paths is $(length(path_enums))")

N1 = 5000
N2 = 10000

path_enums = path_enumeration(origin, destination, start_node, end_node, link_length)
x_data, y_data = actual_cumulative_count(path_enums, :unique)
beta = path_distribution_fitting(x_data, y_data)

samples = monte_carlo_path_sampling(origin, destination, start_node, end_node, link_length)
x_data_est, y_data_est = estimate_cumulative_count(samples, :first_quarter)
beta_est = path_distribution_fitting(x_data_est, y_data_est)

# using Gadfly
#
# x_fit = linspace(minimum(x_data),maximum(x_data),100)
# y_fit = cumulative_model(x_fit, beta)
#
# x_fit_est = linspace(minimum(x_data),maximum(x_data),100)
# y_fit_est = cumulative_model(x_fit_est, beta_est)
#
# fit_plot =
# plot(
#     # layer(x=x_fit, y=y_fit, Geom.line, Theme(default_color=colorant"red") ) ,
#     layer(x=x_data, y=y_data, Geom.step, Theme(default_color=colorant"red") ) ,
#     layer(x=x_fit_est, y=y_fit_est, Geom.line, Theme(default_color=colorant"blue") ) ,
#     # layer(x=x_data_est, y=y_data_est, Geom.point, Theme(default_color=colorant"blue") ) ,
#     Guide.xlabel("Path Length"), Guide.ylabel("Cumulative Count"),
#     Guide.title("Path Length Distribution"),
#     Guide.manual_color_key("Legend", ["Actual", "Estimated"], ["red", "blue"])
# )
#
# draw(PNG("Sioux-Falls-1-15.png", 6inch, 4inch), fit_plot)




beta_est = path_distribution_fitting(origin, destination, start_node, end_node, link_length)
println(beta_est)

N1 = 5000
N2 = 10000
samples = monte_carlo_path_sampling(origin, destination, start_node, end_node, link_length, N1, N2)
x_data_est, y_data_est = estimate_cumulative_count(samples) # default :uniform
println("Estimate = $(y_data_est[end])")
x_data_est, y_data_est = estimate_cumulative_count(samples, :unique)
println("Estimate = $(y_data_est[end])")
x_data_est, y_data_est = estimate_cumulative_count(samples, :first_quarter)
println("Estimate = $(y_data_est[end])")
beta_est = path_distribution_fitting(x_data_est, y_data_est)
println(beta_est)





# END
