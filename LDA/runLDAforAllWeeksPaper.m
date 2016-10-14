function [compareLDA] = runLDAforAllWeeksPaper(weeksList, daysAllClusters, daysList, weekSize, lsList,...
    dayArray, weekListK, allset, parameterVec)

    [~,~,IDdaysUnique] = unique(daysList);
    LS = 1; Wn = 2; Wp = 3; Dn = 4; Dp = 5;

    dag=zeros(5);
    dag(Wn,LS)=1;
    dag(LS,Dn)=1;
    [Gs, numOfModels] = createStructer(dag,[Wp,Dp],[LS,Dn]);
    nuberOFSets = length(allset);

    LS = parameterVec(6);
    lsNow = lsList(LS);
    D = parameterVec(7);
    dayNow = dayArray(D);
    daysListCurrent = daysAllClusters(IDdaysUnique, D)';
    weekAllClusetres = clusterWeeks(weeksList, daysListCurrent, weekListK);
    W = parameterVec(8);
    weekListCurrent = weekAllClusetres(weeksList,W)';
    weekNow = weekListK(W);
    ALPHA = 0.1;
    BETA = 0.01;
    N = 100;
    node_sizes = [lsNow, weekNow, weekNow, dayNow, dayNow];
    compareLDA = cell(1, numOfModels);   

    training(:,Wn) = weekListCurrent(1 + weekSize:end);
    training(:,Wp) = weekListCurrent(1:end - weekSize);
    training(:,Dn) = daysListCurrent(1 + weekSize:end);
    training(:,Dp) = daysListCurrent(1 + weekSize - 1:end - 1);

    for currentModel = 1:numOfModels
%         disp([currentModel, numOfModels]);
        [train] = GIbbs_LDA(Gs{currentModel},1,training,N,ALPHA,BETA,node_sizes);

        result.trainingset = train.samples;
        result.dag = Gs{currentModel};
        result.node_sizes = node_sizes;
        result.alpha = ALPHA;
        result.beta = BETA;

        compareLDA{currentModel} = result;
        clearvars result train test;
    end
end