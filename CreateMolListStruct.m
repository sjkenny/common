function [mol] = CreateMolListStruct(x,y)
%create mol list struct using fields x,y and ones for all other fields
mol=struct;
blank = ones(length(x),1);

mol.x = x;
mol.y = y;
mol.xc = x;
mol.yc = y;
mol.h = blank;
mol.area = blank;
mol.width = blank;
mol.phi = blank;
mol.Ax = blank;
mol.bg = blank;
mol.I = blank;
mol.cat = blank;
mol.valid = blank;
mol.frame = blank;
mol.length = blank;
mol.link = blank;
mol.z = blank;
mol.zc = blank;
mol.N = length(x);
mol.TotalFrames = 1;



