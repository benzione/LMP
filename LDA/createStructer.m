function [Gs, numOfModels]=createStructer(dag, source, target)
N = length(source) * length(target);
locationEdges = zeros(N, 2);
numOfModels = 2^N;

Gs = cell(1, numOfModels);
Gs{1} = dag;

ll = 1;
for i = source
    for j = target
        locationEdges(ll, :) = [i, j];
        ll = ll + 1;
    end
end

ll = 2;
for i = 1:N
    tmp = nchoosek(1:N, i);
    for j = 1:size(tmp, 1)
        Gs{ll} = dag;
        for k = 1:size(tmp, 2)
            Gs{ll}(locationEdges(tmp(j, k), 1), locationEdges(tmp(j, k), 2)) = 1;
        end
        ll = ll + 1;
    end
end
end