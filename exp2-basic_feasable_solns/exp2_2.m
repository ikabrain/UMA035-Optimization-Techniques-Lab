%{
    MATLAB CODE FOR FINDING BASIC FEASABLE SOLUTIONS

    Min Z = x1 + 2x2 + x3
    s.t. -x1 + x2 + x3 = 3
         2x1 + x2 - x3 = 1
            x1,x2,x3>=0
    (Already includes SLACK/SURPLUS added to constraints!)
%}


format short;
clear all;
clc;

%% Phase I: Input Parameters
C = [1, 2, 3];              %%% Cost Coefficients
A = [-1, 1, 1; 2, 1, -1];   %%% Coefficient Matrix
b = [3; 1];                 %%% Right hand side

%% Phase II: Define no. of variables and no. of constraints
m = size(A,1); %%% No. of constraints = No of rows
n = size(A,2); %%% No. of variables   = No of cols

%% Phase III: To choose nCm Basic solutions
if(n>m)
    nCm = nchoosek(n,m);    %%% Total no. of Basic solutions
    pair = nchoosek(1:n,m); %%% Pair of Basic soultions
    % Phase IV and V: To construct the Basic solution and To check BFS.
    sol=[]; % Default solution is zero.
     for i=1:nCm
        y = zeros(n,1);
        x = A(:, pair(i, :)) \ b;
    % To check the feasibility condition
        if all(x>=0 & x~=inf & x~=-inf)
            y(pair(i, :)) = x;
            sol = [sol, y];
        end
    end
else
    error('nCm does not exists')
end

%% Phase VI: To find the objective function value
Z = C*sol;
% find the optimal value
[Zmin, Zindex] = min(Z);
bfs = sol(:,Zindex);

%% Phase VII: To print all the solutions
optimal_value = [bfs' Zmin];
optimal_bfs = array2table(optimal_value);
optimal_bfs.Properties.VariableNames(1:size(optimal_bfs,2)) = {'x_1', 'x_2', 'x_3', 'Z'}