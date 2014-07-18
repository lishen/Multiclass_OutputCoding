function codematrix = codegen(types, code, l)
% Generate code matrix based on the number of classes and coding method. 
switch code
case 'ova'
    % One versus all.
    codematrix = eye(types);
    codematrix = (codematrix - 0.5)*2;
case 'exhaustive'
    % The exhaustive code is obtained by enumerating the numbers from 
    % 0 to 2^(types-1)-2, converting them from decimal to binary and 
    % append a string of 1's to be the first row of the code matrix. 
    codematrix = [num2str(ones(2^(types-1)-1, 1))'; dec2bin(0:2^(types-1)-2)'];
    codematrix = double(codematrix - '0');
    codematrix = (codematrix - 0.5)*2;
case 'allpairs'
    % All pairs.
    codematrix = zeros(types, types*(types-1)/2);
    col = 1;
    for i = 1:types-1
        for j = 1:types-i
            codematrix(i, col) = 1;
            codematrix(i+j, col) = -1;
            col = col + 1;
        end
    end
case 'random'
    % Random code. L = 10*log2(k). Delete the same and the complementary columns. 
    if ~exist('l') || isempty(l)
        l = floor(10*log2(types)); 
    end
    codematrix = rand(types, l);
    codematrix = floor(codematrix*2)*2 - 1;
    % Begin Hill-climbing. 
    % Update code-matrix for sufficient times. 
    for iters = 1:50    % Empirically determined. 50 is thought to be enough. 
        r_mat = simat(codematrix);
        c_mat = simat(codematrix');
        % Find and modify the 2*2 boolean matrix.
        % The closest rows. 
        mind = min(min(r_mat));
        [row1s row2s] = find(r_mat == mind);
        % The most extreme columns.
        mind = min(min(c_mat));
        maxd = max(max(c_mat));
        if mind <= types - maxd
            [col1s col2s] = find(c_mat == mind);
            simflg = 1; % Flag for similarity.
        else
            [col1s col2s] = find(c_mat == maxd);
            simflg = 0; % Flag for dissimilarity. 
        end
        % Search all possible 2*2 boolean matrix. 
        for ridx = 1:length(row1s)
            row1 = row1s(ridx);
            row2 = row2s(ridx);
            for cidx = 1:length(col1s)
                col1 = col1s(cidx);
                col2 = col2s(cidx);
                % Extract 2*2 boolean matrix. 
                A(1, 1) = codematrix(row1, col1);
                A(1, 2) = codematrix(row1, col2);
                A(2, 1) = codematrix(row2, col1);
                A(2, 2) = codematrix(row2, col2);
                match = 0;  % Flag for updating 2*2 boolean matrix. 
                if simflg
                    if (A(1, 1) == A(1, 2) & A(2, 1) == A(2, 2)) | (A(1, 1) == A(2, 1) & A(1, 2) == A(2, 2))
                        match = 1;
                    end
                else
                    if A(1, 1) ~= A(1, 2) & A(2, 1) ~= A(2, 2)
                        match = 1;
                    end
                end
                if match    % Update code-matrix. 
                    break;
                end
            end
            if match    % Update code-matrix. 
                break;
            end
        end
        if match    % modify 2*2 boolean matrix and (update similarity matrix and column hamming-distance matrix). 
            if nnz(A - 1) == 0 | nnz(A + 1) == 0    % randomly invert diagonal.
                if ceil(rand-0.5)
                    A(1, 1) = -A(1, 1);
                    A(2, 2) = -A(2, 2);
                else
                    A(1, 2) = -A(1, 2);
                    A(2, 1) = -A(2, 1);
                end
            else    % randomly invert one element. 
                i1 = ceil(rand*2); i2 = ceil(rand*2);
                A(i1, i2) = -A(i1, i2);
            end
            % put 2*2 boolean matrix back into codematrix. 
            codematrix(row1, col1) = A(1, 1);
            codematrix(row1, col2) = A(1, 2);
            codematrix(row2, col1) = A(2, 1);
            codematrix(row2, col2) = A(2, 2);
        else
            break;
        end
    end
    % Remove the redundant columns. 
    codematrix = rdcol(codematrix);
case 'random1'
    % Random code. L = 10*log2(k). Delete the same and the complementary columns. 
    if ~exist('l') || isempty(l)
        l = floor(10*log2(types)); 
    end
    codematrix = rand(types, l);
    codematrix = floor(codematrix*2)*2 - 1;
    codematrix = rdcol(codematrix);
end % end of switch. 


function codematrix1 = rdcol(codematrix)
% Remove the redundant columns. 
% Find the same and the complementary columns. 
[types ncol] = size(codematrix);
delidx = zeros(1, ncol);
for i = 1:ncol-1
    for j = i+1:ncol
        distance = nnz(codematrix(:, i) - codematrix(:, j));
        if distance == 0 | distance == types
            delidx(j) = 1;
        end
    end
end
% Find the columns that are all 1 or -1.
for i = 1:ncol
    if nnz(codematrix(:, i) - 1) == 0 | nnz(codematrix(:, i) + 1) == 0
        delidx(i) = 1;
    end
end
codematrix1 = codematrix(:, find(delidx == 0));


function sim_mat = simat(codematrix)
% Similarity matrix.
nrow = size(codematrix, 1);
sim_mat = zeros(nrow, nrow);
for i = 1:nrow-1
    for j = i+1:nrow
        sim_mat(i,j) = hamd(codematrix(i, :), codematrix(j, :));
        sim_mat(j,i) = sim_mat(i,j);
    end
end
for i = 1:nrow
    sim_mat(i, i) = NaN;
end






















