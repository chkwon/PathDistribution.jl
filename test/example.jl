using PathDistribution

filename = "Sioux-Falls"
data = readcsv("$(filename).csv", header=true) #3,705
origin = 3
destination = 19

start_node = round(Int64, data[1][:,1])
end_node = round(Int64, data[1][:,2])
link_length = data[1][:,3]

beta_est = path_distribution_fitting(origin, destination, start_node, end_node, link_length

# println("beta_est = $beta_est")

println("cumulative_count(path_length) = beta1 ( 1 - exp ( - (path_length/beta2)^beta3 ) ) ")
println("beta1 = $(beta_est[1])")
println("beta2 = $(beta_est[2])")
println("beta3 = $(beta_est[3])")
