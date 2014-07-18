function [Y, outputs, prob] = ecocfwd(net, test_data)
% Giving the class labels of test samples using specified decoding
% function.

ntest = size(test_data, 1);
if net.realvalued
    ker = net.classifier.ker;
    para = net.classifier.para;
    if strcmp(net.fs, 'RFE')
        outputs = test_data*net.w + repmat(net.bias, [ntest 1]);
    else
        outputs = kf(ker, para, test_data, net.train_data)*((net.alpha).*(net.train_label)) + repmat(net.bias, [ntest 1]);
    end
    Y = zeros(ntest, 4);    % hamming, loss, inner-product, probabilistic.
else
    testd = data(test_data);
    for i = 1:size(net.codematrix, 2)
        tst = test(net.model{i}, testd);
        outputs(:, i) = tst.X;
    end
    Y = zeros(ntest, 1);
end
% csvwrite('results/ECOC/outputs.txt', outputs);

% outputs(:, find(net.mask)) = [];
% net.codematrix(:, find(net.mask)) = [];
% net.A(find(net.mask)) = [];
% net.B(find(net.mask)) = [];

% Prediction using hamming distance. 
for i = 1:ntest
    distance = hamd(net.codematrix, outputs(i, :));
    min_idx = find(distance == min(distance));
    Y(i, 1) = min_idx(ceil(rand*length(min_idx)));
end

if net.realvalued
    % Prediction using loss function.
    for i = 1:ntest
        distance = lossfun(net.classifier.algo, net.codematrix, outputs(i, :));
        [dummy, Y(i, 2)] = min(distance);
    end

    % Prediction using inner-product.
    for i = 1:ntest
        confidence = innrprod(net.codematrix, outputs(i, :));
        [dummy, Y(i, 3)] = max(confidence);
    end

    % Prediction using probabilistic ouputs.
    if length(find(net.A == NaN)) || length(find(net.B == NaN))
        Y(:, 4) = NaN;
    else
        for i = 1:ntest
            eta = outputs(i, :).*net.A + net.B;
            distance = lossfun('plr', net.codematrix, eta);
            [dummy, Y(i, 4)] = min(distance);
        end
    end
end
















