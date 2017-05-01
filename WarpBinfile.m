%Load desired tform file to workspace before using

if exist('LastFolder','var')
    GetFileName=sprintf('%s/*.bin',LastFolder);
else
    GetFileName='*.bin';
end
[FileNameR,PathNameR] = uigetfile(GetFileName,'Select the R bin file to map');
RightFile =sprintf('%s%s',PathNameR,FileNameR)
[rMolAll, r]= readbinfileNXcYcZcCat1All(RightFile)
filehead = RightFile(1:end-4);
outfile = sprintf('%s_Warp.bin',filehead)

bx=double(r.x);
by=double(r.y);

[tx,ty] = tforminv(tform,bx,by);

r.x=tx;
r.y=ty;
WriteMolBinN(r,outfile);