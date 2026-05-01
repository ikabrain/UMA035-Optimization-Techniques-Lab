%{
    Cost Matrix| D1 D2 D3 D4 | Supply
    -----------+-------------+--------
            S1 |  5  2  1  7 | 40
            S2 | 12  4  6  8 | 30
            S3 |  5  4  7  3 | 60
    -----------+-------------+--------
        Demand | 50 20 10 50 | 
%}

format short;
clear all;
clc;

%% Phase 1: Input Parameters
Cost = [5 2 1 7; 12 4 6 8; 5 4 7 3]
A = [40 30 60]     % SUPPLY
B = [50 20 10 50]  % DEMAND

%% Phase 2: Check balanced/unbalanced problem
if sum(A)==sum(B)
    fprintf('Given Transportation Problem is Balanced\n')
else
    fprintf('Given Transportation Problem is Unbalanced\n')
    if sum(A)<sum(B)
        Cost(end+1, :) = zeros(1, size(B, 2))
        A(end+1) = sum(B) - sum(A)
    elseif sum(B)<sum(A)
        Cost(:, end+1) = zeros(size(A, 2), 1)
        B(end+1) = sum(A) - sum(B)
    end
end
%% Phase 3: Initial allocation
ICost = Cost;
X = zeros(size(Cost));  % Initialize allocation

[m, n] = size(Cost);     % Finding No. of rows and columns
BFS = m + n - 1;            % Total No. of BFS
%% Phase 4: Allocating to cells with minimum cost
for i=1:(m + n - 1)
    hh = min(Cost(:));                          % Finding minimum cost value
    [Row_index, Col_index] = find(hh==Cost);    % Finding position of minimum cost cell
    
    x11 = min(A(Row_index), B(Col_index));
    [Value,index] = max(x11);   % Find maximum allocation
    ii = Row_index(index);      % Identify Row Position
    jj = Col_index(index);      % Identify Column Position
    y11 = min(A(ii), B(jj));     % Find the value
    
    X(ii,jj) = y11;
    A(ii) = A(ii) - y11;
    B(jj) = B(jj) - y11;
    
    if A(ii) == 0 && B(jj) == 0
        Cost(ii,:) = Inf;    % Degenerate: eliminate row, keep col (or vice versa)
    elseif A(ii) == 0
        Cost(ii,:) = Inf;    % Eliminate exhausted row
    elseif B(jj) == 0
        Cost(:,jj) = Inf;    % Eliminate exhausted column
    end
end
%% Phase 5: Print initial BFS
fprintf('Initial BFS =\n');
disp(X);
%% Phase 6: Check for Degenerate and Non Degenerate
TotalBFS = length(nonzeros(X));
if TotalBFS == BFS
    fprintf('Initial BFS is Non-Degenerate\n');
else
    fprintf('Initial BFS is Degenerate\n');
end
%% Phase 7: Print inital transportation cost
InitialCost = sum(sum(ICost.*X));
fprintf('Initial BFS Cost is = %d\n', InitialCost);
