function [strain,strainR,strainC,strainInSector,strainInSectorR,strainInSectorC] = ... 
    calcStrain(gradP1x,gradP1y,gradP2x,gradP2y,mask,pc,n_sectors)

[sizeX,sizeY,sizeS,sizeT]=size(gradP1x);

h_wait = waitbar(0,'Wait');

%%% calculating strain directions for each pixel
for t=1:sizeT
    [X,Y]=meshgrid(1:sizeX,1:sizeY);
    X=X-pc.x; % translate center
    Y=Y-pc.y;

    for i=1:sizeX
        for j=1:sizeY
            r=sqrt((X(i,j))^2+(Y(i,j))^2);
            RX(i,j,t)=X(i,j)/r;
            RY(i,j,t)=Y(i,j)/r;
            CX(i,j,t)=-Y(i,j)/r;
            CY(i,j,t)=X(i,j)/r;
        end
    end
end

%%% calculating strain value for every pixel
waitbar(0,h_wait,'Calculating Strain');
for t=1:sizeT
    waitbar(t/(sizeT));
    for x=1:sizeX
        for y=1:sizeY
            
            gxy=[ gradP1x(x,y,1,t),gradP1y(x,y,1,t);
                gradP2x(x,y,1,t),gradP2y(x,y,1,t)];

            strain(x,y,1,t)=norm(gxy)-1;
            
            er=[RX(x,y,t),RY(x,y,t)];
            strainR(x,y,1,t)=norm(gxy*er')-1;
            if isnan(strainR(x,y,1,t)),strainR(x,y,1,t)=0;end
            
            ec=[CX(x,y,t),CY(x,y,t)];
            strainC(x,y,1,t)=norm(gxy*ec')-1;
            if isnan(strainC(x,y,1,t)),strainC(x,y,1,t)=0;end
            
        end
    end    
end

%%% calculating strain value in sectors
for t=1:sizeT
    for i=1:n_sectors
        s=mask(:,:,1,t,i).*strain(:,:,1,t);
        sc=mask(:,:,1,t,i).*strainC(:,:,1,t);
        sr=mask(:,:,1,t,i).*strainR(:,:,1,t);
        s1=sum(s(:));
        s1c=sum(sc(:));
        s1r=sum(sr(:));
        s2=find(mask(:,:,1,t,i));
        s3=size(s2,1);
        strainInSector(t,i)=s1/s3;
        strainInSectorR(t,i)=s1c/s3;
        strainInSectorC(t,i)=s1r/s3;
    end
end

%%% scale strain to first time frame
for i=1:n_sectors
    s0(i)=strainInSector(1,i);
    s0C(i)=strainInSectorC(1,i);
    s0R(i)=strainInSectorR(1,i);
    for t=1:sizeT
        strainInSector(t,i)=strainInSector(t,i)-s0(i);
        strainInSectorC(t,i)=strainInSectorC(t,i)-s0C(i);
        strainInSectorR(t,i)=strainInSectorR(t,i)-s0R(i);
    end
end

close(h_wait);



