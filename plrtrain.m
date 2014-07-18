function net = plrtrain(net, train_data, train_label, prior)
% Penalized logistic regression training. 
% Initialization.
if nargin < 4
    prior = 0;
end
[net.samples net.vars] = size(train_data);
y = train_label;
% Whether choose prior over probabilities of correct labels. 
% Use in the contex of small sample sizes to avoid over-fitting. 
if prior
    np = length(find(train_label == 1));
    nn = length(find(train_label == -1));
    y(find(y == 1)) = (np+1)/(np+2);
    y(find(y == -1)) = 1/(nn+2);
else
    y = (y + 1)/2;
end
y_ = mean(y);
w1 = zeros(1 + net.vars, 1);
w1(1) = log(y_/(1 - y_));
eta = zeros(net.samples, 1);
p = zeros(net.samples, 1);  % Probability.
v = zeros(net.samples, 1);  % diagonal of W.
Z = [ones(net.samples, 1) train_data];

net.L = NaN;  % training log-likelihood.
net.prob = NaN; % training probability.
net.bias = NaN;
net.w = NaN;
% Iteration.
R = eye(1 + net.vars, 1 + net.vars);
R(1,1) = 0; L = 0;
for i = 1:100    % 100 iterations maximum. 
    L_ = L;
    for j = 1:net.samples
        eta(j) = Z(j, :)*w1;
        p(j) = 1/(1 + exp(-eta(j)));
        v(j) = p(j)*(1 - p(j));
    end
    W = diag(v);

    L = 0;
    for j = 1:net.samples
        if p(j)~=1 & p(j)~=0
            L = L + y(j)*log(p(j)) + (1-y(j))*log(1-p(j));
        end
    end
%     global fid
%     fprintf(fid, 'i = %d, L = %f\n', i, L);

    if L == 0 || isnan(L)
        break;
    else
        net.L = L;  % training log-likelihood.
        net.prob = p; % training probability.
        net.bias = w1(1);
        net.w = w1(2:net.vars + 1);
    end

    if abs(L - L_) <= abs(L_)*1e-4    % Stop condition. 
        break;
    end
    % Calculate matrix H.
    H = Z'*W*Z + net.C*R;
    % Component weight vector w and bias.
    w1 = H\(Z'*(y - p + W*eta));
end








