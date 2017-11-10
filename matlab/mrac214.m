%======================================================================
%
%  COE-835  Controle adaptativo
%
%  Script para simular o exemplo
%
%  MRAC  : n  = 2     First order plant
%          n* = 1     Relative degree
%          np = 4     Adaptive parameters
%
%======================================================================
function dx=mrac214(t,x)

global P Z kp Pm Zm km dc a w gama1 gama2;

Z = [1 1];
P = [1 -2 1];
kp = 1;

Zm = [1 1.5];
Pm = [1 3 2];
km = 1;

Y = tf(Z,kp*P);
Ym = tf(Zm,km*Pm);
A0 = tf(1);

[theta_1, theta_n, theta_2, theta_2n, L] = find2DOFparameters(Y,Ym,A0);

y      = x(1);
ym     = x(2);
theta1 = x(3);
theta2 = x(4);

%theta = [theta1 ; theta2];

%--------------------------
r = dc + a*sin(w*t);

%omega = [ y ; r];

e  = y - ym;

u = theta1*y + theta2*r;
%u = theta.'*omega;

dy = ap*y + kp*u;
dym = -am*ym + km*r;

dtheta1 = -gama1*sign(kp)*y*e;
dtheta2 = -gama2*sign(kp)*r*e;

%dtheta = -Gama*sign(kp)*omega*e;


%--------------------------
dx = [dy dym dtheta1 dtheta2]';    %Translation

%---------------------------
