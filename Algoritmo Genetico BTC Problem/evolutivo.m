%%EXPERIMENTACION CON EL ALGORITMO-ALGORITMO GENETICO SIMPLE
clear all; close all;
clc
load Bitcoin.mat; %Carga historico en Precio.
precio(isnan(precio))=[];%Elimina NaN del vector
precio=(precio-min(precio))/(max(precio)-min(precio));%Normalizaci�n de datos (Scaling) para dejar datos entre  [0 1]
numexp = 50;
Errorexp = zeros(numexp,1);
MejoresFis = [];
for exp=1:numexp,
%% Algoritmo gen�tico Simple
exp
%% Caracteristicas de los individuos
n = 5; %Numero de entradas
m = 1; %Numero de salidas
r = 4; %Numero de reglas
H = 50; %Numero de experimentos para calculo de error de un individuo.
totpar=2*n*r+r; % No. total de par�metros
%% Par�metros del algoritmo gen�tico
Ngen=500; % No. de generaciones
npop=30; % Tama�o de la poblaci�n
press=0.01; % Presi�n selectiva
ipop=npop*2; % Tama�o de la poblaci�n intermedia (parejas)
pcross=0.7; % Probabilidad de cruce (Default 70%)
pmut=0.05;% Probabilidad de mutaci�n
f=0;      %No. de Individuos para elitismo  DESACTIVADO Comentarios seccino elitismo
%% Variables
MejoresInd = zeros(f,totpar);
outpop=zeros(Ngen,3);
indiv1 = zeros(ipop,totpar);
findiv1 = zeros (1,1);
Iindiv1 = zeros (1,1);
indiv2 = zeros(ipop,totpar);
findiv2 = zeros (1,1);
Iindiv2 = zeros (1,1);
Errores = zeros (Ngen,npop); 
e = zeros(H,1);

%% Inicializaci�n de individuos (Construcci�n genoma aletario)
rand('state',100*sum(clock));
poblacion = rand(npop,totpar);
fobj=zeros(npop,1);
%% Ciclo principal evoluacion    
for gen =1:Ngen,
%% Evaluaci�n de individuos
for i =1:npop,
    fis=FISg(poblacion(i,:),r,n);     % Se convierte el genotipo en fenotipo.
    fobj(i,1)=FISerror(fis,precio,n,H); % Calculo del error del fenotipo i 
end;
fobjMax = max(fobj);
fobjMin = min(fobj);
fobjAv  = mean (fobj);
Errores(gen,:) = fobj(:,1); % Se guardan los errores de todos los individuos en cada generaci�n.
outpop(gen,1:3)=[fobjMax fobjMin fobjAv];
qpop = [ fobjMax fobjMin fobjAv gen];
%% Elitismo (Editar seccion Nueva poblaci�n si se activa)
% orden = sort(fobj);
% for t=1:f,
%     MejoresInd(t,:) = poblacion(fobj==orden(t));
% end
% mejorFIS    = FISg(poblacion(find(min(fobj)),:),r,n);
%% Calificaci�n de individuos
Efficiency = (1 - press) * (fobjMax - fobj)/max([fobjMax - fobjMin, eps]) + press;
%% Selecci�n por ruleta
Wheel = cumsum(Efficiency);
  for j=1:ipop   %Forma 60 parejas
    %Selecci�n del primer individuo de la pareja
    Shoot = rand(1,1)*max(Wheel);
    Index = 1;
    while((Wheel(Index)<Shoot)&&(Index<length(Wheel))) 
      Index = Index + 1;
    end
    indiv1(j,:) = poblacion(Index,:);
    findiv1(j) = fobj(Index);
    Iindiv1(j) = Index;
    % Selecci�n del segundo individuo de la pareja
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
  
   %Mutaci�n
  
  for j=1:ipop
    if (pmut>rand(1,1)),
      pind= ceil((totpar-1)*rand(1,1) + 1);
      vind=rand(1,1);
      indiv1(j,pind)=vind;
    end
    if (pmut>rand(1,1)),
       pind= ceil((totpar-1)*rand(1,1) + 1);
      vind = rand(1,1);
      indiv2(j,pind)=vind;
    end
  end 
%% Nueva poblaci�n 
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
mejorFIS    = FISg(poblacion(find(min(fobj)),:),r,n); %Busca el menor error y construye esa solucion

%%Save Stage
%save('4reglas100exp.mat','mejorFIS','Errores','outpop','poblacion');%Se guardan finalmente todos los resultados de los experimentos
Errorexp(exp,1) = FISerror(mejorFIS,precio,n,H);
%MejoresFis(exp)= [MejoresFis mejorFIS];

end %Final ciclo experimentaci�n
%%Save Stage (Experimentaci�n)
save('50Exp4Reglasp.mat','MejoresFIS','Errorexp','Errores','outpop','poblacion');%Se guardan finalmente todos los resultados de los experimentos


% %% Graficos de resultados 
% 
% figure; %Grafico Error maximo , Error promedio, Error minimo para cada generaci�n
% plot(outpop);
% grid on;
% set (gca,'fontsize',12);
% title('Errores para cada generaci�n');
% legend('Error Maximo','Error Minimo','Error Promedio');
% ylabel('Estad�stico de evaluaci�n');
% xlabel('Generaci�n #');
% print('figura110Reglas.png','-dpng','-r300');
% 
% figure; %Histograma de evoluci�n. val Errores
% hist(Errores(2,:),9); %Generaci�n 2 Histograma del error de todos los individuos
% hold on
% hist (Errores(Ngen,:),9); %Generaci�n Ngen Histograma del error de todos los individuos
% hold on
% %hist (Errores(round(Ngen/2),:)); %Generaci�n Ngen/2 Histograma del error de todos los individuos
% grid on;
% set (gca,'fontsize',12);
% title('Histograma de evoluci�n.');
% legend('Generaci�n 2','Generaci�n Final');
% ylabel('Repeticiones');
% xlabel('Estad�stico de evaluaci�n');
% print('figura210Reglas.png','-dpng','-r300');

figure; %Histograma de experimentos (errores de los mejores de cada exp)
hist(Errorexp); %Generaci�n 2 Histograma del error de todos los individuos
grid on;
set (gca,'fontsize',12);
title('Histograma de experimentos');
ylabel('Repeticiones');
xlabel('Estad�stico de evaluaci�n');
print('Errorexp4Reglas.png','-dpng','-r300');
%FIN Escrito: Jeison Ivan Roa Mora