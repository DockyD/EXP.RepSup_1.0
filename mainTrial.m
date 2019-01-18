function [data, log] = mainTrial(cfg0)

global G;

data = [];
data.resp = nan;
data.RT = nan;

log = [];
log.cfg0 = cfg0;
log.onsets = nan(6, 1);
log.posOddball = 0;
log.resp = nan(5, 1);
log.respTime = nan(5, 1);

if cfg0.oddball
    log.posOddball = randi(2);
    log.iDucky = randi(G.nDuckies);
end    

%% Present pre-stimulus fixation dot
Screen('DrawDots', G.pWindow, [0, 0], G.fixDotSize*G.pixPerDeg, 0, G.screenCenter, 1);
Screen('DrawDots', G.pWindow, [0, 0], 0.5*G.fixDotSize*G.pixPerDeg, G.fixDotColor, G.screenCenter, 1);

time = Screen('Flip', G.pWindow, cfg0.nextOnset - G.flipLag);
G.B.sendTrigger(G.triggers.mainBlock.preFixOn + (cfg0.tempGap > 0));
log.onsets(1) = time;

log.preFixDur = rand*range(G.mainBlock.preFixDur) + G.mainBlock.preFixDur(1);
nextOnset = time + log.preFixDur;

%% Present stimulus 1
if (log.posOddball == 1)
    pStim1 = Screen('MakeTexture', G.pWindow, G.stimDucky{log.iDucky});
else
    pStim1 = Screen('MakeTexture', G.pWindow, G.stim1{cfg0.stim1});
end    
Screen('DrawTexture', G.pWindow, pStim1);

% Superimpose fixation
Screen('DrawDots', G.pWindow, [0, 0], G.fixDotSize*G.pixPerDeg, 0, G.screenCenter, 1);
Screen('DrawDots', G.pWindow, [0, 0], 0.5*G.fixDotSize*G.pixPerDeg, G.fixDotColor, G.screenCenter, 1);

% Flip
time = Screen('Flip', G.pWindow, nextOnset - G.flipLag);
G.B.sendTrigger(G.triggers.mainBlock.stim1On + cfg0.stim1);
log.onsets(2) = time;

nextOnset = time + G.mainBlock.stimDur;

% Capture response
cfg = [];
cfg.validKeys = G.validKeys;
cfg.endTime = nextOnset - G.pressLag;
[log.resp(1), log.respTime(1)] = getResponse(cfg);

%% Temporal gap
if (cfg0.tempGap > 0)
    Screen('DrawDots', G.pWindow, [0, 0], G.fixDotSize*G.pixPerDeg, 0, G.screenCenter, 1);
    Screen('DrawDots', G.pWindow, [0, 0], 0.5*G.fixDotSize*G.pixPerDeg, G.fixDotColor, G.screenCenter, 1);
    
    % Flip
    time = Screen('Flip', G.pWindow, nextOnset - G.flipLag);
    G.B.sendTrigger(G.triggers.mainBlock.tempGapOn);
    log.onsets(3) = time;

    nextOnset = time + cfg0.tempGap;
    
    % Capture response
    cfg = [];
    cfg.validKeys = G.validKeys;
    cfg.endTime = nextOnset - G.pressLag;
    [log.resp(2), log.respTime(2)] = getResponse(cfg);    
end    

%% Present stimulus 2
if (log.posOddball == 2)
    pStim2 = Screen('MakeTexture', G.pWindow, G.stimDucky{log.iDucky});
else
    pStim2 = Screen('MakeTexture', G.pWindow, G.stim2{cfg0.stim2});
end    
Screen('DrawTexture', G.pWindow, pStim2);

% Superimpose fixation
Screen('DrawDots', G.pWindow, [0, 0], G.fixDotSize*G.pixPerDeg, 0, G.screenCenter, 1);
Screen('DrawDots', G.pWindow, [0, 0], 0.5*G.fixDotSize*G.pixPerDeg, G.fixDotColor, G.screenCenter, 1);

% Flip
time = Screen('Flip', G.pWindow, nextOnset - G.flipLag);
G.B.sendTrigger(G.triggers.mainBlock.stim2On + cfg0.stim2);
log.onsets(4) = time;

nextOnset = time + G.mainBlock.stimDur;

% Capture response
cfg = [];
cfg.validKeys = G.validKeys;
cfg.endTime = nextOnset - G.pressLag;
[log.resp(3), log.respTime(3)] = getResponse(cfg);    

%% Post-stimulus fixation
Screen('DrawDots', G.pWindow, [0, 0], G.fixDotSize*G.pixPerDeg, 0, G.screenCenter, 1);
Screen('DrawDots', G.pWindow, [0, 0], 0.5*G.fixDotSize*G.pixPerDeg, G.fixDotColor, G.screenCenter, 1);

time = Screen('Flip', G.pWindow, nextOnset - G.flipLag);
G.B.sendTrigger(G.triggers.mainBlock.postFixOn + cfg0.oddball);
log.onsets(5) = time;

log.postFixDur = rand*range(G.mainBlock.postFixDur) + G.mainBlock.postFixDur(1);
nextOnset = time + log.postFixDur;

% Capture response
cfg = [];
cfg.validKeys = G.validKeys;
cfg.endTime = nextOnset - G.pressLag;
[log.resp(4), log.respTime(4)] = getResponse(cfg);    

%% Post-stimulus blank
time = Screen('Flip', G.pWindow, nextOnset - G.flipLag);
G.B.sendTrigger(G.triggers.mainBlock.postBlankOn + log.posOddball);
log.onsets(6) = time;

% Capture response
cfg = [];
cfg.validKeys = G.validKeys;
cfg.endTime = time + cfg0.ISI - G.pressLag;
[log.resp(5), log.respTime(5)] = getResponse(cfg);    

%% Post-trial processing
log.lastOnset = time;

data.resp = any(~isnan(log.resp));
firstResp = find(~isnan(log.resp), 1);

% Determine correctness
switch log.posOddball
    case 0
        if data.resp
            log.trialType = 2;              % False alarm
            data.RT = log.respTime(firstResp) - log.onsets(2);
        else
            log.trialType = 0;              % Correct reject
        end    
    case 1
        if data.resp
            log.trialType = 1;              % Hit
            data.RT = log.respTime(firstResp) - log.onsets(2);
        else
            log.trialType = 3;              % Miss
        end
    case 2
        if data.resp
            if (firstResp <= 2)
                log.trialType = 2;          % False alarm
                data.RT = log.respTime(firstResp) - log.onsets(2);
            else
                log.trialType = 1;          % Hit
                data.RT = log.respTime(firstResp) - log.onsets(4);
            end
        else
            log.trialType = 3;              % Miss
        end
end

% Clean-up
Screen('Close', pStim1);
Screen('Close', pStim2);

end
