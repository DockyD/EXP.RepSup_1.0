function [data, log] = mainTrial(cfg0)

global G;

%% Initialize variables
data = [];
data.resp = nan;
data.RT = nan;
data.correct = nan;

nextOnset = cfg0.nextOnset;

log = [];
log.cfg0 = cfg0;
log.onsets = [];

%% Present stimulus before oddball
pStim = Screen('MakeTexture', G.pWindow, G.stim2{cfg0.stim});
Screen('DrawTexture', G.pWindow, pStim);

% Superimpose fixation
Screen('DrawDots', G.pWindow, [0, 0], G.fixDotSize*G.pixPerDeg, 0, G.screenCenter, 1);
Screen('DrawDots', G.pWindow, [0, 0], 0.5*G.fixDotSize*G.pixPerDeg, G.fixDotColor, G.screenCenter, 1);

% Flip
time = Screen('Flip', G.pWindow, nextOnset - G.flipLag);
G.B.sendTrigger(G.triggers.locBlock.stimOn + cfg0.stim); %adds to trigger value 
log.onsets = [log.onsets, time];

nextOnset = time + G.locBlock.stimDurPreOddball;

%% Present stimulus and oddball
Screen('DrawTexture', G.pWindow, pStim);

% Superimpose fixation
Screen('DrawDots', G.pWindow, [0, 0], G.fixDotSize*G.pixPerDeg, 0, G.screenCenter, 1);
if ~cfg0.oddball
    Screen('DrawDots', G.pWindow, [0, 0], 0.5*G.fixDotSize*G.pixPerDeg, G.fixDotColor, G.screenCenter, 1);
end

% Flip
time = Screen('Flip', G.pWindow, nextOnset - G.flipLag);
G.B.sendTrigger(G.triggers.locBlock.oddballOn + cfg0.oddball);
log.onsets = [log.onsets, time];
timeOnset = time;

nextOnset = time + G.locBlock.oddballDur;

cfg = [];
cfg.validKeys = G.validKeys;
cfg.endTime = nextOnset - G.pressLag;    
[data.resp, log.respTime] = getResponse(cfg);

%% Present stimulus
Screen('DrawTexture', G.pWindow, pStim);

% Superimpose fixation
Screen('DrawDots', G.pWindow, [0, 0], G.fixDotSize*G.pixPerDeg, 0, G.screenCenter, 1);
Screen('DrawDots', G.pWindow, [0, 0], 0.5*G.fixDotSize*G.pixPerDeg, G.fixDotColor, G.screenCenter, 1);

% Flip
time = Screen('Flip', G.pWindow, nextOnset - G.flipLag);
log.onsets = [log.onsets, time];

nextOnset = time + G.locBlock.stimDurPostOddball;

if isnan(data.resp)
    cfg = [];
    cfg.validKeys = G.validKeys;
    cfg.endTime = nextOnset - G.pressLag;    
    [data.resp, log.respTime] = getResponse(cfg);
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Present mask
if cfg0.mask
    G.B.sendTrigger(G.triggers.locBlock.mask);
    for i in 10
        mStim = Screen('MakeTexture', G.pWindow, G.stim2{cfg0.stim});
        Screen('DrawTexture', G.pWindow, mStim);
        Screen('DrawDots', G.pWindow, [0, 0], G.fixDotSize*G.pixPerDeg, 0, G.screenCenter, 1);
        Screen('DrawDots', G.pWindow, [0, 0], 0.5*G.fixDotSize*G.pixPerDeg, G.fixDotColor, G.screenCenter, 1);
        nextOnset = time + 0.5;
        time = Screen('Flip', G.pWindow,nextOnset- g.flipLag);
    %% Present post-stimulus fixation dot minus mask time length
    Screen('DrawDots', G.pWindow, [0, 0], G.fixDotSize*G.pixPerDeg, 0, G.screenCenter, 1);
    Screen('DrawDots', G.pWindow, [0, 0], 0.5*G.fixDotSize*G.pixPerDeg, G.fixDotColor, G.screenCenter, 1);

    G.B.sendTrigger(G.triggers.locBlock.stimOff);
    time = Screen('Flip', G.pWindow, nextOnset - G.flipLag - 0.5);
    log.onsets = [log.onsets, time];

else
    %% Present post-stimulus fixation dot
    Screen('DrawDots', G.pWindow, [0, 0], G.fixDotSize*G.pixPerDeg, 0, G.screenCenter, 1);
    Screen('DrawDots', G.pWindow, [0, 0], 0.5*G.fixDotSize*G.pixPerDeg, G.fixDotColor, G.screenCenter, 1);

    G.B.sendTrigger(G.triggers.locBlock.stimOff);
    time = Screen('Flip', G.pWindow, nextOnset - G.flipLag);
    log.onsets = [log.onsets, time];
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Flip for offset
Screen('DrawDots', G.pWindow, [0, 0], G.fixDotSize*G.pixPerDeg, 0, G.screenCenter, 1);
Screen('DrawDots', G.pWindow, [0, 0], 0.5*G.fixDotSize*G.pixPerDeg, G.fixDotColor, G.screenCenter, 1);
%}

if isnan(data.resp)
    cfg = [];
    cfg.validKeys = G.validKeys;
    cfg.endTime = time + cfg0.ISI - G.pressLag;  
    [data.resp, log.respTime] = getResponse(cfg);
end

%% Post-trial stuff
log.lastOnset = time;

if ~isnan(data.resp)
    data.RT = log.respTime - timeOnset;
end

if (cfg0.oddball == ~isnan(data.resp))
    data.correct = 1;
else
    data.correct = 0;
end

Screen('Close', pStim);

end