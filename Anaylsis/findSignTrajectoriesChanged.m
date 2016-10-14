clear all;
close all;
clc;

drive = 'C';
nameuser = 'Harel';
model = 8;
numOfTraj = 5;
parameterVec = [1, 5, 10, 5, 4, 3, 10, 4];
% Harel
if strcmp(nameuser, 'Harel')
    stopArea = {'SeconderyWork', 'Friends', 'MainWork', 'Sport', 'Road', 'Home',...
        'ParentsH', 'FamilyH', 'Other', 'NoRecord'};
% Yarden
elseif strcmp(nameuser, 'Yarden')
    stopArea = {'FriendsBS', 'Home', 'Shopping', 'Study', 'FriendsTA', 'FamilyW',...
        'ParentsH', 'Other', 'NoRecord'};
% Tamar
elseif strcmp(nameuser, 'Tamar')
    stopArea = {'ParentsW', 'Kindergarten', 'CityRoads', 'Home', 'DogTrip',...
        'MainWork', 'SecondryWork', 'MainStudy', 'Family', 'ParentH', 'SecondryStudy',...
        'Other', 'NoRecord'};    
end

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

str = strcat(drive, ':\OneDrive\Research\Algorithms\LMP\LMP_Paper\data\LDABigExp', nameuser, num2str(parameterVec,'_%d'));
load(str);
load(strcat(drive, ':\OneDrive\Research\Algorithms\LMP\LMP_Paper\Users\LDAinput', nameuser));
str = strcat(drive, ':\OneDrive\Research\Algorithms\LMP\LMP_Paper\data\likelihood', nameuser, num2str(parameterVec,'_%d'));
load(str);
clusterdDays = daysAllClusters(:, i7);
uniqueDays = unique(daysList);
result = allLDA{model};
phi = findPhi(result);

daysLifestyle = cell(numOfTraj, i6*2);
for i = 1:(i6*2)
    currentTopic = phi(:, i);
    [~, signTrajectoriesID] = sort(currentTopic,'descend');
    signTrajectoriesID(numOfTraj + 1:end) = [];
    strDays = cell(numOfTraj, 1);
    for j = 1:numOfTraj
        idx = find(clusterdDays == signTrajectoriesID(j));
        strDays(j) = uniqueDays(idx(1));
    end
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
    daysLifestyle(:, i) = daysArr;
end
str = strcat(drive, ':\OneDrive\Research\Algorithms\LMP\LMP_Paper\Figures\daysLifestyleModel_', num2str(model), '_', nameuser, num2str(parameterVec,'_%d'),'.csv');
% save(str, 'daysLifestyle');
cell2csv(str, daysLifestyle);

