function [data] = changeClusterNum(data, arrFlag, k)
    idX = find(arrFlag > k);
    maxCluster = max(data(:, end)) + 1;
    data(ismember(data(:, end), idX),end) = maxCluster;
    j = 1;
    for i = 1:maxCluster
        tmp = find(data(:, end) == i);
        if ~isempty(tmp)
            data(tmp, end) = j;
            j = j + 1; 
        end
    end
end