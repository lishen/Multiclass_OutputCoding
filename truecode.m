clc
clear all
warning off;

global nc l
nc = 9;
l = floor(10*log2(nc));

options = gaoptimset('PlotFcns', @gaplotbestf, 'PopulationType', 'bitstring',...
    'PopulationSize', 100,...
    'SelectionFcn', @selectionroulette,...
    'CrossoverFcn', @crossoversinglepoint,...
    'CrossoverFraction', 0.8,...
    'MutationFcn', {@mutationuniform, 0.01},...
    'StallTimeLimit', 100);

% Use GA.
[cmbs fval reason] = ga(@diversfcn, nc*l, options);
codemat = bs2mat(cmbs, nc, l);
divmat = rdcol(codemat);

[cmbs fval reason] = ga(@hammfcn, nc*l, options);
codemat = bs2mat(cmbs, nc, l);
hammat = rdcol(codemat);

[cmbs fval reason] = ga(@mulmfcn, nc*l, options);
codemat = bs2mat(cmbs, nc, l);
mlmmat = rdcol(codemat);

codemat = codegen(nc, 'random');
rhcmat = rdcol(codemat);

save('NCI60_CODE_TRUE.mat', 'divmat', 'hammat', 'mlmmat', 'rhcmat');


















