function [daysList, weeksList] = makeInputForLDA(trajctories, weekSize)
    numAllDays = size(trajctories, 1);
    currentNumofDays = floor(numAllDays / weekSize) * weekSize;
    daysList = cell(currentNumofDays, 1);
    for i = 1:currentNumofDays
        tmp = trajctories{i};
        n = length(tmp);
        str = '';
        for j = 1:n
            str = strcat(str,char(64 + tmp(j)));
        end
        daysList{i} = str;
    end    
    numOfWeeks = currentNumofDays / weekSize;
    weeksList = reshape(repmat(1:numOfWeeks, weekSize, 1), [numOfWeeks * weekSize, 1])';
end
