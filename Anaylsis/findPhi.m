function [phi] = findPhi(result)
    phi = zeros(result.node_sizes([4,1]));
    data = result.trainingset;
    for i = 1:size(data,1)
        phi(data(i,4), data(i,1)) = phi(data(i,4), data(i,1)) + 1;
    end
end