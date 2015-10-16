type PathSample
    path::Array
    g::Float64
    length::Float64
end


################################################################################
# The Main Functions
################################################################################

# The ultimate form of the function
function monte_carlo_path_distribution(origin::Int, destination::Int, adj_mtx::Array{Int,2}, link_length_dict::Dict, N1=5000, N2=10000)
    samples = length_distribution_method(origin, destination, adj_mtx, link_length_dict, N1, N2)
    # number_paths, path_length_samples = sample_path_dist(samples, N2)

    no_path_est, x_data, y_data = estimate_cumulative_count(samples, N2)

    return no_path_est, x_data, y_data
end

# Useful for testing the instances in
# Roberts, B., & Kroese, D. P. (2007). Estimating the Number of st Paths in a Graph. J. Graph Algorithms Appl., 11(1), 195-214.
# http://dx.doi.org/10.7155/jgaa.00142
function monte_carlo_path_distribution(origin::Int, destination::Int, adj_mtx::Array{Int,2}, N1=5000, N2=10000)
    link_length_dict = getLinkLengthDict(adj_mtx)

    return monte_carlo_path_distribution(origin, destination, adj_mtx, link_length_dict, N1, N2)
end
function monte_carlo_path_number(origin::Int, destination::Int, adj_mtx::Array{Int,2}, N1=5000, N2=10000)
    link_length_dict = getLinkLengthDict(adj_mtx)
    no_path_est, x_data, y_data = monte_carlo_path_distribution(origin, destination, adj_mtx, link_length_dict, N1, N2)

    return no_path_est
end


# Useful for experimenting many realistic road networks
function monte_carlo_path_distribution(origin::Int, destination::Int, start_node::Array{Int,1}, end_node::Array{Int,1}, link_length, N1=5000, N2=10000)
    link_length_dict = getLinkLengthDict(start_node, end_node, link_length)
    adj_mtx = getAdjacency(start_node, end_node)

    return monte_carlo_path_distribution(origin, destination, adj_mtx, link_length_dict, N1, N2)
end

################################################################################
################################################################################






#
# function monte_carlo_path_distribution_split(origin::Int, destination::Int, adj_mtx::Array{Int,2}, N1=1000, N2=2000)
#     final_nodes = []
#     for i=1:size(adj_mtx,1)
#         if adj_mtx[i,destination]==1
#             push!(final_nodes, i)
#         end
#     end
#
#     adj = copy(adj_mtx)
#     adj[:,destination] = 0
#     adj[destination,:] = 0
#
#     total_num = 0
#     for n in final_nodes
#         samples = length_distribution_method(origin, n, adj, [], N1, N2)
#         number_paths, path_length_samples = sample_path_dist(samples, N2)
#
#         total_num += number_paths
#     end
#
#     return total_num
# end



function estimate_cumulative_count(samples::Array{PathSample,1}, NN)
    no_path_est = 0

    path_lengths = []
    likelihoods = []
    for s in samples
        no_path_est += 1 / s.g
        push!(path_lengths, s.length)
        push!(likelihoods, s.g)
    end
    no_path_est = no_path_est / NN

    x_data = linspace(minimum(path_lengths), maximum(path_lengths), 100)
    y_data = similar(x_data)

    for i=1:length(x_data)
        idx = find(x-> x<=x_data[i], path_lengths)
        y_data[i] = sum(1./likelihoods[idx])
    end
    y_data =  y_data / NN

    return no_path_est, x_data, y_data
end


# function estimate_sample_path_dist(samples, N)
#     estimate = 0
#     path_lengths = Float64[]
#     for s in samples
#         estimate += 1 / s.g
#         push!(path_lengths, s.length)
#     end
#     estimate = estimate / N
#
#     return estimate, path_lengths
# end
#
# function estimate_path_number(samples, N)
#     estimate = 0
#     for s in samples
#         estimate += 1 / s.g
#     end
#     estimate = estimate / N
#
#     return estimate
# end

#
# function sample_path_dist(samples, N)
#     estimate = 0
#     path_lengths = Float64[]
#     for s in samples
#         estimate += 1 / s.g
#         push!(path_lengths, s.length)
#     end
#     estimate = estimate / N
#
#     return estimate, path_lengths
# end







# Algorithm 1 (Naive Path Generation) of Roberts and Kroese (2007)
function naive_path_generation(origin, destination, adj_mtx, N1)

    naive_samples = PathSample[]
    for k=1:N1
        adj = copy(adj_mtx)

        # 1
        x = [origin]
        g = 1
        current = origin

        #2
        adj[:,origin] = 0

        while current != destination
            #3
            V = Int[]
            for i=1:size(adj,1) # number of nodes
                if adj[current,i] == 1
                    push!(V, i)
                end
            end
            if length(V)==0
                break
            end

            #4
            next = rand(V)
            x = [x; next]

            #5
            current = next
            adj[:,next] = 0
            g = g / length(V)
        end

        if x[end] == destination
            this_sample = PathSample(x, g, 0.0)
            push!(naive_samples, this_sample)
        end
    end

    return naive_samples
end

# Computing \hat{l}_k as in Equation (4) of Roberts and Kroese (2007)
function length_distribution_vector(naive_samples::Array{PathSample}, adj::Array{Int,2}, no_node::Int, destination::Int)
    # Length-Distribution
    # l_hat = numerator / denominator

    # adj = getAdjacency(start_node, end_node)
    # no_node = getNoNode(start_node, end_node)

    l_hat = Array{Float64}(no_node-1)
    for k = 1:length(l_hat)
        numerator = 0.0
        denominator = 0.0

        for s in naive_samples
            if length(s.path)-1 == k
                numerator += 1 / s.g
            end

            if length(s.path)-1 >= k
                if adj[ s.path[k], destination ]==1
                    denominator += 1 / s.g
                end
            end
        end

        l_hat[k] = numerator / denominator
    end

    return l_hat
end


# Algorithm 2 (Length-Distribution Method) of Roberts and Kroese (2007)
function length_distribution_method(origin, destination, adj_mtx, link_length_dict, N1, N2)

    no_node = size(adj_mtx,1)

    naive_samples = naive_path_generation(origin, destination, adj_mtx, N1)
    l_hat = length_distribution_vector(naive_samples, adj_mtx, no_node, destination)

    # Algorithm 2
    # Naive Path Generation
    better_samples = PathSample[]
    for k=1:N2
        adj = copy(adj_mtx)

        #2
        x = [origin]
        g = 1
        current = origin

        #3
        adj[:,origin] = 0

        next = []
        while current != destination
            t = length(x)

            #4
            if adj[current, destination] == 1
            #4. A(c,n)=1

                if sum(adj, 2)[current] == 1
                #4. destination is the only available vertex adjacent to current
                    next = destination
                else
                #4. If there are other vertices adjacent to current
                    if rand() <= l_hat[t]
                    #   choose the next vertext to be destination with probability l_hat[t]
                        g = g * l_hat[t]
                        next = destination
                    else
                        g = g * (1 - l_hat[t])
                        adj[current, destination] = 0
                    end
                end

            end

            if next == destination
                x = [x; next]
                break

            else
            #5
                V = Int[]
                for i=1:size(adj,1) # number of nodes
                    if adj[current,i] == 1
                        push!(V, i)
                    end
                end
                if length(V)==0
                    break
                end

                #6
                next = rand(V)
                x = [x; next]

                #7
                current = next
                adj[:,next] = 0
                g = g / length(V)

            end


        end

        if x[end] == destination
            this_sample = PathSample(x, g, getPathLength(x, link_length_dict))
            push!(better_samples, this_sample)
        end
    end

    return better_samples
end
