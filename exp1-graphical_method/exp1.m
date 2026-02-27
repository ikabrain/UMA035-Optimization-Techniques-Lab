%{
    MATLAB CODE FOR GRAPHICAL METHOD

    Max Z = 6x1 + 11x2
    s.t.  2x1 +  x2 <= 104
           x1 + 2x2 <= 76
          x1, x2 >= 0
%}

format short;
clear all;
clc;

%% Phase 1: Input parameters
%%% Step-1: Let Max Z = C'X
%%% subject to AX = b
C = [6 11];     %%% Coefficients of objective function
A = [2 1; 1 2]; %%% Constrain function coefficients
b = [104; 76];  %%% Constrain function constants
%% Phase 2: Plot graph
%%% Step-2: Select range of x1>=0 in which graph is plotted
y1 = 0:max(b);  %%% x1 is a 1 x 104 row vector matrix!

%%% Step-3: Find values of x2i from ith constraint
x21 = (b(1) - A(1, 1) * y1) ./ A(1, 2); %%% 2x1 + 1x2 = 104 ==> x2 = (104 - 2*x1) / 1 = 1 x 104 row matrix
x22 = (b(2) - A(2, 1) * y1) ./ A(2, 2); %%% 1x1 + 2x2 =  76 ==> x2 = ( 76 - 1*x1) / 2 = 1 x 104 row matrix
%%% Step-4: Put constraint x2>=0 as well
x21 = max(0, x21);
x22 = max(0, x22);

%%% Step-5: Plotting constraints on graph
plot(y1, x21, 'r', y1, x22, 'g');
xlabel("Value of x1");
ylabel("Value of x2");
title("Graph of x1 vs x2");
legend("2x1 +  x2 = 104", " x1 + 2x2 = 76");
grid on;
hold on;    %%% Retain current plot when drawing new plot

%% Phase 3: Find points intercepting x & y axes
%%% Step-6: Find where x1 is 0 for y-intercepts
cx1 = find(y1==0);      %%% x1(1) = 0 => cx1 = 1

%%% Step-7: Find where x2i is 0 for possible x-intercepts
cx21 = find(x21==0);    %%% x21(53,54,...,105) = 0 i.e. cx21 = [53 54 ... 105]
cx22 = find(x22==0);    %%% x22(77,78,...,105) = 0 i.e. cx22 = [77 78 ... 105]

%%% Step-8: Combine indices
c1 = [cx21, cx1];   %%% Indices in x1 & x21 denoting coordinates where constrain lies on x & y axis
c2 = [cx22, cx1];   %%% Indices in x1 & x21 denoting coordinates where constrain lies on x & y axis

%%% Step-9: Find coordinates of constraint lines lying on x & y axes
line1 = [y1(c1); x21(c1)]';     %%% Matrix denoting constraint 1 lying on axes, where col1 = x-coords & col2 = y-coords
line2 = [y1(c2); x22(c2)]';     %%% Matrix denoting constraint 2 lying on axes, where col1 = x-coords & col2 = y-coords

%%% Step-10: Remove duplicate points (IMPORTANT) & store in final var
corpt = unique([line1; line2], "rows");

%% Phase 4: Find the point(s) of intersection of each pair of constraints
%%% Step-11: Initialise a soln to both constraints
SA = [0; 0];
for i = 1:size(A, 1)  
    s1 = A(i, :);
    b1 = b(i, :);
    for j = i+1:size(A, 1)
        %%% Step-13: For each pair of constraints formed with nested loop, initialise coefficients & constants
        s2 = A(j, :);
        b2 = b(j, :);
   
        %%% Step-14: Use X = inv(A) / b to solve for point of intersection & store in temp soln
        A1 = [s1; s2];
        B1 = [b1; b2];        
        X = A1\B1;          %%% Returns a COLUMN vector
        SA = [SA X];
    end
end

%%% Step-15: Store temp soln transposed
ptt = SA';

%% Phase 5: Combine ALL the corner points
%%% Step-16: Combine
allpt = [ptt; corpt];
%%% Step-17: Remove duplicates
points = unique(allpt, "rows");

%% Phase 6: Filter out points not in feasable region(s)
%%% Step-18: Find values of constraint at all points
for i=1:size(points, 1)
    const1(i) = A(1, 1)*points(i, 1) + A(1, 2)*points(i, 2) - b(1); %%% points(i, 1) => x1 for point i; points(i, 2) => x2 for point i
    const2(i) = A(2, 1)*points(i, 1) + A(2, 2)*points(i, 2) - b(2);
end

%%% Step-19: Check unique indices of points where these values don't satisfy their inequalities
k1 = find(const1 > 0);
k2 = find(const2 > 0);
k = unique([k1 k2]);

%%% Step-20: Remove those points from soln list
points(k, :) = [];

%%% Step-21: Plot feasible corner points
plot(points(:,1), points(:,2), 'bo', 'MarkerFaceColor', 'b');

%%% Step-22: Shade feasible region by plotting the polygon formed by feasible points if there are >=3 points
if size(points,1) >= 3
    K = convhull(points(:,1), points(:,2));
    patch(points(K,1), points(K,2), [0.9 0.9 1], 'FaceAlpha', 0.4, 'EdgeColor', 'none');
end
%% Phase 7: Compute objective function & find optimal value
%%% Step-23: Find value of objective funcn @ each point
value = points * C';
table = [points value];

%%% Step-24: Find OPTIMAL value & point index (max here)
[z, index] = max(value);

%%% Step-25: Store & display value
x1 = points(index, 1);
x2 = points(index, 2);
fprintf("objective value is %.2f at (%.2f, %.2f)\n", z, x1, x2);

%%% Step-26: Plot & annotate optimal point
plot(x1, x2, 'kp', 'MarkerSize', 12, 'MarkerFaceColor', 'y');
text(x1, x2, sprintf('  (%.2f, %.2f)', x1, x2), 'VerticalAlignment', 'bottom');f