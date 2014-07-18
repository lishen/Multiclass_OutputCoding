function bs = mat2bs(codemat)
% Convert coding matrix to bit string.
[nc l] = size(codemat);
codemat = (codemat+1)/2;
for i = 1:nc
    bs(((i-1)*l+1):(i*l)) = codemat(i, :);
end