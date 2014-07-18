function K = kf(ker, para, X1, X2)

[N1, d] = size(X1);
[N2, d] = size(X2);

switch ker
    case 'linear'
        K = X1*X2';
    case 'poly'
        K = (1+X1*X2').^para;
    case 'rbf'
        dist2 = repmat(sum((X1.^2)', 1), [N2 1])' + ...
                repmat(sum((X2.^2)',1), [N1 1]) - ...
                2*X1*(X2');
        K = exp(-dist2/(size(X1, 2)*para));
    otherwise
        error('Unknown kernel function');
end


