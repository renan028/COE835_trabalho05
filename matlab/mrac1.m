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

global P Z kp Pm Zm km L gamma thetas theta_2n;

y      = x(1);
ym     = x(2);
uf     = x(3);
yf     = x(4);
theta  = x(5:end);

%--------------------------
r = 10*sin(0.9*t) + 10*sin(1.9*t);

omega = [uf' y yf' r]';

theta_til = theta - thetas;
dy = [r+(1/theta_2n)*theta_til'*omega-(flip(Pm(2:end))*y)]';
dym = [r-(flip(Pm(2:end))*y)]';

u = theta'*omega;
duf = [u-(flip(L(2:end))*uf)]';
dyf = [y-(flip(L(2:end))'*yf)]';

e  = y - ym;

dtheta = -sign(kp)*gamma*omega*e;


%--------------------------
dx = [dy dym duf' dyf' dtheta']';    %Translation

%---------------------------
