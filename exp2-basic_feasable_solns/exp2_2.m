%{
    MATLAB CODE FOR FINDING BASIC FEASABLE SOLUTIONS

    Min Z = x1 + 2x2 + x3
    s.t. -x1 + x2 + x3 = 3
         2x1 + x2 - x3 = 1
            x1,x2,x3 >= 0
    (Already includes SLACK & SURPLUS added to constraints)
%}

format short;
clear all;
clc;

%% Phase 1: Input Parameters
c = [1 2 1];
A = [-1 1 1; 2 1 -1];
b = [3; 1];

%% Phase 2: Get no. of constriants & variables
m = size(A,1); %%% m = No. of constraints = No of rows
n = size(A,2); %%% n = No. of variables   = No of cols

%% Phase 3: Choose nCm basic solutions
if(n>m)
    nCm = nchoosek(n,m);    %%% Total no. of Basic solutions
    t = nchoosek(1:n,m);    %%% Forms Pairs of Basic soultions
    %% Phase 4: Construct the basic solutions
    S = [];
    for i = 1:nCm
        y = zeros(n,1);         %%% Default soln is zero (all vars are assumed to be non-basic)
        x = A(:, t(i, :)) \ b;
    %% Phase 5: Check that soln exists & is feasable
        if all(x>=0 & x~=inf & x~=-inf)
            y(t(i, :)) = x;     %%% Makes basic solns non-zero!    
            S = [S y];
        end
    end
    BS = S';
else
    error('nCm does not exists')
end

%% Phase 6: Compute objective function
val = BS * c';
resultTable = [BS val];

%% Phase 7: Find optimal value & display solution
[opval, opidx] = max(val);
optab = resultTable(opidx, :);

fprintf('Optimal BFS is:-\n');
OPTIMAL_BFS = array2table(optab, 'VariableNames', {'x1', 'x2', 'x3', 'Z'});
disp(OPTIMAL_BFS);