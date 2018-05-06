%% Composición Difusa
%% Jeison Ivan Roa Mora
clear;

%R
u=[-1:0.01:1.0]';

v=[-1:0.01:1.0];

mu=repmat(u,1,length(v));

mv=repmat(v,length(u),1);


figure;

vr=0.01;

r= exp(-0.5*((3*mu-mv).^2)/vr);

surf(u,v,r);


%S
v=[-1:0.01:1.0]';

z=[-1:0.01:1.0];

mv=repmat(v,1,length(z));

mz=repmat(z,length(v),1);

figure;

vr=0.01;

s= exp(-0.5*((mz - mv.^2).^2)/vr);

surf(v,z,s);


%Composici?n

crs=compx(r,s);

figure

surf(u,z,crs);
