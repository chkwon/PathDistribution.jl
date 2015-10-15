using PathDistribution

filename = "Sioux-Falls"
data = readcsv("$(filename).csv", header=true) #3,705
origin = 3
destination = 19

start_node = round(Int64, data[1][:,1])
end_node = round(Int64, data[1][:,2])
link_length = data[1][:,3]

beta_est = path_distribution_fitting(origin, destination, start_node, end_node, link_length)

# println("beta_est = $beta_est")

println("cumulative_count(path_length) = beta1 ( 1 - exp ( - (path_length/beta2)^beta3 ) ) ")
println("beta1 = $(beta_est[1])")
println("beta2 = $(beta_est[2])")
println("beta3 = $(beta_est[3])")


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

start_node = round(Int64, data[:,1]) #first column of data
end_node = round(Int64, data[:,2]) #second column of data
link_length = data[:,3] #third

origin = 1
destination = 15

beta_est = path_distribution_fitting(origin, destination, start_node, end_node, link_length)
