function [ basic_image ] = create_basic_image( par )
%CREATE_basic_IMAGE( par )
%   TODO:
%   tagAngle

% if nargin==0
%     close all
%     disp('Defaults')
%     par.imSizeX=256;
%     par.imSizeY=256;
%     par.rEpi=100;
%     par.rEndo=50;
%     par.tagDistance=13;
%     par.tagAngle=pi/4; 
% end

basic_image=zeros(par.imSizeX,par.imSizeY);
ring_image=zeros(par.imSizeX,par.imSizeY);
XCenter=round(par.imSizeX/2);
YCenter=round(par.imSizeY/2);
par.rEpi=round(par.rEpi);
par.rEndo=round(par.rEndo);
% modulation: %%%%%%%%%%% do poprawy!!!!
[X,Y]=meshgrid(1:par.imSizeX,1:par.imSizeX);
m1=(X+Y)/2;
[X,Y]=meshgrid(1:par.imSizeX,-par.imSizeX:-1);
m2=(X-Y)/2;
if par.tagAngle==pi/4
    f=par.tagDistance/sqrt(2);
else
    f=par.tagDistance;
end
modX=sin(((2*pi)/f)*(m1))+1.1;
modY=sin(((2*pi)/f)*(m2))+1.1;
% only in the ring area:
for i=XCenter-par.rEpi:XCenter+par.rEpi
    for j=YCenter-par.rEpi:YCenter+par.rEpi
        % ring:
        if (i-XCenter)^2+(j-YCenter)^2 <= par.rEpi^2 ...
                && (i-XCenter)^2+(j-YCenter)^2 > par.rEndo^2
            ring_image(i,j)=1;
        end
        % modulation:
        basic_image(i,j)=...
            ring_image(i,j)*(modX(i,j)*modY(i,j));
    end
end

%Normalization
basic_image=basic_image./max(basic_image(:));

imshow(basic_image)

end

