function [data] = findStopArea(data, i)
    clustercoor = round(data(:, 1:2).* 10000 / i) * (i / 10000);
    [~ , ~, label] = unique(clustercoor, 'rows');
    data = [data, label];
end
