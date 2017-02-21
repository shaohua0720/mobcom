function uty=sum_rcuty(sk,mt,eta,alpha,pu,omega,H,M,Nt)
index=(find(sk==1))';
if(isempty(index))
    uty=0;
    return;
end
[Wmrc,Wzf,Wmmse,H_off]=mudetection(index',H,pu,M*Nt);
Rk=uplinkrts(Wmrc',H_off,pu,omega);

[~,s]=size(index');
time=zeros(1,s);
for i=1:s
    time(i)=eta*mt(index(i)).rpower*alpha/pu;
    time(i)=min(time(i),1-alpha); % cut-off time of the remote computing.
end

rs=time(:).*Rk(:);
uty=sum(rs(:));
end