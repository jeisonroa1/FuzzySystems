
% Cálculo de 2000 muestras de la serie Mackey-Glass

function [x]=mackey(l)
x=zeros(1,l);
x(1,1:30)=0.23*ones(1,30);
t=30;

for i=31:l-1,
  a=x(1,i);
  b=x(1,i-t);
  y=((0.2*b)/(1+b.^10))+0.9*a;
  x(1,i+1)=y;
end;