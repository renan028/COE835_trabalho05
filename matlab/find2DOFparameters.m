function [theta_1, theta_n, theta_2, theta_2n, L] = find2DOFparameters(P,Pm,A0)
s = tf('s');

    %Extract transfer function properties
    function [n, n_star, num, den] = tfprop(y)
        [num,den] = tfdata(y,'v');
        num = num(find(num,1):end);
        den = den(find(den,1):end);
        n = length(den) - 1;
        n_star = n - (length(num) - 1);
    end 

    %Customized convolution (removes first zero entries)
    function A = myconv(n,m)
        A = conv(n,m);
        A = A(find(A,1):end);
    end

%Get plant TF properties
[n, n_star, numy, deny] = tfprop(P);
kp = numy(1);
numy = numy/kp;

%Get model TF properties and add equal poles and zeros to model TF if n > m
[m, ~, ~,~] = tfprop(Pm);
if n>m
    Pm = Pm*((s+1)^(n-m))/((s+1)^(n-m));
end
[~, ~, numym, denym] = tfprop(Pm);
km = numym(1);
numym = numym/km;

%Get A0 polynomial
[A0,~] = tfdata(A0,'v');

%Finding Lambda and Dm*A0
L = myconv(numym,A0);
DmA0 = myconv(denym, A0);

%Solve Diophantina Equation to find G and H
degH = n_star-1; 
degG = n-1;
A = convmtx(deny',degH+1);
S = zeros(n_star + n, degG+1);
S(n_star+1:end,1:end) = -kp*eye(degG+1);
B = [A S];
HG = B\DmA0';
H = HG(1:degH+1);
G = HG(degH+2:end);

%Find F polynomial
F = L - myconv(numy,H');

%Find thetas
theta_1 = F(2:end);
theta_n = G(1);
theta_2 = G(2:end)' - theta_n*L(2:end);
theta_2n = km/kp;

end