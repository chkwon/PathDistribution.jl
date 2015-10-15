function getLinkLengthDict(start_node, end_node, link_length)
    link_length_dict = Dict()
    for k=1:length(start_node)
        link_length_dict[ start_node[k] , end_node[k] ] = link_length[k]
    end

    return link_length_dict
end

function getPathLength(path, link_length_dict)

    if length(link_length_dict) == 0
        return 0.0
    else
        path_length = 0
        for k=1:length(path)-1
            i = path[k]
            j = path[k+1]

            path_length += link_length_dict[i,j]
        end

        return path_length
    end
    
end

function getNoNode(start_node, end_node)
    no_node = max( maximum(start_node), maximum(end_node) )
    return no_node
end

function getAdjacency(start_node, end_node)

    no_node = getNoNode(start_node, end_node)

    adj = zeros(Int64, no_node, no_node)

    for k=1:length(start_node)
        i = start_node[k]
        j = end_node[k]
        adj[i,j] = 1
    end

    #
    #
    # adj = [0 1 1 1 0 1 1 1;
    #        1 0 0 0 1 1 1 0;
    #        1 0 0 1 1 1 1 1 ;
    #        1 0 1 0 1 1 1 1 ;
    #        0 1 1 1 0 1 0 0 ;
    #        1 1 1 1 1 0 1 1 ;
    #        1 1 1 1 0 1 0 1 ;
    #        1 0 1 1 0 1 1 0 ]

    # adj = [ 0 1 1 1 1 1 1 0 1 1 1 1;
    #         1 0 1 1 1 1 1 1 1 1 1 1;
    #         1 1 0 1 1 1 1 1 1 0 1 1;
    #         1 1 1 0 1 1 1 1 1 1 0 1;
    #         1 1 1 0 0 1 1 1 0 1 1 1;
    #         1 1 1 1 1 0 1 1 1 1 1 0;
    #         1 1 1 1 1 1 0 1 1 1 1 1;
    #         1 1 1 1 1 1 1 0 1 1 1 1;
    #         1 1 1 1 1 1 1 1 0 1 1 1;
    #         1 1 1 1 1 1 1 1 1 0 1 0;
    #         1 1 1 1 1 1 1 1 1 1 0 1;
    #         1 1 1 1 1 1 1 1 1 1 1 0         ]
    #


    return adj
end
