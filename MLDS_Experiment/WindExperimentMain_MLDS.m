%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Main experiment for triad MLDS experiments.
% 
% Author: Wenyan Bi
% Date: 11/08/2016.
% 
%
%==================== Initialization =====================================%
clc;clear all;
%Screen ('Preference','SkipSyncTests',1);

%[wb] get function path
curDir=(pwd);

cd('functions');
if (~isempty(strfind(path,pwd))) == 0 
   addpath(genpath(pwd));
   savepath;
end
cd(curDir);


%[wb] get psychtoolbox path
addpath(genpath('/Applications/Psychtoolbox'));

%[wb] Check for Opengl compatibility, abort otherwise:
AssertOpenGL;

%[wb] Initializing sound
%[wb] Reseed the random-number generator for each expt.
rand('state', sum(100 * clock));

%[wb] Make sure keyboard mapping is the same on all supported operating systems
%[wb] Apple MacOS/X, MS-Windows and GNU/Linux:
KbName('UnifyKeyNames');

%[wb] Init keyboard responses (caps doesn't matter)
% advancestudytrial = KbName('n');

%[wb] Anytime during the experiment, press 'e' to quit.
targetexitname = 'e';
targetcontinuename = 'c';

%[wb] these are the only keys that we need, exit and continue
targetexit = KbName(targetexitname);
targetcontinue = KbName(targetcontinuename);

%% =============================== Input ===================================%

%[wb] Define subject: theSbj
defaultSbj = 'wb';
theSbj = input(sprintf('Enter subject name [%s]: ', defaultSbj), 's');
if (isempty(theSbj))
    theSbj = defaultSbj;
end


%[wb] Define experiment: exptName
defaultExpt = 'Bending_Cotton';
exptName = input(sprintf('Enter experiment name [%s]: ', defaultExpt), 's');
if (isempty(exptName))
    exptName = defaultExpt;
end


%[wb] Ask for the block name: blockNumber
defaultBlock= '1'; % Block 1-5
blockNumber = input(sprintf('Which number of block to run [%s]: ',defaultBlock),'s');
if(isempty(blockNumber))
    blockNumber = defaultBlock; 
end
blockNumber = str2num(blockNumber); 


%[wb] change the condition file name based on the block. 
stimFileRootPrefix = 'conditionOrder_';
stimFileRoot = [stimFileRootPrefix,num2str(blockNumber)];


stimFolder  = 'testVideos';
conditionNameRoot = 'vid_';
%[wb] this used to be the duration of the viewing time.
duration= 20; % used to use 6, now use 8 for the timing expt.

%vidLength = 250;
%xCenter = 130;
%yCenter = 130;
%totalDuration = 20;

%% =========================== File handling ===============================%
%[wb] Reseed the random-number generator for each expt.
%[wb] Define filenames of input files and result file:
rootDir = pwd;
exptDir = fullfile(rootDir, exptName);
stimDir = fullfile(exptDir, stimFolder);
dataDir = fullfile(exptDir, 'resultsFolder');
subjectDir = fullfile(dataDir, theSbj);




% ==== Read condition file information. ==== %
if (~exist(exptDir, 'dir'))
    error ('Invalid exptDir (%s).', exptDir)
end

if (~exist(stimDir, 'dir'))
    error ('No test videos in the current exptDir (%s).', stimDir)
end

if (~exist(dataDir, 'dir'))
    mkdir(dataDir);
end

%[wb]: Generate the condition file for the current subject
if (~exist(subjectDir, 'dir'))
    GenerateConditionFil_MLDS(theSbj, subjectDir, stimFolder, stimFileRootPrefix, exptName, curDir);
end



%
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


%% [wb]: Get scence parameters
 defaultRect = '';
 theRect = input(sprintf('Enter the Rect (e.g., [0 0 800 600]):'), 's');
 if (isempty(theRect))
     Screen('Preference', 'SkipSyncTests', 1)
     screenNumber = max(Screen('Screens'));
     gray=GrayIndex(screenNumber);
     [w, theRect]=Screen('OpenWindow',screenNumber, gray);
     sca;
 else
     theRect = str2num(theRect);
 end

% [wb]: Try to load <GetParameters_MLDS_*.mat>
theParameterFile = ['GetParameters_MLDS_', num2str(theRect(3)), '*', num2str(theRect(4)), '.mat'];

% [wb]: If the parameter file doesn't exit
if ~isfile(theParameterFile)
    GetParameters_MLDS(theRect);
    theParameterFile = ['GetParameters_MLDS_', num2str(theRect(3)), '*', num2str(theRect(4)), '.mat'];
end



%% [wb]: Run experiments
if (strcmp(exptName, 'Bending_Silk') == 1)
    MLDS(theRect, theParameterFile);
elseif (strcmp(exptName, 'Bending_Cotton') == 1)
    MLDS(theRect, theParameterFile);
elseif (strcmp(exptName, 'Practice') == 1)
    MLDS(theRect, theParameterFile);
end


