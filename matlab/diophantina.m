function [theta_1, theta_n, theta_2n, theta_2] = diophantina(y,ym,A0)
s = tf('s');

    function [n, n_star, num, den] = tfprop(y)
        [num,den] = tfdata(y,'v');
        num = num(find(num,1):end);
        den = den(find(den,1):end);
        n = length(den) - 1; % calculating n
        n_star = n - (length(num) - 1); % calculating n_star
    end 

    function A = myconv(n,m)
        A = conv(n,m);
        A = A(find(A,1):end);
    end


[n, n_star, numy, deny] = tfprop(y);
kp = numy(1); % Calculating kp
numy = numy/kp;

[m, ~, ~,~] = tfprop(ym);

if n>m
    ym = ym*((s+1)^(n-m))/((s+1)^(n-m));
end
[~, ~, numym, denym] = tfprop(ym);
km = numym(1); % Calculating km
numym = numym/km;

[A0,~] = tfdata(A0,'v');

L = myconv(numym,A0); % Creating Lambda

DmA0 = myconv(denym, A0);

degH = n_star-1; 
degG = n-1;

A = convmtx(deny',degH+1);
S = zeros(n_star + n, degG+1);
S(n_star+1:end,1:end) = -kp*eye(degG+1);
B = [A S];
HG = B\DmA0';
H = HG(1:degH+1);
G = HG(degH+2:end);

theta_n = G(1);
theta_2 = G' - L*theta_n;
theta_2 = (theta_2(2:end))/kp;

F = L - myconv(numy,H');
theta_1 = F(2:end);
theta_2n = km/kp;
end

