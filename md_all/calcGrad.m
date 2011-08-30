function [gradP1x,gradP1y,gradP2x,gradP2y]=calcGrad(harP1,harP2)


[sizeX,sizeY,sizeS,sizeT]=size(harP1);
gradP1x=zeros(size(harP1)); %okreœlenie rozmiaru
gradP1y=zeros(size(harP1));
gradP2x=zeros(size(harP2)); %okreœlenie rozmiaru
gradP2y=zeros(size(harP2));

h_wait = waitbar(0,'Calculating HARP Gradients');
for t=1:sizeT
    waitbar(t/(sizeT));
    [gradP1x(:,:,1,t),gradP1y(:,:,1,t)]=gradient(harP1(:,:,1,t));
    [gradP2x(:,:,1,t),gradP2y(:,:,1,t)]=gradient(harP2(:,:,1,t));

	for x=1:sizeX
        for y=1:sizeY
            if abs(gradP1x(x,y,1,t))>abs(MDWrap(gradP1x(x,y,1,t)+pi))
                gradP1x(x,y,1,t)=MDWrap(gradP1x(x,y,1,t)+pi);
            end  
            if abs(gradP2x(x,y,1,t))>abs(MDWrap(gradP2x(x,y,1,t)+pi))
                gradP2x(x,y,1,t)=MDWrap(gradP2x(x,y,1,t)+pi);
            end 
            if abs(gradP1y(x,y,1,t))>abs(MDWrap(gradP1y(x,y,1,t)+pi))
                gradP1y(x,y,1,t)=MDWrap(gradP1y(x,y,1,t)+pi);
            end  
            if abs(gradP2y(x,y,1,t))>abs(MDWrap(gradP2y(x,y,1,t)+pi))
                gradP2y(x,y,1,t)=MDWrap(gradP2y(x,y,1,t)+pi);
            end
        end
    end
end
    w=((2*pi)/7);
    gradP1x(:,:,1,:)=gradP1x(:,:,1,:)/w;
    gradP1y(:,:,1,:)=gradP1y(:,:,1,:)/w;
    gradP2x(:,:,1,:)=gradP2x(:,:,1,:)/w;
    gradP2y(:,:,1,:)=gradP2y(:,:,1,:)/w;
close(h_wait);
