function [disJS]=JensenShannonDist(weeksList,daysList)
    D = max(daysList);
    W = max(weeksList);

    cwd = zeros(D, W);
    for j = 1:W
        ind = weeksList == j;
        [tmp, ~] = histc(daysList(ind), 1:D);
        cwd(:, j) = tmp';
    end

    disJS = zeros(W);
    for i = 1:W
        disJS(i, :) = JSDiv(cwd', cwd(:, i)');
    end
end