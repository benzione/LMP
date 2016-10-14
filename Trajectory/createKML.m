clear all;
close all;
clc;

drive = 'C';
nameuser = 'Tamar';
load(strcat(drive, ':\OneDrive\Research\Algorithms\LMP\LMP_Paper\Users\', nameuser, 'Data'));

rc = 5;
thresh = [0.1:0.1:0.9,0.95,1];
[data] = findStopArea(data, rc);
arrFlag = occurrenceCluster(data);
[data] = changeClusterNum(data, arrFlag, thresh(10));
maxClust = max(data(:, end));
uncoord = zeros(800, 2);
j = 1;
for i = 1:maxClust
    tmp = find(data(:,end) == i);
    uncoord(j, :) = round(data(tmp(1),1:2).*10000/rc)*rc/10000;
    j =  j + 1;
end
uncoord(uncoord(:, 1)==0,:) = [];
filename = strcat(nameuser, 'StopArea.kml');
kmlwrite(filename, uncoord(:,1), uncoord(:,2));
