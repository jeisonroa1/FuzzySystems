%% Jeison Ivan Roa Mora
%% Composici�n difusa

function [c] = compx (ra,rb)
[m p1]= size(ra);
[p2 n]= size(rb);
c = zeros(m,n);
if p1~=p2,
    msg='revise el tama�o de las matrices'
    return
end;
for i=1:m,
    for j=1:n,
        vec1 = ra(i,:);
        vec2 = rb(:,j)';
        res = min(vec1,vec2);
        c(i,j) = max(res);
    end;
end;