clear;

%x = [15000, 65000, 150000];
x = linspace(15000,150000,10);
%y = [0,27,49,66,100];

p1 =  -1.804e-10;
p2 =   3.643e-05;
p3 =       12.19;


y = p1.*x.^2 + p2.*x + p3;

plot(y)
