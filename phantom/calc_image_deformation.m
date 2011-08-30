function [ image_out, strainRad, strainCirc ] = calc_image_deformation ...
    ( image_in , par, fi, epsilon, lambda, gamma, omega, delta, rEndoT, rEndo, rEpi)
%calc_image_deformation Summary of this function goes here
%   calc_deformation_values( image_in ) - with default parameters
%   calc_deformation_values( image_in , par )

% INIT:
[imSizeX,imSizeY]=size(image_in);
strainRad=zeros(imSizeX,imSizeY);
strainCirc=zeros(imSizeX,imSizeY);
image_out=zeros(imSizeX,imSizeY);
er=[1,0,0];
etheta=[0,1,0];

% motion parameters
% if nargin <2
%     mm=2.56; % 1mm=2,56px
%     fi=deg2rad(0.556)/mm;
%     epsilon=deg2rad(9.2);
%     lambda=1;
%     gamma=deg2rad(0.6)/mm;
%     omega=0.248;
%     delta=4.167*mm;
%     rEndo=15*mm;
%     rEndo_end=20*mm;
% end

i=0; % number of points outside of the image
rEpiDef = sqrt(rEndoT^2 + ( rEpi^2 - rEndo^2 )*lambda);

for x=1:imSizeX
    for y=1:imSizeY
        % calc poral coordinates, with the center at (imSize/2,imSize/2)
        [theta,r]=cart2pol(x-round(imSizeX/2),y-round(imSizeY/2));
        R=sqrt(rEndo^2 + ( r^2 - rEndoT^2 )/lambda);
        THETA=theta-epsilon-gamma-fi*R;
        [X,Y]=pol2cart(THETA,R);
        % fix cart coordinates:
        X=round(X+round(imSizeX/2));
        Y=round(Y+round(imSizeY/2));
        try image_out(x,y)=image_in(X,Y); % because of X and Y not within image_in
        catch exception; i=i+1;%disp(exception.message);
        end
        if (x-imSizeX/2)^2+(y-imSizeY/2)^2 < rEpiDef^2 ...
                && (x-imSizeX/2)^2+(y-imSizeY/2)^2 > rEndoT^2
            dr = R/(lambda*(rEndoT^2 + R^2/lambda - rEndo^2/lambda)^(1/2));
            F = [   dr,   0,      0;
                  r*fi, r/R,      0;
                     0,   0, lambda];
            strainRad(x,y)  = norm(F*er')-1;
            strainCirc(x,y) = norm(F*etheta')-1;
            if isnan(strainRad(x,y))
                strainRad(x,y)=0;
            end
            if isnan(strainCirc(x,y))
                strainCirc(x,y)=0;
            end
        end
    end
end
%imshow(image_out)
end

