clear all;

global G;
G = [];

%% 1. Initialize
KbName('UnifyKeyNames');

%% 2. Global parameters
%% 2.1. Default stuff
G.MEG = 0;

if G.MEG
    G.B = BitsiPim('COM1');
    G.validKeys = ['a']; 
    G.distToScreen = .8;
    G.screenWidth = .492;
    % 255 = 1820 cd/m2 on MEG propixx; this projector has a *linear* relation R/G/B <-> luminance          
    % According to Erik M., in cubicles the luminance ~300, which would be maxWhite = (300/1820)*255 = 42
    G.maxWhite = 42;
else
    G.B = BitsiPim('');
    G.validKeys = KbName('space');
    G.distToScreen = .7;
    G.screenWidth = .52;
    G.maxWhite = 255; 
end    
    
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
G.duckyPath = 'Stimuli/DuckiesMEG/';
G.subjCfgPath = 'subjCfg/';

%% 2.2. Query experimenter
% Subject number
%G.curSubj = input('Subject nr: ');
G.curSubj = 100;

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

% Load subject specific configuration
loadSubjCfg;

% Load stimuli into G
loadStimuli;

%% 3. Run experiment
DrawFormattedText(G.pWindow, 'Ready...', 'center', 'center', G.textColor);
Screen('Flip', G.pWindow);

cfg = [];
cfg.endTime = inf;
getResponse(cfg);

switch 3
    case 1
        cfg = [];
        
%        cfg.nNormal = [ ...
%            24, 6; ... 
%            15, 15; ...
%            6, 24; ...
%        ];
%        cfg.nOddball = [ ...
%            4, 0; ... 
%            2, 2; ...
%            0, 4; ...
%        ];
        
        cfg.nNormal = [ ...
            2, 1; ... 
            1, 1; ...
            1, 2; ...
        ];
        cfg.nOddball = [ ...
            1, 0; ... 
            1, 1; ...
            0, 1; ...
        ];

        cfg.tempGap = 0;          % In seconds
        
        [data, log] = mainBlock(cfg);
    case 2
        cfg = [];
        cfg.nNormal = [5, 5];
        cfg.nOddball = [3, 3];
        [data, log] = locBlock(cfg);
    case 3
        cfg = [];
        [data, log] = contTestBlock(cfg);        
end     

%% 4. End of experiment
% Save G
save([G.dataPath, 'G_Subj', num2str(G.curSubj), '_', G.datestr, '.mat'], 'G');

%% 4.1. Clean-up
sca;
ListenChar(0);
Priority(0);
G.B.close();
KbQueueRelease(G.keyboardNumber);
