function z = mulmfcn(cmbs)
% Error bounds for a coding matrix. 
global nc l % rows, cols.
codemat = bs2mat(cmbs, nc, l);
codemat = rdcol(codemat);
[nrow ncol] = size(codemat);
H_row = zeros(nrow, nrow); H_row = H_row + Inf; % Hamming distances between rows.
for i = 1:nrow-1
    for j = i+1:nrow
        H_row(i, j) = hamd(codemat(i, :), codemat(j, :))/l;
        H_row(j, i) = H_row(i, j);
    end
end
min_H_row = mean(min(H_row));
D_col = zeros(ncol, ncol);    % Diversities between columns.
for i = 1:ncol-1
    for j = i+1:ncol
        D_col(i, j) = min(hamd(codemat(:, i)', codemat(:, j)')/nc, hamd(codemat(:, i)', -codemat(:, j)')/nc);
    end
end
avg_D_col = sum(sum(D_col))*2/(ncol*(ncol-1));

z = -(min_H_row + avg_D_col);