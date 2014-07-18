function grank = s2nrank(train_data, train_label, npc)
% Signal to noise ratio to select genes specified by the number of genes
% per class. 
[samples vars] = size(train_data);
if length(find(train_label == -1))
    pos_idx = find(train_label == 1);
    neg_idx = find(train_label == -1);
    for i = 1:vars
        pos_mean = mean(train_data(pos_idx, i));    pos_std = std(train_data(pos_idx, i));
        neg_mean = mean(train_data(neg_idx, i));    neg_std = std(train_data(neg_idx, i));
        s2nscore(i) = (pos_mean - neg_mean)/(pos_std + neg_std);
    end
    [s2nscore s2nidx] = sort(s2nscore);
    grank = [s2nidx(1:npc) s2nidx(vars-npc+1:vars)];
else
    i = 1;
    grank = [];
    while 1
        cls_idx = find(train_label == i);
        ncls = length(cls_idx);
        if ncls == 0
            break;
        end
        oth_idx = (1:samples)'; oth_idx(cls_idx) = [];
        for j = 1:vars
            pos_mean = mean(train_data(cls_idx, j));    pos_std = std(train_data(cls_idx, j));
            neg_mean = mean(train_data(oth_idx, j));    neg_std = std(train_data(oth_idx, j));
            s2nscore(j) = (pos_mean - neg_mean)/(pos_std + neg_std);
        end
        [s2nscore s2nidx] = sort(s2nscore);    s2nidx = fliplr(s2nidx);
        grank = [grank s2nidx(1:npc)];
        i = i + 1;
    end
    grank = unique(grank);
end



