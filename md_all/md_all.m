function [strain,strainR,strainC,strainInSector,strainInSectorR,strainInSectorC] = ...
    md_all(images,mask,method)
% [strain,strainR,strainC,strainInSector,strainInSectorR,strainInSectorC] = md_all(images,mask,method)
% if mehod is not specified, default method is 'HARP'. other option is 'HARP_gabor';
if ~exist('method','var')
    method = 'HARP';
end

if size(mask)~=size(images)
    disp('wrong size!')
    return
end

tag_space = [7 7];
pixel_space = [1 1];
filter_radius = 7;
grid_angle = pi/4;
n_sectors = 1;
pc.x = round(size(images,1)/2);
pc.y = round(size(images,2)/2);
rvlv.x=0; rvlv.y=0;

%%% HARP
tic;
switch method
    case 'HARP'
        [harP1,harP2,harM1,harM2]=calcHARP(images,tag_space,pixel_space,grid_angle,filter_radius);
    case 'HARP_gabor'
        [harP1,harP2,harM1,harM2]=calcHARP_gabor(images,tag_space,pixel_space,grid_angle);
    otherwise
        disp 'no method specified'
end
disp(['HARP: ',num2str(toc),'s']);

%%% Gradients
[gradP1x,gradP1y,gradP2x,gradP2y]=calcGrad(harP1,harP2);
disp(['HARP gradients: ',num2str(toc),'s']);

%%% Mask with sectors
mask5d=calcMask(mask,n_sectors,pc,rvlv);
disp(['Mask: ',num2str(toc),'s']);

%%% Strain
[strain,strainR,strainC, ...
    strainInSector,strainInSectorR,strainInSectorC] = ...
    calcStrain(gradP1x,gradP1y,gradP2x,gradP2y,mask5d,pc,n_sectors);
disp(['Strain: ',num2str(toc),'s']);
