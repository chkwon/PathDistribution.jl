# PathDistribution.jl

<!--
[![RobustShortestPath](http://pkg.julialang.org/badges/RobustShortestPath_0.3.svg)](http://pkg.julialang.org/?pkg=RobustShortestPath&ver=0.3)
[![RobustShortestPath](http://pkg.julialang.org/badges/RobustShortestPath_0.4.svg)](http://pkg.julialang.org/?pkg=RobustShortestPath&ver=0.4)
-->

[![Build Status](https://travis-ci.org/chkwon/PathDistribution.jl.svg?branch=master)](https://travis-ci.org/chkwon/PathDistribution.jl)
[![Build status](https://ci.appveyor.com/api/projects/status/ft7mcyofj0g9mxr5?svg=true)](https://ci.appveyor.com/project/chkwon/pathdistribution-jl)
[![Coverage Status](https://coveralls.io/repos/chkwon/PathDistribution.jl/badge.svg?branch=master&service=github)](https://coveralls.io/github/chkwon/PathDistribution.jl?branch=master)


This Julia package implements the Monte Carlo path generation method to estimate the number of simple paths between a pair of nodes in a graph, proposed by Roberts and Kroese (2007).

* [Roberts, B., & Kroese, D. P. (2007). Estimating the Number of *s*-*t* Paths in a Graph. *Journal of Graph Algorithms and Applications*, 11(1), 195-214.](http://dx.doi.org/10.7155/jgaa.00142)

In addition, using the same idea, this package tries to estimate the path length distribution as follows. Let *n(x)* denote the cumulative number of paths whose length is no greather than *x*. We assume that *n(x)* is of the form:

```julia
n(x) = beta[1] * ( 1 - exp( - (x/beta[2])^beta[3] ) )
```

This package estimates ```beta``` using the [LsqFit.jl](https://github.com/JuliaOpt/LsqFit.jl) package.

## Installation

This package requires Julia version 0.4.

```julia
Pkg.clone("https://github.com/chkwon/PathDistribution.jl")
```

## Basic Usage with an Adjacency Matrix
First import the package:
```julia
using PathDistribution
```

When you are given an adjacency matrix of the form:

```julia
adj_mtx = [ 0 1 1 1 0 1 1 1 ;
            1 0 0 0 1 1 1 0 ;
            1 0 0 1 1 1 1 1 ;
            1 0 1 0 1 1 1 1 ;
            0 1 1 1 0 1 0 0 ;
            1 1 1 1 1 0 1 1 ;
            1 1 1 1 0 1 0 1 ;
            1 0 1 1 0 1 1 0 ]
```

and want to estimate the number of paths between node 1 and node 8, then

```julia
number_paths = monte_carlo_path_number(1, 8, adj_mtx)
```

or

```julia
samples = monte_carlo_path_sampling(1, 8, adj_mtx)
x_data_est, y_data_est = estimate_cumulative_count(samples)
```
where `x_data_est` and `y_data_est` are for estimating the cumulative count of paths by path length. That is,
`y_data_est[i]` is an estimate for the number of simple paths whose length is no greater than `x_data_est[i]` between the origin and destination nodes. `y_data_est[end]` is the estimated number of total paths.

These data may be used to estimate `beta` in the function form `n(x)` as follows:

```julia
beta_est = path_distribution_fitting(x_data_est, y_data_est)
```

This package can also enumerate all paths explicitly. (**CAUTION:** It may take forever to enumerate all paths for a large network.)
```julia
path_enums = path_enumeration(1, size(adj_mtx,1), adj_mtx)
x_data, y_data = actual_cumulative_count(path_enums)
beta = path_distribution_fitting(x_data, y_data)
```
You can access each enumerated path as follows:
```julia
for enum in path_enums
    println("Length = $(enum.length) : $(enum.path)")
end
println("The total number of paths is $(length(path_enums))")
```


![Example plot](case1.png)


## Another Form

When you have the following form data:
```julia
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
```

The similar tasks as above can be done as follows:
```julia
# Full Path Enumeration
path_enums = path_enumeration(origin, destination, start_node, end_node, link_length)
x_data, y_data = actual_cumulative_count(path_enums)
beta = path_distribution_fitting(x_data, y_data)

# Monte Carlo Path Sampling
samples = monte_carlo_path_sampling(origin, destination, start_node, end_node, link_length)
x_data_est, y_data_est = estimate_cumulative_count(samples)
beta_est = path_distribution_fitting(x_data_est, y_data_est)
```

![Example plot](Sioux-Falls-1-15.png)
