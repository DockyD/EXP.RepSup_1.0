function instructionsBehMid

global G;

%% 1. tempGap will change
if (G.subjCfg.tempGapOrder == 0)
    DrawFormattedText(G.pWindow, [ ...
        'Good job! You''re now halfway through the session.\n\n' ...
        'For the remaining four blocks, the experiment will be slightly different.\n' ...
        'So far the two images were presented immediately after each other.\n' ...
        'From now on, there will be a very brief gap in between the two images.\n\n' ...
        'The rest of the experiment stays the same.\n' ...
        'Your task is still to press the spacebar whenever you see a ducky.\n\n' ...
        'If you have any questions, you can ask the researcher now.\n\n' ...
        'Otherwise, feel free to have a quick break if you wish,\n' ...
        'or continue when you are ready.\n\n' ...
        'Please remember to try to keep your eyes fixated at the central dot.\n\n\n\n' ...
        'Press the spacebar to see the next instructions...'
        ], 'center', 'center', G.textColor, [], [], [], 1.5);
elseif (G.subjCfg.tempGapOrder == 1)
    DrawFormattedText(G.pWindow, [ ...
        'Good job! You''re now halfway through the session.\n\n' ...
        'For the remaining four blocks, the experiment will be slightly different.\n' ...
        'You may have noticed that there was a brief gap in between the two images.\n' ...
        'From now on, the two images will presented immediately after each other.\n\n' ...
        'The rest of the experiment stays the same.\n' ...
        'Your task is still to press the spacebar whenever you see a ducky.\n\n' ...
        'If you have any questions, you can ask the researcher now.\n\n' ...
        'Otherwise, feel free to have a quick break if you wish,\n' ...
        'or continue when you are ready.\n\n' ...
        'Please remember to try to keep your eyes fixated at the central dot.\n\n\n\n' ...
        'Press the spacebar to see the next instructions...'
        ], 'center', 'center', G.textColor, [], [], [], 1.5);
end
    
Screen('Flip', G.pWindow);

pause(0.5); 

cfg = [];
cfg.endTime = inf;
cfg.validKeys = G.validKeys;
getResponse(cfg);

end