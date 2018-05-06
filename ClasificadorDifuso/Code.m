%% Clasificador difuso 
%JEISON IVAN ROA MORA

clc;
clear all;
close all;
load ('workspaceMachine'); %Base de datos para grafica 1.
figure;
plot(petalLVir,sepalWVir,'r','LineStyle', 'none','Marker','o' );
hold on;
plot(petalLVer,sepalWVer,'b','LineStyle', 'none','Marker','o');
set (gca,'fontsize',12); 
title ('Entradas sistema difuso de clasificación');
xlabel ('Petal Length');
ylabel ('Sepal Width');
axis([2 8 1.5 4])
fuzzy Machine % Se carga la maquina difusa
%%%%%%%%%%%%%%%%%%%%%%%REGLAS NO LOCALES 

%Universos
UniversoPetalL=1.5:0.1:8;
UniversoSepalW=1.5:0.1:8;
clase=-1:0.0307:1;

%Evidencia
for i=1:length(UniversoPetalL)
   x1p = UniversoPetalL(1,i);
    for j=1:length(UniversoSepalW)
        x2p = UniversoSepalW(1,j);
        
               
        %Funciones de pertenencia entradas y salida.
        petalL_corto=dsigmf(UniversoPetalL(j), [168 0.405 7.28 3.77]);
        petalL_medio=dsigmf(UniversoPetalL(j), [14.1 4.611 13 5.386]);
        petalL_largo=dsigmf(UniversoPetalL(j), [8.76 5.768 5.33 10.75]);

        sepalW_corto=dsigmf(UniversoSepalW(i), [11 1.08 11 3.74]);
        sepalW_medio=dsigmf(UniversoSepalW(i), [113.1 2.411 126.1 2.577]);
        sepalW_largo=dsigmf(UniversoSepalW(i), [14.19 3.65 11.7 5.81]);

        virginica=dsigmf (clase, [22 -1.361 236 -0.9666] );
        versicolor=dsigmf (clase, [927 0.9714 27.1 1.221] )


        % Fusificación Singleton
        % Motor de inferencia
        % Cálculo de los antecedentes de las reglas (x1 es Ai Y x2 es Bj) T-Norma mínimo
        Ar1 = min(petalL_corto,sepalW_corto); %Versicolor
        Ar2 = min(petalL_largo,sepalW_corto); %Virginica
        Ar3 = min(petalL_medio,sepalW_medio); %Virginica
        
        % Cálculo de la implicación de Dienes-Rescher para todas las reglas
        r1 = max(1-Ar1,versicolor);
        r2 = max(1-Ar2,virginica);
        r3 = max(1-Ar3,virginica);
       
        % Combinación Mamdani de los resultados de las reglas
        fo = min([r1;r2;r3]);

        % Defusificación centroide discreto.
        out = sum(clase.*fo)./sum(fo);
        z(j,i)=out; %%Se va llenando la matriz z
        
    end;   
end;

figure;
set (gca,'fontsize',12); 
surf(UniversoPetalL,UniversoSepalW,z);
ylabel('PetalLength');
xlabel('SepalWidth');
zlabel('Y');
title('Superficie Regla No Local');

