function p=GenerujTablicePolaczen(l, n, zerowy_poziom_fer, miasta)

x=1;
p=zeros(n,10);


%%
fer=zerowy_poziom_fer;
for i=1:l
    for k=1:(l+1-i);
        p(x,1)=x; %indeks polaczenia
        p(x,2)=i; %indeks miasta 1
        p(x,3)=k+i; %indeks miasta 2
        p(x,4)=fer; %feromon
        p(x,5)=sqrt((miasta(p(x,2),2)-miasta(p(x,3),2))^2+(miasta(p(x,2),3)-miasta(p(x,3),3))^2);
        p(x,6)=0;
        p(x,7)=miasta(p(x,2),2);
        p(x,8)=miasta(p(x,3),2);
        p(x,9)=miasta(p(x,2),3);
        p(x,10)=miasta(p(x,3),3);
        x=x+1;
    end
end
clear x

end