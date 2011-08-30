% clear all
% close all

%%
mm=1;
par.mm=mm;
par.framesSystole=2; % frames of systole
par.framesDiastole=2; % frames of distole
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
par.rEndo=30*mm; % initial Endocardium radius
par.rEndo_end=20*mm; % Endocardium radius in the end of the systole

% strainMR_true -> strain matrix radial true value
% strainTC -> strain table(average in region) circumferential calculated value

[phantom,mask,strainMR_true,strainMC_true,strainTR_true,strainTC_true] = create_phantom(par);
%%
[strain,strainMR,strainMC,strainM,strainTR,strainTC] = md_all(phantom,mask,'HARP');
%[strain,strainMR,strainMC,strainM,strainTR,strainTC] = md_all(phantom,mask,'HARP_gabor');
%%

errorR=100*(strainTR_true-strainTR)./strainTR;
errorC=100*(strainTC_true-strainTC)./strainTC;
close all
subplot(2,2,1)
plot(strainTR_true);hold on;plot(strainTR,'r')
subplot(2,2,2)
plot(errorR)
subplot(2,2,3)
plot(strainTC_true);hold on;plot(strainTC,'r')
subplot(2,2,4)
plot(errorC)

