using PathDistribution

# Datasets from
# Roberts, B., & Kroese, D. P. (2007). Estimating the Number of st Paths in a Graph. J. Graph Algorithms Appl., 11(1), 195-214.
# http://dx.doi.org/10.7155/jgaa.00142



adj_mtx =[  0 1 1 1 0 1 1 1;
            1 0 0 0 1 1 1 0;
            1 0 0 1 1 1 1 1 ;
            1 0 1 0 1 1 1 1 ;
            0 1 1 1 0 1 0 0 ;
            1 1 1 1 1 0 1 1 ;
            1 1 1 1 0 1 0 1 ;
            1 0 1 1 0 1 1 0     ]

N1 = 1000
N2 = 2000
no_path_est, x_data, y_data = monte_carlo_path_distribution(1, size(adj_mtx,1), adj_mtx, N1, N2)
println("Case 1: $no_path_est (true value = 397)")
# @assert abs(no_path_est - 397)/397 < 0.05





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

start_node = round(Int, data[:,1]) #first column of data
end_node = round(Int, data[:,2]) #second column of data
link_length = data[:,3] #third

origin = 1
destination = 15

beta_est = path_distribution_fitting(origin, destination, start_node, end_node, link_length)
println(beta_est)


N1 = 1000
N2 = 2000

beta_est = path_distribution_fitting(origin, destination, start_node, end_node, link_length, N1, N2)
println(beta_est)











# END
