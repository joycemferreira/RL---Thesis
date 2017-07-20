% This command computes the static stability test.
function [maxmu, bnds] = statmu(W,V)
    %[maxmu, bnds] = compmu(W,V)
    %Computes static mu
    %Remember to change variables like
    % T sampling rate (0.01)
    % om logspace (-2,2,100)
    % filename task1_mu
    nhid = length(V);
    blk = [nhid, 0];
    om = logspace(-2,2,100);
    set_param('task1_mu/W','K',mat2str(W));
    set_param('task1_mu/V','K',mat2str(V));
    set_param('task1_mu/eyeV','K',mat2str(eye(nhid)));
    disp 'Computing static mu';
    [a,b,c,d] = dlinmod('task1_mu',0.01);
    sys = pck(a,b,c,d);
    sysf = frsp(sys,om,0.01);
    bnds = mu(sysf,blk,'s');
    maxmu = max(bnds(:,1));
end