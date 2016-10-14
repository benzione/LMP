function [compareLDA] = runLDAforPaper(weeksList, daysAllClusters, daysList, weekSize, lsList,...
    dayArray, weekListK, testsize, allset, parameterVec)

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
    compareLDA = cell(nuberOFSets, numOfModels);
    for setSize = 1:nuberOFSets
        startTraining = 1 + testsize * (setSize-1) * weekSize;
        endTraining = (allset(setSize) - testsize) * weekSize;
        startTesting = 1 + (allset(setSize) - testsize) * weekSize;
        endTesting = allset(setSize) * weekSize;
        training = zeros(endTraining - startTraining - weekSize + 1, 5);
        testing = zeros(endTesting - startTesting + 1, 5);

        training(:,Wn) = weekListCurrent(startTraining + weekSize:endTraining);
        training(:,Wp) = weekListCurrent(startTraining:endTraining - weekSize);
        training(:,Dn) = daysListCurrent(startTraining + weekSize:endTraining);
        training(:,Dp) = daysListCurrent(startTraining + weekSize - 1:endTraining - 1);

        testing(:,Wn) = weekListCurrent(startTesting:endTesting);
        testing(:,Wp) = weekListCurrent(startTesting - weekSize:endTesting - weekSize);
        testing(:,Dn) = daysListCurrent(startTesting:endTesting);
        testing(:,Dp) = daysListCurrent(startTesting - 1:endTesting - 1);

        for currentModel = 1:numOfModels
%             disp([setSize, nuberOFSets, currentModel, numOfModels]);
            [train] = GIbbs_LDA(Gs{currentModel},1,training,N,ALPHA,BETA,node_sizes);
            [test] = assign2testGibbs(train,testing,N,1,ALPHA,BETA,node_sizes);

            result.trainingset = train.samples;
            result.testset = test.samples;
            result.dag = Gs{currentModel};
            result.node_sizes = node_sizes;
            result.alpha = ALPHA;
            result.beta = BETA;

            compareLDA{setSize, currentModel} = result;
            clearvars result train test;
        end
    end
end