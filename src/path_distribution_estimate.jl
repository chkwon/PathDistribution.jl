# function getCumulativeCounts(path_lengths)
#     xdata = unique(path_lengths)
#     ydata = zeros(Int64, length(xdata))
#
#     for i=1:length(ydata)
#         ydata[i] = count(x-> x<=xdata[i], path_lengths)
#     end
#     return xdata, ydata
# end


cumulative_model(x, beta) =  beta[1] * (1  -  exp( - (x/beta[2]).^beta[3] ) )



function path_distribution_fitting(origin, destination, start_node, end_node, link_length, N1=5000, N2=10000)
    no_path_est, x_data, y_data =
        monte_carlo_path_distribution(origin, destination, start_node, end_node, link_length, N1, N2)



    beta_est = path_distribution_fitting(x_data, y_data)

    return beta_est
end




function path_distribution_fitting(x_data, y_data)

    beta_guess = [y_data[end], median(x_data), 10.0]
    fit = curve_fit(cumulative_model, x_data, y_data, beta_guess)

    return fit.param

end
