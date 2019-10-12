%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Analyze triplet MLDS data.
% 
% Prepare the data to be analyzed in R. 
%
% Output: <mydata.txt>
%
% author: Wenyan Bi <wb1918a@american.edu>

clear all; close all;

%%
% Define subject
curDir  = pwd;
cd ..
rootDir = pwd;

try
    % [wb]: Get the subject name
    defaultSbj = 'wb';
    theSbj = input(sprintf('Enter subject name [%s]: ', defaultSbj), 's');
    if (isempty(theSbj)),
        theSbj = defaultSbj;
    end
    subjects ={theSbj};

    % [wb]: Get the experiment name
    defaultExpt = 'Bending_Silk';
    exptName = input(sprintf('Enter experiment name [%s]: ', defaultExpt), 's');
    if (isempty(exptName))
        exptName = defaultExpt;
    end

    % [wb]: Get the stimuli number
    default_nStim = 13;
    nStim = input(sprintf('Enter the video number [%s]: ', num2str(default_nStim)), 's');
    if (isempty(nStim))
        nStim = default_nStim;
    else
        nStim = str2num(nStim);
    end


    dataDir = [rootDir, '/',exptName,'/','resultsFolder/'];
    stimDir = [rootDir, '/',exptName,'/','testVideos/'];
    subjectDir = fullfile(dataDir, theSbj);

    nTrials = nchoosek(nStim,3);



    %% load all the data
    filenameroot = fullfile(subjectDir, [theSbj,'*.txt']);
    dataFileNames = dir(filenameroot);
    for i = 1:length(dataFileNames)
        filename = dataFileNames(i).name;
        theSubjectData{i,:} = ReadStructsFromText(fullfile(subjectDir, filename)); 
    end

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
            % [wb]: generate the response matrix. 
            % this requires sort the stimulus to ascending order of the
            % stiffnes values.         
            responseMat(k,:) = [response, stim1, stim2, stim3]';   
        end
    end
    %% [wb]: save the data into a format that can be processed by R. 
    cd(subjectDir);
    dlmwrite('mydata.txt',responseMat,'delimiter','\t');
    cd(curDir);
    
catch
    cd(curDir);
    error('Error!');
end




