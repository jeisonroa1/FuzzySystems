
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Jeison Roa - 2017 Operaciones entre conjuntos
%Particiónes creadas. 
x=[0:1/200:1];
Ua = trimf(x,[0.25 0.5 0.75]);
Ub = trapmf(x,[0.6 0.8 2 5]);
figure;
plot (x,Ua,'b');
hold on
plot (x,Ub,'r');
set (gca,'fontsize',12); 
title ('My First Fuzz Partition');
xlabel ('X (Units)');
ylabel ('Membership');
%axis([0 2*pi -1.5 1.5]) ajustar ejes x,y
% print('mfp.png','-dpng','-r300'); Guarda imagen en png
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
compUa = 1-Ua;
compUb = 1-Ub;
figure;
plot (x,compUa,'b');
hold on
plot (x,compUb,'r');
set (gca,'fontsize',12); 
title ('Complements');
xlabel ('X (Units)');
ylabel ('Membership');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Uniones
umax = max(Ua,Ub);
usa = Ua+Ub-Ua.*Ub; %suma algebraica 
use = (Ua+Ub)./(1+Ua.*Ub); %suma de einstein
figure;
plot (x,umax,'b');
hold on
plot (x,usa,'g');
hold on
plot (x,use,'r');
hold on
set (gca,'fontsize',12); 
title ('Union');
xlabel ('X (Units)');
ylabel ('Membership');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Intersecciones
imin = min(Ua,Ub);%interseccion minimo
iprod = Ua.*Ub; %inter productor
ins = (Ua.*Ub)./(2-(Ua+Ub-Ua.*Ub));  %inter
figure;
plot (x,imin,'b');
hold on
plot (x,iprod,'g');
hold on
plot (x,ins,'r');
hold on
set (gca,'fontsize',12); 
title ('Intersection');
xlabel ('X (Units)');
ylabel ('Membership');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Union del complemento
aac = max(Ua,compUa);
aiac = min(Ua,compUa);
usaac = Ua+compUa-Ua.*compUa; %suma algebraica 
useac = (Ua+compUa)./(1+Ua.*compUa); %suma de einstein
figure;
plot (x,aac,'b');
hold on
plot (x,aiac,'g');
hold on
plot (x,usaac,'r');
hold on
plot (x,useac,'c');
hold on
set (gca,'fontsize',12); 
title ('Union and complement');
xlabel ('X (Units)');
ylabel ('Membership');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Interseccion del complemento





