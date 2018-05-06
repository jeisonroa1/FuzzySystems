function [z]=rmsemg(w,m,n,sc);

par=w;
md=par(1,1:m*n);
dv=par(1,m*n+1:2*m*n);
ys=par(1,2*m*n+1:2*m*n+m)';
for i= 1:m,
med(i,:)=md(1,i*n-n+1:i*n);
dev(i,:)=dv(1,i*n-n+1:i*n);
end;


v1=-10:0.05:10;
fy=sc*sinc(v1/pi);
for i=1:length(fy),
v=v1(1,i);
f=efbd(v,ys,med,dev); 
e(1,i)=(fy(1,i)-f).^2; 
end;

z=sqrt((1/length(fy))*sum(e));
