% Analyze MLDS data
% AnalyzeMLDS.m
% 
% Prepare the data to be analyzed in R. 
%

clear all; close all
% prepare the data 
% Define subject
curDir  = pwd;
defaultSbj = 'wb';
theSbj = input(sprintf('Enter subject name [%s]: ', defaultSbj), 's');
if (isempty(theSbj)),
    theSbj = defaultSbj;
end
subjects ={theSbj};
subjectDir = theSbj;

defaultExpt = 'Bending_Silk';
exptName = input(sprintf('Enter experiment name [%s]: ', defaultExpt), 's');
if (isempty(exptName))
    exptName = defaultExpt;
end
dataDir = [exptName,'/','resultsFolder/'];
stimDir = [exptName,'/','testVideos/'];
nStim = 13;
nTrials = nchoosek(nStim,3);
%% load all the data
cd(dataDir)
cd(subjectDir)
filenameroot = [theSbj,'*.txt'];
dataFileNames = dir(filenameroot);
for i = 1:length(dataFileNames)
    filename = dataFileNames(i).name;
    theSubjectData{i,:} = ReadStructsFromText(filename); 
end
cd(curDir)

%% extract and prepare to the right format.
responseMat = zeros(nTrials,4);
k = 0; 
response = 0;
for n = 1: length(theSubjectData)
    for i = 1:length(theSubjectData{n})
        k = k +1;
        stimname1 = theSubjectData{n}(i).stim1;
        stimname2 = theSubjectData{n}(i).stim2;
        stimname3 = theSubjectData{n}(i).stim3;
        res = theSubjectData{n}(i).response;
        if (stimname1(1) == '/')
            stim1 = str2num(stimname1(6));
        else
            stim1 = str2num(stimname1(5:6));
        end
        if (stimname2(1) == '/')
            stim2 = str2num(stimname2(6));
        else
            stim2 = str2num(stimname2(5:6));
        end
        if (stimname3(1) == '/')
            stim3 = str2num(stimname3(6));
        else
            stim3 = str2num(stimname3(5:6));
        end

        if (res == 1)
            response = 0;
        end
        if (res == 2)
            response = 1;
        end
        % generate the response matrix. 
        % this requires sort the stimulus to ascending order of the
        % stiffnes values.         
        responseMat(k,:) = [response, stim1, stim2, stim3]';   
    end
end
%% save the data into a format that can be processed by R. 
cd(dataDir);
cd(subjectDir);
dlmwrite('mydata.txt',responseMat,'delimiter','\t');
cd(curDir);




