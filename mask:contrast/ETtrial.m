function [data, log] = ETtrial(cfg0)

global G;

data = [];

log = [];
log.cfg0 = cfg0;
log.onsets = [];

% Stim onset
Screen('DrawDots', G.pWindow, [0, 0], G.fixDotSize*G.pixPerDeg, 0, G.screenCenter + G.ET.positions(cfg0.iPosition+1, :), 1);
Screen('DrawDots', G.pWindow, [0, 0], 0.5*G.fixDotSize*G.pixPerDeg, G.fixDotColor, G.screenCenter + G.ET.positions(cfg0.iPosition+1, :), 1);
time = Screen('Flip', G.pWindow, cfg0.nextOnset - G.flipLag);
G.B.sendTrigger(G.triggers.ET.stimOnset + cfg0.iPosition);
log.onsets = [log.onsets, time];

log.lastOnset = time;

end
