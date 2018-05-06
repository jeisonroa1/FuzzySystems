
% Universidad Distrital FJC
% Facultad de Ingeniería
% Proyecto curricular de ingeniería electrónica
% Inteligencia Computacional I

% Algoritmo BACKPROPAGATION
% Aplicación: Predicción de la serie Mackey Glass ( se predice la quinta muestra a partir de las cuatro anteriores).
% Por: Miguel A. Melgarejo R.

clc;
clear;

x=mackey(2000);

tset=x(1,1001:1504); % conjunto de entrenamiento 504 muestras
vset=x(1505:2000); % conjunto de validación 496 muestras

%Algoritmo Backpropagation

% Incialización de la EBDF
% Todos los parámetros son inicializados al azar.

m=16; % M = 16, funciones de base difusa
n=4; % N = 4, cuatro entradas
alfa = 0.1; % Tasa de aprendizaje



%Inicialización aleatoria de parámetros
%md=rand(16,4); 
%ad=rand(16,4);
%y=rand(16,1);

%Inicialización con memoria
iniparam;
y=ones(16,1);

RMSE=1; % Criterio de desempeño, raíz del error cuadrático medio
q=1; % Contador de EPOCHS

while (RMSE > 0.03), % criterio de parada
for p=4:503,
  xp=[ tset(1,p) tset(1,p-1) tset(1,p-2) tset(1,p-3)]; % entrada a la EBDF cuatro muestras p, p-1,p-2,p-3
  yp=tset(1,p+1); % Salida deseada del predictor muestra p+1
  
    [f,b,z]=efbd(xp,y,md,ad); % calculo de la EBDF
    err=f - yp;  % error
      for i=1:m, % actualización de parámetros
        tc = alfa*err*z(i,1)/b;
        ys(i,1)=y(i,1)-tc; % Ajuste de los centros en los consecuentes 
        for j=1:n,
          mds(i,j)=md(i,j)-tc*((y(i,1)-f)*2*(xp(1,j)-md(i,j))/(ad(i,j)^2)); % Ajuste de las medias de los conjuntos antecedentes
          as(i,j)=ad(i,j)-tc*(y(i,1)-f)*2*(((xp(1,j)-md(i,j))^2)/(ad(i,j)^3)); % Ajuste de las desviaciones de los conjuntos antecedentes
        end;
      end;
      y=ys;
      md=mds;
      ad=as;
end;

%Validación por EPOCH
%Se predice la sección de la serie que no se ha visto.

for p=4:length(vset)-1,
   xv=[ vset(1,p) vset(1,p-1) vset(1,p-2) vset(1,p-3)];
   fo=efbd(xv,y,md,ad); 
   yv=vset(1,p+1);
   yv=vset(1,p+1);
   errv(1,p) = (yv - fo)^2;
   fp(1,p)=fo;
   fr(1,p)=yv;
 end;
 serrv=sum(errv);
 RMSE=sqrt((1/length(errv))*serrv) % se calcula la raíz del error cuadrático medio.
r(1,q)=RMSE;
q=q+1;
end;


%Visualización del resultado del aprendizaje.
figure;
plot(fp,'r');
hold;
plot(fr,'b');
figure
plot(r);

 