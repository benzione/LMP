clear all;
close all;
clc;

load('E:\OneDrive\Research\Algorithms\LMP\LMP_Paper\Users\RanAllData');

nrow=size(data,1);
startR = 1;
bothR = 0;
idx = zeros(1, 2);
for i = 1:nrow-1
    elp = etime(data(i + 1, 4:9), data(i, 4:9)) / (60 * 60);
    t1 = datenum(data(i, 4:9));
    t2 = data(i + 1, 3);
    telp = t2 - t1;
    if elp > 18
        if i - startR > bothR
            bothR = i - startR;
            idx = [startR, i];
        end
        startR = i + 1;
    end
end

disp(etime(data(idx(2), 4:9), data(idx(1), 4:9)) / (60 * 60 * 24 * 7))
   
startHour = datenum([data(idx(1), 4:7), 0, 0]);
count = 0;
while (startHour < data(idx(2), 3))
    endHour = addtodate(startHour, 1, 'hour');
    tmp = data(data(:, 3) >= startHour & data(:, 3) < endHour, 3); 
    if isempty(tmp)
        count = count + 1;
    end
    startHour = endHour;
end
disp(count)
disp(etime(data(idx(2), 4:9), data(idx(1), 4:9)) / (60 * 60))