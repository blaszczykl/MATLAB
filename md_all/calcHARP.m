function [harP1,harP2,harM1,harM2]=calcHARP(heart,tag_space,pixel_space,grid_angle,filter_radius)
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

    hWait = waitbar(0,'Calculating HARP');
    for t=1:sizeT
        for slice=1:sizeS
            
        F=fft2(heart(:,:,slice,t));
        F(1,1)=0;
        F=fftshift(F);
        
        % filter:
        hh1=my_filter(F,x(1),y(1),filter_radius);%x,y center of te filter, r-size
        hh2=my_filter(F,x(2),y(2),filter_radius);
        
        % filtering:
        F_filtered1 = fftshift(hh1.*F);
        F_filtered2 = fftshift(hh2'.*F);
        
        IF1=ifft2(F_filtered1);
        IF2=ifft2(F_filtered2);
        harP1(:,:,slice,t)=(angle(IF1));
        harP2(:,:,slice,t)=(angle(IF2));
        harM1(:,:,slice,t)=abs(IF1);
        harM2(:,:,slice,t)=abs(IF2);

        absFFT(:,:,slice,t)=F;
        waitbar(t/sizeT);
        end
    end
    close(hWait);

    
end

