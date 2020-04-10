%% NEXTNAME Examples
% The function <https://www.mathworks.com/matlabcentral/fileexchange/64108
% |NEXTNAME|> returns a file or folder name, incrementing a number at the
% end of the name to ensure that the returned name is not currently used.
%% Basic Usage
% Three inputs are required:
%
% # the base file or folder name, without any file extension. If the
%   location to check for existing files/folders is not the current
%   directory then the base name must include an absolute or relative
%   path to that location. All characters are treated literally.
% # a suffix that will get appended on to the end of the name. The suffix
%   must contain exactly one integer number (zero or greater), which
%   defines the starting value for incrementing from, but otherwise
%   the suffix may contain any other non-digit characters as required.
% # the file extension, e.g. |'.txt'|, |'.mat'|, |'.csv'|, etc.. Use
%   |''| for folder names or for files that do not require an extension.
%
% Example suffixes:
%
% * |'0'|
% * |'_1'|
% * |'(005)'|
% * |'.copy.100'|
% * |' backup 00001'|
% * etc.
%
% For example, starting from an empty directory:
name = nextname('A','_1','.txt') % start from one.
fclose(fopen(name,'w')); % make new file with that name.
name = nextname('A','_1','.txt')
fclose(fopen(name,'w')); % make new file with that name.
name = nextname('A','_1','.txt')
fclose(fopen(name,'w')); % make new file with that name.
%% Start Value
% The suffix must contain one number, which is used as the start value for
% incrementing from. The number must be an integer zero or greater, and
% NEXTNAME will find the next unused file (or folder) name, starting from
% that number. For example:
name = nextname('A','_100','.txt') % start from one hundred.
fclose(fopen(name,'w'));
name = nextname('A','_100','.txt')
fclose(fopen(name,'w'));
name = nextname('A','_0','.txt') % start from zero.
fclose(fopen(name,'w'));
name = nextname('A','_0','.txt')
fclose(fopen(name,'w'));
%% Leading Zeros
% By default the output number has no leading zeros, which means the
% output filename changes length depending on the number of digits in the
% output number. Fixed-width names can be specified using the suffix:
% the number used in the output filename is zero-padded to ensure that
% it has the same (minimum) width as the suffix number has. Leading
% zeros can be included in the suffix number to achieve this length.
%
% Note that |NEXTNAME| compares the number values (not literal strings),
% which ensures that all file/folder names have unique number values, i.e.
% this means that |'A_0001.txt'| will not be returned if the file name/s
% |'A_1.txt'| or |'A_01.txt'| or |'A_001.txt'| etc. already exist.
% For example, starting from one with minimum four digits:
name = nextname('A','_0001','.txt')
fclose(fopen(name,'w'));
name = nextname('A','_0001','.txt')
fclose(fopen(name,'w'));
%% Folders Too
% NEXTNAME can also return folder names, by setting the third input
% (file extension) to |''|. For example:
subd = nextname('B','_0','')
mkdir(subd); % make new folder with that name.
subd = nextname('B','_0','')
mkdir(subd); % make new folder with that name.
subd = nextname('B','_0','')
mkdir(subd); % make new folder with that name.
%% 4th Input: Specify Output
% By default the output includes the file/folder name only. The optional
% fourth input specifies if the output should include the same relative or
% absolute path as the input name has (it does not fully qualify the path):
name = fullfile(subd,'file') % relative path of subfolder
nextname(name,'(1)','.txt',false) % default: output = name only.
nextname(name,'(1)','.txt',true) % output includes same path as input.
%% Sorting Names with Numbers
% Once files are saved in a directory the order in which they are returned
% in by the OS may not be the same as the number order. An easy way to
% sort filenames or directory names which contain numbers is to download
% my FEX submission <https://www.mathworks.com/matlabcentral/fileexchange/47434
% |NATSORTFILES|>. It is very simple to use:
S = dir('A_*.txt');
sort({S.name}.') % not numeric order.
natsortfiles({S.name}.') % numeric order.