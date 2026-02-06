% To Find the Basic Feasible solutions
% Max z=2x1+3x2+4x3+7x4
%Subject to 2x1+3x2-x3+4x4=8
%x1-2x2+6x3-7x4=-3
%x1,x2,x3,x4>=0
clc
clear all
format short
%Phase I: To input Parameters
A=[2,3,-1,4;1,-2,6,-7] % Coefficient Matrix
C=[2, 3, 4,7] %cost Coefficients
b=[8;-3] %Right hand side
%Phase II: To define no. of variables and no. of constraints
n=size(A,2) %No. of variable
m=size(A,1) %No. of constraints
%Phase III: To choose nCm Basic solutions
if(n>m)
nCm=nchoosek(n,m) %Total no. of Basic solutions
pair=nchoosek(1:n,m) %Pair of Basic soultions
%Phase IV and V: To construct the Basic solution and To check BFS.
sol=[]; %Default solution is zero.
 for i=1:nCm
    y=zeros(n,1)
    x=A(:,pair(i,:))\b
    %To check the feasibility condition
    if all(x>=0 & x~=inf & x~=-inf)
    y(pair(i,:))=x
    sol=[sol, y]
    end
  end
else
    error('nCm does not exists')
end
%Phase VI: To find the objective function value
Z=C*sol
%find the optimal value
[Zmax, Zindex]=max(Z)
bfs=sol(:,Zindex)
%Phase VII: To print all the solutions
optimal_value=[bfs' Zmax]
optimal_bfs=array2table(optimal_value)
optimal_bfs.Properties.VariableNames(1:size(optimal_bfs,2))={'x_1','x_2','x_3','x_4','Z'}

