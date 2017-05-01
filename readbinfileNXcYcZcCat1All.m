function [MolAll MolCat1] = readbinfileNXcYcZcCat1All(filename)

% filename='testRead.bin';
fid = fopen(filename,'r');
c = fread(fid,12);
A = fread(fid,'float32');


%   1       2   3   4   5   6       7       8       9   10  11  12
% Cas44178	X	Y	Xc	Yc	Height	Area	Width	Phi	Ax	BG	I	
%   13  14      15      16      17  18
% Frame	Length	Link	Valid	Z	Zc

x = single(A(2:18:end));
y = single(A(3:18:end));
xc = single(A(4:18:end));
yc = single(A(5:18:end));
z = single(A(18:18:end));
zc = single(A(19:18:end));
h = single(A(6:18:end));
area = single(A(7:18:end));
width = single(A(8:18:end));
phi = single(A(9:18:end));
Ax = single(A(10:18:end));
bg = single(A(11:18:end));
I = single(A(12:18:end));

clear A;
% ReadInt

frewind(fid);

%c = fread(fid,12);

c = fread(fid,3,'*int32');
TotalFrames=c(2);

A = fread(fid,'int32');
cat = int32(A(13:18:end));
valid = int32(A(14:18:end));
frame = int32(A(15:18:end));
length = int32(A(16:18:end));
link=int32(A(17:18:end));
clear A;

fclose(fid);

N = min([ size(cat,1),size(z,1),size(bg,1),size(area,1) ]);

mol.cat = cat;
mol.x = x;
mol.y = y;
mol.z = z;
mol.xc = xc;
mol.yc = yc;
mol.zc = zc;
mol.h = h;
mol.area = area;
mol.width = width;
mol.phi = phi;
mol.Ax = Ax;
mol.bg = bg;
mol.I = I;
mol.frame = frame;
mol.length = length;
mol.link = link;
mol.valid = valid;

mol.N=int32(N);
mol.TotalFrames=TotalFrames;

MolAll=mol;

ind = find(cat(1:N)==1);
N = size(ind,1);
% mol = struct('cat',{cat(ind)},'x',{x(ind)},'y',{y(ind)},'z',{z(ind)},'h',{h(ind)},'area',{area(ind)},'width',{width(ind)},'phi',{phi(ind)},         'Ax',{Ax(ind)},'bg',{bg(ind)},'I',{I(ind)},'frame',{frame(ind)},'length',{length(ind)},'link',{-1*ones(N,1)},'valid',{valid(ind)});
mol.cat = cat(ind);
mol.x = x(ind);
mol.y = y(ind);
mol.z = z(ind);
mol.xc = xc(ind);
mol.yc = yc(ind);
mol.zc = zc(ind);
mol.h = h(ind);
mol.area = area(ind);
mol.width = width(ind);
mol.phi = phi(ind);
mol.Ax = Ax(ind);
mol.bg = bg(ind);
mol.I = I(ind);
mol.frame = frame(ind);
mol.length = length(ind);
mol.link = link(ind);
mol.valid = valid(ind);

mol.N=int32(N);
mol.TotalFrames=TotalFrames;

MolCat1 = mol;