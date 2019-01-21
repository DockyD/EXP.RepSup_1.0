%main script to run experiment
clear all;

global G;
G = [];

%% 1. Initialize
KbName('UnifyKeyNames');

%% 2. Global parameters
%% 2.1. Default stuff
G.MEG = 1; %may be useful for debugging/piloting?

G.B = BitsiPim('COM1');
G.validKeys = ['a']; 
G.distToScreen = .8;
G.screenWidth = .487;

% 255 = 1820 cd/m2 on MEG propixx; this projector has a *linear* relation R/G/B <-> luminance          
% According to Erik M., in cubicles the luminance ~300, which would be maxWhite = (300/1820)*255 = 42
%    G.maxWhite = 42;
G.maxWhite = 42;
     
G.triggers = defTriggers;
G.interrupt = KbName('F8');
G.keyboardNumber = max(GetKeyboardIndices);
G.pressLag = .005;

G.BGcolor = G.maxWhite;          % 255 = 1820 cd/m2 on MEG propixx; this projector has a *linear* relation R/G/B <-> luminance
G.textColor = 0;
G.datestr = datestr(now, 'dd-mmm-yyyy_HH-MM-SS');
G.now = now;
G.matlabVersion = version;
G.PTBversion = PsychtoolboxVersion;
G.computer = Screen('Computer');

G.objPath = 'Stimuli/ObjectsMEG/';
G.subjCfgPath = 'subjCfg/';

%% 2.2. Query experimenter
% Subject number
G.curSubj = input('Subject nr: ');

% Create data and log paths
G.dataPath = ['Data - Subj', num2str(G.curSubj), '/'];
G.logPath = [G.dataPath, 'Log/'];
if (~exist(G.dataPath))
    mkdir(G.dataPath);
end
if (~exist(G.logPath))
    mkdir(G.logPath);
end

%% 2.3. Screen related stuff and more initialization
allScreens = Screen('Screens');
G.pWindow = Screen('OpenWindow', allScreens(1), G.BGcolor);
[G.screenResX, G.screenResY] = Screen('WindowSize', G.pWindow);
Screen('BlendFunction', G.pWindow, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
G.screenCenter = [G.screenResX/2, G.screenResY/2];
G.pixPerDeg = (tan(pi/180)*G.distToScreen*G.screenResX)/G.screenWidth;

if IsOSX
    G.frameDur = 1/60;
else    
    G.frameDur = 1/Screen('NominalFrameRate', G.pWindow);
end    
G.flipLag = .9 * G.frameDur;

Screen('TextFont', G.pWindow, 'Arial');
Screen('TextSize', G.pWindow, 16);
Screen('TextStyle', G.pWindow, 0);

Priority(MaxPriority(G.pWindow));
HideCursor;
ListenChar(2);

%RandStream.setDefaultStream(RandStream('mt19937ar','seed',sum(100*clock)));
G.rngSeed = rng('shuffle');

%% 2.4. Load experiment specific parameters
defParams;

% Load subject specific parameters
loadSubjCfg;

% Load stimuli into G
loadStimuli;

% Define blocks
if (G.subjCfg.Order == 0)
    G.blockType = { ...
        {'cont'}; ...
        {'mask'}; ...
        {'cont'}; ...
        {'mask'}; ...        
        {'cont'}; ...
        {'mask'}; ...
        {'cont'}; ...
        {'mask'}; ...
        {'cont'}; ...
        {'mask'}; ...
    };
elseif (G.subjCfg.Order == 1)
    G.blockType = { ...
        {'mask'}; ...
        {'cont'}; ...
        {'mask'}; ...
        {'cont'}; ...
        {'mask'}; ...        
        {'cont'}; ...
        {'mask'}; ...
        {'cont'}; ...
        {'mask'}; ...
        {'cont'}; ...
    };
end

G.nBlock = size(G.blockType, 1);

%% 3. Run experiment
% Full-screen loop, introduction
fullScreenLoop;

DrawFormattedText(G.pWindow, [ ...
    'Welcome to the repeated images MEG experiment!\n' ...
    'Firstly, we would like to thank you for your participation!\n\n' ...
    'Secondly, we would like to tell you a little bit about the experiment you are about to do...\n\n\n\n' ...
    'Press the button to continue.'
    ], 'center', 'center', G.textColor, [], [], [], 1.5);
Screen('Flip', G.pWindow);

pause(0.5); 

cfg = [];
cfg.endTime = inf;
cfg.validKeys = G.validKeys;
getResponse(cfg);

DrawFormattedText(G.pWindow, [ ...
    'In this experiment, we are interested in how the brain behaves when viewing familiar images.\n\n' ...
    'You can therefore expect to spend the next hour looking at the same images over and over.\n\n' ...
    'You will have a main task while viewing these images, which we will tell you about in just a moment.\n\n\n\n' ...
    'Press the button to continue.'
    ], 'center', 'center', G.textColor, [], [], [], 1.5);
Screen('Flip', G.pWindow);

pause(0.5); 

cfg = [];
cfg.endTime = inf;
cfg.validKeys = G.validKeys;
getResponse(cfg);

% Eye-tracker calibration
DrawFormattedText(G.pWindow, [ ...
    'But first, we need to quickly finetune the eye-tracker we will be using today.\n\n' ...
    'On the next screen, a dot will move to various spots on the screen,\n\n' ...
    'Please follow the dot with your eyes.\n\n\n' ...
    'If you have any questions about this task or any other task during the experiment,\n\n\' ...
    'Please do not hesitate to ask the experimenter.\n\n\n\n' ...\    
    'If the instructions are clear, press the button to begin!'
    ], 'center', 'center', G.textColor, [], [], [], 1.5);
Screen('Flip', G.pWindow);

pause(0.5); 

cfg = [];
cfg.endTime = inf;
cfg.validKeys = G.validKeys;
getResponse(cfg);

cfg = [];
cfg.nTrial = 1;                 % Per position
cfg.randomize = 1;
[G.ETdataFiles{1}, G.ETlogFiles{1}] = ETblock(cfg);

% Instructions
instructionsMEGpre;

% Iterate over blocks
G.dataFile = cell(G.nBlock, 1);
G.logFile = cell(G.nBlock, 1);

for iBlock = 1:G.nBlock   
    if (iBlock == 3)
        instructionsMEGducky;
    elseif (iBlock == 9);
        instructionsMEGmid;
    end
    
    switch G.blockType{iBlock}{1};
        case 'cont'
            DrawFormattedText(G.pWindow, sprintf('Block %g/%g\n\n\nPress any button to begin.', iBlock, G.nBlock), 'center', 'center', G.textColor);
            Screen('Flip', G.pWindow);
            
            pause(0.5); 
            cfg = [];
            cfg.endTime = inf;
			cfg.validKeys = G.validKeys;
            getResponse(cfg);

            cfg = [];
            cfg.nNormal = G.locBlock.nNormal;
            cfg.nOddball = G.locBlock.nOddball;
            [G.dataFile{iBlock}, G.logFile{iBlock}] = locBlock(cfg);
        case 'mask'
            DrawFormattedText(G.pWindow, sprintf('Block %g/%g\n\n\nPress any button to begin.', iBlock, G.nBlock), 'center', 'center', G.textColor);
            Screen('Flip', G.pWindow);

            pause(0.5); 
            cfg = [];
            cfg.endTime = inf;
			cfg.validKeys = G.validKeys;
            getResponse(cfg);

            cfg.nNormal = G.mainBlock.nNormal;
            cfg.nOddball = G.mainBlock.nOddball;

            cfg.tempGap = G.blockType{iBlock}{2};          % In seconds
            [G.dataFile{iBlock}, G.logFile{iBlock}] = mainBlock(cfg);
    end
    
    DrawFormattedText(G.pWindow, sprintf('You just finished block %g/%g!\n\nFeel free to take a quick break.\n\n\n\nPress the button to see the next instructions...', iBlock, G.nBlock), 'center', 'center', G.textColor);
    Screen('Flip', G.pWindow);

    pause(0.5); 
    cfg = [];
    cfg.endTime = inf;
	cfg.validKeys = G.validKeys;
    getResponse(cfg);    
end    

% Eye-tracker calibration
DrawFormattedText(G.pWindow, [ ...
    'Excellent! We''re almost done.\n' ...
    'We need to do one more eye-tracker calibration.\n\n' ...
    'Just as before, a dot will move around the screen.\n' ...
    'Please follow the dot with your eyes.\n\n\n\n' ...
    'Press the button to begin!'
    ], 'center', 'center', G.textColor, [], [], [], 1.5);
Screen('Flip', G.pWindow);

pause(0.5); 

cfg = [];
cfg.endTime = inf;
cfg.validKeys = G.validKeys;
getResponse(cfg);

cfg = [];
cfg.nTrial = 1;                 % Per position
cfg.randomize = 1;
[G.ETdataFiles{2}, G.ETlogFiles{2}] = ETblock(cfg);

%% 4. End of experiment
% Save G
save([G.dataPath, 'G_Subj', num2str(G.curSubj), '_', G.datestr, '.mat'], 'G');

DrawFormattedText(G.pWindow, 'This is the end of the experiment!\n\nThank you very much for your participation!', 'center', 'center', G.textColor);
Screen('Flip', G.pWindow);
waitForResearcher;

%% 4.1. Clean-up
sca;
ListenChar(0);
Priority(0);
G.B.close();