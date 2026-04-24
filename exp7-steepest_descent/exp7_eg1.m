%{
    Given: f(x1, x2) = x1^3 + x2^3 - 2*x1*x2; f >= 0
    
    => Derivative wrt x1 = 3*(x1^2) - 2*x1
     &            wrt x2 = 3*(x2^2) - 2*x2

%}
format short
clear all
clc

%% Phase 1: Define the objective function
f = @(x1, x2) x1.^3 + x2.^3 - 2*x1*x2;

%% Phase 2: Define the gradient of the function
grad_f = @(x1, x2) [3*x1.^2 - 2*x1; 3*x2.^2 - 2*x2];

%% Phase 3: Take an initial guess
x = [1; 1];
fprintf('Initial point: (%.2f, %.2f)\n\n', x(1), x(2));

%% Phase 4: Define the parameters
max_iter = 100;     % Maximum number of iterations
tol = 1e-6;         % Tolerance for stopping criterion
alpha = 0.1;        % Fixed step size (learning rate)

%% Phase 5: Start Gradient descent loop for each iteration
for iter = 1:max_iter
    %% Step-1: Compute gradient at current point
    gradient = grad_f(x(1), x(2));
    
    %% Step-2: Check stopping criterion (norm of gradient = its MAGNITUDE < tol)
    if norm(gradient) < tol
        fprintf('\n========********========\n');
        fprintf('Converged after %d iterations', iter-1);
        fprintf('\n========********========\n');
        break;
    end
    
    %% Step-3: Update & display current soln
    x = x - alpha * gradient;
    
    % Displaying progress
    fprintf('Iteration %3d: x = (%f, %f), f(x) = %f\n', ...
            iter, x(1), x(2), f(x(1), x(2)));
end

%% Phase 6: Print final solution
fprintf('\nFinal solution: (%.2f, %.2f)\n', x(1), x(2));
fprintf('Minimum function value: %.4f\n\n', f(x(1), x(2)));