function GetParameters_MLDS(ScreenRect)
% To get parameters of the triads MLDS experiment:
% Three videos/images are shown on the screen, participants judge which two
% looks more similar.

% This code enables experimenter to modify:
% video/Image size, Screen size.
%  
% 11/08/2016 Wenyan Bi <wb1918a@american.edu> wrote it.


%% WB% 00. Define Color
  color_red = [255 0 0];
  %color_grey = [184 184 184];
  color_white = [255 255 255];
%  
%  
%% 0. Get font size and center of the screen: [X,Y],textRect_26,textRect_24
% Get screenNumber of stimulation display. We choose the display with
% the maximum index, which is usually the right one, e.g., the external
% display on a Laptop:
Screen('Preference', 'SkipSyncTests', 1)
screenNumber = max(Screen('Screens'));
% Returns as default the mean gray value of screen:
gray=GrayIndex(screenNumber);


if (nargin == 0)
    [w, wRect]=Screen('OpenWindow',screenNumber, gray);
else
    [w, wRect]=Screen('OpenWindow',screenNumber, gray, ScreenRect);
end



[X,Y] = RectCenter(wRect);
% Close the screen.
sca;


%% WB% 1. LISTS of SAVED & Changable PARAMETERS:
%%%%%%%%%%%%%%%%%%%%%%%%%%
% 1. Environment variable
% 
% # [X,Y]: screen center;
% # textRect_26(4): height of textsize 26;
% # textRect_24(4): height of textsize 24;
%
%%%%%%%%%%%%%%%%%%%%%%%%%%
% 2. Fixation
% 
  FixCross_w = 1; % change to larger number if want widder fixation;
  FixCross_h = 40; % change to larger number if want taller fixation; 
% # FixCross_v: vertical line of the fixation;
% # FixCross_p: parellel line of the fixation;
%
%%%%%%%%%%%%%%%%%%%%%%%%%%
% 3. Video/Image stimuli
%
% # video_width: width of the rescaled video stimuli (calculated from "original_video_width", default 1280);
% # video_height: height of the rescaled video stimuli (calculated from "original_video_height", default 720);
% # resize_video:   % If the video is too large to the screen, can resize the video size here.
  distance_mid = 0;  % "intervalBetweenVideos", change this value to make two videos closer.

  
% # rect1: position of the left video ([top-left-x,top-left-y,bottom-right-x, bottom-right-y]);
% # rect2: position of the middle video ();
% # rect3: position of the right video ([top-left-x,top-left-y,bottom-right-x, bottom-right-y]);
%
%%%%%%%%%%%%%%%%%%%%%%%%%%
% 4. Title
%   
% # title_size: Font size of the question title (input, default 26);
% # (title_x(i),title_y(i)): (x,y) position of i-th line of the title.
  upper_title_y = wRect(2) + 20;  % The title will starts at position x=10, change to larger number to move right.
  upper_title_x = wRect(1) + 10;

  lower_title_y = wRect(4) - 40;
  lower_title_x = wRect(1) + 10;
  title_size = 24;
%
%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  


%% 2. Fixation: FixCross_v,FixCross_p
% vertical line: FixCross_v = [top-left-x,top-left-y,bottom-right-x,bottom-right-y]
FixCross_v = [X-FixCross_w,Y-FixCross_h,X+FixCross_w,Y+FixCross_h];
% parallel line: 
FixCross_p = [X-FixCross_h,Y-FixCross_w,X+FixCross_h,Y+FixCross_w];

% clear up
clear FixCross_w FixCross_h;

%% 3. Position of the three video stimuli: video_width, video_height, rect1,rect2
% Get size of the original video;
 fprintf ('\n\n[1]. Initializing video stimuli ...\n\n');
 default_original_video_width = 1280; 
 default_original_video_height = 720;
 
 original_video_width = input('(1.1)What is the width of the video stimuli (defult 1280)?\n');
 if (isempty(original_video_width))
     original_video_width = default_original_video_width;
 end 
 
 
 original_video_height=input('(1.2) What is the height of the video stimuli (defult 720)?\n');
 if (isempty(original_video_height))
     original_video_height = default_original_video_height;
 end 
 
 
 clear default_original_video_width default_original_video_height;
 
%
resize_video=[];
default_resize_video=0.5;

while (isempty(resize_video))
      if (isempty(resize_video))
            resize_video = input(sprintf('(1.3) Do you want to resize the video? Put a number between 0~1 (default [%s]). \n', num2str(default_resize_video)));
            
            if (isempty(resize_video))
                resize_video = default_resize_video;
            end 
      end
      
      % Get the size of the rescaled video that suits the screen 
      video_width= resize_video * original_video_width;
      video_height = resize_video * original_video_height;
      
      
      %WB% Check width
      if (video_width*3)> wRect(3)
          warning('Video is too wide for the current sceen, change the <resize_video> to smaller number!!\n');
          resize_video=[];
      end
      %WB% Check height
      if (Y - video_height * 0.8 < 0) || (Y + video_height * 0.8 > wRect(4))  
         warning ('Video is too high for the current sceen, change the <resize_video> to smaller number!!\n');
         resize_video=[];
      end
end
      


%WB% rect1 is the rect of the left video; rect2 is the rect of the middle video; rect3 is the rect of the right video.                   
rect1 = [X - video_width * 1.5, Y - video_height * 0.8, X - video_width * 0.5, Y + video_height * 0.2];
rect2 = [X - video_width * 0.5, Y - video_height * 0.2, X + video_width * 0.5, Y + video_height * 0.8];
rect3 = [X + video_width * 0.5, Y - video_height * 0.8, X + video_width * 1.5, Y + video_height * 0.2];
% clear up
clear distance_mid default_video_width default_video_height resize_video intervalBetweenVideos;



%% 5. Title of the video
% font size
dis_from_title_to_video = 20;

movie1_text_x = rect1(1) + 0.5 * (rect1(3) - rect1(1));
movie1_text_y = rect1(2) - dis_from_title_to_video;
    
movie2_text_x = rect2(1) + 0.5 * (rect2(3) - rect2(1));
movie2_text_y = rect2(2) - dis_from_title_to_video;

movie3_text_x = rect3(1) + 0.5 * (rect3(3) - rect3(1));
movie3_text_y = rect3(2) - dis_from_title_to_video;

%% clear up all useless variables.    
 clear dis_from_title_to_video default_resize_video gray original_video_height original_video_width screenNumber ...
     video_height video_width w X Y;

 fprintf ('\n\nFile is successfully generated!\n')
 fprintf ('You can change other parameters in <LISTS of SAVED & Changable PARAMETERS> setion of this code if you want.\n');

 save(['GetParameters_MLDS_',num2str(wRect(3)),'*',num2str(wRect(4)),'.mat']);
 close all;
end
