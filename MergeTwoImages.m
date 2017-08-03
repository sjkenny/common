clearvars -except LastFolder;
if exist('LastFolder','var')
    GetFileName=sprintf('%s/*.png',LastFolder);
else
    GetFileName='*.png';
end


[FileNameL,PathNameL] = uigetfile(GetFileName,'Select Image 1');
GetFileName=sprintf('%s/*.png',PathNameL);
[FileNameR,PathNameR] = uigetfile(GetFileName,'Select Image 1');
LastFolder=PathNameR;

LeftFile =sprintf('%s%s',PathNameL,FileNameL);
RightFile =sprintf('%s%s',PathNameR,FileNameR);
filehead = LeftFile(1:end-4);

OutFile=sprintf('%s%s',filehead,FileNameR(1:end-4),'-merged.png');

LeftImg=imread(LeftFile);
RightImg=imread(RightFile);
% RightImg=imtranslate(RightImg,[9, -2]);
Merged=LeftImg+RightImg;
imshow(Merged)
imwrite(Merged,OutFile);
