# PathDistribution

[![Build Status](https://travis-ci.org/chkwon/PathDistribution.jl.svg?branch=master)](https://travis-ci.org/chkwon/PathDistribution.jl)

This package implements the Monte Carlo path generation method to estimat the number of simple paths between a pair of nodes in a graph, proposed by [Roberts and Kroese (2007)](http://dx.doi.org/10.7155/jgaa.00142): Estimating the Number of *s*-*t* Paths in a Graph. *Journal of Graph Algorithms and Applications*, 11(1), 195-214.

In addition, using the same idea, this package tries to estimate the path length distribution as follows. Let $n(x)$ denote the cumulative number of paths whose length is no greather than $x$.
