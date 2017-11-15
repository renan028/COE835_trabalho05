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
disp('Script para simular o trabalho 5')
disp(' ')
disp('Caso: Planta ............. n = 2')
disp('      Grau relativo ..... n* = 1')
disp('      Parâmetros ........ np = 4')
disp(' ')
disp('Algoritmo: MRAC direto')
disp(' ')
disp('-------------------------------')

global Z P Zm Pm kp km L gamma thetas theta_2n;

Z = [1 1];
P = [1 -2 1];
kp = 1;

Zm = [1];
Pm = [1 1];
km = 1;

Y = tf(kp*Z,P);
Ym = tf(km*Zm,Pm);
A0 = tf([1]);

[theta_1, theta_n, theta_2, theta_2n, L] = find2DOFparameters(Y,Ym,A0);
thetas = [theta_1, theta_n, theta_2, theta_2n]'; 

gamma = 100*eye(length(thetas));

y0  = 0;
ym0 = 0;
uf0 = [0];
yf0 = [0];
theta0 = zeros(length(thetas),1);

%-----------------------
clf;
tf = 50;

init = [y0 ym0 uf0' yf0' theta0']';

options = odeset('OutputFcn','odeplot');
[T,X] = ode23s('mrac1',tf,init,options);

y      = X(:,1);
ym     = X(:,2);
theta =  X(:,5:end);

e =  y - ym;
r = 10*sin(0.9.*T) + 10*sin(1.9.*T);

figure(1)
clf
subplot(211)
plot(T,r,T,ym,T,y);grid;shg
legend('r','y_m','y','Location','SouthEast')
print -depsc2 fig01a

figure(2)
clf
subplot(211)
plot(T,e);grid;shg
legend('e','Location','SouthEast')
print -depsc2 fig01b

%---------------------------------------------------------------------

