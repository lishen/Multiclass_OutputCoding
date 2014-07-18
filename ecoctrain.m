function net = ecoctrain(net, train_data, train_label)
% Training a set of dichotomies using the basic classifier and ECOC.
% global fid
% Initialization.
[net.samples net.vars] = size(train_data);
types = net.types;
codematrix = net.codematrix;
l = size(codematrix, 2);
if net.realvalued
    net.train_data = train_data;
    net.train_label = zeros(net.samples, l);
    net.bias = zeros(1, l);
    net.alpha = zeros(net.samples, l);
    net.A = zeros(1, l);
    net.B = zeros(1, l);
    if strcmp(net.fs, 'RFE')
        net.w = zeros(net.vars, l);
    end
else
    net.model = cell(1, l);
end

% Training for each dichotomy.
avg_err = 0;
avg_genes = 0;
nfold = 3;
for i = 1:l
    global base_csr; base_csr = i;
    % Data and label setting.
    train_label1 = train_label;
    % Labeled as positive.
    positive = find(codematrix(:, i) == 1);
    for j = 1:length(positive)
        train_label1(find(train_label == positive(j))) = 1;
    end
    % Labeled as negative.
    negative = find(codematrix(:, i) == -1);
    for j = 1:length(negative)
        train_label1(find(train_label == negative(j))) = -1;
    end
    % Not for training.
    ignore = find(codematrix(:, i) == 0);
    for j = 1:length(ignore)
        train_label1(find(train_label == ignore(j))) = 0;
    end
    % Delete the data and labels not for training.
    train_data1 = train_data;
    omitidx = find(train_label1 == 0); trnidx = find(train_label1 ~= 0);
    net.train_label(:, i) = train_label1; 
    train_data1(omitidx, :) = []; train_label1(omitidx) = [];
    
    if exist('net.kerset')
        net.classifer.ker = net.kerset.ker{i};
        net.classifier.para = net.kerset.para(i);
        net.classifeir.C = net.kerset.C(i);
    end
    % Feature selection.
    if strcmp(net.fs, 'RFE')
        [selidx cverr] = rfecv(net.classifier, nfold, train_data1, train_label1);
%         avg_genes = avg_genes + length(selidx);
%         fprintf(fid, 'Base classifier: %d, C: %.4f, Genes: %d, CV errors: %d.\n', i, C, length(selidx), cverr);
        train_data1 = train_data1(:, selidx); 
%         [net.A(i) net.B(i)] = myplatt(net.classifier, nfold, train_data1, train_label1);
    elseif net.realvalued
        if length(train_label1) < nfold % Too few samples, fail to estimate probabilities immediately. 
            net.A(i) = NaN;
            net.B(i) = NaN;
        else
            [net.A(i) net.B(i)] = myplatt(net.classifier, nfold, train_data1, train_label1);
        end
    end
    if net.realvalued
        %    fprintf(fid, 'Probabilistic parameter: A = %f, B = %f.\n', net.A(i), net.B(i));
        %    net.mask(i) = cverr;
%        avg_err = avg_err + cverr;
        [net.alpha(trnidx, i) net.bias(i) w] = csrtrain(net.classifier, train_data1, train_label1);
        if strcmp(net.fs, 'RFE')
            net.w(selidx, i) = w;
        end
        %     fstr = sprintf('results/ECOC/%d_w.txt', base_csr);
        %     csvwrite(fstr, w);
    else
        traind = data(train_data1, train_label1);
        if strcmp(net.classifier.algo, 'knn')
            [tr net.model{i}] = train(knn('k=1'), traind);
        elseif strcmp(net.classifier.algo, 'c45')
            [tr net.model{i}] = train(c45, traind);
        end
    end
end
% avg_err = avg_err/l;
% net.mask(net.mask < avg_err) = 0;
% net.mask(net.mask >= avg_err) = 1;

% fprintf(fid, 'Average CV errs: %.1f.\n', avg_err);
% if strcmp(net.fs, 'RFE')
%     avg_genes = floor(avg_genes/l);
%     fprintf(fid, 'Average genes: %d.\n', avg_genes);
% end















