# PathDistribution

[![Build Status](https://travis-ci.org/chkwon/PathDistribution.jl.svg?branch=master)](https://travis-ci.org/chkwon/PathDistribution.jl)

This package implements the Monte Carlo path generation method to estimat the number of simple paths between a pair of nodes in a graph, proposed by [Roberts and Kroese (2007)](http://dx.doi.org/10.7155/jgaa.00142): Estimating the Number of *s*-*t* Paths in a Graph. *Journal of Graph Algorithms and Applications*, 11(1), 195-214.

In addition, using the same idea, this package tries to estimate the path length distribution as follows. Let *n(x)* denote the cumulative number of paths whose length is no greather than *x*. We assume that *n(x)* is of the form:

n(x) = beta1 ( 1 - exp( - (x/beta2)^beta3 ) )

This package estimates beta1, beta2, and beta3.

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
number_paths = monte_carlo_path_generation(1, 8, adj_mtx)
```
