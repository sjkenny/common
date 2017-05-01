

if exist('LastFolder','var')
    GetFileName=sprintf('%s/*.bin',LastFolder);
else
    GetFileName='*.bin';
end

[FileNameR,PathNameR] = uigetfile(GetFileName,'Select bin file');

RightFile =sprintf('%s%s',PathNameR,FileNameR);
LastFolder=PathNameR;
r= readbinfileNXcYcZc(RightFile);
rx=double(r.xc);
ry=double(r.yc);

ShiftX=0; %-2 for aligning non-split data to split data
rx=rx+ShiftX;


GetFileName=sprintf('%s/*.mat',LastFolder);

[FileName,PathName] = uigetfile(GetFileName,'Select warp file');
tformfile =sprintf('%s%s',PathName,FileName);
tform=importdata(tformfile);

[tx,ty] = tforminv(tform,rx,ry);
r.x=tx;
r.y=ty;

filehead = RightFile(1:end-4);
outfile = sprintf('%s_Warp.bin',filehead)
WriteMolBinN(r,outfile);


