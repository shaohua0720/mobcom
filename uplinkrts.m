function uplinkR=uplinkrts(Wvector,Hl,pu,omega)
[numusers,~]=size(Wvector);
SINR=zeros(1,numusers);
for i=1:numusers
   A=Wvector(i,:);
   B=Hl*A';
   C=abs(sum(B(:))-A*Hl(i,:)');
   noise=A*A'*10^(-14.4); % 174dbm=10^(-17.4)mW/Hz=10^(-20.4)W/Hz
   SINR(i)=(A*Hl(i,:)')^2*pu/(C^2*pu+noise);
end
uplinkR=omega*log2(1+SINR);
end