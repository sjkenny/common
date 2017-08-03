function [mol] = CreateMolListStruct(x,y)
%create mol list struct using fields x,y and ones for all other fields
mol=struct;
blank = ones(length(x),1);

mol.x = x;
mol.y = y;
mol.xc = x;
mol.yc = y;
mol.h = 1000.*blank;
mol.area = 100.*blank;
mol.width = 100.*blank;
mol.phi = blank;
mol.Ax = blank;
mol.bg = 100.*blank;
mol.I = 10000.*blank;
mol.cat = blank;
mol.valid = blank;
mol.frame = blank;
mol.length = blank;
mol.link = -blank;
mol.z = blank;
mol.zc = blank;
mol.N = length(x);
mol.TotalFrames = 1;



