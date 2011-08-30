function [harP1,harP2,harM1,harM2]=calcHARP_gabor(heart,tag_space,pixel_space,grid_angle)
%CALCHARP Summary of this function goes here
%   Detailed explanation goes here
    if pixel_space(1) ~= pixel_space(2) || tag_space(1) ~= tag_space(2)
        disp('look at pixel and tag spacing!');return;
    end
    
    [sizeX,sizeY,sizeS,sizeT]=size(heart);
    harP1=zeros(size(heart));  harP2=zeros(size(heart));
    harM1=zeros(size(heart));  harM2=zeros(size(heart));
    
    T = tag_space(1) / pixel_space(1);
    freA=[1/T,1/T];
    freB=[-1/T,1/T];
    
    %%% position of the center of the filter
    x=round([freA(1)*sizeX*sin(grid_angle)+sizeX/2,freB(1)*sizeX*cos(grid_angle)+sizeX/2])+1;
    y=round([freA(2)*sizeY*cos(grid_angle)+sizeY/2,freB(2)*sizeY*sin(grid_angle)+sizeY/2])+1;
    x=(x-sizeX/2)/sizeX;
    y=(y-sizeY/2)/sizeY;
    
    hWait = waitbar(0,'Calculating HARP Gabor');
    for t=1:sizeT
        for slice=1:sizeS

        IF1=GaborTag(heart(:,:,slice,t),x(1),y(1));%x,y center of te filter, r-size
        IF2=GaborTag(heart(:,:,slice,t),x(2),y(2));

        harP1(:,:,slice,t)=(angle(IF1));
        harP2(:,:,slice,t)=(angle(IF2));
        harM1(:,:,slice,t)=abs(IF1);
        harM2(:,:,slice,t)=abs(IF2);
        
        waitbar(t/sizeT);
        end
    end 
    close(hWait)
end

