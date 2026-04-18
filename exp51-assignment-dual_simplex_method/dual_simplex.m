% TODO: Understand this code

%{
    MATLAB CODE FOR SOLVING LPP USING DUAL SIMPLEX METHOD (BY CHATGPT)

    Example Problem:
    Minimize Z = -3x1 - 2x2

    Subject to:
        x1 + x2 >= 2
        x1 + 3x2 >= 3
        x1, x2 >= 0

    Converted to standard form (Dual Simplex applicable):
        x1 + x2 - s1 = 2
        x1 + 3x2 - s2 = 3

    Initial BFS is infeasible (RHS negative after conversion),
    hence Dual Simplex is applied.
%}

format short
clear all
clc

%% Phase 1: Input Parameters (Initial Tableau)
% Coefficients of constraints
A = [1 1 -1 0; 
     1 3 0 -1];

% RHS values
B = [2; 3];

% Cost coefficients (objective function)
C = [-3 -2 0 0];

% Construct initial tableau
Table = [A B];
ZjCj = C;

[m, n] = size(A);

%% Phase 2: Check feasibility (Dual Simplex condition)
if all(B >= 0)
    fprintf('Initial BFS is Feasible (Dual Simplex not required)\n')
else
    fprintf('Initial BFS is Infeasible → Applying Dual Simplex\n')
end

%% Phase 3: Iterative Dual Simplex Process
RUN = true;

while RUN
    
    % Step 1: Find leaving variable (most negative RHS)
    [minB, pivot_row] = min(Table(:, end));
    
    if minB >= 0
        RUN = false;
        break;
    end
    
    % Step 2: Compute ratios (only for negative elements in pivot row)
    Row = Table(pivot_row, 1:end-1);
    Ratio = inf(1, length(Row));
    
    for j = 1:length(Row)
        if Row(j) < 0
            Ratio(j) = abs(ZjCj(j) / Row(j));
        end
    end
    
    % Step 3: Find entering variable (minimum ratio)
    [minRatio, pivot_col] = min(Ratio);
    
    % Step 4: Pivot element
    pivot_element = Table(pivot_row, pivot_col);
    
    % Step 5: Normalize pivot row
    Table(pivot_row, :) = Table(pivot_row, :) / pivot_element;
    
    % Step 6: Make other elements in pivot column zero
    for i = 1:m
        if i ~= pivot_row
            Table(i, :) = Table(i, :) - Table(i, pivot_col) * Table(pivot_row, :);
        end
    end
    
    % Step 7: Update Zj - Cj
    ZjCj = ZjCj - ZjCj(pivot_col) * Table(pivot_row, 1:end-1);
    
end

%% Phase 4: Final Tableau
fprintf('Final Tableau = \n');
FinalTable = array2table(Table);
disp(FinalTable);

%% Phase 5: Extract Solution
Solution = zeros(1, n);
for i = 1:m
    col = Table(i,1:n);
    if sum(col == 1) == 1 && sum(col == 0) == (m-1)
        idx = find(col == 1);
        Solution(idx) = Table(i,end);
    end
end

fprintf('Optimal Solution:\n');
for i = 1:n
    fprintf('x%d = %f\n', i, Solution(i));
end

%% Phase 6: Compute Optimal Value
OptimalValue = sum(Solution .* C);
fprintf('Optimal Value of Z = %f\n', OptimalValue);
