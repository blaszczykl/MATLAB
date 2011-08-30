function [phantom,mask,strainRad,strainCirc,strainTableR,strainTableC] = ...
    create_phantom(par)
%   CREATE_PHANTOM to create a heart deformation phantom
%   [phantom,strainRad,strainCirc,strainTableR,strainTableC] = create_phantom()
%   Konrad Werys

out_dir=[pwd,filesep,'phantom_dicom']; %%% ALL FILES FROM THIS DIRECTORY WILL BE DELETED!!!!!

% defaults:
if ~isfield(par,'rEpi')
    par.mm=1;
    mm=par.mm;
    par.framesSystole=10; % frames of systole
    par.framesDiastole=10; % frames of distole
    par.imSizeX=128; % image size
    par.imSizeY=128; % image size
    par.tagDistance=7*mm;
    par.tagAngle=pi/4;
    par.fi_end=0; % R ? ? shear
    par.epsilon_end=0; % rigid body rotation
    par.lambda_end=1; % longitudinal contraction
    par.gamma_end=0; % axial torsion
    par.omega_end=0; % R ? Z shear
    par.delta_end=0; % rigid body displacement
    par.rEpi=50*mm; % initial Epicardium radius
    par.rEndo=20*mm; % initial Endocardium radius
    par.rEndo_end=10*mm; % Endocardium radius in the end of the systole
end

% par.fi_end=deg2rad(0.556)/mm; % R ? ? shear
% par.epsilon_end=deg2rad(9.2); % rigid body rotation
% par.lambda_end=1; % longitudinal contraction
% par.gamma_end=deg2rad(0.6)/mm; % axial torsion
% par.omega_end=0.248; % R ? Z shear
% par.delta_end=4.167*mm; % rigid body displacement

% initial values of the movement  parameters
fi(1)=0;
epsilon(1)=0;
lambda(1)=1;
gamma(1)=0;
omega(1)=0;
delta(1)=0;

% how parameters are changing in time
fi=[linspace(fi(1),par.fi_end,par.framesSystole),...
        linspace(par.fi_end,fi(1),par.framesSystole)];
epsilon=[linspace(epsilon(1),par.epsilon_end,par.framesSystole),...
        linspace(par.epsilon_end,epsilon(1),par.framesSystole)];
lambda=[linspace(lambda(1),par.lambda_end,par.framesSystole),...
        linspace(par.lambda_end,lambda(1),par.framesSystole)];
gamma=[linspace(gamma(1),par.gamma_end,par.framesSystole),...
        linspace(par.gamma_end,gamma(1),par.framesSystole)];
omega=[linspace(omega(1),par.omega_end,par.framesSystole),...
        linspace(par.omega_end,omega(1),par.framesSystole)];
delta=[linspace(delta(1),par.delta_end,par.framesSystole),...
        linspace(par.delta_end,delta(1),par.framesSystole)];
rEndoT=[linspace(par.rEndo,par.rEndo_end,par.framesSystole),...
        linspace(par.rEndo_end,par.rEndo,par.framesSystole)];
   
basic_image=create_basic_image(par);
imshow(basic_image);
%h_wait = waitbar(0,'Calculating ...');
frames=par.framesSystole+par.framesDiastole;
phantom=zeros(par.imSizeX,par.imSizeY,1,frames);
for t=1:frames
    figure(1)
    [phantom(:,:,1,t),strainRad(:,:,1,t),strainCirc(:,:,1,t)]=calc_image_deformation(...
        basic_image,par,fi(t),epsilon(t),lambda(t),...
        gamma(t),omega(t),delta(t),rEndoT(t),par.rEndo,par.rEpi);
    
    s=strainRad(:,:,1,t);
    s1=sum(s(:));
    s2=find(s~=0);
    s3=size(s2,1);
    strainTableR(t)=s1/s3;
    if isnan(strainTableR(t)),strainTableR(t)=0;end
    
    s=strainCirc(:,:,1,t);
    s1=sum(s(:));
    s2=find(s~=0);
    s3=size(s2,1);
    strainTableC(t)=s1/s3;
    if isnan(strainTableC(t)),strainTableC(t)=0;end
    
    subplot(2,3,1);imshow(phantom(:,:,1,t),[]);title(['phantom, time: ',num2str(t),'/',num2str(frames)])
    subplot(2,3,2);imshow(strainRad(:,:,1,t),[]);title('radial strain')
    subplot(2,3,3);imshow(strainCirc(:,:,1,t),[]);title('circ strain')
    
    
    subplot(2,3,2)
%     imellipse(gca,[ par.imSizeX/2-par.rEndo_end ...
%                     par.imSizeY/2-par.rEndo_end ...
%                     par.rEndo_end*2 ...
%                     par.rEndo_end*2 ]);
%                 
%     rEpiDef = sqrt(par.rEndo_end^2 + ( par.rEpi^2 - par.rEndo^2 )*par.lambda_end);
%     imellipse(gca,[ par.imSizeX/2-rEpiDef ...
%                     par.imSizeY/2-rEpiDef ...
%                     rEpiDef*2 ...
%                     rEpiDef*2 ]);
                
    imellipse(gca,[ par.imSizeX/2-par.rEndo_end ...
                    par.imSizeY/2-par.rEndo_end ...
                    par.rEndo_end*2 ...
                    par.rEndo_end*2 ]);
                
    rEpiDef = sqrt(par.rEndo_end^2 + ( par.rEpi^2 - par.rEndo^2 )*par.lambda_end);
    imellipse(gca,[ par.imSizeX/2-rEpiDef ...
                    par.imSizeY/2-rEpiDef ...
                    rEpiDef*2 ...
                    rEpiDef*2 ]);
    %pause
    
    %waitbar(t/frames,h_wait,['time:',num2str(t)]);s
end
% close(h_wait);
strainTableC=strainTableC';
strainTableR=strainTableR';
subplot(2,3,4:6);plot(strainTableC,'g');hold on; plot(strainTableR,'r')

%%% delete all files from output directory
try rmdir (out_dir,'s'); end %!!!!!!!!!!!
mkdir(out_dir)

%%% save to MATLAB
mask=(phantom>0);
save([out_dir,filesep,'phantom.mat'], 'phantom','mask')
save([out_dir,filesep,'phantom_strain.mat'], 'strainTableC','strainTableR')

%%% save to DICOM
save_phantom_to_dicom( out_dir, par, phantom );

%%% save to XLS
xlswrite([out_dir,filesep,'phantom_strainC.xls'],strainTableC','circ strain');
xlswrite([out_dir,filesep,'phantom_strainR.xls'],strainTableR','radial strain');

end

function rad=deg2rad(deg)
    rad=deg*pi/180;
end

