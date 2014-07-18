function [alpha, b0] = mysvc(X, Y, ker, para, C)
%  SVC Support Vector Classification
%
%  Usage: [nsv alpha bias] = svc(X,Y,ker,C)
%
%  Parameters: X      - Training inputs
%              Y      - Training targets
%              ker    - kernel function
%              C      - upper bound (non-separable case)
%              nsv    - number of support vectors
%              alpha  - Lagrange Multipliers
%              b0     - bias term
%
%  Author: Steve Gunn (srg@ecs.soton.ac.uk) 
%  Modified: Li Shen. For linear kernel only. Enhanced speed. 
n = size(X,1);
% tolerance for Support Vector Detection
epsilon = svtol(C);
% Construct the Kernel matrix
H = Y*Y';
K = kf(ker, para, X, X);
H = H.*K;
f = -ones(n,1);  
% Add small amount of zero order regularisation to 
% avoid problems when Hessian is badly conditioned. 
H = H+1e-10*eye(size(H));
% Set up the parameters for the Optimisation problem
vlb = zeros(n,1);      % Set the bounds: alphas >= 0
vub = C*ones(n,1);     %                 alphas <= C
x0 = zeros(n,1);       % The starting point is [0 0 0   0]
A = Y'; b = 0;     % Set the constraint Ax = b
% Solve the Optimisation Problem
opts = optimset('Display', 'off');
% alpha = quadprog(H, f, [], [], A, b, vlb, vub, x0, opts);
alpha = qp(H, f, A, b, vlb, vub, x0, 1);
% alpha = loqo(H, f, A, b, vlb, vub, x0, 1);
% Compute the number of Support Vectors
svi = find(alpha > epsilon);
% Explicit bias, b0 
% find b0 from average of support vectors on margin
% SVs on margin have alphas: 0 < alpha < C
svii = find( alpha > epsilon & alpha < (C - epsilon));
b0 = 0;
if length(svii) > 0
    b0 =  (1/length(svii))*sum(Y(svii) - H(svii,svi)*alpha(svi).*Y(svii));
end

