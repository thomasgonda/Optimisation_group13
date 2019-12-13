clear;

totalCost = @(x) (((((x(4)/...
    (-1.804e-10.*x(2).^2+3.643e-05.*x(2)+12.19))/24)...
    /((100-x(1))/100))*(x(2)*14700/15000)+ ...
    ((((x(4)/(-1.804e-10.*x(2).^2+3.643e-05.*x(2)+12.19))/24)...
    /((100-x(1))/100))* ...
    x(3)* ...   
    (x(2)*2.2/15000+x(2)*20/15000*...
    (100-(0.09158*(x(1)/10)^3-2.907*(x(1)/10)^2+29.92*(x(1)/10)...
    +0.02321))/100))))/(x(2)*x(4));

% x(1) is speed reduction, x(2) is ship weight, x(3) is fuel cost, x(4) is
% travel distance
x0 = [10,20000,800,10000];
A = [];
b = [];
Aeq = [];
beq = [];


lb = [0,15000,0,6000];
ub = [50,150000,1000,20000];

nonlcon = @nonlcon;

%options = optimoptions('fmincon','Display','iter','Algorithm','sqp')
options = optimoptions(@fmincon,'Algorithm','sqp','StepTolerance',1e-12);

[xmin, fval] = fmincon(totalCost,x0,A,b,Aeq,beq,lb,ub,nonlcon,options)

[xmin, fval] = ga(totalCost,4,A,b,Aeq,beq,lb,ub,nonlcon)







