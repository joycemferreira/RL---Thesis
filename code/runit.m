
function [x,y,u,e] = runit(r,AK,BK,CK,DK)
    %[x,y,u,e] = runit(r,AK,BK,CK,DK)
    % r is a fixed reference input
    [kk,sr] = size(r);
    [k1,k1] = size(AK);
    A = [0.99867, 0; 0, 0.99867];
    B = [-1.01315, 0.99700; -1.24855, 1.26471];
    C = [-0.11547, 0; 0, -0.11547];
    D = [0, 0; 0, 0];
    
%     %results from planta.m
%     A = [0.998667555160625   0.998667555160625;0.998667555160625   0.998667555160625];
%     B = ones(2,2);
%     C = [0.116988656897083  -0.115123234121959; 0.144170531620323  -0.146035954395447];
%     D = zeros(2,2);
    
    
    e = 0;
    x = zeros(2,sr);
    k = zeros(k1,sr);
    y(:,1) = C * x(:,1);
    start = 300;
    
    for i = 1:sr-1
        err = r(:,i) - y(:,i);
        k(:,i+1) = AK*k(:,i) + BK*err;
        u(:,i) = CK*k(:,i) + DK*err;
        u(1,i) = u(1,i);
        u(2,i) = u(2,i);
        x(:,i+1) = A*x(:,i) + B*u(:,i);
        y(:,i+1) = C*x(:,i) + D*u(:,i);
        err = r(:,i) - y(:,i);
        if ( i > start )
        e = e + sum(abs(err));
        end;
    end;
    u(:,sr) = u(:,sr-1);
    err = r(:,sr) - y(:,sr);
    e = e + sum(abs(err));