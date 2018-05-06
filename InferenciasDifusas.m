%Jeison Roa - 2017
%% Inferencias difusas
clc
clear all
close all
PRE = (0:1/10:10); %Universos
PRO = [0: 1/100:1]';
A = trimf (PRE, [4 5 6]); %Conjuntos en los universos
B = trimf (PRO, [0.7 0.8 0.9]);
figure;
plot (PRO, B, 'b');
hold on
plot (PRE, A, 'y');
N = length(PRE);
M = length(PRO);
u = repmat(A,M,1); %Expande a R3
v = repmat(B,1,N); 
%sizeU = length (u)
%sizeV = length (v)
surf(PRE,PRO,u);
surf(PRE,PRO,v);
R = min(u,v); %Se calculó la regla local Interseccion
figure;
surf (PRE,PRO,R);
R2 = u.*v;
figure
surf (PRE,PRO,R2)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
P =4; %Medida de presión
a = trimf(PRE,[P-1 P P+1]); %% Nuevo conjunto difuso de presion
EE = repmat(a,N,1); %% Extensión cilindrica
figure
surf (PRE,PRO,R);
hold on
surf (PRE,PRO,EE);
% intersección
W = min (R,EE);
figure
surf (PRE,PRO,W); %sobrevive de la regla ante la evidencia
% %Calcular proyeccion
C = max (W,[],2); %calcula el máximo de las columnas
figure
plot (PRO,C); %
%%%%Reglas no locales
r = max(1-u,v);
figure
surf (PRO,PRE,r)

