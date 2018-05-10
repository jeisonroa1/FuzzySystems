%% Predictor precio Bitcoin utilizando un sistema difuso basado en la experiencia.
%% Jeison Ivan Roa Mora
clc;
clear all;
close all;

load Bitcoin.mat; %Carga historico en Precio.
load fis.mat;
precio(isnan(precio))=[];%Elimina NaN del vector

precioN=(precio(1:100)-min(precio(1:100)))/(max(precio(1:100))-min(precio(1:100)));%Normalización de datos (Scaling) 
meanp=mean(precioN);
precioNM=precioN-meanp;
salidas=zeros(95,1);
preciox=zeros(95,5);
for p=1:95
preciox(p,:)=precioNM(p:p+4);
end
salidas=evalfis(preciox,BITCOINV2);
%% Validación

for i=1:length(salidas);
e1(i)=(precioNM(i+5)-salidas(i)).^2; %RMSE
e2(i)=abs((precioNM(i+5)-salidas(i))/(salidas(i)));
e3(i)=(precioNM(i+5)-salidas(i)).^2;
end;

for i=1:length(salidas)-1;
e4(i)=(salidas(i+1)-salidas(i)).^2;
end
figure;
plot(precioNM(6:100));
hold on;
plot(salidas);
legend('Precio Real','Precio Predicho');
ylabel('PrecioNormalizado');
xlabel('Tiempo[h]');
title('Prueba');
%e2(isinf(e2))=[];

MSE=(1/100)*sum(e1);
MAPE=(100/95)*(sum(e2));
NMSE=sum(e3)/sum(e4);
