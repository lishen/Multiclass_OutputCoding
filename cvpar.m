function [train_data, train_label, test_data, test_label] = cvpar(data, label, nfold, ifold)
% Cross-validation partition. Return training data and left-out data.
% [label lidx] = sort(label); data = data(lidx, :);
samples = size(data, 1);
j = ifold;
idx = 1;
fold_idx = zeros(ceil(samples/nfold), 1);
while j <= samples
    fold_idx(idx) = j;
    idx = idx + 1;
    j = j + nfold;
end
if idx - 1 < length(fold_idx)
    fold_idx(length(fold_idx)) = [];
end

% Training data. 
train_data = data;
train_data(fold_idx, :) = [];
train_label = label;
train_label(fold_idx) = [];
% Left-out data. 
test_data = data(fold_idx, :); % left out data
test_label = label(fold_idx); % left out class labels






