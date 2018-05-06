function [z]=FISerror(fis,precio,n,H)
%Se arma arreglo de H datos para validación

data=zeros(H,n+1);
for p=1:H, 
	rand('state',100*sum(clock));
        ventanat=round(2000*rand(1,1));
        for d=1:n+1,
            data(p,d)=precio(ventanat+d);
        end    
end

real =data(:,6);
data = data(:,1:5);
salidas= evalfis(data,fis);


for i=1:length(salidas),
e(i)=(real(i)-salidas(i)).^2; %RMSE
end;
rmse=sqrt((1/H)*sum(e));
z=rmse;

