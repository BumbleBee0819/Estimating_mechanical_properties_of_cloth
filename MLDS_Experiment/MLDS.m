function MLDS
% Maxmium Likelihood scaling experiment (triads)
% Three videos/images are shown on the screen, participants judge which two
% looks more similar.
%


%%
Screen('Preference', 'SkipSyncTests', 1)
screenNumber = max(Screen('Screens'));
gray=GrayIndex(screenNumber);
[w, wRect]=Screen('OpenWindow',screenNumber, gray,[0 0 1200 800]);


%%
% 
%WB% get all paths. 
load('MLDS_path.mat');  
%WB% I am hard coded to load the GetParamerers_MLDS for debugging purpose:
load('GetParameters_MLDS_1200*800.mat');


%%WB% I need to be commented out for debugging purpose; For the actual experiment, I need to be uncommented.   
% get all parameters
%   try
%       load(['GetParameters_MLDS_',num2str(wRect(3)),'*',num2str(wRect(4)),'.mat']);
%   catch
%       clear mex;
%       clear all;
%       error ('Run <GetParameters_MLDS.m> to get parameters for this display screen first!!')
%   end
% %

% Results data file
  dataFileName = [theSbj, '_', exptName,'_',num2str(blockNumber),'_',expDate(1:6), expDate(10:11), '_',...
    num2str(expTime(4)), '_', num2str(expTime(5)), '.txt'];


%% =================  Instruction Screen =================================% 
% Read instrucion from file:
  fd = fopen('Instruction.m');

  Intro = '';
  tl = fgets(fd);
  lcount = 0;
  while lcount < 48
        Intro = [Intro tl]; 
        tl = fgets(fd);
        lcount = lcount + 1;
  end

    fclose(fd);
    Intro = [Intro char(10)];
% Get rid of '% ' symbols at the start of each line:
  Intro = strrep(Intro, '% ', '');
  Intro = strrep(Intro, '%', '');

  
  Screen ('TextSize', w, 26);
% Define test start postion (x,y)=(0.0078*wRect(3),0.0250*wRect(4))
  DrawFormattedText(w, Intro,0.0078*wRect(3),0.0250*wRect(4));
  Screen('Flip', w);

  
% Press q to move on
  flag = true;
  while flag
        KbWait();
        [keyIsDown, secs, keyCode, deltaSecs] = KbCheck; % Wait for and checkwhich key was pressed
         Intro_response = KbName(keyCode);   
         if Intro_response == 'q'
             flag = false;
         end
         
         if (keyCode(targetexit)) == 1
             Screen('CloseAll');
             ShowCursor;
             fclose('all');
             fprintf('Quit.\n');
             return;
         end
  end




 %% =================  Experiment ========================================%    
%WB% Preset parameters
ntrials = nConditions;
selectLeft = KbName('q');
selectRight = KbName('p');
targetexit = KbName ('e');

%WB% Set priority for script execution to realtime priority:
priorityLevel = MaxPriority(w);
Priority(priorityLevel);

%WB% Hide cursor
HideCursor;
%    
%

for trial=1:ntrials 
    %WB% wait a bit between trials
    trial
    WaitSecs(0.5);
      
      
    %% WB% ===== 1. Draw Fixation Cross ======%
    Screen('FillRect', w, color_white, FixCross_v);
    Screen('FillRect', w, color_white, FixCross_p);
    Screen('Flip', w);
      
    %WB% Fixation lasts for 800ms
    WaitSecs(0.8);
      
    %WB% initialize KbCheck and variables to make sure they're
    % properly initialized/allocted by Matlab - this to avoid time
    % delays in the critical reaction time measurement part of the script:
    [KeyIsDown, endrt, KeyCode] = KbCheck;
        
      
    %% WB% ===== 2. Show Stimuli ============= %
    %% WB% ===== 2.1.  read video stimulus       
    objName1 = [conditionNameRoot ,num2str(conditionStruct(trial).sample1),'.mov'];
    stimfilename1 = strcat(char(objName1)); % assume stims are in subfolder "stims"
    moviename{1} = fullfile(stimDir, stimfilename1);

    objName2 = [conditionNameRoot ,num2str(conditionStruct(trial).sample2),'.mov'];
    stimfilename2 = strcat(char(objName2)); % assume stims are in subfolder "stims"
    moviename{2} = fullfile(stimDir, stimfilename2);
        
    objName3 = [conditionNameRoot ,num2str(conditionStruct(trial).sample3),'.mov'];
    stimfilename2 = strcat(char(objName3)); % assume stims are in subfolder "stims"
    moviename{3} = fullfile(stimDir, stimfilename2);
      
    %objName4 = [conditionNameRoot ,num2str(conditionStruct(trial).sample4),'.mov'];
    %moviename{4}=strcat(char(objName4)); % assume stims are in subfolder "stims"

      
    movie1 = Screen('OpenMovie', w, moviename{1});
    movie2 = Screen('OpenMovie', w, moviename{2});
    movie3 = Screen('OpenMovie', w, moviename{3});
    %movie4 = Screen('OpenMovie', w, moviename{4});
        
    % play sound: indicates that video stimuli will come
    Snd('Play', sin(0:800), 8000);
    [VBLTimestamp, startrt] = Screen('Flip', w);

    %% WB %===== 2.2 Draw Texts.    
    %WB% draw "left", "center", "right" marker
    DrawFormattedText(w, 'Left',  movie1_text_x, movie1_text_y, WhiteIndex(w));
    DrawFormattedText(w, 'Center',  movie2_text_x, movie2_text_y, WhiteIndex(w));
    DrawFormattedText(w, 'Right',  movie3_text_x, movie3_text_y, WhiteIndex(w));
    
    %WB% draw title
    Screen('TextSize', w, title_size);    
    messagetitle1 = 'Which fabric, Left or Right, was more DIFFERENT in their bending stiffness from the Center\n\n Pay attention the intrinsinc mateiral properties, the wind direction might be different across videos\n Press q to choose the left or p to choose the right.\n';
    DrawFormattedText(w, messagetitle1, upper_title_x, upper_title_y, WhiteIndex(w));
    messagetitle2 = sprintf('Block %d/%d, Trial %d / %d, Press %s to quit.\n',blockNumber, 2, trial, ntrials, targetexitname);
    DrawFormattedText(w, messagetitle2, lower_title_x, lower_title_y, WhiteIndex(w));
    
    %% WB %===== 2.3.  display All Stimuli    
    Screen('PlayMovie', movie1, 1, 1, 0);
    Screen('PlayMovie', movie2, 1, 1, 0);
    Screen('PlayMovie', movie3, 1, 1, 0);
    %Screen('PlayMovie', movie4, 1, 1, 0);
    
  
    
    %WB% Playback loop: Runs until end of movie or keypress:
    res = 2.5; 
    tic;     
          
    %WB% won't move to next trial when: 
    % 1) looking time <= res(2.5s); 2) didn't select either of the three
    %      keys "targetexit", "selectLeft", "selectRight"
      
    while (toc<res || ~KeyIsDown || (KeyCode(targetexit) ~= 1 && KeyCode(selectLeft) ~= 1 && KeyCode(selectRight) ~= 1))
        [KeyIsDown, endrt, KeyCode] = KbCheck;
                  
        %WB% Wait for next movie frame, retrieve texture handle to it
        tex1 = Screen('GetMovieImage', w, movie1);
        tex2 = Screen('GetMovieImage', w, movie2);
        tex3 = Screen('GetMovieImage', w, movie3);
        %tex4 = Screen('GetMovieImage', w, movie4);
         
         
        %WB% Valid texture returned? A negative value means end of movie reached:
        if tex1>0 
            %WB% Draw the new texture immediately to screen:
            Screen('DrawTexture', w, tex1, [], rect1);
            %WB% Release texture:
            Screen('Close', tex1);
        end
         
        %WB% Valid texture returned? A negative value means end of movie reached:
        if tex2>0 
        %WB% Draw the new texture immediately to screen:
            Screen('DrawTexture', w, tex2, [], rect2);
            %WB% Release texture:
            Screen('Close', tex2);
        end         
                 
        %WB% Valid texture returned? A negative value means end of movie reached:
        if tex3>0 
            %WB% Draw the new texture immediately to screen:
            Screen('DrawTexture', w, tex3, [], rect3);
            %WB% Release texture:
            Screen('Close', tex3);
        end 

     
        
        %WB% Update display if there is anything to update:
        if (tex1 > 0 || tex2 > 0 || tex3 > 0)
            vbl=Screen('Flip', w, 0, 1);
        end
    end
      
    %WB% Reaction Time
    rt=round(1000*(endrt-startrt));
    
    
    %WB% Log response  
    if (KeyCode(targetexit) == 1)        %WB% Quit
        Screen('CloseAll');
        ShowCursor;
        fclose('all');
        Priority(0);
        fprintf('Quit.\n');
        cd(curDir);
        return;
    elseif (KeyCode(selectLeft) == 1)
        trialResp = int2str(1);
    elseif (KeyCode(selectRight) == 1)
        trialResp = int2str(2);
    end
      
    
    %WB% Stop playback:
    Screen('PlayMovie', movie1, 0);
    Screen('PlayMovie', movie2, 0);
    Screen('PlayMovie', movie3, 0);
    %Screen('PlayMovie', movie4, 0);

    
    %WB Close movie:
    Screen('CloseMovie', movie1);
    Screen('CloseMovie', movie2);
    Screen('CloseMovie', movie3);
    %Screen('CloseMovie', movie4);

        
    clear movie1 movie2 movie3
    clear tex1 tex2 tex3

 
    Snd('Play', sin(0:800), 10000)
    Screen('Flip', w);      
      
      
    %% WB % 2.4 ============== Write trial result to a structure ================% 
    subjectData(trial).subNo = theSbj;
    subjectData(trial).experimentName = exptName;
    subjectData(trial).trial = int2str(trial);
    subjectData(trial).stim1 = moviename{1}(end-9:end);
    subjectData(trial).stim2 = moviename{2}(end-9:end);
    subjectData(trial).stim3 = moviename{3}(end-9:end);
    subjectData(trial).response = trialResp;
    subjectData(trial).reactionTime = rt;
    fprintf('trial number %s\n',num2str(trial+1));  
    %WB% write data for each trial, in case the procedure freze halfway
    WriteStructsToText(fullfile(subjectDir, dataFileName), subjectData);
    fprintf('write data file for subject,%s\n',theSbj);

end %WB% Forloop each trial

    
 
%WB Cleanup at end of experiment - Close window, show mouse cursor, close
% result file, switch Matlab/Octave back to priority 0 -- normal priority:
Screen('Flip', w);
WaitSecs(0.500);
Screen('CloseAll');
ShowCursor;
fclose('all');
Priority(0);
cd(curDir);
% End of experiment:
return;