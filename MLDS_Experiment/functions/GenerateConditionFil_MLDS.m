function GenerateConditionFil_MLDS(theSbj, subjectDir, stimFolder, stimFileRootPrefix, exptName, curDir)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% <GenerateConditionFil_MLDS.m>
%
% This code is used to generate condition files for tiplet MLDS experiment.
%
% Input:
%      * theSbj: 'wb';
%      * subjectDir: '/MLDS_Experiment/Bending_Cotton/resultsFolder/wb'
%      * stimFolder: 'testVideos';
%      * stimFileRootPrefix: 'conditionOrder';
%      * exptName: 'Bending_Cotton';
%      * curDir:
%
% Output: 
%      * Condition Files
% 
% 11/08/2016 Wenyan Bi <wb1918a@american.edu> wrote it.

%==========================================================================%



%% [WB]: Define parameters & Get paths
    switch exptName
        case 'Bending_Cotton'
            fprintf('Experiment name: %s \n', exptName);   
        case 'Bending_Silk'
            fprintf('Experiment name: %s \n', exptName);      
        otherwise
            error ('Stimuli folder <%s> not found, create Stimuli Folder First!!', exptName);
    end
    fprintf('Subject name: %s \n\n', theSbj);


    %[wb]: Create the subjectDir
    if (~exist(subjectDir, 'dir'))
        mkdir(subjectDir);
    end



    %[wb]: check if this obsever has generated condition files.
    cd(subjectDir)
    testname = [stimFileRootPrefix, '_*.txt'];

    if ~isempty(dir(testname))
        cd(curDir);
        warning('Existing condition files for subject: [%s], no new  files are generated. \n\n', theSbj);
    else
        cd(curDir);

        %% [wb]: Count the stimuli number
        %[wb]: Get all stimuli in the current stimDir
        stimDir = fullfile(exptName, stimFolder);
        d = dir(stimDir);
        names = {d.name};
        %[wb]: Get unhidden files
        numnames = length(names);
        visible = logical(zeros(numnames, 1));
        for n = 1:numnames
            name = names{n};
            if name(1) ~= '.'
                visible(n) = 1;
            end
        end
        names = names(visible);
        %[wb]: <Default> use all stimuli
        defaultnnStimuli = length(names);
        nStimuli = input(sprintf('How many stimuli in this condition? (Default: use all videos [%d]): \n',defaultnnStimuli));
        if (isempty(nStimuli))
            nStimuli = defaultnnStimuli;
        end

        %% [wb]:Create stimuli pairs
        [nItems_rand,randomOrder] = triplePerm(nStimuli);
        totalTrials = length(nItems_rand);
        %% [wb]: Define Number of blocks
        defaultnBlock = 2;
        nBlock= input(sprintf('There are %d trials in this experiment, how many blocks do you want to devide them into? [Default: %s]\n', totalTrials, int2str(defaultnBlock)));
        if (isempty(nBlock))
            nBlock = defaultnBlock;
        end 
        %% [wb]: Generate condition file
        trialsInEachBlock = floor(totalTrials/nBlock);
        trialsInLastBlock = totalTrials-trialsInEachBlock*(nBlock-1);
        condition = 0;

        % [wb]:(1: n-1) Blocks
        for iBlock = 1:(nBlock-1)      
            for nTrials = 1:trialsInEachBlock
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

            % [wb]: save the file into the subject folder
            newTestFileName = fullfile(subjectDir, [stimFileRootPrefix, blockNumber, '.txt']);
            fprintf('write the %d-th condition file for subject,%s\n',iBlock, theSbj);
            WriteStructsToText(newTestFileName , conditionStruct);
        end

        % [wb]: the last Block
        iBlock = nBlock;
        for nTrials = 1:trialsInLastBlock
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

        % [wb]: save the file into the subject folder
        newTestFileName = fullfile(subjectDir, [stimFileRootPrefix, blockNumber, '.txt']);
        fprintf('write the %d-th condition file for subject,%s\n',iBlock, theSbj);
        WriteStructsToText(newTestFileName , conditionStruct); 
    end
    cd(curDir);
end
        
