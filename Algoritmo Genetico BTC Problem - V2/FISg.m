

function [myfis] = FISg(individuo,m,n)

%Generación de parametros aleatorios segun las escalas
% md1=rand(m,n);
% dv1=rand(m,n);
% yo1=rand(m,1);
%
%m numero de reglas
%n numero de entradas
md1=zeros(m,n);
dv1=zeros(m,n);
yo1=zeros(m,1);
yo2=zeros(m,1);
ind=0;
b=1;
v=1;
for b=1:n,
    for v=1:m,
        md1(b,v)=individuo(ind+v);
    end
    ind=ind+m;
end
for b=1:n,
    for v=1:m,
        dv1(b,v)=individuo(ind+v);
    end
    ind=ind+m;
end

for b=1:m,
    yo1(b)=individuo(ind+b);
end
ind=ind+m;
for b=1:m,
    yo2(b)=individuo(ind+b);
end

myfis=newfis('myfis');
% Se generan rangos para las entradas y la salida normalizados [0 1]

varran=[];
varrani = [-1 1];
for(g=1:20)
varran=[varran ; varrani]; 
end
varran(n+2:length(varran),:)=[];



%Escalado entradas (para n entradas)
for k=1:n,
    md(:,k)=md1(:,k) .* (varran(k,2)-varran(k,1)) + varran(k,1);
    dv(:,k)=dv1(:,k) .* (varran(k,2)-varran(k,1)) + varran(k,1);
end




%Agregaci?n de entradas

for j=1:n,
    myfis = addvar(myfis,'input',['inpt' num2str(j)],varran(j,:));
    for i=1:m,
        %agregaci?n de funciones de pertenencia por entrada
        myfis=addmf(myfis,'input',j,['mfu' num2str(i)],'gaussmf',[abs(dv1(j,i)) md1(j,i)]);
    end 
end

% Agregaci?n de salida (1 salida)
myfis=addvar(myfis,'output','fisopt',varran(n+1,:));


% agergaci?n de conjuntos de salida
for i=1:m,
        myfis=addmf(myfis,'output',1,['mfo' num2str(i)],'gaussmf',[abs(yo2(i,1)) yo1(i,1)]);
end


% Creaci?n de la base de reglas
id=ones(1,n+1);

for i=1:m, 
    rule=i*id;
    rulelist=[ rule 1 1]; 
    myfis=addrule(myfis,rulelist);
end
%myfis=mam2sug(myfis);



