function Fout=my_filter(Fin,xf,yf,rf)
% circle filter
% xf,yf - center of the filter bandpass region
% rf - size of bandpass region

% sig=0.05;
[sizeX,sizeY] = size(Fin);

[f1,f2] = meshgrid(1:sizeY,1:sizeX);
Hd = ones(sizeX,sizeY); 
% circle equation:
r = sqrt(((f1-xf).^2) + ((f2-yf).^2));
Hd(r>rf) = 0;
% Fout=Hd; %!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

% tic ;
% Fout=exp(-((Hd-1).^2)/(2*sig^2));
% toc;

h = fwind1(Hd, gausswin(sizeY),gausswin(sizeX));
Fout=freqz2(h,sizeY,sizeX);


% Fout=fftshift(Fout);
% figure;mesh(abs(h));
% subplot(1,2,1);imshow(Fin);hold on;contour(Fout,2);alpha(1)%imshow(abs((Hd)),[]);hold on;scatter(xf,yf)
% subplot(1,2,2);
% imshow(abs(fftshift(Fout)),[]);hold on;scatter(xf,yf)
end