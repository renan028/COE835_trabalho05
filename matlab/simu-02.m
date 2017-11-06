%----------------------------------------------------------------------
%
%  COE-835  Controle adaptativo
%
%  Script para simular exemplo 
%
%  MRAC  : n  = 1     First order plant
%          n* = 1     Relative degree
%          np = 2     Adaptive parameters
%
%                                                        Ramon R. Costa
%                                                        30/abr/13, Rio
%----------------------------------------------------------------------
clear;
clc;

disp('-------------------------------')
disp('Script para simular o exemplo 9')
disp(' ')
disp('Caso: Planta ............. n = 1')
disp('      Grau relativo ..... n* = 1')
disp('      Parâmetros ........ np = 2')
disp(' ')
disp('Algoritmo: MRAC direto')
disp(' ')
disp('-------------------------------')

global ap kp km am dc a w gama1 gama2;

ap =  0;
kp =  0.5;
am =  1;
km =  1;

dc = 1;
a  = 1;
w  = 1;

gama1 = 1
gama2 = 1

y0  = 5
ym0 = 0;
theta0 = [0 0];

%-----------------------
theta1s = -(ap + am)/kp
theta2s = km/kp

%-----------------------
clf;
tf = 100;

init = [y0 ym0 theta0];

options = odeset('OutputFcn','odeplot');
[T,X] = ode23s('mrac112',tf,init,options);

y      = X(:,1);
ym     = X(:,2);
theta1 = X(:,3);
theta2 = X(:,4);

e =  y - ym;
r = dc + a.*sin(w.*T);
modtt = sqrt(theta1.^2 + theta2.^2);

figure(1)
clf
subplot(211)
plot(T,r,T,ym,T,y);grid;shg
legend('r','y_m','y','Location','SouthEast')
print -depsc2 fig02a

figure(2)
clf
subplot(211)
plot(T,theta1,T,theta2);grid;shg
legend('\theta_1','\theta_2','Location','SouthEast')
print -depsc2 fig02b

figure(3)
clf
subplot(211)
plot(T,e);grid;shg
legend('e','Location','SouthEast')
print -depsc2 fig02c

figure(4)
clf
subplot(211)
plot(T,modtt);grid;shg
legend('|\theta|','Location','SouthEast')
print -depsc2 fig02d

%---------------------------------------------------------------------

