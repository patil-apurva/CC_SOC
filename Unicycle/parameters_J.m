close all
%outer rectangle
xP = -0.5;
yP = -0.5;
A = 0.6; 
B = 0.6;

%obstacles
xR1 = -0.3;
yR1 = -0.4;
xS1 = -0.2;
yS1 = -0.25;
xR2 = -0.3;
yR2 = -0.15;
xS2 = -0.1;
yS2 = 0;
% xR2 = xR1;
% yR2 = yR1;
% xS2 = xS1;
% yS2 = yS1;

n = 3; %state space dimension
m = 2; %control input dimension

c = 1; %associated with g
s2 = 0.01; %s2=s^2. s is associated with sigma

a = 1; %R=a.I
b = 1; %V=b.(x_1^2 + x_2^2)
d = 1; %psi=d.(x_1^2 + x_2^2)
e = 2;

eta = 0.7216 %lagrange multiplier
runs = 10000 %MC runs

h = 0.01;
t0 = 0.0; %initial time
T = 10; % final time

Nx = 121; %grid points along x for plotting J0 and u0 
Ny = 121; %grid points along y for plotting J0 and u0

Speed = 0;
Theta = 0;

%==========================================================================
k1 = -e/T;
k2 = k1;
k3 = k1;

lambda = a*s2/(c^2); %PDE linearization constant
s = sqrt(s2); %s is associated with sigma

G_u = [0 0; 0 0; 1 0; 0 1];
Sigma = s*[0 0; 0 0; 1 0; 0 1];

xQ = xP+A;
yQ = yP+B;

clear xi zeta eta_FB nu