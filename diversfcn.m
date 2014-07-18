function z = diversfcn(cmbs)
% Diversity measures for a coding matrix.
global nc l % rows, cols.
codemat = bs2mat(cmbs, nc, l);
codemat = rdcol(codemat);
[nrow ncol] = size(codemat);
D_row = zeros(nrow, nrow);  % Diversities between rows.
D_col = zeros(ncol, ncol);    % Diversities between columns.
for i = 1:nrow-1
    for j = i+1:nrow
        D_row(i, j) = hamd(codemat(i, :), codemat(j, :))/l;
    end
end
for i = 1:ncol-1
    for j = i+1:ncol
        D_col(i, j) = min(hamd(codemat(:, i)', codemat(:, j)')/nc, hamd(codemat(:, i)', -codemat(:, j)')/nc);
    end
end
tot_D_row = sum(sum(D_row))*2/(nrow*(nrow-1));
tot_D_col = sum(sum(D_col))*2/(ncol*(ncol-1));

z = -(tot_D_row + tot_D_col);