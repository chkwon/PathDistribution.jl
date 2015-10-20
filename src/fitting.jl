
cumulative_model(x, beta) =  beta[1] * (1  -  exp( - (x/beta[2]).^beta[3] ) )


function path_distribution_fitting(origin, destination, start_node, end_node, link_length, N1=5000, N2=10000)
    return path_distribution_fitting(origin, destination, start_node, end_node, link_length, N1, N2, :uniform)
end

function path_distribution_fitting(origin, destination, start_node, end_node, link_length, option=:uniform)
    return path_distribution_fitting(origin, destination, start_node, end_node, link_length, 5000, 10000, option)
end

function path_distribution_fitting(origin, destination, start_node, end_node, link_length, N1=5000, N2=10000, option=:uniform)
    samples = monte_carlo_path_sampling(origin, destination, start_node, end_node, link_length, N1, N2)
    x_data, y_data = estimate_cumulative_count(samples, option)
    beta_est = path_distribution_fitting(x_data, y_data)
    return beta_est
end




function path_distribution_fitting(x_data, y_data)

    beta_guess = [y_data[end], median(x_data), 10.0]
    fit = curve_fit(cumulative_model, x_data, y_data, beta_guess)

    return fit.param

end

function estimate_cumulative_count(samples::Array{PathSample,1}, option=:uniform)
    no_path_est = 0
    path_lengths = Array{Float64,1}(0)
    likelihoods = Array{Float64,1}(0)
    for s in samples
        no_path_est += 1 / s.g
        push!(path_lengths, s.length)
        push!(likelihoods, s.g)
    end
    no_path_est = no_path_est / samples[1].N


    N_data = 100
    # option == :uniform
    x_data = collect(linspace(minimum(path_lengths), maximum(path_lengths), N_data))
    if option == :unique
        x_data = sort(unique(path_lengths))
    elseif option == :first_quarter
        x_q1 = linspace(minimum(path_lengths), 0.25*maximum(path_lengths), N_data/2)
        x_q234 = linspace(0.25*maximum(path_lengths), maximum(path_lengths), N_data/2)
        x_data = append!(collect(x_q1), collect(x_q234))
    end

    y_data = similar(x_data)

    for i=1:length(x_data)
        idx = find(x-> x<=x_data[i], path_lengths)
        y_data[i] = sum(1 ./ likelihoods[idx])
    end
    y_data =  y_data / samples[1].N

    return x_data, y_data
end
