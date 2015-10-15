# PathDistribution

[![Build Status](https://travis-ci.org/chkwon/PathDistribution.jl.svg?branch=master)](https://travis-ci.org/chkwon/PathDistribution.jl)

This package implements the Monte Carlo path generation method to estimat the number of simple paths between a pair of nodes in a graph, proposed by [Roberts and Kroese (2007)](http://dx.doi.org/10.7155/jgaa.00142): Estimating the Number of *s*-*t* Paths in a Graph. *Journal of Graph Algorithms and Applications*, 11(1), 195-214.

In addition, using the same idea, this package tries to estimate the path length distribution as follows. Let *n(x)* denote the cumulative number of paths whose length is no greather than *x*. We assume that *n(x)* is of the form:

n(x) = beta1 ( 1 - exp( - (x/beta2)^beta3 ) )

This package estimates beta1, beta2, and beta3.

## Installation

```julia
Pkg.clone("https://github.com/chkwon/PathDistribution.jl")
```

## Tutorial
There are two ways of using this package. When you are given an adjacency matrix of the form:

```julia
adj_mtx =[  0 1 1 1 0 1 1 1;
            1 0 0 0 1 1 1 0;
            1 0 0 1 1 1 1 1 ;
            1 0 1 0 1 1 1 1 ;
            0 1 1 1 0 1 0 0 ;
            1 1 1 1 1 0 1 1 ;
            1 1 1 1 0 1 0 1 ;
            1 0 1 1 0 1 1 0     ]
```

and want to estimate the number of paths between node 1 and node 8, then

```julia
using PathDistribution
number_paths = monte_carlo_path_generation(1, 8, adj_mtx)
```

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

start_node = round(Int64, data[:,1]) #first column of data
end_node = round(Int64, data[:,2]) #second column of data
link_length = data[:,3] #third

origin = 1
destination = 15
```

then use the following function:
```julia
using PathDistribution
beta_est = path_distribution_fitting(origin, destination, start_node, end_node, link_length)
```
which returns
```julia
3-element Array{Float64,1}:
 184.822  
 324.145  
   6.49087
```
In this case, the first element ```beta_est[1]``` is simply an estimate of the total number of paths between origin and destination.
