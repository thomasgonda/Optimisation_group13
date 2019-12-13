%13th December 2019
%Laerke Mop Rasmussen
%Imperial College London, Dyson School of Design Engineering
%Optimisation coursework - Group 13
%Subsystem 2: Hull Design

close all                   %Closing All Open Figures
clc                         %Clear the command window


%% Definitions
vi = 0.0000010804;          %kinematic viscosity of water at 15 degrees C 
d = 3632;                   %distance in nautical miles
p = 997;                    %density of water 
a = 2.44*6.1;               %Measurements taken from a standar TEU (20-feet equivalent unit)
cj =  1.7855*10^-8 ;        %fuel cost in $/Joule
cc = 6700/24;               %operational costs in $/hour
e = 1508;                   %earning in $/container
lw_L = 150;                 %Lower bounds for the water-line length of the boat 
lw_U = 200;                 % Upper Bound for the water-line length of the boat
v_L = 10;                   % Lower bound for the velocity of the boat
v_U = 25;                   % Upper bound for the velocity of the boat 
be_L = 10;                  % Lower bound for the beam (width) of the boat
be_U = 63;                  % Upper bound for the beam (width) of the boat
cb_L = 0.75;                % Lower bound for the block coefficient
cb_U = 0.84;                % Upper bound for the block coefficient
teu_L = 1;                  % Lower bound for the number of rows of stacked containers
teu_U =21;                  % Upper bound for the number of rows of stacked containers
f = 0.75 ;                  % Estimate of how occupied the deck is - 75%

%% Problem Exploration 
T= csvread('Optimisation_TEU_Draft.csv');           %Load Data from Excel Sheet
teu = T(:,1);                                       %Container capacity (TEU) in column 1
draft = T(:,2);                                     %Draft in column 2 
figure('Name','Draft against Capacity');            %Naming the figure
scatter(teu,draft)                                  %Plot the points for Draft against TEU 
xlabel('Capacity /TEU')                             %Labelling the x-axis
ylabel('Draft / m ')                                %Labelling the y-axis 
title('Draft against Container Capacity')           %Giving the graph a title 
grid on                                         

dlog = log(teu);                                    %Calculating the ln of the container capacity 
figure('Name','Draft against log(Capacity)');   
scatter(dlog,draft);                            
xlabel('log(Capacity)')                         
ylabel('Draft / m ') 
title('Draft against Container Capacity)')
grid on
col1 = ones(size(dlog));                            %Creating a matrix the sixe of dlog filled with 1's 
x = [col1 dlog];                                    %Formulating the least square problem

fprintf('<strong>Problem Exploration:</strong>\n'); 
b1 = x\draft                                        %Finding the linear coefficients in a least square sense 
hold on
yCalc1= x*b1;
plot(dlog,yCalc1)                                   %Plotting the equation obtained from least square method 
Rsq = 1 - sum((draft - yCalc1).^2)/sum((draft - mean(draft)).^2) % Finding the Root mean square error to measure the goodness of fit
legend('Data','Slope','Location','best');


%% Objective Function Formulation
fun = @(x)((0.075/(log(x(1)*x(2)/vi)-2)^2)+(0.28/1000*...
((x(1)*x(3)*x(5)*f/a)^(-1.26))))*p*x(2)^(2)*0.99*((x(4)...
*x(3)*x(1)/1.02)+1.9*x(1)*(-10.7896+2.8024*log(x(1)*x(3)...
*x(5)*f/a)))*0.5*d*cj*cc*d/x(2)-(x(1)*x(3)*x(5)*f/a)*e;

lb = [lw_L,v_L,be_L, cb_L,teu_L];               % Lower Bounds
ub = [lw_U, v_U, be_U,cb_U,teu_U];              % Upper Bounds
nonlcon = @draft_function;                      % Non-linear constraints (Function is found at the bottom of the script) 
A = [];
b = [];
Aeq = [];
beq = [] ;
x0 = [155, 20, 20, 0.76, 0.80];                 % Starting Points



%% fmincon 
fprintf('<strong>fmincon sqp:</strong>\n');
options = optimoptions('fmincon','Algorithm','sqp');    
x = fmincon(fun,x0,A,b,Aeq,beq,lb,ub,nonlcon,options)            %Performing fmincon using sqp algorithm

fprintf('<strong>fmincon interior-point:</strong>\n');
options = optimoptions('fmincon','Algorithm','interior-point');
x = fmincon(fun,x0,A,b,Aeq,beq,lb,ub,nonlcon,options)            %Performing fmincon using interior-point algorithm

fprintf('<strong>fmincon active-set:</strong>\n');
options = optimoptions('fmincon','Algorithm','active-set');
x = fmincon(fun,x0,A,b,Aeq,beq,lb,ub,nonlcon,options)            %Performing fmincon using active-set algorithm


%% Global Search
rng default;
gs = GlobalSearch;
fun1 = @(x)((0.075/(log(x(1)*x(2)/vi)-2)^2)+(0.28/1000*...
((x(1)*x(3)*x(5)*f/a)^(-1.26))))*p*x(2)^(2)*0.99*((x(4)...
*x(3)*x(1)/1.02)+1.9*x(1)*(-10.7896+2.8024*log(x(1)*x(3)...
*x(5)*f/a)))*0.5*d*cj*cc*d/x(2)-(x(1)*x(3)*x(5)*f/a)*e;

problem = createOptimProblem('fmincon','x0',[155, 20, 20,...
 0.76, 0.80],'objective',fun1,'lb',[lw_L,v_L,be_L, cb_L,teu_L],...
'ub',[lw_U, v_U, be_U,cb_U,teu_U],'nonlcon', [@draft_function]);

fprintf('<strong>Global Search Results:</strong>\n');
x = run(gs,problem)                                              %Running Global Search


%% Displaying the Optimisation Results 

pl = 1.02*(x(1));                               %Perpendicular Length
T = -10.7896+2.8024*log(x(1)*x(3)*x(5)*f/a);    %Draft
ratio = (x(3)/T);                               %Ratio of Width to Draft
teu = x(1)*x(3)*x(5)*f/a;                       %Number of containers
earnings = teu*1508;                            %Total Earnings for container transport 

fprintf('<strong>Optimisation Results:</strong>\n');
fprintf('Total Cost:                   %.3f $\n\n',fun(x))
fprintf('Earnings                       %.3f $\n',earnings)
fprintf('Velocity:                      %.1f Knots\n',x(2))
fprintf('Waterline length:              %.2f m\n',x(1))
fprintf('Perpendicular lenght:          %.2f m\n',pl)
fprintf('Draft:                         %.2f m\n',T)
fprintf('Breadth                        %.3f m\n',x(3))
fprintf('Breadth/Draft Ratio            %.1f\n',ratio)
fprintf('Block Coefficient              %.2f \n',x(4))
fprintf('Layers of containers           %.0f \n',x(5))
fprintf('Number of Containers           %.0f \n\n',teu)


%% Draft Function
function [c,ceq] = draft_function(x)
f=0.75;
c(1) = -10.7896+2.8024*log(x(1)*x(3)*x(5)*f/14.8840)-7.92;          %Constraint 12
c(2) = 0.09-(0.28/1000*(f*x(5)*x(1)*x(3)/14.8840))^(-0.126);        %Constraint 11
ceq = x(3)-(2.5*(-10.7896+2.8024*log(x(1)*x(3)*x(5)*f/14.8840))) ;  %Constraint 13
end

