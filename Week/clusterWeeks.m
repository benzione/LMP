function [weekClusetred] = clusterWeeks(weeksList, daysList, kList)
    D = JensenShannonDist(weeksList,daysList);
    D = squareform(D, 'tovector');
    ZZ = linkage(D,'complete');
    weekClusetred = cluster(ZZ,'MaxClust',kList);
end