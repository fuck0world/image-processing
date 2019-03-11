clc;
clear all;
m1 = [-0.4 0.58 0.089;
    -0.31 0.27 -0.04;
    0.38 0.055 -0.035;
    -0.15 0.53 0.011;
    -0.35 0.47 0.034;
    0.17 0.69 0.1;
    -0.0011 0.55 -0.18]
m2 = [0.83 1.6 -0.014;
    1.1 1.6 0.48;
    -0.44 -0.41 0.32;
    0.047 -0.45 1.4;
    0.280 0.35 3.1;
    -0.39 -0.48 0.11;
    0.34 -0.079 0.14;
    ]
%求均值
u1 = mean(m1);
u2 = mean(m2);

%求类内散度Si和总类内散度Sw
t1 = abs(m1);
t2 = abs(m2);
t11 = min(t1);
t12 = min(t2);
t21 = max(t1);
t22 = max(t2);
e1 = min(t11,t12);
e2 = min(t21,t22);

[s,i1] = size(m1);
[t,i2] = size(m2);
One1 = ones(s,1);
One2 = ones(t,1);
S1 = s * (m1 - One1 * u1)' * (m1 - One1 * u1);
S2 = t * (m2 - One2 * u2)' * (m2 - One2 * u2);