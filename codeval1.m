clc
clear all
warning off;

load GCM
datastr = 'GCM';

classifier.algo = 'svm1'; % svm, svm1, slog (PLR), psvd (RLSC), ppls (PLS-RLSC), plog(PLS-PLR).
classifier.ker = 'linear';  % Kernel.
classifier.para = [];   % Kernel parameters.
classifier.C = 1; 
fs = 'NO'; % feature selection methods: BW, RFE, PCA, PLS, GA. 
switch classifier.algo
    case {'svm', 'svm1', 'rlsc'}
        realvalued = 1;
    case {'knn', 'c45'}
        realvalued = 0;
end
npc = 100;
if npc > 0
    grank = s2nrank(data, label, npc);
    data = data(:, grank);
    sel_genes = length(grank);
end
data = datanorm(data);
% Generate coding matrix and run classification. 
iters = 100;
nfold = 3;

% Use OVA coding matrix.
codemat = codegen(types, 'ova');
fprintf(1, 'OVA coding.\n');
for i = 1:iters
    fprintf(1, 'Iteration: %d.\n', i);
    ERR = ecocv(classifier, codemat, types, fs, data, label, nfold);
    err1(1, i) = ERR(1);
    err2(1, i) = ERR(2);
    err3(1, i) = ERR(3);
    err4(1, i) = ERR(4);
end

% Use AP coding matrix.
codemat = codegen(types, 'allpairs');
fprintf(1, 'AP coding.\n');
for i = 1:iters
    fprintf(1, 'Iteration: %d.\n', i);
    ERR = ecocv(classifier, codemat, types, fs, data, label, nfold);
    err1(2, i) = ERR(1);
    err2(2, i) = ERR(2);
    err3(2, i) = ERR(3);
    err4(2, i) = ERR(4);
end

% Write mean and std into file.
fstr = sprintf('%s_codeval1.txt', datastr);
fid = fopen(fstr, 'w');
fprintf(fid, 'Classifier: %s.\n', classifier.algo);
fprintf(fid, 'Samples: %d.\n', samples);
if npc > 0
    fprintf(fid, 'Genes per class: %d.\n', npc);
    fprintf(fid, 'Selected genes: %d.\n', sel_genes);
else
    fprintf(fid, 'Gene Selection: NO.\n');
end
fprintf(fid, 'Iterations: %d.\n', iters);
fprintf(fid, 'OVA coding matrix:\n');

err1 = err1/samples;
err2 = err2/samples;
err3 = err3/samples;
err4 = err4/samples;

fprintf(fid, '\nCoding matrix from one-vs-all:\n');
fprintf(fid, 'Hamming distance decoding, mean = %.4f, std = %.4f.\n', mean(err1(1, :)), std(err1(1, :)));
fprintf(fid, 'Loss decoding, mean = %.4f, std = %.4f.\n', mean(err2(1, :)), std(err2(1, :)));
fprintf(fid, 'Inner-product decoding, mean = %.4f, std = %.4f.\n', mean(err3(1, :)), std(err3(1, :)));
fprintf(fid, 'Probabilistic decoding, mean = %.4f, std = %.4f.\n', mean(err4(1, :)), std(err4(1, :)));

fprintf(fid, '\nCoding matrix from all-pairs:\n');
fprintf(fid, 'Hamming distance decoding, mean = %.4f, std = %.4f.\n', mean(err1(2, :)), std(err1(2, :)));
fprintf(fid, 'Loss decoding, mean = %.4f, std = %.4f.\n', mean(err2(2, :)), std(err2(2, :)));
fprintf(fid, 'Inner-product decoding, mean = %.4f, std = %.4f.\n', mean(err3(2, :)), std(err3(2, :)));
fprintf(fid, 'Probabilistic decoding, mean = %.4f, std = %.4f.\n', mean(err4(2, :)), std(err4(2, :)));

fclose(fid);
fstr = sprintf('%s_ERR_OVAP.mat', datastr);
save(fstr, 'err*');
























