function z = hammfcn(cmbs)
% Hamming distances for a coding matrix.
global nc l % rows, cols.
codemat = bs2mat(cmbs, nc, l);
codemat = rdcol(codemat);
[nrow ncol] = size(codemat);
H_row = zeros(nrow, nrow); H_row = H_row + Inf; % Hamming distances between rows.
H_col = zeros(ncol, ncol); H_col = H_col + Inf;   % Hamming distances between columns.
for i = 1:nrow-1
    for j = i+1:nrow
        H_row(i, j) = hamd(codemat(i, :), codemat(j, :))/l;
    end
end
for i = 1:ncol-1
    for j = i+1:ncol
        H_col(i, j) = min(hamd(codemat(:, i)', codemat(:, j)')/nc, hamd(codemat(:, i)', -codemat(:, j)')/nc);
    end
end
min_H_row = min(min(H_row));
min_H_col = min(min(H_col));

z = -(min_H_row + min_H_col);