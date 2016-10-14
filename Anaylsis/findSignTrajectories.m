clear all;
close all;
clc;

% % % Ran
% stopArea = {'RoadInterurbanBSN', 'RoadInterurbanWork', 'BadAntenaWork', 'MarketWork', 'Work',...
%     'RamatGanRoads', 'Fun', 'OldHome', 'RanParents', 'RoadInterurbanBSS', 'Friends',...
%     'BadAntenaRamotWest', 'BeerShevaRoads', 'Home', 'Kindergarten', 'AnnaParents',...
%     'BadAntenaRamotEast', 'Other', 'NoRecord'};
% % Harel
% stopArea = {'Shoping', 'Work', 'Sport', 'RoadHomeWork', 'Home', 'Fun',...
%     'Parents', 'Family', 'Other', 'NoRecord'};
% % Tamar
stopArea = {'ParentsW', 'Kindergarten', 'CityRoads', 'DogTrip', 'Home',...
    'MainWork', 'SecondryWork', 'Family', 'MainStudy', 'ParentH', 'SecondryStudy',...
    'Other', 'NoRecord'};

currentDataset = 1;
model = 8;

parameterVec = [1, 5, 10, 5, 4, 2, 10, 4];
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

str = strcat('C:\OneDrive\Research\Algorithms\LMP\LMP_Paper\data\LDABigExpTamar', num2str(parameterVec,'_%d'));
load(str);
load('C:\OneDrive\Research\Algorithms\LMP\LMP_Paper\Users\LDAinputTamar');
str = strcat('C:\OneDrive\Research\Algorithms\LMP\LMP_Paper\data\likelihoodTamar',num2str(parameterVec,'_%d'));
load(str);
clusterdDays = daysAllClusters(:, i7);
uniqueDays = unique(daysList);
result = allLDA{model};
phi = findPhi(result);

daysLifestyle = cell(1, i6*2);
for i = 1:(i6*2)
    currentTopic = phi(:, i);
    [~, signTrajectoriesID] = sort(currentTopic,'descend');
    signTrajectoriesID(6:end) = [];
    idx = [];
    for j = 1:5
        idx = [idx; find(clusterdDays == signTrajectoriesID(j))];
    end
    strDays = uniqueDays(idx);
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
str = strcat('C:\OneDrive\Research\Algorithms\LMP\LMP_Paper\data\daysLifestyleTamar', num2str(parameterVec,'_%d'));
save(str, 'daysLifestyle');

