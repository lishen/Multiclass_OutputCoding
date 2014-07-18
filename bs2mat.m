function codemat = bs2mat(bs, nc, l)
% Convert bit string to code matrix.
codemat = zeros(nc, l);
for i = 1:nc
    codemat(i, :) = bs((l*(i-1))+1:(l*i));
end
codemat = codemat*2 - 1;