%write info file
%filename should have no extension

function [info] = write_info_template(img,filename)

DaxName = sprintf('%s.dax',filename);
FileNameInf = sprintf('%s.inf',filename);

info = ReadInfoFile('C:/STORM/common/blank.inf');
info.frame_dimensions = flip(size(img));
info.frame_size = info.frame_dimensions(2)*info.frame_dimensions(1);
info.file=DaxName;
info.localName=FileNameInf;
info.number_of_frames = 1;

info.hstart = 1;
info.vstart = 1;
info.hend = info.frame_dimensions(1);
info.vend = info.frame_dimensions(2);
