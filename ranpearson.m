load NCI60_CODE_RAN
load NCI60_ERR_RAN
load NCI60

nc = types; l = 9;
% Pearson Correlations between Mean Errors and Multiple Margin, Row Diversity
% Measure, Row Minimum Hamming Distance, Col Diversity Measure.
err = zeros(100, 1);
minr = zeros(100, 1);
divr = zeros(100, 1);
mlmr = zeros(100, 1);
minc = zeros(100, 1);
divc = zeros(100, 1);
for i = 1:100
    err(i) = mean(err2(i, :));
    [minr(i) divr(i) mlmr(i) minc(i) divc(i)] = minavgmat(RAN_mats{i});
end

for i = 1:types
    spc(i) = length(find(label == i));
end
sbal = zeros(100, 1);
for i = 1:100
    bal = spc*RAN_mats{i};
    sbal(i) = (mean(abs(bal)) + std(abs(bal)))/samples;
end

% fid = fopen('ranpearson.txt', 'w');
fid = 1;
fprintf(fid, 'Pearson Correlations between Mean Errors and Matrix Measures.\n\n');
[rho p] = corr(err, mlmr);
fprintf(fid, 'Multiple Margin - Rho: %f, P-value: %f.\n', rho, p);
[rho p] = corr(err, divr);
fprintf(fid, 'Row Diversity Measures - Rho: %f, P-value: %f.\n', rho, p);
[rho p] = corr(err, minr);
fprintf(fid, 'Row Minimum Hamming Distance - Rho: %f, P-value: %f.\n', rho, p);
[rho p] = corr(err, divc);
fprintf(fid, 'Col Diversity Measures - Rho: %f, P-value: %f.\n', rho, p);
[rho p] = corr(err, minc);
fprintf(fid, 'Col Minimum Hamming Distance - Rho: %f, P-value: %f.\n', rho, p);
[rho p] = corr(err, sbal);
fprintf(fid, 'P/N class difference - Rho: %f, P-value: %f.\n', rho, p);

fprintf(fid, '\n');
fprintf(fid, 'Without P/N Class Balance.\n');
[rho p] = corr(err, -mlmr/l-divc/nc);
fprintf(fid, 'MLM - Rho: %f, P-value: %f.\n', rho, p);
[rho p] = corr(err, -divr/l-divc/nc);
fprintf(fid, 'DIV - Rho: %f, P-value: %f.\n', rho, p);
[rho p] = corr(err, -minr/l-minc/nc);
fprintf(fid, 'HAM - Rho: %f, P-value: %f.\n', rho, p);

fprintf(fid, '\n');
fprintf(fid, 'With P/N Class Balance.\n');
[rho p] = corr(err, -(mlmr/l+divc/nc)+sbal);
fprintf(fid, 'MLM - Rho: %f, P-value: %f.\n', rho, p);
[rho p] = corr(err, -(divr/l+divc/nc)+sbal);
fprintf(fid, 'DIV - Rho: %f, P-value: %f.\n', rho, p);
[rho p] = corr(err, -(minr/l+minc/nc)+sbal);
fprintf(fid, 'HAM - Rho: %f, P-value: %f.\n', rho, p);

plot(err, -(mlmr/l+divc/nc), 's', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'g', 'MarkerSize', 10);
xlabel('Mean Errors');
ylabel('MLM');

% fclose(fid);






















