function [A, B, cverr, cverr0] = myplatt(classifier, nfold, data, label, fsrt)
% Sigmoid parameters for probabilistic outputs. The cverr is the CV error without sigmoid. 
if ~exist('fsrt')
    fsrt = [];
end
[cverr0 acmop acmy] = cvalid(classifier, nfold, data, label, fsrt);
% Calculate probabilistic parameters using logistic regression.
net = plr(0);   % 0 for regularization parameter.
net = plrtrain(net, acmop, acmy, 1); % Use prior for class labels for small sample sizes.
A = net.w; B = net.bias;
if ~isnan(A) && ~isnan(B)
    y = sigmoid(acmop, A, B);
    cverr = nnz(y - acmy);
end



