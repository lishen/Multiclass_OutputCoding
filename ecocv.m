function ERR = ecocv(classifier, codematrix, types, fs, data, label, nfold)
% Cross-validation error given basic classifier and decoding function. 

% Start training.
samples = size(data, 1);
if nfold == -1 % LOOCV
    nfold = samples;
else
    randidx = randperm(samples);
    data = data(randidx, :);
    label = label(randidx, :);
end

ERR = zeros(1, 4);  % hamming, loss, inner-product, probabilistic.
for i = 1:nfold
    [train_data train_label test_data test_label] = cvpar(data, label, nfold, i);
    net = ecoc(classifier, codematrix, types, fs);
    net = ecoctrain(net, train_data, train_label);
    Y = ecocfwd(net, test_data);
    for j = 1:4
        ERR(j) = ERR(j) + nnz(Y(:, j) - test_label);
    end
end
















