%This command initializes a sigmoid neural network.
function [W,V] = setSIG(Nin,Nhid,Nout)
    %[W,V] = setSIG(Nin,Nhid,Nout);
    %remember to add 1 at input and hidden for bias
    W = (rand(Nhid,Nin)-0.5);
    V = (rand(Nout,Nhid)-0.5) .* 0.1;
end