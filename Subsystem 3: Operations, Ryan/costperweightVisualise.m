clear;


syms SR SW;
totalCostGraph = ((((((6000/(-1.804e-10.*SW.^2+3.643e-05.*SW+12.19)))/24)/((100-SR)/100))*(SW*14700/15000)+ ...
    (((((6000/(-1.804e-10.*SW.^2+3.643e-05.*SW+12.19)))/24)/((100-SR)/100))* ...
    800* ...
    (SW*2.2/15000+SW*20/15000*...
    (100-(0.09158*(SR/10)^3-2.907*(SR/10)^2+29.92*(SR/10)+0.02321))/100))))/(SW*6000);

%plots the graph for a fixed fuel cost of $800/tonne and distance of 6000nm

fsurf(totalCostGraph, [0 50 15000 150000])
title('Minimise Cost Objective Function')
xlabel('Speed Reduction')
ylabel('Ship Capacity')
zlabel('Cost per tonne per distance')


