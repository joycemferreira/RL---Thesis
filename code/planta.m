g11 = tf([87.8],[75 1]);
g12 = tf([-86.4],[75 1]);
g21 = tf([108.2],[75 1]);
g22 = tf([-109.6],[75 1]);

Ts = .1

g11d = c2d(g11,Ts);
g12d = c2d(g12,Ts);
g21d = c2d(g21,Ts);
g22d = c2d(g22,Ts);

[A1, B1, C1, D1] = tf2ss(g11d.num{:,:},g11d.den{:,:});
[A2, B2, C2, D2] = tf2ss(g12d.num{:,:},g12d.den{:,:});
[A3, B3, C3, D3] = tf2ss(g21d.num{:,:},g21d.den{:,:});
[A4, B4, C4, D4] = tf2ss(g22d.num{:,:},g22d.den{:,:});

A = [A1 A2; A3 A4]
B = [B1 B2; B3 B4]
C = [C1 C2; C3 C4]
D = [D1 D2; D3 D4]
