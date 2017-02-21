function uty=sum_lcuty(sk,mt,eta,alpha,tau,d)
rs=0;
[~,s]=size(sk);
for i=1:s
   if(sk(i)==0)
      rs=rs+eta*mt(i).rpower*alpha/(tau*d)*32;
   end
end
uty=rs;
end
