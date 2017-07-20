%This command computes the dynamics stability test by computing the
% allowable neural network weight uncertainty.
function [dW,dV] = dynamu(W,V)
    %[dW,dV] = dynamu(W,V)
    %Remember to change variables like
    % T sampling rate (0.01)
    % om logspace (-2,2,100)
    % filename task1_mu
    [h,n] = size(W);
    [jj,h] = size(V);
    mW = n * h;
    mV = h * jj;
    dW = eye(mW);
    dV = eye(mV);
    sumW = sum(sum(abs(W)));
    sumV = sum(sum(abs(V)));
    sumT = sumW + sumV;
    for i = 1:h
        for j = 1:n
        k = (i-1)*n + j;
        dW(k,k) = abs(W(i,j) / sumT);
        dV(i,i) = abs(V(i) / sumT);
        end;
    end;
    iW = dW;
    iV = dV;
    minf = 1;
    maxf = 1;
    blk = [h, 0];
    blk = [blk; ones(mW + mV,2)];
    %blk(:,1) = blk(:,1) .* -1;
    om = logspace(-2,2,100);
    [WA,WB] = diagfit(W);
    [VA,VB] = diagfit(V);
    %set parameters in simulink model 'task1_mu3'
    set_param('task1_mu3/W','K',mat2str(W));
    set_param('task1_mu3/V','K',mat2str(V));
    set_param('task1_mu3/WA','K',mat2str(WA));
    set_param('task1_mu3/WB','K',mat2str(WB));
    set_param('task1_mu3/VA','K',mat2str(VA));
    set_param('task1_mu3/VB','K',mat2str(VB));
    set_param('task1_mu3/eyeV','K',mat2str(eye(h)));
    set_param('task1_mu3/dW','K',mat2str(dW));
    set_param('task1_mu3/dV','K',mat2str(dV));

    %Compute initial mu
    set_param('task1_mu3/dW','K',mat2str(dW));
    set_param('task1_mu3/dV','K',mat2str(dV));
    
    [a,b,c,d] = dlinmod('task1_mu3',0.01);
    
    sys = pck(a,b,c,d);
    sysf = frsp(sys,om,0.01);
    disp 'Computing mu';
    bnds = mu(sysf,blk,'s');
    maxmu = max(bnds(:,1));
    s = sprintf('mu = %f for scale factor %f',maxmu,minf);
    disp(s);
    if ( maxmu < 1 )
        while ( maxmu < 1 )
            temp = maxmu;
            minf = maxf;
            maxf = maxf * 2;
            dW = iW .* maxf;
            dV = iV .* maxf;
            set_param('task1_mu3/dW','K',mat2str(dW));
            set_param('task1_mu3/dV','K',mat2str(dV));
            [a,b,c,d] = dlinmod('task1_mu3',0.01);
            sys = pck(a,b,c,d);
            sysf = frsp(sys,om,0.01);
            disp 'Computing mu';
            bnds = mu(sysf,blk,'s');
            maxmu = max(bnds(:,1));
            s = sprintf('mu = %f for scale factor %f',maxmu,maxf);
            disp(s);
        end;
        maxmu = temp;
    else
        while ( maxmu > 1 )
            if (minf < 0.01)
                disp 'Warning: dynamu cannot find dW,dV with mu < 1'
                disp 'Halt Learning'
                dW = iW .* 0;
                dV = iV .* 0;
                return;
            end;
            maxf = minf;
            minf = minf * 0.5;
            dW = iW .* minf;
            dV = iV .* minf;
            set_param('task1_mu3/dW','K',mat2str(dW));
            set_param('task1_mu3/dV','K',mat2str(dV));
            [a,b,c,d] = dlinmod('task1_mu3',0.01);
            sys = pck(a,b,c,d);
            sysf = frsp(sys,om,0.01);
            disp 'Computing mu';
            bnds = mu(sysf,blk,'s');
            maxmu = max(bnds(:,1));
            s = sprintf('mu = %f for scale factor %f',maxmu,minf);
            disp(s);
        end;
    end;
    while ( maxmu < 0.95 | maxmu > 1 )
        if ( maxmu < 1 )
            safe = minf;
            minf = (maxf-safe)/2 + safe;
        else
            maxf = minf;
            minf = (maxf-safe)/2 + safe;
        end;
        if (minf < 0.01)
            disp 'Warning: dynamu cannot find dW,dV with mu < 1'
            disp 'Halt Learning'
            dW = iW .* 0;
            dV = iV .* 0;
            return
        end;
            dW = iW .* minf;
            dV = iV .* minf;
            set_param('task1_mu3/dW','K',mat2str(dW));
            set_param('task1_mu3/dV','K',mat2str(dV));
            [a,b,c,d] = dlinmod('task1_mu3',0.01);
            sys = pck(a,b,c,d);
            sysf = frsp(sys,om,0.01);
            disp 'Computing mu';
            bnds = mu(sysf,blk,'s');
            maxmu = max(bnds(:,1));
            s = sprintf('mu = %f for scale factor %f',maxmu,minf);
            disp(s);
    end;
    dW = WA * dW * WB;
    dV = VA * dV * VB;
end