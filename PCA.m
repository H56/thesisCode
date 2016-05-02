function [Y, P] = PCA(X, dimension)
if nargin < 2
    dimension = 2;
end
X = bsxfun(@minus, X, mean(X, 2));
[P, ~] = eigs(X * X', dimension);
P = P';
Y = P * X;