function [] = lifestyle(nameuser, drive, parameterVec)
    resultsTraining = zeros(2, 16);
    resultsTesting = zeros(2, 16);
    str = strcat(drive, ':\OneDrive\Research\Algorithms\LMP\LMP_Paper\data\LDABigExp', nameuser, num2str(parameterVec,'_%d'));
    load(str);
    iter = size(compareLDA,1);
    parameterPhi = cell(iter, 16);
    parameterTheta = cell(iter, 16);
    for k = 1:16
        tmp1 = zeros(1,iter);
        tmp2 = zeros(1,iter);
        for kk = 1:iter
%             disp([kk, iter, k, 16]);
            nS = size(compareLDA{kk, k}.trainingset,1);
            [likelihoodTrain, likelihoodTest, parameterTheta{kk, k}, parameterPhi{kk, k}] = loglikelihoodLDA(compareLDA{kk, k}.dag,...
                compareLDA{kk, k}.trainingset, compareLDA{kk, k}.testset,...
                compareLDA{kk, k}.alpha, compareLDA{kk, k}.beta, compareLDA{kk, k}.node_sizes);
            tmp1(kk) = exp(-likelihoodTrain/nS);
            nS = size(compareLDA{kk, k}.testset,1);
            tmp2(kk) = exp(-likelihoodTest/nS);
        end   
        resultsTraining(1, k) = mean(tmp1);
        resultsTraining(2, k) = std(tmp1);
        resultsTesting(1, k) = mean(tmp2);
        resultsTesting(2, k) = std(tmp2);
    end

    str = strcat(drive, ':\OneDrive\Research\Algorithms\LMP\LMP_Paper\data\likelihood', nameuser, num2str(parameterVec,'_%d'));
    save(str, 'resultsTraining', 'resultsTesting', 'parameterTheta', 'parameterPhi');
end

