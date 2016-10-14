function [daysAllClusters] = clusterTrajectories(daysUnique, kList)
    numOfDays = length(daysUnique);
    D = zeros(numOfDays);
    for kk = 1:numOfDays
        for jk = kk+1:numOfDays
            [D(kk,jk),~] = EditDistance(daysUnique{kk},daysUnique{jk});
        end
    end
    D = D+D';
    D = squareform(D, 'tovector');
    ZZ1 = linkage(D,'complete');
    clust = cluster(ZZ1,'maxclust', kList);
    daysAllClusters = clust;
end