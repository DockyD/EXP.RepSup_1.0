function [data, log] = contTestTrial(cfg0)

global G;

data = [];

log = [];
log.cfg0 = cfg0;
log.onsets = [];

%% Blank
time = Screen('Flip', G.pWindow);
log.onsets = [log.onsets, time];

%% Make textures
pTexture = cell(5, 1);
for a = 1:5
    if (a <= 3)
        pTexture{a} = Screen('MakeTexture', G.pWindow, G.stim1{a});
    elseif (a >= 4)
        pTexture{a} = Screen('MakeTexture', G.pWindow, G.stim2{a-3});
    end
end
stimRect = [0, 0, size(G.stim1{1}, 2), size(G.stim1{1}, 1)];
screenRect = [0, 0, G.screenResX, G.screenResY];

%% Compose test screen screen
% Test stimulus 
Screen('DrawTexture', G.pWindow, pTexture{cfg0.testStim + 1}, stimRect, centRect(stimRect, screenRect) + [0, -G.screenResY*.2, 0, -G.screenResY*.2]); 

% Distractor stimuli
DrawFormattedText(G.pWindow, [ ...
    'None of these.\n\n' ...
    'The above image was\n' ...
    'never presented first.' ...
    ], 'center', 'center', G.textColor, [], [], [], 1.5, [], ...
    centRect(stimRect, screenRect) + [(+2/6)*G.screenResX, G.screenResY*.3, (+2/6)*G.screenResX, G.screenResY*.3] ...
);
Screen('DrawTexture', G.pWindow, pTexture{cfg0.targStim(1) + 1}, stimRect, centRect(stimRect, screenRect) + [(-2/6)*G.screenResX, G.screenResY*.3, (-2/6)*G.screenResX, G.screenResY*.3]); 
Screen('DrawTexture', G.pWindow, pTexture{cfg0.targStim(2) + 1}, stimRect, centRect(stimRect, screenRect) + [(-1/6)*G.screenResX, G.screenResY*.3, (-1/6)*G.screenResX, G.screenResY*.3]); 
Screen('DrawTexture', G.pWindow, pTexture{cfg0.targStim(3) + 1}, stimRect, centRect(stimRect, screenRect) + [(+0/6)*G.screenResX, G.screenResY*.3, (+0/6)*G.screenResX, G.screenResY*.3]); 
Screen('DrawTexture', G.pWindow, pTexture{cfg0.targStim(4) + 1}, stimRect, centRect(stimRect, screenRect) + [(+1/6)*G.screenResX, G.screenResY*.3, (+1/6)*G.screenResX, G.screenResY*.3]); 

% Text
switch G.MEG
    case 0
        DrawFormattedText(G.pWindow, [ ...
            'If the first image was this one:' ...
            ], 'center', 0.1*G.screenResY, G.textColor, [], [], [], 1.5);
        DrawFormattedText(G.pWindow, 'a', 'center', (0.6)*G.screenResY, G.textColor, [], [], [], 1.5, [], centRect(stimRect, screenRect) + [(-2/6)*G.screenResX, -G.screenResY*.5, (-2/6)*G.screenResX, +G.screenResY*.5]);
        DrawFormattedText(G.pWindow, 's', 'center', (0.6)*G.screenResY, G.textColor, [], [], [], 1.5, [], centRect(stimRect, screenRect) + [(-1/6)*G.screenResX, -G.screenResY*.5, (-1/6)*G.screenResX, +G.screenResY*.5]);
        DrawFormattedText(G.pWindow, 'd', 'center', (0.6)*G.screenResY, G.textColor, [], [], [], 1.5, [], centRect(stimRect, screenRect) + [(+0/6)*G.screenResX, -G.screenResY*.5, (+0/6)*G.screenResX, +G.screenResY*.5]);
        DrawFormattedText(G.pWindow, 'f', 'center', (0.6)*G.screenResY, G.textColor, [], [], [], 1.5, [], centRect(stimRect, screenRect) + [(+1/6)*G.screenResX, -G.screenResY*.5, (+1/6)*G.screenResX, +G.screenResY*.5]);
        DrawFormattedText(G.pWindow, 'g', 'center', (0.6)*G.screenResY, G.textColor, [], [], [], 1.5, [], centRect(stimRect, screenRect) + [(+2/6)*G.screenResX, -G.screenResY*.5, (+2/6)*G.screenResX, +G.screenResY*.5]);
        
        DrawFormattedText(G.pWindow, [ ...
            'Which one would most likely follow?\n\n\n' ...
            'Please press the corresponding key on the keyboard.\n' ...
            ], 'center', 'center', G.textColor, [], [], [], 1.5);
    case 1
        DrawFormattedText(G.pWindow, [ ...
            'If the first image was this one:' ...
            ], 'center', 0.1*G.screenResY, G.textColor, [], [], [], 1.5);
        
        DrawFormattedText(G.pWindow, 'left\nmiddle', 'center', (0.6)*G.screenResY, G.textColor, [], [], [], 1.5, [], centRect(stimRect, screenRect) + [(-2/6)*G.screenResX, -G.screenResY*.5, (-2/6)*G.screenResX, +G.screenResY*.5]);
        DrawFormattedText(G.pWindow, 'left\nindex', 'center', (0.6)*G.screenResY, G.textColor, [], [], [], 1.5, [], centRect(stimRect, screenRect) + [(-1/6)*G.screenResX, -G.screenResY*.5, (-1/6)*G.screenResX, +G.screenResY*.5]);
        DrawFormattedText(G.pWindow, 'right\nindex', 'center', (0.6)*G.screenResY, G.textColor, [], [], [], 1.5, [], centRect(stimRect, screenRect) + [(+0/6)*G.screenResX, -G.screenResY*.5, (+0/6)*G.screenResX, +G.screenResY*.5]);
        DrawFormattedText(G.pWindow, 'right\nmiddle', 'center', (0.6)*G.screenResY, G.textColor, [], [], [], 1.5, [], centRect(stimRect, screenRect) + [(+1/6)*G.screenResX, -G.screenResY*.5, (+1/6)*G.screenResX, +G.screenResY*.5]);
        DrawFormattedText(G.pWindow, 'right\nring', 'center', (0.6)*G.screenResY, G.textColor, [], [], [], 1.5, [], centRect(stimRect, screenRect) + [(+2/6)*G.screenResX, -G.screenResY*.5, (+2/6)*G.screenResX, +G.screenResY*.5]);

        DrawFormattedText(G.pWindow, [ ...
            'Which one would most likely follow?\n\n\n' ...
            'Please indicate your choice by pressing the button\n' ...
            'corresponding to the finger as indicated.\n' ...
            ], 'center', 'center', G.textColor, [], [], [], 1.5);
end

%% Display test screen
time = Screen('Flip', G.pWindow, time + 1);
log.onsets = [log.onsets, time];

%% Capture response
cfg = [];
switch G.MEG
    case 0
        cfg.validKeys = [KbName('a'), KbName('s'), KbName('d'), KbName('f'), KbName('g')];
    case 1
        cfg.validKeys = 'feabc';
end
cfg.endTime = inf;
[data.resp, respTime] = getResponse(cfg);

data.RT = respTime - time;

%% Blank screen
Screen('Flip', G.pWindow);

end
