% GenerateConditionFil_MLDS.m
%
% This code is used to generate condition files for MLDS experiment.
% Input: 1) ; 2) 
% Output: Condition Files
% 
% 11/08/2016 Wenyan Bi wrote it.

%%
%WB% clear
clear; close all;

%WB% Setup Path
curDir=(pwd);

%
cd('functions');
if (~isempty(strfind(path,pwd))) == 0 
   addpath(genpath(pwd));
   savepath;
end

cd(curDir);


%% WB %% Define parameters & Get paths
%


%WB% 1. Define stimulus folder: stimFolder
%       Define the stimFileRoot: stimFileRoot

stimFolder = 'testVideos';
stimFileRoot = 'conditionOrder';




%WB% 2. Define subject:theSbj
defaultSbj = 'wb';
theSbj = input(sprintf('Enter subject name [%s]: ', defaultSbj), 's');
if (isempty(theSbj))
    theSbj = defaultSbj;
end




%WB% 3. Define the experiment condition:exptName    
defaultExpt = 'Bending_Cotton';
exptName = input(sprintf('Enter experiment name [%s]: ', defaultExpt), 's');
if (isempty(exptName))
    exptName = defaultExpt;   
end


switch exptName
    case 'Bending_Cotton'
        fprintf('Experiment name: %s \n', defaultExpt);   
    case 'Bending_Silk'
        fprintf('Experiment name: Bending_Silk\n');
    case 'Mass_Cotton'
        fprintf('Experiment name: Mass_Cotton\n');
    case 'Mass_Silk'
        fprintf('Experiment name: Mass_Silk\n');       
    otherwise
        %fprintf('Error! Create Stimuli Folder First!!\n');
        error ('Stimuli folder not found, create Stimuli Folder First!!')
end




%WB% 4. Define the subject directory: sbjDir
sbjDir = fullfile(exptName, 'resultsFolder',theSbj);
if (~exist(sbjDir, 'dir'))
    mkdir(sbjDir);
end


%WB% check if this obsever has generated condition files.
cd(sbjDir)
testname = 'conditionOrder_1.txt';
if ~isempty(dir(testname))
    cd(curDir);
    error('Condition file is already existed for subject: %s\nDelete the current condition file and retry. \n\n', theSbj);
else
    cd(curDir);
end


%WB% 5. Define Number of stimuli: nStimuli

%
%WB% Get all stimuli in the current stimDir
stimDir = fullfile(exptName, stimFolder);
d = dir(stimDir);
names = {d.name};  


%WB% Get unhidden files
numnames = length(names);
visible = logical(zeros(numnames, 1));
for n = 1:numnames
    name = names{n};
    if name(1) ~= '.'
        visible(n) = 1;
    end
end
names = names(visible); 


%WB% Default: use all stimuli
defaultnnStimuli = length(names);

nStimuli = input(sprintf('How many stimuli in this condition? (Default: use all videos [%d]): \n',defaultnnStimuli));
if (isempty(nStimuli))
    nStimuli = defaultnnStimuli;
end

%% Create stimuli pairs

% change the stim folder name based on experiment name.
%testFileName = fullfile(exptName, [stimFileRoot, '.txt']);

[nItems_rand,randomOrder] = triplePerm(nStimuli);
TotalTrials = length(nItems_rand);


%WB% 6. Define Number of blocks
defaultnBlock = 2;
nBlock= input(sprintf('There are %d trials in this experiment, you want to divide them into how many blocks? [%s]\n', TotalTrials, int2str(defaultnBlock)));
if (isempty(nBlock))
    nBlock = defaultnBlock;
end 


%% Generate condition file
%
TrialsInEachBlock = floor(TotalTrials/nBlock);
TrialsInLastBlock = TotalTrials-TrialsInEachBlock*(nBlock-1);
condition = 0;


%WB% (1: n-1) Blocks
for iBlock = 1:(nBlock-1)      
    for nTrials = 1:TrialsInEachBlock
        condition = condition +1;
        curCon = randomOrder(condition);
        conditionStruct(nTrials).conditions = curCon;
        conditionStruct(nTrials).block = iBlock;
        conditionStruct(nTrials).stimFolder = stimFolder;
        conditionStruct(nTrials).sample1 = nItems_rand(condition,1);
        conditionStruct(nTrials).sample2 = nItems_rand(condition,2);
        conditionStruct(nTrials).sample3 = nItems_rand(condition,3);
    end
    
    blockNumber = num2str(iBlock);
    
    % save the file into the subject folder
    newTestFileName = fullfile(sbjDir, [stimFileRoot, 'new_',blockNumber, '.txt']);
    fprintf('write condition file for subject,%s\n',theSbj);
    WriteStructsToText(newTestFileName , conditionStruct);
end



%WB% Last block
iBlock = nBlock;
for nTrials = 1:TrialsInLastBlock
    condition = condition +1;
    curCon = randomOrder(condition);
    conditionStruct(nTrials).conditions = curCon;
    conditionStruct(nTrials).block = iBlock;
    conditionStruct(nTrials).stimFolder = stimFolder;
    conditionStruct(nTrials).sample1 = nItems_rand(condition,1);
    conditionStruct(nTrials).sample2 = nItems_rand(condition,2);
    conditionStruct(nTrials).sample3 = nItems_rand(condition,3);
end
blockNumber = num2str(iBlock);

% save the file into the subject folder
newTestFileName = fullfile(sbjDir, [stimFileRoot, 'new_',blockNumber, '.txt']);
fprintf('write condition file for subject,%s\n',theSbj);
WriteStructsToText(newTestFileName , conditionStruct); 
        
%%      
cd(curDir);
        
