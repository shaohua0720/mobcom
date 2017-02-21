%function [value, TT]=mobilecloud(K)
M=5; % number of BSs
Nt=8; % number of antennas per BS
K=60; % number of MTs
dist=zeros(K,M);
H=zeros(K,M*Nt); % channel matrix;
Xrange=100;
Yrange=100;
a=2.5; % pathloss coefficient
isPlot=1;
pu=5e-2; % transmit power of MTs.
omega=1e6; % bandwidth
%tau=1.8*(3.5e-5)*(1e-6); % 100uA/MHz*1.8v*10^(-6) W/Hz
tau=1e-9;
b=5e10; % 5MBit
d=5e4; % cycles
eta=0.8; % efficiency
%% location of BSs
BS(1).location=[25;25];
BS(2).location=[50;50];
BS(3).location=[75;25];
BS(4).location=[25;75];
BS(5).location=[75;75];

for i=1:M
    BS(i).tpower=20; % unit of W
end
%% location of MTs
for i=1:K
    while(1)
        MT(i).location=random('unif',5,95,2,1);
        if(fbddist(MT(i).location,BS,7))
            break;
        end
    end
end
%% plot the scenario
if(isPlot)
    
    for i=1:M
        scatter(BS(i).location(1),BS(i).location(2),'^','r');
        hold on
    end
    hold on
    for i=1:K
        scatter(MT(i).location(1),MT(i).location(2),'x','k');
        hold on
    end
    axis equal;
    axis([0 100 0 100]);
    hold on 
    rectangle('Position',[0,0,100,100]);
    xlabel('X/m');ylabel('Y/m');
end
%% calculate the channel matrix
for i=1:K
    for j=1:M
        dist(i,j)=sqrt(sum((MT(i).location-BS(j).location).^2));
        for n=1:Nt
            H(i,(j-1)*Nt+n)=random('rayl',1)*dist(i,j)^(-a);
        end
    end
end
%% calculate the downlink Beamforming
BFdl=energyBF(H,M,Nt);
%% calculate the receive power of MT k
for i=1:K
    MT(i).rpower=20*norm(H(i,:).*BFdl,'fro')^2;
end
%% calculate the uplink multiuser detection vector
% Wmrc=H';
% Wzf=(H'*H)\H';
% Wmmse=(H'*H+(1/pu).*eye(M*Nt))\H';
[Wmrc,Wzf,Wmmse,H_off]=mudetection(1:K,H,pu,M*Nt);
% W=Wzf';
W=Wmrc';
%% compute the uplink rates
Rk=uplinkrts(W,H_off,pu,omega);
%TT=sum(Rk);
%end

%% optimal alpha search
alphas=0.5:0.01:1;
[~,l]=size(alphas);
maxv=zeros(1,l);
for tt=1:l
%     alpha=0.5; 
    alpha=alphas(tt);
    %% merge and split process
    sk=zeros(1,K);%sk(K/2:end)=1; sk=1 means offloading
    uty1=sum_lcuty(sk,MT,eta,alpha,tau,d);
    uty2=sum_rcuty(sk,MT,eta,alpha,pu,omega,H,M,Nt);
    uty=uty1+uty2;
    maxtt=uty;
    for i=1:K
        sk(i)=1;
        uty11=sum_lcuty(sk,MT,eta,alpha,tau,d);
        uty22=sum_rcuty(sk,MT,eta,alpha,pu,omega,H,M,Nt);
        utytt=uty11+uty22;
        if(utytt>maxtt) % here to merge
            maxtt=utytt;
            for j=1:i
                sk(j)=1-sk(j);
                uty33=sum_lcuty(sk,MT,eta,alpha,tau,d);
                uty44=sum_rcuty(sk,MT,eta,alpha,pu,omega,H,M,Nt);
                if (uty33+uty44>utytt) %split
                    maxtt=uty33+uty44;
                    continue
                else
                    sk(j)=1-sk(j);
                end
            end
        else
            sk(i)=0;
        end
    end
   maxv(tt)=maxtt; % print the max value
   value=maxtt;
    TT=sum(sk)
    maxtt
end
figure,plot(alphas,maxv);
