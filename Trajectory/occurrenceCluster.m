function [arrFlag] = occurrenceCluster(data)
    numClust = max(data(:, end));
    startHour = datenum([data(1, 4:6), 0, 0, 0]);
    weekDate = addtodate(startHour, 7, 'day');
    arrFlag = zeros(numClust,1);
    arrSToccur = zeros(numClust,1);
    weekCount = 0;
    while (startHour < data(end, 3))
        endHour = addtodate(startHour, 1, 'hour');
        if endHour <= weekDate
            x = data(data(:, 3) >= startHour & data(:, 3) < endHour, end); 
            if ~isempty(x)
                y = unique(x);
                for i = 1:length(y)
                    arrSToccur(y(i)) = arrSToccur(y(i)) + 1;
                end
            end
        else
            weekDate = addtodate(weekDate, 7, 'day');
            arrFlag(arrSToccur <= 3) = arrFlag(arrSToccur <= 3) + 1;
            arrSToccur = zeros(numClust,1);
            weekCount = weekCount + 1;
        end
        startHour = endHour;
    end
    arrFlag = arrFlag / weekCount;
end