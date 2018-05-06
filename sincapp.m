clear
clc

x=-10:20/1000:10;
w=sinc(0.3*x);

plot(x,w,'r');

med=[-10 -7.5 -4.5 0 4.5 7.5 10]';
dev=[1.0 1.0 1.0 1.0 1.0 1.0 1.0]';
y=[0.0 0.15 -0.2 1.0 -0.2 0.15 0.0]';

for i=1:length(x),
    xi=x(1,i);
    z(1,i)=efbd(xi,y,med,dev);
end;

hold;

plot(x,z,'b');

