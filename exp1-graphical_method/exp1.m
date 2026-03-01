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
x1 = 0:max(b);  %%% x1 is a 1 x 104 row vector matrix!

%%% Step-3: Find values of x2i from ith constraint
x21 = (b(1) - A(1, 1) * x1) ./ A(1, 2); %%% 2x1 + 1x2 = 104 ==> x2 = (104 - 2*x1) / 1 = 1 x 104 row matrix
x22 = (b(2) - A(2, 1) * x1) ./ A(2, 2); %%% 1x1 + 2x2 =  76 ==> x2 = ( 76 - 1*x1) / 2 = 1 x 104 row matrix
%%% Step-4: Put constraint x2>=0 as well
x21 = max(0, x21);
x22 = max(0, x22);

%%% Step-5: Plotting constraints on graph
plot(x1, x21, "r", "DisplayName", "2x1 +  x2 = 104");
hold on;    %%% Retain current plot when drawing new plot
plot(x1, x22, "g", "DisplayName", " x1 + 2x2 = 76");
xlabel("Value of x1");
ylabel("Value of x2");
title("Graph of x1 vs x2");
legend("show");
grid on;

%% Phase 3: Find points intercepting x & y axes
%%% Step-6: Find where x1 is 0 for y-intercepts
cx1 = find(x1==0);      %%% x1(1) = 0 => cx1 = 1

%%% Step-7: Find where x2i is 0 for possible x-intercepts
cx21 = find(x21==0);    %%% x21(53,54,...,105) = 0 i.e. cx21 = [53 54 ... 105]
cx22 = find(x22==0);    %%% x22(77,78,...,105) = 0 i.e. cx22 = [77 78 ... 105]

%%% Step-8: Find coordinates of constraint lines lying on x & y axes
line1 = [x1(:, [cx21, cx1]); x21(:, [cx21, cx1])]';     %%% Matrix denoting constraint 1 lying on axes, where col1 = x-coords & col2 = y-coords; each row is ONE PT!
line2 = [x1(:, [cx22, cx1]); x22(:, [cx22, cx1])]';     %%% Matrix denoting constraint 2 lying on axes, where col1 = x-coords & col2 = y-coords; each row is ONE PT!

%%% Step-9: Remove duplicate points (IMPORTANT) & store in final var
corpt = unique([line1; line2], "rows");

%% Phase 4: Find the point(s) of intersection of each pair of constraints
%%% Step-10: Initialise a soln to both constraints
SA = [0; 0];
for i = 1:size(A, 1)  
    s1 = A(i, :);
    b1 = b(i, :);
    for j = i+1:size(A, 1)
        %%% Steps-11 & 12: For each pair of constraints formed with nested loop, initialise coefficients & constants
        s2 = A(j, :);
        b2 = b(j, :);
   
        %%% Step-13: Use X = inv(A) / b to solve for point of intersection & store in temp soln
        A1 = [s1; s2];
        B1 = [b1; b2];        
        X = A1 \ B1;          %%% Returns a COLUMN vector
        SA = [SA X];
    end
end

%%% Step-14: Store temp soln transposed
ptt = SA';   %%% Transposing the col vector answer to match with the corpt matrix format

%% Phase 5: Combine ALL the corner points
%%% Step-15: Combine
allpt = [ptt; corpt];
%%% Step-16: Remove duplicates (IMPORTANT)
points = unique(allpt, "rows");

%% Phase 6: Filter out points not in feasable region(s)
%%% Step-17: Find values of constraint at all points
for i=1:size(points, 1)
    const1(i) = A(1, 1)*points(i, 1) + A(1, 2)*points(i, 2) - b(1); %%% points(i, 1) => x1 for point i; points(i, 2) => x2 for point i
    const2(i) = A(2, 1)*points(i, 1) + A(2, 2)*points(i, 2) - b(2);
end

%%% Step-18: Check unique indices of points where these values don't satisfy their inequalities
k1 = find(const1 > 0);
k2 = find(const2 > 0);
k = unique([k1 k2]);

%%% Step-19: Remove those points from soln list
points(k, :) = [];

%%% Step-20: Plot feasible corner points
plot(points(:,1), points(:,2), "bo", "MarkerSize", 5, "MarkerFaceColor", "b", "DisplayName", "Extreme points");   %%% Blue circles with blue fill!

%%% Step-21: Shade feasible region by plotting the polygon formed by feasible points if there are >=3 points
if size(points,1) >= 3
    K = convhull(points(:,1), points(:,2));
    patch(points(K,1), points(K,2), [0.9 0.9 1], 'FaceAlpha', 0.5, 'EdgeColor', 'none', "DisplayName", "Feasable Region");
end
%% Phase 7: Compute objective function & find optimal value
%%% Step-22: Find value of objective funcn @ each point
value = points * C';
table = [points value];

%%% Step-23: Find OPTIMAL value & point index (max here)
[z, index] = max(value);

%%% Step-24: Store & display value
optimal_x1 = points(index, 1);
optimal_x2 = points(index, 2);
fprintf("objective value is %.2f at (%.2f, %.2f)\n", z, optimal_x1, optimal_x2);

%%% Step-25: Plot & annotate optimal point
plot(optimal_x1, optimal_x2, 'kp', 'MarkerSize', 12, 'MarkerFaceColor', 'y', "DisplayName", "Optimal Solution");
text(optimal_x1, optimal_x2, sprintf('  (%.2f, %.2f)', optimal_x1, optimal_x2));