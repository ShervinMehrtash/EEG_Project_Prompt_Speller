clc; clear;

% Storing the initial time
Init_Time = GetSecs();
Start = datetime("now");

% Declaring Number of Trials
N = 12;

% Declaring Time of each Trial
TT = 10;

% Declaring Time of each Rest
RT = 5;

Screen('Preference', 'SkipSyncTests',1);
% PsychDebugWindowConfiguration

% Opening the window
[WinPointer, WinSize] = Screen('OpenWindow', 0);

% Defining the centers of Circles
Center1X = WinSize(3)/4 - 100; Center1Y = WinSize(4)/4 - 100;
Center2X = (3*WinSize(3))/4 + 100; Center2Y = WinSize(4)/4 - 100;
Center3X = WinSize(3)/4 - 100; Center3Y = (3*WinSize(4))/4 + 100;
Center4X = (3*WinSize(3))/4 + 100; Center4Y = (3*WinSize(4))/4 + 100;


% Text properties
Screen('TextFont', WinPointer, 'Arial');
Screen('TextSize', WinPointer, 26);
Screen('TextStyle', WinPointer, 1);

% Setting up the rectangles
rect1 = [Center1X - 125, Center1Y - 125, Center1X + 125, Center1Y + 125];
rect2 = [Center2X - 125, Center2Y - 125, Center2X + 125, Center2Y + 125];
rect3 = [Center3X - 125, Center3Y - 125, Center3X + 125, Center3Y + 125];
rect4 = [Center4X - 125, Center4Y - 125, Center4X + 125, Center4Y + 125];

% List of All rectangles
AllRects = [rect1, rect2, rect3, rect4];

% Setting the colors
WhiteColor = [230 230 230];
BackColor = [50 50 50];

% Set the flicker frequency in Hz
Hzs = [7.5, 8.57, 10, 12];

% Get the screen refresh rate in seconds
Frametime = Screen ('GetFlipInterval',WinPointer);

% Calculate the number of frames for each stimulus
FramesPerStims = round ( (1./Hzs)/Frametime);

% Initialize the frame counter
Framecounter = 1;

% Initializing the visibilities
rectVisible1 = 0;
rectVisible2 = 0;
rectVisible3 = 0;
rectVisible4 = 0;

TS = []; % Trials' Starting times
TE = []; % Trials' Ending times
%--------------------------------------
RS = []; % Rests' Starting times
RE = []; % Rests' Ending times
%--------------------------------------
NS = []; % Notifications' Starting times
NE = []; % Notifications' Ending times

% Randomization of trials
RandomRects = zeros(1, N);

numbers = [1, 2, 3, 4];

for i = numbers

    % Generate random positions for each number
    positions = randperm(N, N/4);
    
    % Check if the positions are already filled
    while any(RandomRects(positions) ~= 0)
        positions = randperm(N, N/4);
    end
    
    % Assign the number to the randomly selected positions
    RandomRects(positions) = i;
end

% Initializing the index of random rect
RandIndex = 1;

% Start the loop for 10 Seconds (Or any other required period)
while (Framecounter< (N * TT * 60))
   if mod(Framecounter,60 * TT) == 0
       TempTime1 = GetSecs();
       TE = [TE, TempTime1 - Init_Time];
       RS = [RS, TempTime1 - Init_Time];
       Screen('FillRect', WinPointer, BackColor, WinSize);
       Screen('DrawText', WinPointer, 'REST TIME STARTED', 1010, 700, WhiteColor);
       Screen('Flip', WinPointer);
       WaitSecs(RT);
       Framecounter = Framecounter + 1;
       TempTime2 = GetSecs();
       RE = [RE, TempTime2 - Init_Time];
   else
        if mod(Framecounter, TT * 60) == 1
            Screen ('FillRect', WinPointer, BackColor, WinSize);
            Screen ('Flip', WinPointer);
            TempTime3 = GetSecs();
            NS = [NS, TempTime3 - Init_Time];
            WaitSecs(0.7);
            RandRect = AllRects(1,(4 * RandomRects(RandIndex))-3 : (4 * RandomRects(RandIndex)));
            Screen ('FillRect', WinPointer, BackColor, WinSize);
            Screen ('FillRect', WinPointer, WhiteColor, RandRect);
            Screen ('Flip', WinPointer);
            WaitSecs(2.5);
            Screen ('FillRect', WinPointer, BackColor, WinSize);
            Screen ('Flip', WinPointer);
            WaitSecs(0.6);
            TempTime4 = GetSecs();
            NE = [NE, TempTime4 - Init_Time];
            TS = [TS, TempTime4 - Init_Time];
            RandIndex = RandIndex + 1;
        end

   % Toggle the rectangle visibility based on the frame counter
   if mod (Framecounter,FramesPerStims(1)) == 0
      rectVisible1 = ~rectVisible1;
   end
   if mod (Framecounter,FramesPerStims(2)) == 0
      rectVisible2 = ~rectVisible2;
   end
   if mod (Framecounter,FramesPerStims(3)) == 0
      rectVisible3 = ~rectVisible3;
   end
   if mod (Framecounter,FramesPerStims(4)) == 0
      rectVisible4 = ~rectVisible4;
   end
   
   Screen('FillRect', WinPointer, BackColor, WinSize);

   % Draw the rectangle if visible
   if rectVisible1
      Screen ('FillRect', WinPointer, WhiteColor, rect1);
   end
   if rectVisible2
      Screen ('FillRect', WinPointer, WhiteColor, rect2);
   end
   if rectVisible3
      Screen ('FillRect', WinPointer, WhiteColor, rect3);
   end
   if rectVisible4
      Screen ('FillRect', WinPointer, WhiteColor, rect4);
   end

   % Flip the screen
   Screen ('Flip',WinPointer);

   % Increase the frame counter6
   Framecounter = Framecounter + 1;
   end 
end

TempTime5 = GetSecs();
TE = [TE, TempTime5 - Init_Time];

% Final form of stored times and periods
TrialPeriods = [TS', TE'];
RestPeriods = [RS', RE'];
NotificationPeriods = [NS', NE'];

% Fixing the dimension of Rest arrays
RS = [RS, 0];
RE = [RE, 0];

% All time stamps
AllPeriods = [NS', TS', TE', RE'];

% Saving the workspace
save("Sub1-Run2(Nima Kamali).mat");

% Close the window
clear Screen;
