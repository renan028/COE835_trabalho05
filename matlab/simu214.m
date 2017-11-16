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

global Ay By Aym Bym Auf Buf Ayf Byf kp km gamma w A;

%% r
w1 = .63493;
w2 = 4.5669;
w = [w1 w2];

a1 = 10;
a2 = 25;
A = [a1 a2];

%% H, Hm
Z = [1 1];
P = [1 4 4];
kp = 1;

Zm = [1];
Pm = [1 5];
km = 1;

H = tf(kp*Z,P);
Hm = tf(km*Zm,Pm);
A0 = tf([1]);

%% Init
[theta_1, theta_n, theta_2, theta_2n, L] = find2DOFparameters(H,Hm,A0); 

gamma = 20*eye(4);

y0  = [0 0]';
ym0 = 0;
uf0 = [0]';
yf0 = [0]';
theta0 = zeros(4,1);

clf;
tfinal = 100;

init = [y0' ym0 uf0' yf0' theta0']';


%% Sistemas
% Planta
ss_H = canon(ss(H), 'companion');
Ay = ss_H.A';
By = ss_H.C'; % Forma canônica observável
Cy = ss_H.B';

% Modelo
ss_Hm = canon(ss(Hm), 'companion');
Aym = ss_Hm.A';
Bym = ss_Hm.C'; % Forma canônica observável
Cym = ss_Hm.B';

% Filtro u
ss_uf = canon(ss(tf(1,L)), 'companion');
Auf = ss_uf.A';
Buf = ss_uf.C'; % Forma canônica observável
Cuf = ss_uf.B';

% Filtro y
ss_yf = canon(ss(tf(1,L)), 'companion');
Ayf = ss_yf.A';
Byf = ss_yf.C'; % Forma canônica observável
Cyf = ss_yf.B';

%% Plots
[T,X] = ode23s('mrac214',tfinal,init,'');

y      = X(:,1);
ym     = X(:,3);
theta =  X(:,6:end);

e =  y - ym;
r = A(1)*sin(w(1).*T) + A(2)*sin(w(2).*T);

%Set matlab interpreter to latex
set(groot, 'defaultAxesTickLabelInterpreter','latex');
set(groot, 'defaultLegendInterpreter','latex');
set(groot, 'defaultTextInterpreter','latex');

figure(1)
clf
plot(T,e);grid;shg
legend('e','Location','SouthEast')
title('$y_{m2}$')
print -depsc2 en2ym2

figure(2)
clf
plot(T,theta(:,1)-theta_1,T,theta(:,2)-theta_n,T,theta(:,3)-theta_2,T,theta(:,4)-theta_2n);grid;shg
legend('$\tilde{\theta_1}$','$\tilde{\theta_n}$','$\tilde{\theta_2}$','$\tilde{\theta_{2n}}$','Location','SouthEast')
title('$y_{m2}$')
print -depsc2 tiln2ym2


%---------------------------------------------------------------------

