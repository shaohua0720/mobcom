k=40:3:61;
vvv=[];
ttt=[];
vv=0;
tt=0;
for i=k
    mc=0;
    for j=1:6
        [v,t]=mobilecloud(i);
        vv=vv+v;
        tt=tt+t;
    end
    vv=vv/6;
    vvv=[vvv vv];
    tt=tt/6;
    ttt=[ttt tt];
    i
end
figure, plot(k,vvv,'s-');
ylabel('troughout(bps)');
xlabel('number of users');
figure, plot(k,ttt,'c-');
xlabel('number of MTs');
ylabel('number of offloading MTs');