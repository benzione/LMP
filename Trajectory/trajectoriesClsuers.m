clear all;
close all;
clc;

drive = 'C';
nameuser = 'Tamar';

load(strcat(drive, ':\OneDrive\Research\Algorithms\LMP\LMP_Paper\Users\', nameuser, 'Data'));
disp(etime(data(end, 4:9), data(1, 4:9)) / (60 * 60 * 24 * 7))
kclustertraj = 10:10:100;
lsList = 2:2:20;

weekdays = 1;
rCell = 5;
i3 = 10;
testsize = 5;
allsetsize = 50;

if weekdays == 1
    weekSize = 7;
else
    weekSize = 5;
end
thresh = [0.1:0.1:0.9, 0.95, 1];

data = findStopArea(data,rCell);
arrFlag = occurrenceCluster(data);
data = changeClusterNum(data, arrFlag, thresh(i3));
% Harel
if strcmp(nameuser, 'Harel')
    stopArea = ones(62, 1) * 3;
    stopArea(1) = 1;
    stopArea(2:3) = 2;
    stopArea([15,16,27,54]) = 4;
    stopArea([37,43,45:47]) = 5;
    stopArea(48:53) = 6;
    stopArea(55:60) = 7;
    stopArea(61:63) = 8;
    stopArea(64) = 9;
% Yarden
elseif strcmp(nameuser, 'Yarden')
    stopArea = ones(83, 1) * 4;
    stopArea([1:11, 66:68]) = 1;
    stopArea(12:20) = 2;
    stopArea(38) = 3;
    stopArea(69) = 5;
    stopArea(70:76) = 6;
    stopArea(77:82) = 7;
    stopArea(83) = 8;  
% Tamar
elseif strcmp(nameuser, 'Tamar')   
    stopArea = ones(92, 1) * 6;
    stopArea(1:3) = 1;
    stopArea(4:5) = 2;
    stopArea([6, 7, 11, 17, 29, 30, 31]) = 3;
    stopArea([10, 12:15, 18:21, 24, 25]) = 4;
    stopArea([8, 9, 16, 22, 23, 26, 27, 28]) = 5;
    stopArea(63:76) = 7;
    stopArea(77) = 8;
    stopArea(78) = 9;
    stopArea(79) = 10;
    stopArea(80:83) = 11;
    stopArea(84) = 12;
end

data(:, end) = stopArea(data(:, end));
save(strcat(drive, ':\OneDrive\Research\Algorithms\LMP\LMP_Paper\Users\', nameuser, 'PostData'),'data');
% load('E:\OneDrive\Research\Algorithms\LMP\LMP_Paper\Users\TamarPostData')
trajctories = createTrajectories(data, weekdays - 1);
[daysList, weekList] = makeInputForLDA(trajctories, weekSize);
daysUnique = unique(daysList);
daysAllClusters = clusterTrajectories(daysUnique, kclustertraj);
save(strcat(drive, ':\OneDrive\Research\Algorithms\LMP\LMP_Paper\Users\LDAinput', nameuser), 'daysList', 'daysAllClusters', 'weekList');