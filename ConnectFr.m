clearvars -except LastFolder;
if exist('LastFolder','var')
    GetFileName=sprintf('%s/*-sp.bin',LastFolder);
else
    GetFileName='*-sp.bin';
end

TolX=0.35;
TolY=0.35;
AllowSkip=0;
SearchFr=AllowSkip+1;
% LeftLimitXc=255;

RightStartCol=258;

%MolsInLeft=find(MolList.xc<LeftLimitXc);

[Filename,PathName] = uigetfile(GetFileName,'Select the bin file for connecting');
LastFolder=PathName;

FullFileName=sprintf('%s%s',PathName,Filename);

Filehead=FullFileName(1:end-4);

SpTxtFile=sprintf('%s.txt', Filehead);
SpDaxFile=sprintf('%s.dax', Filehead);
SpInfFile=sprintf('%s.inf', Filehead);

TxtData=importdata(SpTxtFile);
% [XDim,YDim,nFrames] = ReadInfFile(SpInfFile);
% Dax = ReadDaxFile(SpDaxFile,XDim, YDim, nFrames);

OutFileName=sprintf('%s-Connected-sp.bin', Filehead);
OutTxtFileName=sprintf('%s-Connected-sp.txt', Filehead);
CopyDaxFileName=sprintf('%s-Connected-sp.dax', Filehead);
CopyInfFileName=sprintf('%s-Connected-sp.inf', Filehead);

CopyCommand=sprintf('copy "%s" "%s"', SpDaxFile, CopyDaxFileName);
system(CopyCommand)

CopyCommand=sprintf('copy "%s" "%s"', SpInfFile, CopyInfFileName);
system(CopyCommand)

fprintf(1,'Loading...');

MolList=readbinfileNXcYcZcCat0(FullFileName);

fprintf(1,'Loaded!\nConnecting...\n');

if MolList.yc(1)==MolList.yc(2)
    StepForLeft=2;
    fprintf(1,'Double image treatment!\n');

else
    StepForLeft=1;
end

IsDouleImage=StepForLeft-1;

MolNum=MolList.N;

%MergedList=zeros(MolNum,18);

CurrentSp=uint32(0);

for i=1:StepForLeft:MolNum
    
    if (MolList.cat(i)==0||MolList.cat(i)==9)% && MolList.xc(i)<LeftLimitXc)
    
        CurrentSp=CurrentSp+1;
    end   
    if (MolList.cat(i)==0)% && MolList.xc(i)<LeftLimitXc)
        
%         if (CurrentSp==30)
%             
%             
%         end
        
        CurrentFr=MolList.frame(i);
        CurrentLength=MolList.length(i);
        CurrentXc=MolList.xc(i);
        CurrentYc=MolList.yc(i);
        CurrentZc=MolList.zc(i);
        
        CurrentX=MolList.x(i);
        CurrentY=MolList.y(i);
        CurrentZ=MolList.z(i);
                
        CurrentIntensity= MolList.area(i);
        
        CurrentXR=MolList.x(i+1);
        CurrentYR=MolList.y(i+1);
        CurrentZcR=MolList.zc(i+1);
        CurrentZR=MolList.z(i+1);
        
        CurrentPixShift=TxtData(CurrentSp,7);
        CurrenntCoM=TxtData(CurrentSp,end);
        CurrentSpetrum=TxtData(CurrentSp,8:(end-1));
        
        
        for FollowMol=i+StepForLeft:StepForLeft:MolNum
            CmpFr=MolList.frame(FollowMol);
            if (CmpFr==CurrentFr)% || MolList.xc(FollowMol)>LeftLimitXc)
                continue;
            end

            if (CmpFr>CurrentFr+SearchFr)
                break;
            end

            if (MolList.cat(FollowMol)==0 && abs(MolList.xc(FollowMol)-CurrentXc) < TolX && abs(MolList.yc(FollowMol)-CurrentYc) < TolY)
                if CmpFr-CurrentFr>1
                    MolList.cat(i)=2;
                    MolList.cat(i+IsDouleImage)=2;
                    TxtData(CurrentSp,1)=2;
                elseif MolList.cat(i)==0
                    MolList.cat(i)=1; %!!!!!!!!!!!!!!!!!!!!!!
                    MolList.cat(i+IsDouleImage)=1;
                    TxtData(CurrentSp,1)=1;
                end
                    
                CurrentFr=CmpFr;
                CurrentLength=CurrentLength+1;
                MolList.cat(FollowMol)=9;
                MolList.cat(FollowMol+IsDouleImage)=9;
                
                TxtData(MolList.valid(FollowMol),1)=9;
                
                AddIntensity=MolList.area(FollowMol);
                NewIntensity=CurrentIntensity+AddIntensity;
                
                CurrentXc=(CurrentXc*CurrentIntensity + MolList.xc(FollowMol)*AddIntensity)/NewIntensity;
                CurrentYc=(CurrentYc*CurrentIntensity + MolList.yc(FollowMol)*AddIntensity)/NewIntensity;
                CurrentZc=(CurrentZc*CurrentIntensity + MolList.zc(FollowMol)*AddIntensity)/NewIntensity;

                CurrentX=(CurrentX*CurrentIntensity + MolList.x(FollowMol)*AddIntensity)/NewIntensity;
                CurrentY=(CurrentY*CurrentIntensity + MolList.y(FollowMol)*AddIntensity)/NewIntensity;
                CurrentZ=(CurrentZ*CurrentIntensity + MolList.z(FollowMol)*AddIntensity)/NewIntensity;
                                
                if (StepForLeft==2)
                    CurrentZcR=(CurrentZcR*CurrentIntensity + MolList.zc(FollowMol+1)*AddIntensity)/NewIntensity;
                    CurrentZR=(CurrentZR*CurrentIntensity + MolList.z(FollowMol+1)*AddIntensity)/NewIntensity;
                    CurrentXR=(CurrentXR*CurrentIntensity + MolList.x(FollowMol+1)*AddIntensity)/NewIntensity;
                    CurrentYR=(CurrentYR*CurrentIntensity + MolList.y(FollowMol+1)*AddIntensity)/NewIntensity;
                end
                CurrentPixShift=(CurrentPixShift*CurrentIntensity + TxtData(MolList.valid(FollowMol),7)*AddIntensity)/NewIntensity;
                CurrenntCoM=(CurrenntCoM*CurrentIntensity + TxtData(MolList.valid(FollowMol),end)*AddIntensity)/NewIntensity;
                
                CurrentSpetrum=CurrentSpetrum+TxtData(MolList.valid(FollowMol),8:(end-1));
                
                CurrentIntensity=NewIntensity;
                
            end
        end
        
        MolList.length(i)=CurrentLength;
        MolList.xc(i)=CurrentXc;
        MolList.yc(i)=CurrentYc;
        MolList.zc(i)=CurrentZc;

        MolList.x(i)=CurrentX;
        MolList.y(i)=CurrentY;
        MolList.z(i)=CurrentZ;
        
        MolList.area(i)=CurrentIntensity;

        TxtData(CurrentSp,4)=CurrentIntensity;
        TxtData(CurrentSp,5)=CurrentX;
        TxtData(CurrentSp,6)=CurrentY;
        TxtData(CurrentSp,7)=CurrentPixShift;
        TxtData(CurrentSp,end)=CurrenntCoM;
        TxtData(CurrentSp,8:(end-1))=CurrentSpetrum;
         
        if (StepForLeft==2)
            MolList.length(i+1)=CurrentLength;
            MolList.xc(i+1)=CurrentXc+RightStartCol;
            MolList.yc(i+1)=CurrentYc;
            MolList.zc(i+1)=CurrentZcR;
            MolList.x(i+1)=CurrentXR;
            MolList.y(i+1)=CurrentYR;
            MolList.z(i+1)=CurrentZR;
            MolList.area(i+1)=CurrentIntensity;
        end
        
    end
    
end

fprintf(1,'Done!\nWriting...\n');

WriteMolBinNXcYcZc(MolList, OutFileName);

dlmwrite(OutTxtFileName, TxtData, 'delimiter', '\t', 'precision', 9);

