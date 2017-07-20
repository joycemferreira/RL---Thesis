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

r = zeros(2,1000);
r(1,300:end) = 1;

[x,y,u,e] = runitnn(W,V, r,AK,BK,CK,DK);

%figures
clf;
plot(r(1,:), 'b');
hold on;
plot(y(1,:),'r');
xlabel('Samples')
hold on;
plot(y(2,:),'g')
legend('r1','y1','y2')