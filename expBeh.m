clear all;

global G;
G = [];

%% 1. Initialize
KbName('UnifyKeyNames');

%% 2. Global parameters
%% 2.1. Default stuff
G.MEG = 0;

G.B = BitsiPim('');
G.validKeys = KbName('space');
G.distToScreen = .5;
G.screenWidth = .53;
G.maxWhite = 255; 
    
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

G.objPath = 'Stimuli/ObjectsBEH/';
G.duckyPath = 'Stimuli/DuckiesBEH/';
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
if (G.subjCfg.tempGapOrder == 0)
    G.blockType = { ...
        {'main', 0}; ...
        {'main', 0}; ...
        {'main', 0}; ...
        {'main', 0}; ...
        {'main', 0.3}; ...
        {'main', 0.3}; ...
        {'main', 0.3}; ...
        {'main', 0.3}; ...
    };
elseif (G.subjCfg.tempGapOrder == 1)
    G.blockType = { ...
        {'main', 0.3}; ...
        {'main', 0.3}; ...
        {'main', 0.3}; ...
        {'main', 0.3}; ...
        {'main', 0}; ...
        {'main', 0}; ...
        {'main', 0}; ...
        {'main', 0}; ...
    };
end    

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% DELETE THIS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%if (G.subjCfg.tempGapOrder == 0)
%    G.blockType = { ...
%        {'main', 0}; ...
%        {'main', 0.3}; ...
%    };
%elseif (G.subjCfg.tempGapOrder == 1)
%    G.blockType = { ...
%        {'main', 0.3}; ...
%        {'main', 0}; ...
%    };
%end    
%G.trainBlock.nNormal = G.trainBlock.nOddball;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% DELETE THIS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

G.nBlock = size(G.blockType, 1);

%% 3. Run experiment
% Full-screen loop
fullScreenLoop;

% Instructions
instructionsBehPre;

% Iterate over blocks
G.dataFile = cell(G.nBlock, 1);
G.logFile = cell(G.nBlock, 1);

for iBlock = 1:G.nBlock   
    if (iBlock == 5)
        instructionsBehMid;
    end
    
    switch G.blockType{iBlock}{1};
        case 'loc'
        case 'main'
            DrawFormattedText(G.pWindow, sprintf('Next: block %g/%g\n\nDetect the rubber duckies.\n\n\n\nPress the spacebar to begin.', iBlock, G.nBlock), 'center', 'center', G.textColor);
            Screen('Flip', G.pWindow);

            pause(0.5); 
            cfg = [];
            cfg.endTime = inf;
			cfg.validKeys = G.validKeys;
            getResponse(cfg);

            cfg.nNormal = G.trainBlock.nNormal;
            cfg.nOddball = G.trainBlock.nOddball;

            cfg.tempGap = G.blockType{iBlock}{2};          % In seconds
            [G.dataFile{iBlock}, G.logFile{iBlock}] = mainBlock(cfg);
    end
    
    DrawFormattedText(G.pWindow, sprintf('You just finished block %g/%g!\n\nFeel free to take a quick break.\n\n\n\nPress the spacebar to see the next instructions...', iBlock, G.nBlock), 'center', 'center', G.textColor);
    Screen('Flip', G.pWindow);

    pause(0.5); 
    cfg = [];
    cfg.endTime = inf;
	cfg.validKeys = G.validKeys;
    getResponse(cfg);       
end    

%% 4. Post-instructions
instructionsBehPost;

%% 5. End of experiment
% Save G
save([G.dataPath, 'G_Subj', num2str(G.curSubj), '_', G.datestr, '.mat'], 'G');

DrawFormattedText(G.pWindow, 'This is the end of the experiment!\n\n\n\nPlease call the researcher.', 'center', 'center', G.textColor);
Screen('Flip', G.pWindow);
waitForResearcher;

%% 5.1. Clean-up
sca;
ListenChar(0);
Priority(0);
G.B.close();
