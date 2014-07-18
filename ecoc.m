function net = ecoc(classifier, codematrix, types, fs, kerset)
switch classifier.algo
    case {'svm', 'svm1', 'rlsc'}
        net.realvalued = 1;
    case {'knn', 'c45'}
        net.realvalued = 0;
end
net.samples = 0;
net.vars = 0;
net.types = types;
if net.realvalued
    net.train_data = [];
    net.train_label = [];
    net.bias = []; net.alpha = [];  % Bias and weights.
    net.A = []; net.B = []; % Parameters for probabilistic outputs.
    net.w = [];
else
    net.model = [];
end
net.classifier = classifier;
net.codematrix = codematrix;
net.fs = fs;
net.mask = [];
if exist('kerset');
    net.kerset = kerset;
end