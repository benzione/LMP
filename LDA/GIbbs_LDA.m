function [result] = GIbbs_LDA(dag, class_hidden, samples, N, alpha, beta, node_sizes)
numToken = size(samples,1);
samples(:,class_hidden) = ceil(rand(numToken,1).* node_sizes(class_hidden));

childnode = find(dag(class_hidden, :));
[paChildnode, ~] = find(dag(:, childnode));
paChildnode = setdiff(paChildnode', class_hidden);
allChild = sort([childnode, paChildnode]);
if ~isempty(allChild) 
    cChildHidden = zeros(node_sizes([allChild, class_hidden]));
else
    cChildHidden = zeros(1, node_sizes(class_hidden));
end

parentnode = find(dag(:, class_hidden))';
if ~isempty(parentnode)
    cParentHidden = zeros(node_sizes([parentnode, class_hidden]));
else
    cParentHidden = zeros(1, node_sizes(class_hidden));
end

for j = 1:numToken
    evidance = samples(j, :);
    idx = sub2indmy(size(cChildHidden), [evidance(allChild), evidance(class_hidden)]);
    cChildHidden(idx) = cChildHidden(idx) + 1;
    idx = sub2indmy(size(cParentHidden), [evidance(parentnode), evidance(class_hidden)]);
    cParentHidden(idx) = cParentHidden(idx) + 1;
end

if ~isempty(allChild)
    sumAllCCH = sum(reshape(cChildHidden, prod(node_sizes(allChild)), node_sizes(class_hidden)) + beta);
else
    sumAllCCH = cChildHidden;
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
            jW = sub2indmywithoutclass(size(cChildHidden),evidance(allChild));
        end
        
        if ~isempty(parentnode)
            jD = sub2indmywithoutclass(size(cParentHidden), evidance(parentnode));
            jSumD = sub2indmy(size(sumAllCPH),evidance(parentnode));
        end
        
        cChildHidden(jW(jT)) = cChildHidden(jW(jT))-1;
        cParentHidden(jD(jT)) = cParentHidden(jD(jT))-1;
        sumAllCCH(jT) = sumAllCCH(jT)-1;
        
        pz = ((cChildHidden(jW) + beta)./sumAllCCH).*...
            ((cParentHidden(jD) + alpha)./(sumAllCPH(jSumD) - 1));
        pzall = pz./ sum(pz);
        c = cumsum(pzall);

        tmp = sizHidden;
        for k = 1:sizHidden-1
            if u(j) < c(k)
                tmp = k;
                break;
            end
        end  

        cChildHidden(jW(tmp)) = cChildHidden(jW(tmp)) + 1;
        cParentHidden(jD(tmp)) = cParentHidden(jD(tmp)) + 1;
        sumAllCCH(tmp) = sumAllCCH(tmp) + 1;
        
        samples(j, class_hidden) = tmp;
    end
end

result.cChildHidden = cChildHidden;
result.allChild = allChild;
result.parentnode = parentnode;
result.samples = samples;
result.sumAllCCH = sumAllCCH;
end