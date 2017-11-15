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
function dx=mrac316(t,x)

global Ay By Aym Bym Auf Buf Ayf Byf kp gamma w A;

y      = x(1:3);
ym     = x(4);
uf     = x(5:6);
yf     = x(7:8);
theta  = x(9:end);

%--------------------------
r = A(1)*sin(w(1)*t) + A(2)*sin(w(2)*t) + A(3)*sin(w(3)*t);

omega = [uf' y(1) yf' r]';
u = theta'*omega;

%------- Cálculo de y --------
dy = Ay*y + By*u;

%------- Cálculo de ym --------
dym = Aym*ym + Bym*r;

%------- Cálculo de uf --------
duf = Auf*uf + Buf*u;

%------- Cálculo de yf --------
dyf = Ayf*yf + Byf*y(1);

e  = y(1) - ym(1);
dtheta = -sign(kp)*gamma*omega*e;

%--------------------------
dx = [dy' dym duf' dyf' dtheta']';    %Translation

%---------------------------
