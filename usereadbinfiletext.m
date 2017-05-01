%Press "Run" and select a .txt molecule list saved in Insight
%To save .txt molecule file, select region of interest in Insight,
%then press ctrl+shift+S, and select 'save as .txt file' from dropdown menu



r=OpenMolListTxt;
x=r.xc;
y=r.yc;
xy=[x y];

xSize=256;
pxSize=1;

nbins=round(xSize/pxSize);
[n,c]=hist3(xy,[nbins nbins]);


%Number of histogram bins
% NBins=40;
% 
% %Molecule category for analysis
% CoMcat=1;
% %select between Y or X histogram
% yMode=1;
% 
% CoMcatInd=find(r.cat==CoMcat);
% N=numel(CoMcatInd);
% xcList=(r.xc(CoMcatInd));
% xcList=xcList*160;
% xcList=xcList-min(xcList);
% 
% ycList=(r.yc(CoMcatInd));
% 
% ycList=ycList-min(ycList);
% ycList=ycList*160;
% zcList=r.zc(CoMcatInd);
% zcList=zcList-min(zcList);
% molData=[xcList,zcList];
% if yMode==1
%     molData=[ycList,zcList];
% end
%     

% nbins=[25,25];
% [n,c]=hist3(molData,nbins);
% hist3(molData,nbins)
% set(get(gca,'child'),'FaceColor','interp','CDataMode','auto')
% cx=cell2mat(c(1));
% cz=cell2mat(c(2));
% % xCoords=(max(xcList)-min(xcList))/nbins(1)*160;
% % zCoords=(max(zcList)-min(zcList))/nbins(1);
% 
% [peaks]=FastPeakFind(n);
% z1=peaks(1);
% z1=cz(z1);
% z2=peaks(3);
% z2=cz(z2);
% x1=peaks(2);
% x1=cx(x1);
% x2=peaks(4);
% x2=cx(x2);
% distX=x2-x1;
% distZ=z2-z1;
% dist=sqrt(distX*distX+distZ*distZ)

% [mc,mcInd]=max(counts);
% CenterSub=[abs(centers-mc/2)];
% Turn square or rectangular matrix into arrays of indices - use indices to
% get values of square matrix
% [xSize,ySize]=size(n)
% xData=[];
% yData=[];
% zData=[];
% for i=1:xSize
%     for j=1:ySize
%         yData(25*(i-1)+j)=i;
%         xData(25*(i-1)+j)=j;
%     end
% end
% 
% for i=1:numel(n)
%     indX=xData(i);
%     indY=yData(i);
%     zData(i)=n(indX,indY);
% end
% plot(xData,yData,zData,'k')
