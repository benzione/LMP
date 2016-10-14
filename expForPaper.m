function [] = expForPaper(nameuser, drive, i1, i2, i3, i4, i5, i6, i7, i8)
    addpath(genpath(strcat(drive, ':\OneDrive\Research\Algorithms\FullBNT-1.0.7')));

    kclustertraj = 10:10:100;
    lsList = 2:2:20;
    testsize = (1:5);
    allsetsize = (25:5:50);

    if i1==1
        weekSize = 7;
    else
        weekSize = 5;
    end
    str = strcat(drive, ':\OneDrive\Research\Algorithms\LMP\LMP_Paper\Users\LDAinput', nameuser);
    load(str);
    numOfWeeks = max(weekList);
    weekListK = 5:5:30;
    minWeekEnd = numOfWeeks-mod(numOfWeeks,testsize(i4));
    allset = (allsetsize(i5):testsize(i4):minWeekEnd);
    if length(allset)>10
        allset = allset(1:10);
    end

    compareLDA = runLDAforPaper(weekList, daysAllClusters, daysList, weekSize, lsList,...
        kclustertraj, weekListK, testsize(i4), allset, [i1, i2, i3, i4, i5, i6, i7, i8]);
    [allLDA] = runLDAforAllWeeksPaper(weekList, daysAllClusters, daysList, weekSize, lsList,...
        kclustertraj, weekListK, allset, [i1, i2, i3, i4, i5, i6, i7, i8]);

    str = strcat(drive, ':\OneDrive\Research\Algorithms\LMP\LMP_Paper\data\LDABigExp', nameuser, num2str([i1, i2, i3, i4, i5, i6, i7, i8],'_%d'));
        save(str,'compareLDA', 'allLDA');

%     rmpath(genpath('E:\OneDrive\Research\Algorithms\LMP\LMP_Paper'));
    rmpath(genpath(strcat(drive, ':\OneDrive\Research\Algorithms\FullBNT-1.0.7')));
end