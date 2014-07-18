function [alpha, b, w] = csrtrain(classifier, train_data, train_label)
% Linear classifier weight and bias from training data.
% bsp > 0, use bootstrap samples to estimate weights. else, bsp <= 0.
algo = classifier.algo;
ker = classifier.ker;
para = classifier.para; 
C = classifier.C;
[samples vars] = size(train_data);
switch algo
    case 'svm'
        % package by Schwaighofer.
        net = svm0(vars, ker, para, C); % linear kernel, no parameter
        net.alphatol = 1e-6;
        net = svmtrain(net, train_data, train_label);
        alpha = net.alpha; 
        b = net.bias;
        if strcmp(ker, 'linear')
            w = net.normalw;
        end
    case 'svm1'
        % package by Steve Gunn. modified by Li Shen.
        [alpha, bias] = mysvc(train_data, train_label, ker, para, C);
        b = bias;
        if strcmp(ker, 'linear')
            w = train_data'*(alpha.*train_label);
        end
end
