%% Generación de un sistema de inferencia difusa aleatorio.
clear;
clc;

myfix=newfis('fis1');

n=4; % numero de entradas
varran=[ 0 5; -3 2; -1 1; -1 3; -1 1]; % rangos de las entradas y salida ( ?ltima fila )
m=8; % numero de reglas


%Generaci?n de parametros aleatorios segun las escalas
md1=rand(m,n);
dv1=rand(m,n);
yo1=rand(m,1);

%Escalado entradas
for k=1:n,
    md(:,k)=md1(:,k) .* (varran(k,2)-varran(k,1)) + varran(k,1);
    dv(:,k)=dv1(:,k) .* (varran(k,2)-varran(k,1)) + varran(k,1);
end

%Escalado salida
yo=yo1 .* (varran(n+1,2)-varran(n+1,1)) + varran(n+1,1);


%Agregaci?n de entradas

for j=1:n,
    myfix = addvar(myfix,'input',['inpt' num2str(j)],varran(j,:));
    for i=1:m,
        %agregaci?n de funciones de pertenencia por entrada
        myfix=addmf(myfix,'input',j,['mfu' num2str(i)],'gaussmf',[dv(i,j) md(i,j)]);
    end 
end

% Agregaci?n de salida
myfix=addvar(myfix,'output','fisopt',varran(n+1,:));


% agergaci?n de conjuntos de salida
for i=1:m,
        myfix=addmf(myfix,'output',1,['mfo' num2str(i)],'gaussmf',[0.05 yo(i,1)]);
end


% Creaci?n de la base de reglas
id=ones(1,n+1);

for i=1:m, 
    rule=i*id;
    rulelist=[ rule 1 1]; 
    myfix=addrule(myfix,rulelist);
end


