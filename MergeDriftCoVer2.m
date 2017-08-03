clearvars -except LastFolder;
if exist('LastFolder','var')
    GetFileName=sprintf('%s/*.txt',LastFolder);
else
    GetFileName='*.txt';
end


CoEnd=0; %1: to End. %0: no Change

[FileNameL,PathNameL] = uigetfile(GetFileName,'Select the first drift correction txt file');

GetFileName=sprintf('%s/*.txt',PathNameL);
[FileNameR,PathNameR] = uigetfile(GetFileName,'Select the second drift correction txt file');
LastFolder=PathNameR;

LeftFile =sprintf('%s%s',PathNameL,FileNameL);
RightFile =sprintf('%s%s',PathNameR,FileNameR);
filehead = FileNameL(1:end-4);

if CoEnd==1
    outfile = sprintf('%sMergedEnd_%s.txt',PathNameL,filehead);
else
    outfile = sprintf('%sMergedNoChange_%s.txt',PathNameL,filehead);
end
%RightFile='CoEnd-cell6_0024-R_xycorr_start=1,end=80376,last=80376,seg=0,prd=220,xy=19,pix=143.txt';
DriftDataR=importdata(RightFile);
DriftDataL=importdata(LeftFile);

MergedDrift=DriftDataL+DriftDataR;

MergedDrift(:,1)=MergedDrift(:,1)./2;

if CoEnd==1
   MergedDrift(:,2)=MergedDrift(:,2)- MergedDrift(end,2);
   MergedDrift(:,3)=MergedDrift(:,3)- MergedDrift(end,3);
   MergedDrift(:,4)=MergedDrift(:,4)- MergedDrift(end,4);
end

dlmwrite(outfile, MergedDrift, 'delimiter', '\t', ...
         'precision', 10)