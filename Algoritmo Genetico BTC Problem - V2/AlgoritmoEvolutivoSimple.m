%%EXPERIMENTACION CON EL ALGORITMO GENETICO SIMPLE PARA LA PREDICCIÓN DEL
%%PRECIO DEL BITCOIN

%% Jeison Ivan Roa Mora 2017
clear all; close all;
clc
load Bitcoin.mat; %Carga historico en Precio.
precio(isnan(precio))=[];%Elimina NaN del vector
precioN=(precio(1:320)-min(precio(1:320)))/(max(precio(1:320))-min(precio(1:320)));%Normalización de datos (Scaling) para dejar datos entre  [0 1]
meanp=mean(precioN);
precioNM=precioN-meanp;

mejorFIS=[];
mejorChk=[];
mejorChk=1000000000000;
for q=1:150
    traindata(q,:)=precioNM(q:q+5);
end
for q=1:60
    valdata(q,:)=precioNM(q+240:q+245);
end

numexp = 1;
for exp=1:numexp,
%% Algoritmo genético Simple
exp
%% Caracteristicas de los individuos
n = 5; %Numero de entradas
m = 1; %Numero de salidas
r = 10; %Numero de reglas
H = 100; %Numero de datos de validación.
totpar=(2*n*r)+(2*r); % No. total de parámetros
%% Parámetros del algoritmo genético
Ngen=2000; % No. de generaciones
npop=30; % Tamaño de la población
press=0.01; % Presión selectiva
ipop=npop*2; % Tamaño de la población intermedia (parejas)
pcross=0.7; % Probabilidad de cruce (Default 70%)
pmut=0.05;% Probabilidad de mutación
f=0;      %No. de Individuos para elitismo  DESACTIVADO Comentarios seccino elitismo
%% Variables
poblacion =zeros(npop,totpar);
outpop=zeros(Ngen,3);
%% Inicialización de individuos (Construcción genoma aletario)
rand('state',100*sum(clock));
for c=1:npop
    for f=1:totpar
    poblacion(c,f) = unifrnd(-1,1);
    end
end
fobj=zeros(npop,1);
%% Ciclo principal evoluacion    
for gen =1:Ngen,
%% Evaluación de individuos
for i =1:npop,
    fis=FISg(poblacion(i,:),r,n);     % Se convierte el genotipo en fenotipo.
    fobj(i,1)=FISerror(fis,precioNM,n,H); % Calculo del error del fenotipo i 
end;
fobjMax = max(fobj);
fobjMin = min(fobj);
fobjAv  = mean (fobj);

qpop = [fobjMax fobjMin fobjAv gen]
%% Elitismo (Editar seccion Nueva población si se activa)
% orden = sort(fobj);
% for t=1:f,
%     MejoresInd(t,:) = poblacion(fobj==orden(t));
% end
% mejorFIS    = FISg(poblacion(find(min(fobj)),:),r,n);
%% Calificación de individuos
Efficiency = (1 - press) * (fobjMax - fobj)/max([fobjMax - fobjMin, eps]) + press;
%% Selección por ruleta
Wheel = cumsum(Efficiency);
  for j=1:ipop   %Forma 60 parejas
    %Selección del primer individuo de la pareja
    Shoot = rand(1,1)*max(Wheel);
    Index = 1;
    while((Wheel(Index)<Shoot)&&(Index<length(Wheel))) 
      Index = Index + 1;
    end
    indiv1(j,:) = poblacion(Index,:);
    findiv1(j) = fobj(Index);
    Iindiv1(j) = Index;
    % Selección del segundo individuo de la pareja
    Shoot = rand(1,1)*max(Wheel);
    Index = 1;
    while((Wheel(Index)<Shoot)&&(Index<length(Wheel))) 
      Index = Index + 1;
    end
    indiv2(j,:)= poblacion(Index,:);
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
  
%% Mutación
  
  for j=1:ipop
    if (pmut>rand(1,1)),
      pind= ceil((totpar-1)*rand(1,1) + 1);
      vind=unifrnd(-1,1);
      indiv1(j,pind)=vind;
    end
    if (pmut>rand(1,1)),
       pind= ceil((totpar-1)*rand(1,1) + 1);
      vind = unifrnd(-1,1);
      indiv2(j,pind)=vind;
    end
  end 
%% Nueva población 
%  for j=1:f, %Elitismo
%      poblacion(j,:)=MejoresInd(j,:); %Se agregan primeros f individuos por elitismo
%  end;
 poblacion(1,:)=poblacion(find(min(fobj)),:); %Se agrega el mejor individuo
 for j=2:npop, %desde f+1 Para activar elitismo
   indexsel = ceil((ipop-1)*rand(1,1) + 1);
   if rand(1,1) > 0.5,
     poblacion(j,:)=indiv1(indexsel,:);
   else
     poblacion(j,:)=indiv2(indexsel,:);
   end;
 end;
 Wheel = 0;


end

%% Mejor Solucion
if  min(fobj)<mejorChk 
mejorFIS    = FISg(poblacion(find(min(fobj)),:),r,n); %Busca el menor error y construye esa solucion
mejorChk    = min(fobj);
mejorChk
end
end %Final ciclo experimentación

%% Save Stage (Experimentación)
save('datafinal.mat','mejorFIS','mejorChk');%Se guardan finalmente todos los resultados de los experimentos

