function [result] = assign2testGibbs(input, samples, N, class_hidden, alpha, beta, node_sizes)
    numToken = size(samples,1);
    allChild = input.allChild;
    parentnode = input.parentnode;
    cChildHidden = input.cChildHidden;
    sumAllCCH = input.sumAllCCH;


    samples(:, class_hidden) = ceil(rand(numToken, 1).* node_sizes(class_hidden));

    cChildHiddenTmp = zeros(size(cChildHidden));
    if ~isempty(parentnode)
        cParentHidden = zeros(node_sizes([parentnode, class_hidden]));
    else
        cParentHidden = zeros(1, node_sizes(class_hidden));
    end

    for j = 1:numToken
        evidance = samples(j, :);
        idx = sub2indmy(size(cChildHiddenTmp), [evidance(allChild), evidance(class_hidden)]);
        cChildHiddenTmp(idx) = cChildHiddenTmp(idx) + 1;
        idx=sub2indmy(size(cParentHidden), [evidance(parentnode), evidance(class_hidden)]);
        cParentHidden(idx) = cParentHidden(idx) + 1;
    end

    if ~isempty(allChild)
        sumAllCCHtmp = sum(reshape(cChildHiddenTmp, prod(node_sizes(allChild))...
            ,node_sizes(class_hidden)) + beta);
    else
        sumAllCCHtmp = cChildHidden;
    end
    if ~isempty(parentnode)
        sumAllCPH = sum(cParentHidden + alpha, length(parentnode) + 1);
    else
        sumAllCPH = sum(cParentHidden);
    end

    for i = 1:N
        u = rand(1, numToken);
        for j = 1:numToken
            sizHidden = node_sizes(class_hidden);
            jT = samples(j, class_hidden);
            evidance = samples(j, :);
            if ~isempty(allChild)
                jW = sub2indmywithoutclass(size(cChildHidden), evidance(allChild));
            else
                jW = 1:sizHidden;
            end
            if ~isempty(parentnode)
                jD = sub2indmywithoutclass(size(cParentHidden), evidance(parentnode));
                jSumD = sub2indmy(size(sumAllCPH), evidance(parentnode));
            else
                jD = 1:sizHidden;
                jSumD = 1;
            end
            cChildHiddenTmp(jW(jT)) = cChildHiddenTmp(jW(jT)) - 1;
            cParentHidden(jD(jT)) = cParentHidden(jD(jT)) - 1;
            sumAllCCHtmp(jT) = sumAllCCHtmp(jT) - 1;
            pz = ((cChildHidden(jW) + beta)./ sumAllCCH).* ((cParentHidden(jD)...
                + alpha)./ (sumAllCPH(jSumD) - 1));
            pzall = pz./ sum(pz);
            c = cumsum(pzall);

            tmp = sizHidden;
            for k = 1:sizHidden - 1
                if u(j) < c(k)
                    tmp = k;
                    break;
                end
            end  

            cChildHiddenTmp(jW(tmp)) = cChildHiddenTmp(jW(tmp)) + 1;
            cParentHidden(jD(tmp)) = cParentHidden(jD(tmp)) + 1;
            sumAllCCHtmp(tmp) = sumAllCCHtmp(tmp) + 1;
            samples(j, class_hidden) = tmp;
        end
    end
    result.samples = samples;
end
