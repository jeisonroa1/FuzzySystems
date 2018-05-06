
%Algoritmo gen�tico simple 
%Codificaci�n real
%Selecci�n estoc�stica por ruleta
%Problema: Aproximaci�n de la funci�n SINC con una EFBD

clc;
clear;

rand('state',sum(100*clock))
 
% Par�metros de la EFBD
rules=16; % No de reglas
inpt=1; %No de entradas 
totpar=2*inpt*rules+rules; % No. total de par�metros
scale=15; % escala  de los parametros (+/-) scale/2


% Par�metros del algoritmo gen�tico
Ngen=1000; % No. de generaciones
npop=30; % Tama�o de la poblaci�n
press=0.01; % Presi�n selectiva
ipop=60; % Tama�o de la poblaci�n intermedia (parejas)
pcross=0.7; % Probabilidad de cruce
pmut=0.03;% Probabilidad de mutaci�n

% inicializaci�n
pop=2*scale*(rand(npop,totpar)-0.5);

% Ciclo evolutivo
for gen =1:Ngen,
 
%evaluaci�n de individuos
for i =1:npop,
    w=pop(i,:);
    err=rmsemg(w,rules,inpt,scale); % Calculo de la aproximaci�n funci�n SINC
    fobj(i,1)=err;
  end;
  
fobjMax = max(fobj);
fobjMin = min(fobj);
fobjAv  = mean (fobj);

outpop(gen,1:3)=[ fobjMax fobjMin fobjAv];
qpop = [  fobjMax fobjMin fobjAv gen]

%calificaci�n de individuos
Efficiency = (1 - press) * (fobjMax - fobj)/max([fobjMax - fobjMin, eps]) + press;

%Selecci�n por ruleta
Wheel = cumsum(Efficiency);
  for j=1:ipop
    %Selecci�n del primer individuo de la pareja
    Shoot = rand(1,1)*max(Wheel);
    Index = 1;
    while((Wheel(Index)<Shoot)&(Index<length(Wheel))) 
      Index = Index + 1;
    end
    indiv1(j,:) = pop(Index,:);
    findiv1(j) = fobj(Index);
    Iindiv1(j) = Index;
    % Selecci�n del segundo individuo de la pareja
    Shoot = rand(1,1)*max(Wheel);
    Index = 1;
    while((Wheel(Index)<Shoot)&(Index<length(Wheel))) 
      Index = Index + 1;
    end
    indiv2(j,:)= pop(Index,:);
    findiv2(j)= fobj(Index);
    Iindiv2(j)= Index;
  end
 
 % Cruce
 
  for j=1:ipop
    if (pcross>rand(1,1)),
      pind = ceil((totpar-1)*rand(1,1) + 1);
      x1 = [indiv1(j,1:pind)  indiv2(j,pind+1:totpar)];
      x2 = [indiv2(j,1:pind)  indiv1(j,pind+1:totpar)];
      indiv1(j,:) = x1;
      indiv2(j,:) = x2;
     end;
  end;
  
  %Mutaci�n
  
  for j=1:ipop
    if (pmut>rand(1,1)),
      pind= ceil((totpar-1)*rand(1,1) + 1);
      vind=2*(rand(1,1)-0.5)*scale;
      indiv1(j,pind)=vind;
      end
    if (pmut>rand(1,1)),
       pind= ceil((totpar-1)*rand(1,1) + 1);
      vind=2*(rand(1,1)-0.5)*scale;
      indiv2(j,pind)=vind;
    end
  end 
 
 poplast=pop;
 
 %  Nueva poblaci�n 
 for j=1:npop,
   indexsel = ceil((ipop-1)*rand(1,1) + 1);
   if rand(1,1) > 0.5,
     pop(j,:)=indiv1(indexsel,:);
   else
     pop(j,:)=indiv2(indexsel,:);
   end;
 end;
 
 Wheel = 0;
 
end;

%Obtenci�n del mejor individuo de la poblaci�n final
for i =1:npop,
    w=poplast(i,:);
    err=rmsemg(w,rules,inpt,scale);
    fobj(i,1)=err;
end; 

[sobj k]=sort(fobj);

indx=k(1,1);
m=rules;
n=inpt;
par=poplast(indx,:);
md=par(1,1:m*n);
dv=par(1,m*n+1:2*m*n);
ys=par(1,2*m*n+1:2*m*n+m)';

for i= 1:m,
med(i,:)=md(1,i*n-n+1:i*n);
dev(i,:)=dv(1,i*n-n+1:i*n);
end;

v1=-10:0.05:10;
fy=scale*sinc(v1/pi);
for i=1:length(fy),
v=v1(1,i);
fev(1,i)=efbd(v,ys,med,dev);
end;

plot(v1,fy,'b');
hold
plot(v1,fev,'r');

figure
plot(outpop);
