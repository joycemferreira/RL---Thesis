a = .3994;
b = -.3149;
c = .3943;
d = -.3200;

Ki = .7;
num1 = Ki*[75*a a]
num2 = Ki*[75*b b];
num3 = Ki*[75*c c];
num4 = Ki*[75*d d];

deno = [1 0];

g11 = tf(num1, deno);
g12 = tf(num2, deno);
g21 = tf(num3, deno);
g22 = tf(num4, deno);

Ts = 1;

g11d = c2d(g11,Ts);
g12d = c2d(g12,Ts);
g21d = c2d(g21,Ts);
g22d = c2d(g22,Ts);

[A1, B1, C1, D1] = tf2ss(g11.num{:,:},g11.den{:,:});
[A2, B2, C2, D2] = tf2ss(g12.num{:,:},g12.den{:,:});
[A3, B3, C3, D3] = tf2ss(g21.num{:,:},g21.den{:,:});
[A4, B4, C4, D4] = tf2ss(g22.num{:,:},g22.den{:,:});

AK = [A1 A2; A3 A4]
BK = [B1 B2; B3 B4]
CK = [C1 C2; C3 C4]
DK = [D1 D2; D3 D4]

r = zeros(2,1000);
r(1,300:end) = 1;

[x,y,u,e] = runit(r,AK,BK,CK,DK);

%figures
clf;
plot(r(1,:), 'b');
hold on;
plot(y(1,:),'r');
xlabel('Samples')
hold on;
plot(y(2,:),'g')
legend('r1','y1','y2')