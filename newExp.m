% Irem Sultan Ilci //// Implicit Learning Experiment Code //// 27.06.2022
% Beep sound for every false response


% Clear the workspace and the screen
close all;
clear;
sca

KbName('UnifyKeyNames')

% info
Subj            =input('Participant ID? \n\n -->  '); clc;
Age             =input('Participant age? \n\n -->  '); clc;
Gender          =input('Participant gender? \n\n -->  '); clc;
HandPref        =input('right/left handed? \n\n -->  '); clc;

data = struct('Subj',[], 'Age', [], 'Gender',[],'HandPref',[],'trials',[], 'keyCodepre',[], 'keyCodepost',[],'keyCoderand',[], 'block', [], 'RTpre', [], 'RTrand', [],'RTpost', [],'correctpre',[],'correctpost', [], 'correctRan', []);

data.Subj = [data.Subj Subj];
data.Age = [data.Age Age];
data.Gender = [data.Gender Gender];
data.HandPref = [data.HandPref HandPref];

% Screen Settings
PsychDefaultSetup(2);
Screen('Preference', 'SkipSyncTests', 2); % Skip sync tests for demo purposes only
screens = Screen('Screens');
screenNumber = max(screens);
black = BlackIndex(screenNumber);
white = WhiteIndex(screenNumber);
[window, windowRect] = PsychImaging('OpenWindow', screenNumber, black);
Screen('BlendFunction', window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');
[screenXpixels, screenYpixels] = Screen('WindowSize', window);
[xCenter, yCenter] = RectCenter(windowRect);
ifi                      =   Screen('GetFlipInterval', window);
topPriorityLevel         =   MaxPriority(window);
HideCursor
Priority(topPriorityLevel);
Screen('Preference', 'TextRenderer', 0);

% Key Settings
keys=[71, 89, 85, 75, 27]; % [g, y, u, k, ESC] [Turkish Keyboard]
keyList  = zeros(1,256);
KbName('UnifyKeyNames');
keyList(keys)=1; 
% ------------------------ 
waitframes = 1;
numFrames = 1/ifi;



%% Show instructions

Instructions1 = 'In the experiment where the relevant keys are G-Y-U-K and these keys correspond to the numbers 1-2-3-4 respectively, you are expected to react according to the number displayed on the screen. \n\n In each block, the similar sequence is repeated a certain number of times, and the order of pressing the keys is ALWAYS the same. \n\nPress any key to continue.';
Instructions2 = 'For more information. \n Your goal in the experiment is to repeat the key sequence as often as possible during the practice phases. \n\n During quiet times set as ''''Please wait 30 seconds'''', please do not move your finger. \n\n Relax and don not worry about the key sequence. \n\nAfter pressing any key to start, the task will start in 3 seconds.';
Screen(window,'TextSize',30);

for i=1:2

DrawFormattedText(window, eval(['Instructions' num2str(i)]),'center','center', white, 60,[],[],2);
Screen('Flip',window);
WaitSecs(0.2)
KbWait
end

Screen('Flip',window);

% We set the text size to be nice and big here
Screen('TextSize', window, 300);
nominalFrameRate = Screen('NominalFrameRate', window);

%% 
% ---------Sequence--------------------
% fixed sequence(1-8. & 10. blocks)
seq = [4 2 3 1 3 2 4 3 2 1];

% for random sequence (9.block)
n = 10;k = 4;t = 5;
emdSeq = 1+mod(cumsum([randi(k,t,1),randi(k-1,t,n-1)],2),k);

% sequence for comparision
numemdSeq = zeros(size(seq));
numseq = zeros(size(seq));
for i = 1:size(seq,1)
    for j = 1:size(seq,2)
        if seq(i,j)==1 
            numseq(i,j)=71;
        elseif seq(i,j)==2
                numseq(i,j)=89;
                elseif seq(i,j)==3
                    numseq(i,j)=85; 
                    elseif seq(i,j)==4
                         numseq(i,j)=75;
        end
    end
end
for i = 1:size(emdSeq,1)
    for j = 1:size(emdSeq,2)
       if emdSeq(i,j)==1
           numemdSeq(i,j)=71;
       elseif emdSeq(i,j)==2
           numemdSeq(i,j)=89;
        elseif emdSeq(i,j)==3
                    numemdSeq(i,j)=85;
                    elseif  emdSeq(i,j)==4
                         numemdSeq(i,j)=75;
       end
   end
end

KbReleaseWait();
nTrials = 5;
totaln = nTrials* length(seq);
vbl = Screen('Flip',window);

pressMal = cell(1,nTrials);% initiliazation of the cell that inludes data about how many times the desired key is pressed

% ------Before the Experiment---------
for block = 1:8
for i = 1:size(seq,1)

    Screen('TextSize', window, 30);
    Text = strcat('Now you are going to perform  ', num2str(block),'. block \n\n Press any key to start');
    DrawFormattedText(window, Text, 'center', 'center', white);
    vbl = Screen('Flip', window, vbl + (waitframes - 0.5) * ifi);
    KbWait;
    WaitSecs(1);
   vbl = Screen('Flip', window, vbl + (waitframes - 0.5) * ifi);
   timeStart= zeros(1);
% ------Beginning of the Experiment--------

  for trials = 1:nTrials
     for j = 1 : size(seq, 2)
              
         numberString = num2str(seq(i, j));
         Screen(window,'TextSize',150);
         
            DrawFormattedText(window, numberString, 'center', 'center', white);
            Screen('Flip', window, vbl + (waitframes - 0.5) * ifi);
            WaitSecs(0.5);
            Screen('Flip', window, vbl + (waitframes - 0.5) * ifi);
 

         timeStart = GetSecs;
         keyIsDown = 0;
         while 1
             [keyIsDown, secs, keyCode, deltaSecs] = KbCheck;
             if keyIsDown && sum(keyCode)==1
                 data.RTpre = [data.RTpre, (secs-timeStart)];
                 data.keyCodepre = [data.keyCodepre find(keyCode)];
                 data.block = [data.block block];
                 data.trials      = [data.trials trials];
                 Screen('Flip', window);
                 break;
             else
                 keyIsDown = 0;
             end
         end
         Screen('Flip', window);
                
                 if numseq(i,j)~=find(keyCode)
                     Beeper;
                     correct = 0;
                     data.correctpre = [data.correctpre correct];
                 else
                     correct = 1;
                     data.correctpre = [data.correctpre correct];
                 end
            
     end
% meancorrectRT(block,trials)= sum(data.RT(find(data.correct==1)))/size(data.correct(data.correct==1),2);
   end
end  
Screen('Flip', window);   

% ----------Break Time-----------------    
      if i~=size(seq,1)
         Screen('TextSize', window, 50);
         DrawFormattedText(window, 'Please Wait 30 Seconds', 'center', 'center', white/2);
         Screen('Flip', window, vbl + (waitframes - 0.5) * ifi);
         WaitSecs(1);    

    %  ----Countdown ab 30 ----   
         Screen('TextSize', window, 150);
         presSecs = [sort(repmat(1:3, 1, nominalFrameRate), 'descend') 0];

        for i = 1:length(presSecs)

            numberString = num2str(presSecs(i));
            DrawFormattedText(window, numberString, 'center', 'center', white/2);
            Screen('Flip', window, vbl + (waitframes - 0.5) * ifi);
        end
      end
end
%       ------------------------- random

for block = 9:9
for i = 1:size(emdSeq,1)

    Screen('TextSize', window, 30);
    Text = strcat('Now you are going to perform  ', num2str(block),'. block \n\n Press any key to start');
    DrawFormattedText(window, Text, 'center', 'center', white);
    vbl = Screen('Flip', window, vbl + (waitframes - 0.5) * ifi);
    KbWait;
    WaitSecs(1);
   vbl = Screen('Flip', window, vbl + (waitframes - 0.5) * ifi);
   timeStart= zeros(1);
% ------Beginning of the Experiment--------

  for trials = 1:1
     for j = 1 : size(emdSeq, 2)
              
         numberPseudo = num2str(emdSeq(i, j));
         Screen(window,'TextSize',150);

            DrawFormattedText(window, numberPseudo, 'center', 'center', white);
            Screen('Flip', window, vbl + (waitframes - 0.5) * ifi);
            WaitSecs(0.5);
            Screen('Flip', window, vbl + (waitframes - 0.5) * ifi);


         timeStart = GetSecs;
         keyIsDown = 0;
         while 1
             [keyIsDown, secs, keyCode, deltaSecs] = KbCheck;
             if keyIsDown && sum(keyCode)==1
                 data.RTrand = [data.RTrand (secs-timeStart)];
                 data.keyCoderand = [data.keyCoderand find(keyCode)];
                 data.block = [data.block block];
                 data.trials     = [data.trials trials];
                 Screen('Flip', window);
                 break;
             else
                 keyIsDown = 0;
             end
         end
         Screen('Flip', window);
                
                 if numemdSeq(i,j)~=find(keyCode)
                     Beeper;
                     correct = 0;
                     data.correctRan = [data.correctRan correct];
                 else
                     correct = 1;
                     data.correctRan = [data.correctRan correct];
                 end
            
     end
% meancorrectRT(block,trials)= sum(data.RT(find(data.correct==1)))/size(data.correct(data.correct==1),2);
   end
end  
Screen('Flip', window);  

% ----------Break Time-----------------    
      if i~=size(seq,1)
         Screen('TextSize', window, 50);
         DrawFormattedText(window, 'Please Wait 30 Seconds', 'center', 'center', white/2);
         Screen('Flip', window, vbl + (waitframes - 0.5) * ifi);
         WaitSecs(1);    

    %  ----Countdown ab 30 ----   
         Screen('TextSize', window, 150);
         presSecs = [sort(repmat(1:3, 1, nominalFrameRate), 'descend') 0];

        for i = 1:length(presSecs)

            numberString = num2str(presSecs(i));
            DrawFormattedText(window, numberString, 'center', 'center', white/2);
            Screen('Flip', window, vbl + (waitframes - 0.5) * ifi);
        end
      end
end
%  --------------------------after random
      
      
for block = 10:10
for i = 1:size(seq,1)

    Screen('TextSize', window, 30);
    Text = strcat('Now you are going to perform  ', num2str(block),'. block \n\n Press any key to start');
    DrawFormattedText(window, Text, 'center', 'center', white);
    vbl = Screen('Flip', window, vbl + (waitframes - 0.5) * ifi);
    KbWait;
    WaitSecs(1);
   vbl = Screen('Flip', window, vbl + (waitframes - 0.5) * ifi);
   timeStart= zeros(1);
% ------Beginning of the Experiment--------

  for trials = 1:nTrials
     for j = 1 : size(seq, 2)
              
         numberString = num2str(seq(i, j));
         Screen(window,'TextSize',150);
         
            DrawFormattedText(window, numberString, 'center', 'center', white);
            Screen('Flip', window, vbl + (waitframes - 0.5) * ifi);
            WaitSecs(0.5);
            Screen('Flip', window, vbl + (waitframes - 0.5) * ifi);

         timeStart = GetSecs;
         keyIsDown = 0;
         while 1
             [keyIsDown, secs, keyCode, deltaSecs] = KbCheck;
             if keyIsDown && sum(keyCode)==1
                 data.RTpost = [data.RTpost (secs-timeStart)];
                 data.keyCodepost = [data.keyCodepost find(keyCode)];
                 data.block = [data.block block];
                 data.trials       = [data.trials trials];
                 Screen('Flip', window);
                 break;
             else
                 keyIsDown = 0;
             end
         end
         Screen('Flip', window);
                
                 if numseq(i,j)~=find(keyCode)
                     Beeper;
                     correct = 0;
                     data.correctpost = [data.correctpost correct];
                 else
                     correct = 1;
                     data.correctpost = [data.correctpost correct];
                 end
            
     end
% meancorrectRT(block,trials)= sum(data.RT(find(data.correct==1)))/size(data.correct(data.correct==1),2);
   end
end  
Screen('Flip', window); 

% ----------Break Time-----------------    
      if i~=size(seq,1)
         Screen('TextSize', window, 50);
         DrawFormattedText(window, 'Please Wait 30 Seconds', 'center', 'center', white/2);
         Screen('Flip', window, vbl + (waitframes - 0.5) * ifi);
         WaitSecs(1);    

    %  ----Countdown ab 30 ----   
         Screen('TextSize', window, 150);
         presSecs = [sort(repmat(1:3, 1, nominalFrameRate), 'descend') 0];

        for i = 1:length(presSecs)

            numberString = num2str(presSecs(i));
            DrawFormattedText(window, numberString, 'center', 'center', white/2);
            Screen('Flip', window, vbl + (waitframes - 0.5) * ifi);
        end
      end
      end
          
     
% -------End of the Experiment-----------

     Screen('TextSize', window, 30);
     DrawFormattedText(window, 'The experiment is completed. Thank you for your participation!' ,'center','center', white);
     Screen('Flip', window, vbl + (1 - 0.5) * ifi,0);        
%   Save
           save(['irem_son' num2str(Subj)], 'data')

% END

WaitSecs(1);
ShowCursor;
WaitSecs(1);
sca;
