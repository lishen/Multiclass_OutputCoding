function [y, output] = mysvcfwd(trnX, trnY, tstX, ker, para, alpha, bias)
%SVCOUTPUT Calculate SVC Output
%
%  Usage: predictedY = svcoutput(trnX,trnY,tstX,ker,alpha,bias,actfunc)
%
%  Parameters: trnX   - Training inputs
%              trnY   - Training targets
%              tstX   - Test inputs
%              ker    - kernel function
%              beta   - Lagrange Multipliers
%              bias   - bias
%              actfunc- activation function (0(default) hard | 1 soft) 
%
%  Author: Steve Gunn (srg@ecs.soton.ac.uk) Modified: Li Shen.


n = size(trnX,1);
m = size(tstX,1);
H = repmat(trnY', [m 1]);
K = kf(ker, para, tstX, trnX);
H = H.*K;
output = H*alpha + bias;
y = sign(output);
