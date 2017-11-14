%======================================================================
%
%  COE-835  Controle adaptativo
%
%  Script para simular o exemplo
%
%  MRAC  : n  = 2     First order plant
%          n* = 2     Relative degree
%          np = 4     Adaptive parameters
%
%======================================================================
function dx=mrac1(t,x)

global P Z kp Pm Zm km L dc a w gama1 gama2;

y      = x(1);
ym     = x(2);
theta1 = x(3);
theta2 = x(4);

%theta = [theta1 ; theta2];

%--------------------------
r = dc + a*sin(w*t);

omega = [uf' y yf' r]';
y = thetas'*phi;
dy = [y(2:end) u-(flip(P(2:end))*y)]';

u = theta'*omega;
duf = [u-(flip(L(2:end))*uf)]';
dyf = [y-(flip(L(2:end))'*yf)]';

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
