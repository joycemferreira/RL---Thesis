%This command implements the backpropagation learning algorithm for sigmoid networks.
function [W, V] = backprop(x,h,y,yp,alpha,W,V);
    %[W, V] = backprop(x,h,y,yp,alpha,W,V);
    % Inputs: x input vector (n,1)
    % h hidden tanh (h,1)
    % y output vector (o,1)
    % yp output target (o,1)
    % alpha learning rate
    % W input weights (h,n)
    % V output weights (o,h)
    % Outputs W, V new
    d2 = yp - y;
    dV = alpha .* d2 * h';
    d1 = (1 - h.*h) .* (V' * d2);
    dW = alpha .* d1 * x';
    V = V + dV;
    W = W + dW;
end