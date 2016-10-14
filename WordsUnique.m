clear all;
close all;
clc;

nameuser = 'Yarden';
drive = 'C';
load(strcat(drive, ':\OneDrive\Research\Algorithms\LMP\LMP_Paper\Users\\LDAinput', nameuser,'.mat'));

[~,~,IDdaysUnique] = unique(daysList);
daysListCurrent = daysAllClusters(IDdaysUnique, 10)';
words = cell(100, 1);
j = 1;
str = '';
for i = 1:length(daysListCurrent)
    m = daysListCurrent(i);
    x = m;
    str = '';
    while x > 0
        if x > 26
            d = mod(x, 26);
            if d == 0
                d = 26;
            end
        else
            d = x;
        end
        x = x - 26;
        str = sprintf('%s%s',str, char(d + 64));        
    end
    words{m, 1} = str;
end

fileID = fopen(strcat(nameuser,'Words.txt'),'w');
formatSpec = '%s\n';        
for i = 1:length(words)
    fprintf(fileID,formatSpec,words{i});
end   
fclose(fileID);
        