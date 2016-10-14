function [LLtrain, LLtest, theta, phi] = loglikelihoodLDA(dag, train, test, alpha, beta, ns)
    LS = 1; Dn = 4;
    numTokenTrain = size(train,1);
    numTokenTest = size(test,1);
    parentLS = find(dag(:, LS))';
    allParentsLS = [LS, parentLS];
    theta = zeros(ns(allParentsLS));
    parentTrajectory = find(dag(:,Dn))';
    allparentTrajectory = [Dn, parentTrajectory];
    phi = zeros(ns(allparentTrajectory));
    combainParents = setdiff(unique([parentLS, parentTrajectory]),LS);
    combainParentsTrajectory = [Dn combainParents];
    NconditionTraining = zeros(ns(combainParentsTrajectory));
    NconditionTest = zeros(ns(combainParentsTrajectory));
    for j=1:numTokenTrain
        evidance = train(j,:);
        idx = sub2indmy(size(phi),[evidance(Dn),evidance(parentTrajectory)]);
        phi(idx) = phi(idx)+1;
        idx = sub2indmy(size(theta),[evidance(LS),evidance(parentLS)]);
        theta(idx) = theta(idx)+1;
        idx = sub2indmy(size(NconditionTraining),[evidance(Dn), evidance(combainParents)]);
        NconditionTraining(idx) = NconditionTraining(idx)+1;
    end
    for j=1:numTokenTest
        evidance = test(j,:);
        idx = sub2indmy(size(NconditionTest),[evidance(Dn), evidance(combainParents)]);
        NconditionTest(idx) = NconditionTest(idx)+1;
    end
    
    sumTheta = sum(theta + alpha, 1);
    sumPhi = sum(phi + beta, 1);
    
    LLtrain = 0;
    LLtest = 0;
    for i = 1:numel(NconditionTest);
        if NconditionTest(i) > 0 || NconditionTraining(i) > 0
           [idx1, idx2, idx3, idx4, idx5] = ind2sub(ns(combainParentsTrajectory),i);
           idx = [idx2, idx3, idx4, idx5];
           if length(combainParents)<4
               idx(length(combainParents)+1:end) = [];
           end
           sumTopic = 0;
           for j = 1:ns(LS)
               [~, idxtmp1] = intersect(combainParents, parentLS);
               [~, idxtmp2] = intersect(combainParents, parentTrajectory);
               idxtmp11 = sub2indmy(size(theta),[j,idx(idxtmp1)]);
               idxtmp12 = sub2indmy(size(sumTheta),[1, idx(idxtmp1)]);
               idxtmp21 = sub2indmy(size(phi),[idx1, j, idx(idxtmp2)]);
               idxtmp22 = sub2indmy(size(sumPhi),[1, j, idx(idxtmp2)]);
               sumTopic = sumTopic + ((theta(idxtmp11)+alpha)/sumTheta(idxtmp12))*...
                   ((phi(idxtmp21)+beta)/sumPhi(idxtmp22));
           end
           LLtrain = LLtrain + NconditionTraining(i) * log(sumTopic);
           LLtest = LLtest + NconditionTest(i) * log(sumTopic);
       end
    end
       
end