function confidence = innrprod(codeword, ov)
% Calculate the inner product between the codeword(s) and the output
% vector.

ncode = size(codeword, 1);
l = size(codeword, 2);
confidence = zeros(ncode, 1);

% Calculate distance from each codeword. 
for i = 1:ncode
    for j = 1:l
        if codeword(i, j) == 0
            prod = 0;
        else
            prod = codeword(i, j)*ov(j);
        end
        confidence(i) = confidence(i) + prod;
    end
end




