%Nominal controller

a=0.7*.3994;
b=0.7*-.3149;
c=0.7*.3943;
d=0.7*-.3200;

K = [tf([75*a a],[1 0]) tf([75*b b],[1 0]) ; tf([75*c c],[1 0]) tf([75*d d],[1 0])];

Ts = .1;

Kd = c2d(K,Ts);

sys1 = ss(Kd)

AK=sys1.A;
BK=sys1.B;
CK=sys1.C;
DK=sys1.D;


%critic network
n = 10;
t = 3;
mins = [-10 -10 -10 -10];
sizes = [100 100 100 100];

%actor network
Nin = 3;
Nhid = 4;
Nout = 2;

a1 = .01;
a2 = .001;

N = 500000;

[Q,q] = setCMAC(n,t,mins,sizes);
[W,V] = setSIG(Nin,Nhid,Nout);

[Q,W,V] = both(Q,q,W,V,N,a1,a2,AK,BK,CK,DK);
