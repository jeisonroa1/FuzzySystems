%%Implementación de un algoritmo genético simple para el diseño de un sistema difuso
%% Para la predicción del precio del Bitcoin

%% Jeison Ivan Roa Mora 2017
clear all; close all;
clc
load Bitcoin.mat; %Carga historico en Precio.
precio(isnan(precio))=[];%Elimina NaN del vector
precio=(precio-min(precio))/(max(precio)-min(precio));%Normalización de datos (Scaling) para dejar datos entre  [0 1]
numexp = 50;
Errorexp = zeros(numexp,1);
MejoresFis = [];
for exp=1:numexp,
%% Algoritmo genético Simple
exp
%% Caracteristicas de los individuos
n = 5; %Numero de entradas
m = 1; %Numero de salidas
r = 4; %Numero de reglas
H = 50; %Numero de experimentos para calculo de error de un individuo.
totpar=2*n*r+r; % No. total de parámetros
%% Parámetros del algoritmo genético
Ngen=500; % No. de generaciones
npop=30; % Tamaño de la población
press=0.01; % Presión selectiva
ipop=npop*2; % Tamaño de la población intermedia (parejas)
pcross=0.7; % Probabilidad de cruce (Default 70%)
pmut=0.05;% Probabilidad de mutación
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

%% Inicialización de individuos (Construcción genoma aletario)
rand('state',100*sum(clock));
poblacion = rand(npop,totpar);
fobj=zeros(npop,1);
%% Ciclo principal evoluacion    
for gen =1:Ngen,
%% Evaluación de individuos
for i =1:npop,
    fis=FISg(poblacion(i,:),r,n);     % Se convierte el genotipo en fenotipo.
    fobj(i,1)=FISerror(fis,precio,n,H); % Calculo del error del fenotipo i 
end;
fobjMax = max(fobj);
fobjMin = min(fobj);
fobjAv  = mean (fobj);
Errores(gen,:) = fobj(:,1); % Se guardan los errores de todos los individuos en cada generación.
outpop(gen,1:3)=[fobjMax fobjMin fobjAv];
qpop = [ fobjMax fobjMin fobjAv gen];
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

 %% Cruce
 
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
      vind=rand(1,1);
      indiv1(j,pind)=vind;
    end
    if (pmut>rand(1,1)),
       pind= ceil((totpar-1)*rand(1,1) + 1);
      vind = rand(1,1);
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
mejorFIS    = FISg(poblacion(find(min(fobj)),:),r,n); %Busca el menor error y construye esa solucion

%% Save Stage
%save('4reglas100exp.mat','mejorFIS','Errores','outpop','poblacion');%Se guardan finalmente todos los resultados de los experimentos
Errorexp(exp,1) = FISerror(mejorFIS,precio,n,H);
%MejoresFis(exp)= [MejoresFis mejorFIS];

end % Final ciclo experimentación
%% Save Stage (Experimentación)
save('50Exp4Reglasp.mat','MejoresFIS','Errorexp','Errores','outpop','poblacion');%Se guardan finalmente todos los resultados de los experimentos


%% Graficos de resultados 
% 
% figure; %Grafico Error maximo , Error promedio, Error minimo para cada generación
% plot(outpop);
% grid on;
% set (gca,'fontsize',12);
% title('Errores para cada generación');
% legend('Error Maximo','Error Minimo','Error Promedio');
% ylabel('Estadístico de evaluación');
% xlabel('Generación #');
% print('figura110Reglas.png','-dpng','-r300');
% 
% figure; %Histograma de evolución. val Errores
% hist(Errores(2,:),9); %Generación 2 Histograma del error de todos los individuos
% hold on
% hist (Errores(Ngen,:),9); %Generación Ngen Histograma del error de todos los individuos
% hold on
% %hist (Errores(round(Ngen/2),:)); %Generación Ngen/2 Histograma del error de todos los individuos
% grid on;
% set (gca,'fontsize',12);
% title('Histograma de evolución.');
% legend('Generación 2','Generación Final');
% ylabel('Repeticiones');
% xlabel('Estadístico de evaluación');
% print('figura210Reglas.png','-dpng','-r300');

figure; %Histograma de experimentos (errores de los mejores de cada exp)
hist(Errorexp); %Generación 2 Histograma del error de todos los individuos
grid on;
set (gca,'fontsize',12);
title('Histograma de experimentos');
ylabel('Repeticiones');
xlabel('Estadístico de evaluación');
print('Errorexp4Reglas.png','-dpng','-r300');
%FIN Escrito: Jeison Ivan Roa Mora
