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
w1 = .63493;
w2 = 4.5669;
w3 = 5;
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
Pm = [1 1];
km = 1;

H = tf(kp*Z,P);
Hm = tf(km*Zm,Pm);
A0 = tf([1]);

%% Init
[theta_1, theta_n, theta_2, theta_2n, L] = find2DOFparameters(H,Hm,A0); 

gamma = 10*eye(6);

y0  = [5 0 0]';
ym0 = 0;
uf0 = [0 0]';
yf0 = [0 0]';
theta0 = zeros(6,1);

clf;
tfinal = 200;

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
[T,X] = ode23s('mrac316',tfinal,init,'');

y      = X(:,1);
ym     = X(:,4);
theta =  X(:,9:end);

e =  y - ym;
r = A(1)*sin(w(1).*T) + A(2)*sin(w(2).*T) + A(3)*sin(w(3).*T);
figure(1)
clf
plot(T,ym,T,y);grid;shg
legend('y_m','y','Location','SouthEast')
print -depsc2 fig01a

figure(2)
clf
plot(T,e);grid;shg
legend('e','Location','SouthEast')
print -depsc2 fig01b

%---------------------------------------------------------------------

