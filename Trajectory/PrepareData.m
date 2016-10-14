clear all;
close all;
clc;

drive = 'C';
nameuser = 'Yarden';

% str = strcat(drive, ':\OneDrive\Research\Algorithms\matlab-json\', nameuser);
% load(str);
% numofMS=24*60*60*1000;
% dnOffset=datenum('01-Jan-1970 03:00:00');
% 
% lendata=size(X.locations,2);
% data=zeros(lendata,9);
% for i=1:lendata
%     disp([lendata,i])
%     data(i,1)=X.locations{1, lendata-i+1}.latitudeE7;
%     data(i,2)=X.locations{1, lendata-i+1}.longitudeE7;
%     data(i,4:end)=datevec((str2double(X.locations{1, lendata-i+1}.timestampMs)/numofMS)+dnOffset);
%     data(i,3)=(str2double(X.locations{1, lendata-i+1}.timestampMs)/numofMS)+dnOffset;
% end
% str = strcat('C:\OneDrive\Research\Algorithms\LMP\LMP_Paper\Users\', nameuser, 'AllData');
% save(str,'data');
str = strcat(drive, ':\OneDrive\Research\Algorithms\LMP\LMP_Paper\Users\', nameuser, 'AllData');
load(str);

% [tmp1, ~, tmp2] = unique(etime(data(2:end, 4:9), data(1:end-1, 4:9)) / (60 * 60));
nrow=size(data,1);
startR = 1;
bothR = 0;
idx = zeros(1, 2);
for i = 1:nrow-1
    disp([i, nrow-1]);
    elp = etime(data(i + 1, 4:9), data(i, 4:9)) / (60 * 60 * 24 * 7);
    if elp > 4
        if etime(data(i, 4:9), data(startR, 4:9)) / (60 * 60) > bothR
            bothR = etime(data(i, 4:9), data(startR, 4:9)) / (60 * 60);
            idx = [startR, i];
        end
        startR = i + 1;
    end
end

if idx(1)
    data = data(idx(1):idx(2), :);
end
nrow = size(data,1);
for i = 1:nrow
    if weekday(data(i,3)) == 1
        startrecord = i;
        break;
    end
end
data = data(startrecord:end, :);
data(:,1:2) = data(:,1:2)/10000000;
disp(etime(data(end, 4:9), data(1, 4:9)) / (60 * 60 * 24 * 7))
str = strcat(drive, ':\OneDrive\Research\Algorithms\LMP\LMP_Paper\Users\', nameuser, 'Data');
save(str,'data');
    