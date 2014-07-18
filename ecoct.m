function ERR = ecoct(classifier, codematrix, types, fs, train_data, train_label, test_data, test_label)
% Testing errors given basic classifier, coding strategy, decoding function
% and data. 

net = ecoc(classifier, codematrix, types, fs);
net = ecoctrain(net, train_data, train_label);
[Y outputs] = ecocfwd(net, test_data);
if net.realvalued
    ERR = zeros(1, 4);  % hamming, loss, inner-product, probabilistic.
    for i = 1:4
        ERR(i) = nnz(Y(:, i) - test_label);
    end
else
    ERR = nnz(Y - test_label);
end

% global fid
% fprintf(fid, '---- Misclassified samples ----\n');
% ntest = length(test_label);
% for i = 1:ntest
%     if Y(i, 3) ~= test_label(i)
%         fprintf(fid, 'No.%d: %d -> %d.\n', i, test_label(i), Y(i, 3));
%     end
% end








