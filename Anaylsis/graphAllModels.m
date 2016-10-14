clear all;
close all;
clc;

drive = 'C';
nameuser = 'Tamar';

addpath(genpath(strcat(drive, ':\OneDrive\Research\Algorithms\LMP\LMP_Paper')));
for i = 3
    parameterVec = [1, 5, 10, 5, 4, i, 10, 4];

    dayArray = 10:10:100;
    allsetsize = 5:5:30;
    nModels1 = 1:16;
    nModels2 = [1, 4:5, 2:3, 11, 7:10, 6, 14:15, 12:13, 16];

    modelsLabels = {'1', '2','3', '4', '5', '6', '7', '8', '9', '10', ...
        '11','12', '13', '14', '15' , '16'};
    str = strcat(drive, ':\OneDrive\Research\Algorithms\LMP\LMP_Paper\data\likelihood', nameuser, num2str(parameterVec,'_%d'));
    load(str);

    if dayArray(parameterVec(end - 1)) < allsetsize(parameterVec(end))
        y1 = resultsTraining(1, nModels2);
        e1 = resultsTraining(2, nModels2);
        y2 = resultsTesting(1, nModels2);
        e2 = resultsTesting(2, nModels2);
        nXtick = modelsLabels(nModels2);
    else
        y1 = resultsTraining(1, :)';
        e1 = resultsTraining(2, :)';
        y2 = resultsTesting(1, :)';
        e2 = resultsTesting(2, :)';
        nXtick = modelsLabels;
    end

    figure;
    % set(gca,'fontsize',35)
    hold on;
    errorbar(nModels1, y1, e1, '-x');
    hold on;
    errorbar(nModels1, y2, e2, '-*');

    set(gca,'XTick',nModels1);
    set(gca,'XTickLabel',nXtick);
    ylabel('Perplexity')
    str = sprintf('Model number');
    xlabel(str)
    legend('Training', 'Testing');

    tmp = ceil(max(y2(2:3)));
    rectangle('Position',[1.8, 0, 1.4, tmp],'Curvature',0.2)
    tmp = ceil(max(y2(4:5)));
    rectangle('Position',[3.8, 0, 1.4, tmp],'Curvature',0.2)
    tmp = ceil(max(y2(7:10)));
    rectangle('Position',[6.8, 0, 3.4, tmp],'Curvature',0.2)
    tmp = ceil(max(y2(12:13)));
    rectangle('Position',[11.8, 0, 1.4, tmp],'Curvature',0.2)
    tmp = ceil(max(y2(14:15)));
    rectangle('Position',[13.8, 0, 1.4, tmp],'Curvature',0.2)

%     str = strcat(drive, ':\OneDrive\Research\Algorithms\LMP\LMP_Paper\Figures\GraphAllModels', nameuser, num2str(parameterVec,'_%d'),'.pdf');
%     export_fig(str,'-pdf','-q101','-r600');
%     close all;
end
rmpath(genpath(strcat(drive, ':\OneDrive\Research\Algorithms\LMP\LMP_Paper')));