function [train_data, test_data] = datanorm(train_data, test_data)
% DATANORM Data normalization.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%---------------------Data Normalization----------------------------%
% Each gene is normalized to have mean = 0 and sd = 1.
for i = 1:size(train_data, 2)
    genestd = std(train_data(:, i));
    if genestd == 0
        continue;
    end
    genemean = mean(train_data(:, i));

    train_data(:, i) = train_data(:, i) - genemean;
    train_data(:, i) = train_data(:, i)/genestd;
    
    if exist('test_data') && ~isempty(test_data)
        test_data(:, i) = test_data(:, i) - genemean;
        test_data(:, i) = test_data(:, i)/genestd;
    end
end

