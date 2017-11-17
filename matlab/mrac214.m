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

global Ay By Aym Bym Auf Buf Ayf Byf kp gamma w A;

y      = x(1:2);
ym     = x(3);
uf     = x(4);
yf     = x(5);
theta  = x(6:end);

%--------------------------
r = A(1)*sin(w(1)*t) + A(2)*sin(w(2)*t);

omega = [uf' y(1) yf' r]';
u = theta'*omega;

%------- Calculo de y --------
dy = Ay*y + By*u;

%------- Calculo de ym --------
dym = Aym*ym + Bym*r;

%------- Calculo de uf --------
duf = Auf*uf + Buf*u;

%------- Calculo de yf --------
dyf = Ayf*yf + Byf*y(1);

e  = y(1) - ym(1);
dtheta = -sign(kp)*gamma*omega*e;

%--------------------------
dx = [dy' dym' duf' dyf' dtheta']';    %Translation

%---------------------------