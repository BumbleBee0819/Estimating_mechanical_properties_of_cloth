%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Main experiment for triad MLDS experiments.
%
%==================== Initialization =====================================%
%==================== Initialization =====================================%
clc;clear all;

%Screen ('Preference','SkipSyncTests',1);

%% WB %% Initial Setup
% get function path
curDir=(pwd);

cd('functions');
if (~isempty(strfind(path,pwd))) == 0 
   addpath(genpath(pwd));
   savepath;
end
cd(curDir);

%WB% get psychtoolbox path
addpath(genpath('/Applications/Psychtoolbox'));

%WB% Check for Opengl compatibility, abort otherwise:
AssertOpenGL;

%WB% Initializing sound
%WB% Reseed the random-number generator for each expt.
rand('state', sum(100 * clock));

%WB% Make sure keyboard mapping is the same on all supported operating systems
%WB% Apple MacOS/X, MS-Windows and GNU/Linux:
KbName('UnifyKeyNames');

%WB% Init keyboard responses (caps doesn't matter)
% advancestudytrial = KbName('n');

%WB% Anytime during the experiment, press 'e' to quit.
targetexitname = 'e';
targetcontinuename = 'c';

%WB% these are the only keys that we need, exit and continue
targetexit = KbName(targetexitname);
targetcontinue = KbName(targetcontinuename);

%=============================== Input ===================================%

%WB% Ask for current subject
defaultSbj = 'wb';
theSbj = input(sprintf('Enter subject name [%s]: ', defaultSbj), 's');
if (isempty(theSbj)),
    theSbj = defaultSbj;
end;


%WB% Ask for current experiment name
defaultExpt = 'Bending_Cotton';
exptName = input(sprintf('Enter experiment name [%s]: ', defaultExpt), 's');
if (isempty(exptName))
    exptName = defaultExpt;
end;


%WB% Ask for the block name.
defaultBlock= '1'; % Block 1-5
blockNumber = input(sprintf('Which number of block to run [%s]: ',defaultBlock),'s');
if(isempty(blockNumber))
    blockNumber = defaultBlock; 
end
blockNumber = str2num(blockNumber); %#ok<ST2NM>


%WB% change the condition file name based on the block. 
stimFileRoot = ['conditionOrdernew','_',num2str(blockNumber)];


stimFolder  = 'testVideos';
conditionNameRoot = 'vid_';
%sec this used to be the duration of the viewing time.
duration= 20; % used to use 6, now use 8 for the timing expt.

vidLength = 250;
xCenter = 130;
yCenter = 130;
totalDuration = 20;

%=========================== File handling ===============================%
%WB% Reseed the random-number generator for each expt.
%WB% Define filenames of input files and result file:
curDir = pwd;
rootDir = curDir;
exptDir = fullfile(rootDir, exptName);
stimDir = fullfile(exptDir, stimFolder);
dataDir = fullfile(exptDir, 'resultsFolder');
subjectDir = fullfile(dataDir, theSbj);
%setDir = fullfile(exptDir, setName);
%setFile = fullfile(setDir, sprintf('%s_%s', exptName, setName));


%WB% === Read condition file information. ====%
if (~exist(exptDir, 'dir')),
    mkdir(exptDir);
end;
if (~exist(stimDir, 'dir')),
    mkdir(stimDir);
end;
if (~exist(dataDir, 'dir')),
    mkdir(stimDir);
end;
if (~exist(subjectDir, 'dir')),
    mkdir(subjectDir);
end;



if (strcmp(exptName, 'Bending_Silk') == 1)
    testFileName = fullfile(subjectDir, [stimFileRoot, '.txt']);
    fprintf('using condition file,%s\n',testFileName);
    
elseif (strcmp(exptName, 'Bending_Cotton') == 1)
    testFileName = fullfile(subjectDir, [stimFileRoot, '.txt']);
    
elseif (strcmp(exptName, 'Practice') == 1)
    testFileName = fullfile(subjectDir, [stimFileRoot, '.txt']);
    fprintf('using condition file,%s\n',testFileName)
    
else
    error ('No such experiment!')
end


conditionStruct = ReadStructsFromText(testFileName);
nConditions = length(conditionStruct);
expDate = date;
expTime = clock;

save('MLDS_path.mat');


%WB% Run experiments
if (strcmp(exptName, 'Bending_Silk') == 1)
    MLDS;
elseif (strcmp(exptName, 'Bending_Cotton') == 1)
    MLDS;
elseif (strcmp(exptName, 'Practice') == 1)
    MLDS;
end


