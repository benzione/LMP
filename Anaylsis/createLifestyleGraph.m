clear all;
close all;
clc;

drive = 'C';
nameuser = 'Tamar';
model = 1;
parameterVec = [1, 5, 10, 5, 4, 0, 10, 4];

addpath(genpath(strcat(drive, ':\OneDrive\Research\Algorithms\LMP\LMP_Paper')));
lsList = 2:2:20;
n = length(lsList);
results = zeros(2, n);
for i = 1:n
    parameterVec(6) = i;
    str = strcat(drive, ':\OneDrive\Research\Algorithms\LMP\LMP_Paper\data\likelihood', nameuser ,num2str(parameterVec,'_%d'));
    load(str);
    results(1, i) = resultsTraining(1, model);
    results(2, i) = resultsTesting(1, model);
    clearvars resultsTraining resultsTesting parameterTheta parameterPhi;
end

fig = figure;
plot(lsList, results(1, :), '-x', lsList, results(2, :), '-*');
xlabel('Number of lifestyle')
ylabel('Perplexity')
legend('Training', 'Testing')
x = gca;
x.XTick = lsList;
% str =strcat(drive, ':\OneDrive\Research\Algorithms\LMP\LMP_Paper\Figures\', nameuser, 'Model_', num2str(model), '_LifestyleBench',num2str(parameterVec,'_%d'));
% export_fig(str,'-pdf','-q101','-r600');
rmpath(genpath(strcat(drive, ':\OneDrive\Research\Algorithms\LMP\LMP_Paper')));