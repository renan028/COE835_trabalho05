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
function dx=mrac(t,x)

global Ay By Aym Bym Auf Buf Ayf Byf kp gamma w A gP gPm;

y      = x(1:gP);
ym     = x(gP+1:gP+gPm);
uf     = x(gP+gPm+1:gP+gPm+gP-1);
yf     = x(gP+gPm+gP:gP+gPm+gP-1+gP-1);
theta  = x(gP+gPm+gP-1+gP:end);

%--------------------------
r = 0;
for i=1:gP
    r = r + A(i)*sin(w(i)*t);
end

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