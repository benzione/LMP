clear all;
close all;
clc;

nameuser = 'Tamar';
drive = 'C';
load(strcat(drive, ':\OneDrive\Research\Algorithms\LMP\LMP_Paper\Users\\LDAinput', nameuser,'.mat'));

[~,~,IDdaysUnique] = unique(daysList);
daysListCurrent = daysAllClusters(IDdaysUnique, 10)';
sentences = cell(length(daysListCurrent) / 7, 1);
j = 1;
str = '';
for i = 1:length(daysListCurrent)
    x = daysListCurrent(i); 
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
    if mod(i, 7) ~= 0
        str = sprintf('%s ', str);
    else
        if i > 7
            strnew = sprintf('%s %s', strpre, str);
            sentences{j} = strnew;
            j = j + 1;
        end
        strpre = str;
        str = '';
    end
end

fileID = fopen(strcat(nameuser,'Data.txt'),'w');
formatSpec = '%s\n';        
for i = 1:length(daysListCurrent) / 7
    fprintf(fileID,formatSpec,sentences{i});
end   
fclose(fileID);
        