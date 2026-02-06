% MATLAB CODE FOR GRAPHICAL METHOD

% Max Z = 6x1 + 11x2
% s.t.  2x1 +  x2 <= 104
%        x1 + 2x2 <= 76
%       x1, x2 >= 0

format short;
clear all;
clc;

% Phase 1: Input parameters
C = [6 11];     %%% Cost of objective function
A = [2 1; 1 2]; %%% Constrained coefficients
b = [104; 76];  %%% Constraint values

% Phase 2: Plotting of graph
y1 = 0:max(b); %%% Values of x1>=0 to try
x21 = (b(1) - A(1, 1) * y1) ./ A(1, 2); %%% Values of x2 from constraint 1
x22 = (b(2) - A(2, 1) * y1) ./ A(2, 2); %%% Values of x2 from constraint 2

%%% Putting constraint x2 >= 0
x21 = max(0, x21);
x22 = max(0, x22);

%%% Plotting constraints on graph
plot(y1, x21, 'r', y1, x22, 'g');
xlabel("Value of x1");
ylabel("Value of x2");
title("Graph of x1 vs x2");
legend("2x1 +  x2 <= 104", " x1 + 2x2 <= 76");

% Phase 3: Finding corner points from graphs
cx1 = find(y1==0); %%% where x1 is 0
c1 = find(x21==0); %%% where x2 for constraint 1 is 0
%%% finding the coordinates of the region
line1 = [y1(:, [c1, cx1]); x21(:, [c1, cx1])]'

%%% doing same with line2
c2 = find(x22==0);
line2 = [y1(:, [c2, cx1]); x22(:, [c2, cx1])]'

corpt = unique([line1; line2], "rows")

% Phase 4: Find the point of intersection
SA = [0; 0];
for i = 1:size(A, 1)
    s1 = A(i, :);
    b1 = b(i, :);
    for j = i+1:size(A, 1)
        s2 = A(j, :);
        b2 = b(j, :);
   
        A1 = [s1; s2];
        B1 = [b1; b2];
        
        X = A1\B1;
        SA = [SA X];
    end
end
ptt = SA';

% Phase 5: Find ALL the corner points
allpt = [ptt; corpt];
points = unique(allpt, "rows");

% Phase 6: Find feasable region(s)
for i=1:size(points, 1)
    const1(i) = A(1, 1)*points(i, 1) + A(1, 2)*points(i, 2) - b(1);
    const2(i) = A(2, 1)*points(i, 1) + A(2, 2)*points(i, 2) - b(2);
end
k1 = find(const1 > 0);
k2 = find(const2 > 0);
k = unique([k1 k2]);
points(k, :) = [];

% Phase 7: Compute objective function
value = points * C';
table = [points value]
[obj, index] = max(value);
x1 = points(index, 1);
x2 = points(index, 2);
fprintf("objective value is %f at (%f, %f)", obj, x1, x2);