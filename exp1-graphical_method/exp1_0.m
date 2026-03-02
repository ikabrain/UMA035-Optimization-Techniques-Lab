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
x1 = 0:1:max(abs(b));  %%% x1 is a 1 x 104 row vector matrix!

%%% Step-3: Find values of x2i from ith constraint
x21 = (b(1) - A(1, 1) * x1) ./ A(1, 2); %%% 2x1 + 1x2 = 104 ==> x2 = (104 - 2*x1) / 1 = 1 x 104 row matrix
x22 = (b(2) - A(2, 1) * x1) ./ A(2, 2); %%% 1x1 + 2x2 =  76 ==> x2 = ( 76 - 1*x1) / 2 = 1 x 104 row matrix
%%% Step-4: Put constraint x2>=0 as well
x21 = max(0, x21);
x22 = max(0, x22);

%%% Step-5: Plotting constraints on graph
plot(x1, x21, 'r', 'DisplayName', '2x1 +  x2 = 104');
hold on;    %%% Retain current plot when drawing new plot
plot(x1, x22, 'g', 'DisplayName', ' x1 + 2x2 = 76');
xlabel('Value of x1');
ylabel('Value of x2');
title('Graph of x1 vs x2');
legend show;
grid on;

%% Phase 3: Find points intercepting x & y axes
%%% Step-6: Find where x1 is 0 for y-intercepts
cx1 = find(x1==0);      %%% x1(1) = 0 => cx1 = 1

%%% Step-7: Find where x2i is 0 for possible x-intercepts
cx21 = find(x21==0);    %%% x21(53,54,...,105) = 0 i.e. cx21 = [53 54 ... 105]
cx22 = find(x22==0);    %%% x22(77,78,...,105) = 0 i.e. cx22 = [77 78 ... 105]

%%% Step-8: Find coordinates of constraint lines lying on x & y axes
line1 = [x1(:, [cx21 cx1]); x21(:, [cx21 cx1])]';     %%% Matrix denoting constraint 1 lying on axes, where col1 = x-coords & col2 = y-coords; each row is ONE PT!
line2 = [x1(:, [cx22 cx1]); x22(:, [cx22 cx1])]';     %%% Matrix denoting constraint 2 lying on axes, where col1 = x-coords & col2 = y-coords; each row is ONE PT!

%%% Step-9: Store in final var
corpt = unique([line1; line2], 'rows');

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
%%% Step-15: Combine & remove duplicates (IMPORTANT)
points = unique([ptt; corpt], 'rows');

%% Phase 6: Filter out points not in feasable region(s)
%%% Step-16: Find values of constraint at all points
for i=1:size(points, 1)
    const1(i) = A(1, 1)*points(i, 1) + A(1, 2)*points(i, 2) - b(1); %%% points(i, 1) => x1 for point i; points(i, 2) => x2 for point i
    const2(i) = A(2, 1)*points(i, 1) + A(2, 2)*points(i, 2) - b(2);
end

%%% Step-17: Check unique indices of points where these values don't satisfy ALL their constraints
k1 = find(const1 > 0);
k2 = find(const2 > 0);
k3 = find(points(:, 1) < 0);
k4 = find(points(:, 2) < 0);
k = unique([k1 k2 k3 k4]);

%%% Step-18: Remove those points from soln list
points(k, :) = [];

%%% Step-19: Check if points is empty i.e. if there exists any feasable
%%% soln
if isempty(points)
    fprintf('There exists no feasable solution.\n');
else
    %%% Step-20: Plot feasible corner points
    plot(points(:,1), points(:,2), 'bo', 'MarkerSize', 5, 'MarkerFaceColor', 'b', 'DisplayName', 'Extreme points');   %%% Blue circles with blue fill!
    
    %%% Step-21: Shade feasible region by plotting the polygon formed by feasible points if there are >=3 points
    if size(points,1) >= 3
        K = convhull(points(:,1), points(:,2));
        patch(points(K,1), points(K,2), [0.9 0.9 1], 'FaceAlpha', 0.5, 'EdgeColor', 'none', 'DisplayName', 'Feasable Region');
    end
    %% Phase 7: Compute objective function
    %%% Step-22: Find value of objective funcn @ each point
    val = points * C'; %%% Returns a COLUMN VECTOR where each row = value @ point!
    resultTable = [points val];

    %% Phase 8: Find optimal value & display solution
    %%% Step-23: Find OPTIMAL value & point index (max here)
    [opval, opidx] = max(val);
    
    %%% Step-24: Store & display values
    optab = resultTable(opidx, :);
    opx1 = points(opidx, 1);
    opx2 = points(opidx, 2);
    
    fprintf('Optimal Values are:-\n');
    OPTIMAL_GRAPH = array2table(optab, 'VariableNames', {'x1', 'x2', 'Z'});
    disp(OPTIMAL_GRAPH);
    
    %%% Step-25: Plot & annotate optimal point
    plot(opx1, opx2, 'kp', 'MarkerSize', 12, 'MarkerFaceColor', 'y', 'DisplayName', 'Optimal Solution');
    text(opx1, opx2, sprintf('  (%.2f, %.2f)', opx1, opx2));
end