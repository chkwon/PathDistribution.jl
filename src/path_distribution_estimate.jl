function getCumulativeCounts(path_lengths)
    xdata = unique(path_lengths)
    ydata = zeros(Int64, length(xdata))

    for i=1:length(ydata)
        ydata[i] = count(x-> x<=xdata[i], path_lengths)
    end
    return xdata, ydata
end


cumulative_model(x, beta) =  beta[1] * (1  -  exp( - (x/beta[2]).^beta[3] ) )


function path_distribution_fitting(origin, destination, start_node, end_node, link_length)
    number_paths, path_length_samples =
        monte_carlo_path_generation(origin, destination, start_node, end_node, link_length)

    beta_est = path_distribution_fitting(number_paths, path_length_samples)

    return beta_est
end


function path_distribution_fitting(number_paths, path_lengths)

    beta_guess = [length(path_lengths), median(path_lengths), 10.0]



    min_len = minimum(path_lengths)
    max_len = maximum(path_lengths)

    x_data, y_data = getCumulativeCounts(path_lengths)

    fit = curve_fit(cumulative_model, x_data, y_data, beta_guess)
    beta_fit = fit.param
    beta_scale = [number_paths; beta_fit[2]; beta_fit[3]]
    # return beta_fit

    # x_fit = min_len:max_len
    # y_fit = cumulative_model(x_fit, beta_fit)
    # y_scale = cumulative_model(x_fit, beta_scale)
    #
    # fit_plot =
    #     plot(
    #         layer(x=x_fit, y=y_fit, Geom.line, Theme(default_color=colorant"red") ) ,
    #         layer(x=x_fit, y=y_scale, Geom.line, Theme(default_color=colorant"blue") ) ,
    #         layer(x=x_data, y=y_data, Geom.point, Theme(default_point_size=1pt,default_color=colorant"green") ),
    #         Guide.xlabel("Path Length"), Guide.ylabel("Cumulative Count"),
    #         # Guide.title(title),
    #     )
    #
    # draw(PDF("buffalo.pdf", 10inch, 6inch), fit_plot)


    return beta_scale

end
