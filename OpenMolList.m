function [r,filehead]=OpenMolList
global LastFolder
if exist('LastFolder','var')
    GetFileName=sprintf('%s/*.bin',LastFolder);
else
    GetFileName='*.bin';
end

[FileNameR,PathNameR] = uigetfile(GetFileName,'Select bin file');

RightFile =sprintf('%s%s',PathNameR,FileNameR);
LastFolder=PathNameR;
r= readbinfileNXcYcZc(RightFile);
filehead = RightFile(1:end-4);