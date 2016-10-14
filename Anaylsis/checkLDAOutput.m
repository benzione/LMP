clear all;
close all;
clc;

% stopArea = {'Work', 'SecondWork', 'Lunch', 'Home', 'Parents', 'Grandmother', 'Other', 'NoRecored'};
% stopArea = {'Shoping', 'Work', 'Work', 'Work', 'Work',...
%     'Sport', 'Work', 'Work', 'Work', 'RoadHomeWork', 'RoadHomeWork','RoadHomeWork',...
%     'RoadHomeWork', 'RoadHomeWork', 'Home', 'Sport', 'Fun',...
%     'Parents', 'Hunt', 'Grandmother', 'Other', 'NoRecord'};
% stopArea = {'Shoping', 'Work', 'Sport', 'RoadHomeWork', 'Home', 'Fun',...
%     'Parents', 'Family', 'Other', 'NoRecord'};

currentDataset = 1;
model = 2;

parameterVec = [1, 2, 9, 5, 6, 3, 10, 4];
i1 = parameterVec(1);
testsize = parameterVec(4);
i5 = parameterVec(5);
i6 = parameterVec(6);
i7 = parameterVec(7);
i8 = parameterVec(8);

if i1 == 1
   weekSize = 7;
else
    weekSize = 5;
end

str = strcat('C:\OneDrive\Research\Algorithms\LMP\LMP_Paper\data\LDABigExpHarelReduce', num2str(parameterVec,'_%d'));
load(str);
load('C:\OneDrive\Research\Algorithms\LMP\LMP_Paper\Users\LDAinputHarelReduce');

data = compareLDA{currentDataset, model}.trainingset;
startTraining = 1 + testsize * (currentDataset - 1) * weekSize;
endTraining = startTraining + size(data,1) - 1;
ds1 = mat2dataset(daysList(startTraining:endTraining), 'VarNames', 'Trajectories');
ds2 = mat2dataset(data(:, 1), 'VarNames', 'Lifestyle');

result = [ds1, ds2];
daysLifestyle = cell(i6*2 ,1);
for i = 1:(i6*2)
    strDays = dataset2cell(result(result.Lifestyle == i, 1));
    strDays(1) = [];
    daysArr = cell(length(strDays), 1);
    for j = 1:length(strDays)
        strtmp = strjoin(strDays(j));
        previousChar = strtmp(1);
        str = stopArea{uint8(previousChar) - 64};
        count = 1;
        for k = 2:length(strtmp)
            currentChar = strtmp(k);
            if previousChar == currentChar
                count = count + 1;
            else
                str = strcat(str, num2str(count));
                str = strcat(str, stopArea{uint8(currentChar) - 64});
                previousChar = currentChar;
                count = 1;
            end
        end
        str = strcat(str, num2str(count));
        daysArr{j} = str;
    end
    daysLifestyle{i} = unique(daysArr);
end


