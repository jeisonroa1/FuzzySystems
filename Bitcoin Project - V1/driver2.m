clear all; close all; clc;
%% Inicialización
a=[5 10 15 20 25];      %Numeros de reglas
alfa = 0.01;      %Tasa de aprendizaje
c = 500   ;        %Numero de datos de entrenamiento
v = 50  ;          %Numero de datos de validación
epochs = 600;       %Numero de epocas.
%% Inicialización variables
traindata = zeros(150,6);
valdata = zeros(60,6);
mejorfis =[];
%% Segmentación de datos
load('Bitcoin.mat');     %Carga base de datos
precio(isnan(precio))=[];%Elimina NaN del vector
%precioN=(precio(1:320)-min(precio(1:320)))/(max(precio(1:320))-min(precio(1:320)));%Normalización de datos (Scaling) para dejar datos entre  [0 1]
precioN=precio/6000
meanp=mean(precioN);
precioNM=precioN-meanp;

for q=1:c
    traindata(q,:)=precioNM(q:q+5);
end
for q=1:v
    valdata(q,:)=precioNM(q+c:q+c+5);
end

mejorCHK=100; 
%% Ciclo de Reglas
for(i=1:length(a))
            i
            %% Implementacion ANFIS
            dispOpt=[0 0 0 0];         %OPCIONES DE FUNCION ANFIS
            trnOpt=[epochs 0 alfa 0.9 1.1];%OPCIONES DE FUNCION ANFIS
            optMethod=1;                % 1= Usa metodo hibrido.
                  
            for (l=1:15), %Experimentos
                rng('shuffle'); % Cambia semilla
                myfis=FISrnd(a(i),5); %FIS Aleatoria
                [fis,error,stepsize,chkFis,chkErr] =  anfis(traindata,myfis,trnOpt,dispOpt,valdata,optMethod); 
                if chkErr<mejorCHK 
                mejorCHK=chkErr;
                mejorfis=fis;
                end 
            end
            
end
 
%% Save Stage
save('Datafinal.mat','mejorfis','mejorCHK');



