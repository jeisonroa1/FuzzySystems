 %función para calcular una EBDF de M términos
% x vector de n entradas
% y vector de m centros
% med matriz con medias de las funciones de base difusas gaussianas
% dev matriz con desviaciones estándar de las funciones de base difusa gaussianas


function [f,b,rul] = efbd(x,y,med,dev)
m=length(y);
n=length(x);
z=1;
for i=1:m,
  for j=1:n,
    xp=x(1,j);
    mp=med(i,j);
    dp=dev(i,j);
    f=exp((-0.5*(xp-mp)^2)/(dp^2));
    z=z*f;
  end;
  rul(i,1)=z;
  z=1;
end;
b=sum(rul);
a=sum(rul.*y);
f=a/b;
