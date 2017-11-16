%----------------------------------------------------------------------
%
%  COE-835  Controle adaptativo
%
%  Script para simular exemplo 
%
%  MRAC  : n  = 3     First order plant
%          n* = 1     Relative degree
%          np = 6     Adaptive parameters
%
%                                                        Ramon R. Costa
%                                                        30/abr/13, Rio
%----------------------------------------------------------------------
clear;
clc;

disp('-------------------------------')
disp('Script para simular o trabalho 5')
disp(' ')
disp('Caso: Planta ............. n = 3')
disp('      Grau relativo ..... n* = 1')
disp('      Parâmetros ........ np = 6')
disp(' ')
disp('Algoritmo: MRAC direto')
disp(' ')
disp('-------------------------------')

global Ay By Aym Bym Auf Buf Ayf Byf kp km gamma w A;

%% r
w1 = 1;
w2 = 2.1;
w3 = 3.5;
w = [w1 w2 w3];

a1 = 10;
a2 = 25;
a3 = 10;
A = [a1 a2 a3];

%% H, Hm
Z = [1 2 1];
P = [1 6 12 8];
kp = 1;

Zm = [1];
Pm = [1 10];
km = 1;

H = tf(kp*Z,P);
Hm = tf(km*Zm,Pm);
A0 = tf([1]);

%% Init
[theta_1, theta_n, theta_2, theta_2n, L] = find2DOFparameters(H,Hm,A0); 

gamma = 100*eye(6);

y0  = [0 0 0]';
ym0 = 0;
uf0 = [0 0]';
yf0 = [0 0]';
theta0 = zeros(6,1);

clf;
tfinal = 300;

init = [y0' ym0 uf0' yf0' theta0']';


%% Sistemas
% Planta
ss_H = canon(ss(H), 'companion');
Ay = ss_H.A';
By = ss_H.C'; % Forma canônica observável

% Modelo
ss_Hm = canon(ss(Hm), 'companion');
Aym = ss_Hm.A';
Bym = ss_Hm.C'; % Forma canônica observável

% Filtro u
ss_uf = canon(ss(tf(1,L)), 'companion');
Auf = ss_uf.A';
Buf = ss_uf.C'; % Forma canônica observável

% Filtro y
ss_yf = canon(ss(tf(1,L)), 'companion');
Ayf = ss_yf.A';
Byf = ss_yf.C'; % Forma canônica observável

%% Plots
[T,X] = ode23s('mrac316',tfinal,init,'');

y      = X(:,1);
ym     = X(:,4);
theta =  X(:,9:end);

e =  y - ym;
r = A(1)*sin(w(1).*T) + A(2)*sin(w(2).*T) + A(3)*sin(w(3).*T);

%Set matlab interpreter to latex
set(groot, 'defaultAxesTickLabelInterpreter','latex');
set(groot, 'defaultLegendInterpreter','latex');
set(groot, 'defaultTextInterpreter','latex');

figure(1)
clf
plot(T,e);grid;shg
legend('e','Location','SouthEast')
title('$\theta(0)=0$')
print -depsc2 en3t0

figure(2)
clf
plot(T,theta(:,1:2)-theta_1,T,theta(:,3)-theta_n,T,theta(:,4:5)-theta_2,T,theta(:,6)-theta_2n);grid;shg
legend('$\tilde{\theta_1}$','$\tilde{\theta_n}$','$\tilde{\theta_2}$','$\tilde{\theta_{2n}}$','Location','SouthEast')
title('$\theta(0)=0$')
print -depsc2 tiln3t0

%---------------------------------------------------------------------

