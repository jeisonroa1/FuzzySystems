function [z]=FISerror(fis,precioNM,n,H)
%Se genera arreglo de H datos para validación

data=zeros(H,n+1);
for p=1:H, 
    data(p,:)=precioNM(p:p+5);
end

real =data(:,6);
data = data(:,1:5);
salidas= evalfis(data,fis);

for i=1:length(salidas);
e1(i)=(real(i)-salidas(i)).^2; %RMSE
e2(i)=abs((real(i)-salidas(i))/(salidas(i))); %MAPE
e3(i)=(real(i)-salidas(i)).^2; %NMSE
end;
for i=1:length(salidas)-1;
e4(i)=(salidas(i+1)-salidas(i)).^2;
end

MSE=(1/length(e1))*sum(e1);
MAPE=(100/length(e2))*(sum(e2));
NMSE=sum(e3)/sum(e4);
z=MSE+(MAPE/100)+NMSE;
