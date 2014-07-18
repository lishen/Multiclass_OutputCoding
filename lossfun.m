function distance = lossfun(classifier, codeword, ov)
% Calculate the total loss between the codeword(s) and the output
% vector.

ncode = size(codeword, 1);
l = size(codeword, 2);
distance = zeros(ncode, 1);

% Calculate distance from each codeword. 
for i = 1:ncode
    for j = 1:l
        switch classifier
            case {'svm', 'svm1'}
                lv = 1 - codeword(i, j)*ov(j);
                if lv < 0
                    lv = 0;
                end
            case 'plr'
                lv = log(1 + exp(-codeword(i, j)*ov(j)));
            case 'rlsc'
                lv = (1 - codeword(i, j)*ov(j))^2;
        end
        distance(i) = distance(i) + lv;
    end
end




