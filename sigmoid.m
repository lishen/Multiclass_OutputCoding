function [y, output] = sigmoid(rv, A, B)
% Sigmoid outputs for real-valued classifiers. If rv has n columns, A and B can also have n columns.
output = rv.*A + B;
y = output;
output = 1./(1 + exp(output));
y(find(y>=0)) = 1;
y(find(y<0)) = -1;