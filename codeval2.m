clc
clear all
warning off;

load GCM
load GCM_CODE_TRUE
datastr = 'GCM';

classifier.algo = 'svm1'; % svm, svm1, rlsc, knn, c45.
classifier.ker = 'linear';  % Kernel.
classifier.para = [];   % Kernel parameters.
classifier.C = 1; 
fs = 'NO'; % feature selection methods: BW, RFE, PCA, PLS, GA. 
npc = 100;
if npc > 0
    grank = s2nrank(data, label, npc);
    data = data(:, grank);
    sel_genes = length(grank);
end
data = datanorm(data);

% Read coding matrix and run classification.
iters = 100;
nfold = 3;
codestr = {'mlmmat', 'divmat', 'hammat', 'rhcmat'};
for i = 1:4
    loadstr = sprintf('codemat = %s;', codestr{i});
    eval(loadstr);
    disp(loadstr);
    % Determine multiple kernels by 5-fold.
    for j = 1:iters
        fprintf(1, 'Iteration: %d.\n', j);
        ERR = ecocv(classifier, codemat, types, fs, data, label, nfold);
        err1(i, j) = ERR(1);
        err2(i, j) = ERR(2);
        err3(i, j) = ERR(3);
        err4(i, j) = ERR(4);
    end
end
% Write mean and std into file.
fstr = sprintf('%s_codeval2.txt', datastr);
fid = fopen(fstr, 'w');
fprintf(fid, 'Classifier: %s.\n', classifier.algo);
fprintf(fid, 'Samples: %d.\n', size(data, 1));
if npc > 0
    fprintf(fid, 'Genes per class: %d.\n', npc);
    fprintf(fid, 'Selected genes: %d.\n', sel_genes);
else
    fprintf(fid, 'Gene Selection: NO.\n');
end
fprintf(fid, 'Iterations: %d.\n', iters);
fprintf(fid, '\n');            

err1 = err1/samples;
err2 = err2/samples;
err3 = err3/samples;
err4 = err4/samples;

fprintf(fid, '\nCoding matrix from multiple margin:\n');
fprintf(fid, 'Hamming distance decoding, mean = %.4f, std = %.4f.\n', mean(err1(1, :)), std(err1(1, :)));
fprintf(fid, 'Loss decoding, mean = %.4f, std = %.4f.\n', mean(err2(1, :)), std(err2(1, :)));
fprintf(fid, 'Inner-product decoding, mean = %.4f, std = %.4f.\n', mean(err3(1, :)), std(err3(1, :)));
fprintf(fid, 'Probabilistic decoding, mean = %.4f, std = %.4f.\n', mean(err4(1, :)), std(err4(1, :)));

fprintf(fid, '\nCoding matrix from diversity measures:\n');
fprintf(fid, 'Hamming distance decoding, mean = %.4f, std = %.4f.\n', mean(err1(2, :)), std(err1(2, :)));
fprintf(fid, 'Loss decoding, mean = %.4f, std = %.4f.\n', mean(err2(2, :)), std(err2(2, :)));
fprintf(fid, 'Inner-product decoding, mean = %.4f, std = %.4f.\n', mean(err3(2, :)), std(err3(2, :)));
fprintf(fid, 'Probabilistic decoding, mean = %.4f, std = %.4f.\n', mean(err4(2, :)), std(err4(2, :)));

fprintf(fid, '\nCoding matrix from hamming distance:\n');
fprintf(fid, 'Hamming distance decoding, mean = %.4f, std = %.4f.\n', mean(err1(3, :)), std(err1(3, :)));
fprintf(fid, 'Loss decoding, mean = %.4f, std = %.4f.\n', mean(err2(3, :)), std(err2(3, :)));
fprintf(fid, 'Inner-product decoding, mean = %.4f, std = %.4f.\n', mean(err3(3, :)), std(err3(3, :)));
fprintf(fid, 'Probabilistic decoding, mean = %.4f, std = %.4f.\n', mean(err4(3, :)), std(err4(3, :)));

fprintf(fid, '\nCoding matrix from randomized hill-climbing:\n');
fprintf(fid, 'Hamming distance decoding, mean = %.4f, std = %.4f.\n', mean(err1(4, :)), std(err1(4, :)));
fprintf(fid, 'Loss decoding, mean = %.4f, std = %.4f.\n', mean(err2(4, :)), std(err2(4, :)));
fprintf(fid, 'Inner-product decoding, mean = %.4f, std = %.4f.\n', mean(err3(4, :)), std(err3(4, :)));
fprintf(fid, 'Probabilistic decoding, mean = %.4f, std = %.4f.\n', mean(err4(4, :)), std(err4(4, :)));

fclose(fid);
fstr = sprintf('%s_ERR_TRUE.mat', datastr);
save(fstr, 'err*');























