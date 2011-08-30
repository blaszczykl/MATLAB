function status=save_phantom_to_dicom( out_dir, par, phantom )
%SAVE_DICOM Summary of this function goes here
%   Detailed explanation goes here

% load metadata

[imSizeX,imSizeY,imSizeT]=size(phantom);
phantom=uint16(phantom*256);
status=0;

% metadata.Width=imSizeX;
% metadata.Height=imSizeY;
metadata.PatientName.FamilyName='phantom';
metadata.PatientName.GiveName='Andrzej';
metadata.PatientID='phantom';
metadata.InstitutionName='phantom';
metadata.InstitutionAddress='phantom';
metadata.StudyDescription='phantom';
metadata.SeriesDescription='phantom';
metadata.SequenceName='phantom';
metadata.ProtocolName='phantom';
metadata.Modality='MR';
metadata.StudyID='1';
metadata.SeriesNumber=1;
metadata.PixelSpacing=[par.mm;par.mm];
metadata.StudyInstanceUID=dicomuid;
metadata.SeriesInstanceUID=dicomuid;

metadata.PatientAge='000Y';
metadata.PatientBirthDate='20000101';
metadata.FileModDate='01-jan-2011 00:00:00';

metadata.CardiacNumberofImages=imSizeT;

number_format=['%0',num2str(size(num2str(imSizeT),2)),'d'];

for t=1:imSizeT
    filename=[out_dir,filesep,'phantom_',sprintf(number_format,t),'.dcm'];
    metadata.Filename=filename;
    metadata.InstanceNumber=t;
    metadata.TriggerTime=t*10;
    % dicomwrite(phantom(:,:,t), filename,'ObjectType','MR Image Storage');
    status=dicomwrite(phantom(:,:,t), filename, metadata);
end

end