%{
    MATLAB CODE FOR FINDING BASIC FEASABLE SOLUTIONS

    Max Z = 2x1 + 3x2 + 4x3 + 7x4
    Subject to 2x1 + 3x2 -  x3 + 4x4 = 8
                x1 - 2x2 + 6x3 - 7x4 =-3
            x1,x2,x3,x4>=0
    (Already includes SLACK/SURPLUS added to constraints!)
%}


format short;
clear all;
clc;

%% Phase 1: Input Parameters
C = [2, 3, 4, 7];               %%% Cost Coefficients
A = [2, 3,-1, 4; 1, -2, 6, -7]; %%% Coefficient Matrix
b = [8; -3];                    %%% Right hand side

m = size(A,1); %%% m = No. of constraints = No of rows
n = size(A,2); %%% n = No. of variables   = No of cols

%% Phase 2: To choose nCm Basic solutions
if(n>m)
    nCm = nchoosek(n,m);    %%% Total no. of Basic solutions
    pair = nchoosek(1:n,m); %%% Forms Pairs of Basic soultions
    %% Phase IV and V: To construct the Basic solution and To check BFS.
    sol=[]; % Default solution is zero.
     for i=1:nCm
        y = zeros(n,1);
        x = A(:, pair(i, :)) \ b;
    %%% To check the feasibility condition
        if all(x>=0 & x~=inf & x~=-inf)
            y(pair(i, :)) = x;
            sol = [sol, y];
        end
    end
else
    error('nCm does not exists')
end

%% Phase 3: To find the objective function & optimal value
Z = sol*C';
sol_withz = [sol' Z];
sol_table = array2table(sol_withz);
sol_table.Properties.VariableNames(1:size(sol_table,2)) = {'x_1','x_2','x_3','x_4','Z'};
disp(sol_table);

%% find the optimal value
[Zmax, Zindex] = max(Z);
bfs = sol(:,Zindex);

%% Phase 4: To print optimal solution
optimal_value = [bfs' Zmax];
optimal_bfs = array2table(optimal_value);
optimal_bfs.Properties.VariableNames(1:size(optimal_bfs,2)) = {'x_1','x_2','x_3','x_4','Z'};
disp(optimal_bfs);