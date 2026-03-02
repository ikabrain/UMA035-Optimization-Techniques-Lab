%{
    Maximize/Minimize Z = 3x1 + 2x2
    Subject to  2x1 + 4x2 <= 8
                3x1 + 5x2 >= 15
                x1 >=0 , x2 >= 0
%}

format short;
clear all;
clc;

C = [3, 2];
A = [2, 4; -3, -5];
b = [8; -15];

x1 = 0:max(b);
x21 = (b(1) - A(1, 1) * x1) ./ A(1, 2);
x22 = (b(2) - A(2, 1) * x1) ./ A(2, 2);
x21 = max(0, x21);
x22 = max(0, x22);

plot(x1, x21, "r", "DisplayName", "2x1 + 4x2 = 8")
hold on;
plot(x1, x22, "g", "DisplayName", "3x1 + 5x2 = 15");
xlabel("x1");
ylabel("x2");
title("Graph of x1 vs x2");
legend show;
grid on;

cx1 = find(x1==0);
cx21 = find(x21==0);
cx22 = find(x22==0);

line1 = [x1(:, [cx1, cx21]); x21(:, [cx1, cx21])]';
line2 = [x1(:, [cx1, cx22]); x22(:, [cx1, cx22])]';

corpt = [line1; line2];

SA = [0; 0];
for i = 1:size(A, 1)
    s1 = A(i, :);
    b1 = b(i, :);
    for j = i+1:size(A, 1)
        s2 = A(j, :);
        b2 = b(j, :);

        A1 = [s1; s2];
        B1 = [b1; b2];
        X = A1 \ B1;
        SA = [SA X];
    end
end

ptt = SA';

points = unique([corpt; ptt], "rows");

for i = 1: size(points, 1)
    px1 = points(i, 1);
    px2 = points(i, 2);
    cons1(i) = A(1, 1)*px1 + A(1, 2)*px2 - b(1);
    cons2(i) = A(2, 1)*px1 + A(2, 2)*px2 - b(2);
end

k1 = find(cons1 > 0);
k2 = find(cons2 > 0);
k = unique([k1, k2]);

points(k, :) = [];

if isempty(points)
    fprintf("There exists no feasable solution.\n");
else
    plot(points(:, 1), points(:, 2), "bo", "MarkerSize", 5, "MarkerFaceColor", "b", "DisplayName", "Extreme points");
    if size(points, 1) >= 3
        K = convhull(points(:, 1), points(:, 2));
        patch(points(K, 1), points(K, 2),[0.9 0.9 1], "FaceAlpha", 0.5, "EdgeColor", "none", "DisplayName", "Feasable Region");
    end

    Z = points * C';
    table = [points, z];

    [optim_z, optim_idx] = max(z);
    optim_x1 = points(optim_idx, 1);
    optim_x2 = points(optim_idx, 2);
    fprintf("Optimal value is %.2f at (%.2f, %.2f)\n", optim_z, optim_x1, optim_x2);
    
    plot(optim_x1, optim_x2, "kp", "MarkerSize", 12, "MarkerFaceColor", "y", "DisplayName", "Optimal Value");
    text(optim_x1, optim_x2, sprintf("    (%.2f, %.2f)", optim_x1, optim_x2));
end