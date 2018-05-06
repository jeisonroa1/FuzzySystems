

function [myfis] = FISg(individuo,x,y)

%Generación de parametros aleatorios segun las escalas
% md1=rand(m,n);
% dv1=rand(m,n);
% yo1=rand(m,1);

m=x; % numero de reglas
n=y; % numero de entradas
md1=zeros(m,n);
dv1=zeros(m,n);
yo1=zeros(m,1);
ind=0;

for b=1:m,
    for v=1:n,
        md1(b,v)=individuo(ind+v);
    end
    ind=ind+n;
end
for b=1:m,
    for v=1:n,
        dv1(b,v)=individuo(ind+v);
    end
    ind=ind+n;
end
for b=1:m,
    yo1(b)=individuo(ind+b);
end

myfis=newfis('myfis');
% Se generan rangos para las entradas y la salida normalizados [0 1]
varran=[];
varrani = [0 1];
for(g=1:20)
varran=[varran ; varrani]; 
end
varran(n+2:length(varran),:)=[];



%Escalado entradas (para n entradas)
for k=1:n,
    md(:,k)=md1(:,k) .* (varran(k,2)-varran(k,1)) + varran(k,1);
    dv(:,k)=dv1(:,k) .* (varran(k,2)-varran(k,1)) + varran(k,1);
end

%Escalado salida
yo=yo1 .* (varran(n+1,2)-varran(n+1,1)) + varran(n+1,1);


%Agregaci?n de entradas

for j=1:n,
    myfis = addvar(myfis,'input',['inpt' num2str(j)],varran(j,:));
    for i=1:m,
        %agregaci?n de funciones de pertenencia por entrada
        myfis=addmf(myfis,'input',j,['mfu' num2str(i)],'gaussmf',[dv(i,j) md(i,j)]);
    end 
end

% Agregaci?n de salida (1 salida)
myfis=addvar(myfis,'output','fisopt',varran(n+1,:));


% agergaci?n de conjuntos de salida
for i=1:m,
        myfis=addmf(myfis,'output',1,['mfo' num2str(i)],'gaussmf',[0.05 yo1(i,1)]);
end


% Creaci?n de la base de reglas
id=ones(1,n+1);

for i=1:m, 
    rule=i*id;
    rulelist=[ rule 1 1]; 
    myfis=addrule(myfis,rulelist);
end
%myfis=mam2sug(myfis);



