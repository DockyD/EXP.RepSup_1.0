function instructionsMEGmid

global G;

%% 1. Explain task and contingencies
% Temporal gap
if (G.subjCfg.tempGapOrder == 0)
    DrawFormattedText(G.pWindow, [ ...
        'We are now just over half of the experiment.\n\n' ...
        'From this moment on, the two images will be shown\n' ...
        'with a brief gap in between them.\n\n\n\n' ...
        'Press the button to see the next instructions...'
        ], 'center', 'center', G.textColor, [], [], [], 1.5);
elseif (G.subjCfg.tempGapOrder == 1)
    DrawFormattedText(G.pWindow, [ ...
        'We are now just over half of the experiment.\n\n' ...
        'From this moment on, the two images will be shown\n' ...
        'immediately after each other.\n\n\n\n' ...
        'Press the button to see the next instructions...'
        ], 'center', 'center', G.textColor, [], [], [], 1.5);
end
    
Screen('Flip', G.pWindow);

pause(0.5); 

cfg = [];
cfg.endTime = inf;
cfg.validKeys = G.validKeys;
getResponse(cfg);

end
