% Steepest Descent Method for minimizing a function
% This example uses f(x1,x2) = x1^2 + 2*x2^2 as the objective function

clear all;
clc;

% Define the objective function
f = @(x1, x2) x1.^2 + 2*x2.^2;

% Define the gradient of the function
grad_f = @(x1, x2) [2*x1; 4*x2];

% Initial guess
x = [3; 3];

% Parameters
max_iter = 100;     % Maximum number of iterations
tol = 1e-6;         % Tolerance for stopping criterion
alpha = 0.1;        % Fixed step size (learning rate)

fprintf('Initial point: (%f, %f)', x(1), x(2));

for iter = 1:max_iter
    % Compute gradient at current point
    gradient = grad_f(x(1), x(2));
    
    % Check stopping criterion (norm of gradient)
    if norm(gradient) < tol
        fprintf('Converged after %d iterations', iter-1);
        break;
    end
    
    % Update the solution
    x = x - alpha * gradient;
    
    % Display progress
    fprintf('Iteration %d: x = (%f, %f), f(x) = %f', ...
            iter, x(1), x(2), f(x(1), x(2)));
end

fprintf('Final solution: (%f, %f)', x(1), x(2));
fprintf('Minimum function value: %f', f(x(1), x(2)));