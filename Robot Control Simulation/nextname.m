function name = nextname(bnm,sfx,ext,otp) %#ok<*ISMAT>
% Return the next unused filename, incrementing a numbered suffix if required.
%
% (c) 2017-2020 Stephen Cobeldick
%
%%% Syntax:
% name = nextname(bnm,sfx,ext)
% name = nextname(bnm,sfx,ext,otp)
%
% The base name is supplied as the first input. If the location to be
% checked is not the current directory then the base name must use a
% relative or absolute path to that location, otherwise the base name
% is treated literally. The second input is a suffix that will be
% appended to the base name: the suffix must contain exactly one starting
% integer, e.g.: '(0)', '_1', ' v005', '.temp.1000', etc., and NEXTNAME
% increments the integer value so that the returned name is currently
% unused by any file/folder. The third input is the file extension: for
% folders or if the file does not require an extension simply use ''.
%
% Padding the suffix integer with leading zeros indicates the required
% number length, thus allowing for the creation of fixed-width names.
%
% Duplicate number values will not be returned, regardless of any leading
% zeros in the existing file/folder names or in the requested suffix.
%
%% Examples %%
%
%%% Current directory contains files 'A1.m', 'A2.m', and 'A4.m':
%
% >> nextname('A','1','.m')
% ans = 'A3.m'
%
% >> nextname('A','001','.m')
% ans = 'A003.m'
%
%%% Subdirectory 'HTML' contains folders 'B(1)', 'B(2)', and 'B(4)':
%
% >> nextname('HTML\B','(1)','')
% ans = 'B(3)'
%
% >> nextname('HTML\B','(001)','')
% ans = 'B(003)'
%
% >> nextname('HTML\B','(1)','',false) % default = name only.
% ans = 'B(3)'
% >> nextname('HTML\B','(1)','',true) % prepend same path as the input name.
% ans = 'HTML\B(3)'
%
%% Inputs and otputs %%
%
%%% Input Arguments (*==default):
% bnm = CharVector, the base filename or folder name, absolute or relative.
% sfx = CharVector, the suffix to append, containing exactly one integer.
% ext = CharVector, the file extension, if any. For folder names use ''.
% otp = LogicalScalar, true/false* -> output with same path as input name / name only. 
%
%%% otput Arguments:
% name = CharVector, a currently unused file/folder name.
%
% See also: DIR EXIST WHAT FILEPARTS FULLFILE MKDIR FOPEN SPRINTF NATSORTFILES ISDIR ISFOLDER

%% Input Wrangling %%
%
fmt = 'Input <%s> must be a 1xN char array.';
assert(ischar(bnm)&&ndims(bnm)==2&&size(bnm,1)==1,fmt,'bnm')
assert(ischar(sfx)&&ndims(sfx)==2&&size(sfx,1)==1,fmt,'sfx')
assert(ischar(ext)&&ndims(ext)==2&&size(ext,1)<=1,fmt,'ext')
tkn = regexp(sfx,'\d+','match');
val = sscanf(sprintf(' %s',tkn{:}),'%lu'); % faster than STR2DOUBLE.
assert(numel(val)==1,'The suffix must contain exactly one integer value.')
wid = numel(tkn{1});
%
%% Get Existing File / Folder Names %%
%
[inpth,fnm,tmp] = fileparts(bnm);
fnm = [fnm,tmp];
%
% Find files/subfolders on that path:
raw = dir(fullfile(inpth,[fnm,regexprep(sfx,'\d+','*'),ext]));
%
% Special case of exactly one matching subfolder (Octave):
if ~all(strncmp({raw.name},fnm,numel(fnm)));
	raw = dir(fullfile(inpth,'*'));
end
%
% Generate regular expression:
rgx = regexprep(regexptranslate('escape',sfx),'\d+','(\\d+)');
rgx = ['^',regexptranslate('escape',fnm),rgx,regexptranslate('escape',ext),'$'];
%
% Extract numbers from names:
tkn = regexpi({raw.name},rgx,'tokens','once');
tkn = [tkn{:}];
%
%% Identify First Unused Name %%
%
if numel(tkn)
	% For speed these values must be converted before the WHILE loop:
	vec = sscanf(sprintf(' %s',tkn{:}),'%lu');  % faster than STR2DOUBLE.
	%
	% Find the first unused name, starting from the provided value:
	while any(val==vec)
		val = val+1;
	end
end
%
name = [fnm,regexprep(sfx,'\d+',sprintf('%0*u',wid,val)),ext];
%
if nargin>3
    assert(islogical(otp)&&isscalar(otp),'Input <otp> must be scalar logical.')
    if otp
        name = fullfile(inpth,name);
    end
end
%
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%nextname