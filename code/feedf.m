% This command performs the feedforward operation on a sigmoid neural network.
function [y, h] = feedf(x,W,V)
    %[y, h] = feedf(x,W,V)
    % Inputs: x is input vector (n,1)
    % W is input side weights (h,n)
    % V is output side weights (o,h)
    % Outputs: y is output vector (o,1)
    % h is tanh hidden layer (h,1)
    % Note: h is required for back prop training
    h = W * x;
    h = tanh(h);
    y = V * h;
end