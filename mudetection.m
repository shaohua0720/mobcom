function [Wmrc,Wzf,Wmmse,H_off]=mudetection(users,matrix,pu,MNt)
[~,s]=size(users);
[~,l]=size(matrix);
H_off=zeros(s,l);
for i=1:s
    index=users(i);
    H_off(i,:)=matrix(index,:);
end
Wmrc=pinv(H_off')';
Wzf=pinv(H_off'*H_off)*H_off';
SNR=10^(-20.4)*1.5e5/pu*eye(MNt);
Wmmse=pinv(H_off'*H_off+SNR)*H_off';
end
