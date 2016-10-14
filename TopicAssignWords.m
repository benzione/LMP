clear all;
close all;
clc;


drive = 'C';
nameuser = 'Tamar';
model = 5;
numOfTraj = 10;
parameterVec = [1, 5, 10, 5, 4, 3, 10, 4];
addpath(genpath(strcat(drive, ':\OneDrive\Research\Algorithms\LMP\LMP_Paper')));
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
topicAssignTrajectory = cell(numOfTraj, i6*2);
for i = 1:(i6*2)
    currentTopic = phi(:, i);
    [~, signTrajectoriesID] = sort(currentTopic,'descend');
    signTrajectoriesID(numOfTraj + 1:end) = [];
    for j = 1:numOfTraj
        topicAssignTrajectory{j,i} = signTrajectoriesID(j);
    end
end
str = strcat(drive, ':\OneDrive\Research\Algorithms\LMP\LMP_Paper\Figures\topic2words_', nameuser,'.txt');

fileID = fopen(str,'w');
formatSpec = '%d %d %d %d %d %d\n';
for i = 1:length(topicAssignTrajectory)
    fprintf(fileID,formatSpec,topicAssignTrajectory{i,:});
end   
fclose(fileID);

rmpath(genpath(strcat(drive, ':\OneDrive\Research\Algorithms\LMP\LMP_Paper')));

