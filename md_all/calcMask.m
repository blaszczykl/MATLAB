function mask=calcMask(maskLV,n_sectors,pc,rvlv)
%CALCMASK Summary of this function goes here
%   Detailed explanation goes here

[sizeX,sizeY,sizeS,sizeT]=size(maskLV);
mask=zeros([size(maskLV),n_sectors]);
maskSector=zeros([size(maskLV),n_sectors]);

%%% calculating points for sectors 
h_wait = waitbar(0,'Calculating mask');
if n_sectors==1
    maskSector=ones([size(maskLV),n_sectors]);
elseif n_sectors==2
    disp('Number of sectors must be differen than 2!');return;
else
    T1 = makehgtform('translate',[pc.x,pc.y,0]);
    % Tales =]
    len=sqrt((pc.x-rvlv.x)^2+(pc.y-rvlv.y)^2);
    lenplus=min([pc.x,pc.y,sizeX-pc.x,sizeY-pc.y])-1;
    rvlvplus.x=-(lenplus/len)*(pc.x-rvlv.x)+pc.x;
    rvlvplus.y=-(lenplus/len)*(pc.y-rvlv.y)+pc.y;

    for i=1:n_sectors
        T_rot = makehgtform('zrotate',2*pi*i/n_sectors);
        pos=T1 * T_rot * inv(T1) * [rvlvplus.x,rvlvplus.y,0,1]';
        pos=pos(1:2);
        psec(i).x=pos(1);
        psec(i).y=pos(2);

        if pos(1)<1 || pos(2)<1
            warndlg(num2str(pos));
        end
    end

    for i=1:n_sectors
        ii=mod(i,n_sectors)+1; % ii=i+1, but ii=1 for i=last sector
        X=[psec(i).x, psec(ii).x, pc.x];
        Y=[psec(i).y, psec(ii).y, pc.y];
        maskSector(:,:,1,1,i)=poly2mask(X,Y,sizeX,sizeY);

    end
end

%%% calculating full mask
for t=1:sizeT
    for i=1:n_sectors
        mask(:,:,1,t,i)=maskLV(:,:,1,t)&maskSector(:,:,1,1,i);
    end
end
close(h_wait);

end

