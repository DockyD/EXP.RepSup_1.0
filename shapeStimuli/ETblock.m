function [dataFile, logFile] = ETblock(cfg0)

global G;

log = [];
log.cfg0 = cfg0;
log.datestr = datestr(now, 'dd-mmm-yyyy_HH-MM-SS');
log.interrupt = [];

%% Generate stimulus conditions
nCond = size(G.ET.positions, 1);

cond = zeros(nCond*cfg0.nTrial, 1);
for iRep = 1:cfg0.nTrial
    tmp = (1:nCond) - 1;
    
    if cfg0.randomize
        tmp = tmp(randperm(nCond));
    end
    
    cond((1:nCond) + (iRep-1)*nCond) = tmp;
end

nTrial = cfg0.nTrial*nCond;

%% Initialize
dataFile = [G.dataPath, 'dataSubj', num2str(G.curSubj), '_', log.datestr, '.mat'];
logFile = [G.logPath, 'logSubj', num2str(G.curSubj), '_', log.datestr, '.mat'];

data = nan(nTrial, 3);
log.trial = cell(nTrial, 1);

%% Loop over trials
% Start with fixation dot
Screen('DrawDots', G.pWindow, [0, 0], G.fixDotSize*G.pixPerDeg, 0, G.screenCenter, 1);
Screen('DrawDots', G.pWindow, [0, 0], 0.5*G.fixDotSize*G.pixPerDeg, G.fixDotColor, G.screenCenter, 1);
time = Screen('Flip', G.pWindow);
log.preFixOnset = time;

nextOnset = time + 2;

for in = 1:nTrial
    % Do trial
    cfg = [];
    cfg.iPosition = cond(in);
    cfg.nextOnset = nextOnset;
    
	[~, log.trial{in}] = ETtrial(cfg);

    % Store data
    nextOnset = log.trial{in}.lastOnset + G.ET.ITI;
    
    data(in, :) = [in, G.ET.positions(cond(in)+1, :)];
   
    % Save data to disk
    save(dataFile, 'data', '-v6');
    save(logFile, 'log', '-v6');
    
    % Interrupt trial?
    [~, ~, keyCode] = KbCheck;
    if (ismember(G.interrupt, find(keyCode)))
        DrawFormattedText(G.pWindow, 'Experiment temporarily interrupted by researcher.\n\nPlease wait...', 'center', 'center', 255);
        Screen('Flip', G.pWindow);
        
        waitForResearcher;
        
        Screen('DrawDots', G.pWindow, [0, 0], G.fixDotSize*G.pixPerDeg, 255, G.screenCenter, 1);
        time = Screen('Flip', G.pWindow);

        nextOnset = time + 2;
    end
end

Screen('Flip', G.pWindow, nextOnset);

end
