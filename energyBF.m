function w_EH=energyBF(H,M,Nt)
w=zeros(1,M*Nt);
for i=1:M
   Hm=H(:,Nt*(i-1)+1:(Nt*(i-1)+Nt)); 
   [~,~,v]=svd(Hm);
   w(Nt*(i-1)+1:(Nt*(i-1)+Nt))=-v(:,1)';
end
w_EH=w;
end