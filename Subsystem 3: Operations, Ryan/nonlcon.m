function [c,ceq] = nonlcon(x)
    c = (((6000/(-1.804e-10.*x(2).^2+3.643e-05.*x(2)+12.19))/24)/((100-x(1))/100))-30; %Maximum number of days allowable for a trip scales with the distance travelled and ship capacity
    c = x(4)-(-1.203e-6.*x(2).^2+0.3762.*x(2)+627.5) ; %(Maximum travel distance allowable scales with ship capacity
    ceq = x(3) - 800; %set fuel cost to 800, knowing that the real fuel cost is $372.50/tonne in New York as of 12/Dec/2019
    %ceq = x(4) - 6000;
end



