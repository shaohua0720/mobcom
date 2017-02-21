function A=fbddist(location,BS,r)
[~,s]=size(BS);
A=true;
for i=1:s
    lctn=BS(i).location;
    dist=norm(location-lctn,'fro')^2;
    if(dist<r^2)
        A=false;
    end
end
end