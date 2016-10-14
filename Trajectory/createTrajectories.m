function [trajctories] = createTrajectories(data, flag)
    t = datenum([data(1, 4:6), 0, 0, 0]);
    tEnd = data(end, 3);
    numOfDays = ceil(tEnd-t);
    maxCluster = max(data(:, end)) + 1;
    trajctories = cell(numOfDays, 1);
    for i = 1:numOfDays
        daySlots = zeros(1, 24);
        for j = 1:24;
            t1 = addtodate(t, 1, 'hour');
            x = data(data(:, 3) >= t & data(:, 3) < t1, end);
            if ~isempty(x)
                [a,b] = histc(x,unique(x));
                y = a(b);
                [~, I] = max(y); 
                daySlots(j) = x(I);             
            else
                daySlots(j) = maxCluster;
            end
            t = t1;
        end           
        trajctories{i} = daySlots;    
    end
    if flag
        tmp = 7:7:numOfDays;
        trajctories(tmp) = [];
        numOfDays = size(trajctories,1);
        tmp = 6:6:numOfDays;
        trajctories(tmp) = [];
    end
end
            
        
    
