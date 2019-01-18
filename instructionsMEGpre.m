function instructionsMEGpre

global G;

%% 1. Instructions
DrawFormattedText(G.pWindow, [ ...
    'Excellent!\n\n' ...
    'Today we''ll be doing both the blink task and the ducky task.\n' ...
    'Before each block you''ll see what the task for that block is.\n\n' ...
    'We''ll first shortly recap the blink task.\n\n\n\n' ...
    'Press the button to see the next instructions...'
    ], 'center', 'center', G.textColor, [], [], [], 1.5);
Screen('Flip', G.pWindow);

pause(0.5); 

cfg = [];
cfg.endTime = inf;
cfg.validKeys = G.validKeys;
getResponse(cfg);

DrawFormattedText(G.pWindow, [ ...
    'In the blink task you''ll continuously see images.\n' ...
    'Every now and then, the fixation dot will "blink".\n' ...
    'It is your task to press the button when you see such a blink.\n\n' ...
    'Try to keep your eyes fixated at the central dot.\n\n' ...
    'If you''re ready, we can begin a few examples\n\n\n\n' ...
    'Press the button to begin the examples.'
    ], 'center', 'center', G.textColor, [], [], [], 1.5);
Screen('Flip', G.pWindow);

pause(0.5); 

cfg = [];
cfg.endTime = inf;
cfg.validKeys = G.validKeys;
getResponse(cfg);

%% 2. Practice blink task
nCorrect = 0;
nTrial = 20;

while (1)
    Screen('DrawDots', G.pWindow, [0, 0], G.fixDotSize*G.pixPerDeg, 0, G.screenCenter, 1);
    Screen('DrawDots', G.pWindow, [0, 0], 0.5*G.fixDotSize*G.pixPerDeg, G.fixDotColor, G.screenCenter, 1);
    time = Screen('Flip', G.pWindow);

    nextOnset = time + 2;

    oddball = Shuffle(((0:(nTrial-1))/nTrial)' < 0.3);
    
    data = cell(nTrial, 1);    
    for in = 1:nTrial
        ISI = rand*range(G.locBlock.ISI) + G.locBlock.ISI(1);

        cfg = [];
        cfg.stim = randi(2);
        cfg.oddball = oddball(in);
        cfg.nextOnset = nextOnset;
        cfg.ISI = ISI;

        [data{in}, trialLog] = locTrial(cfg);
        
        nextOnset = trialLog.lastOnset + ISI;
    end
    
    resp = cellfun(@(X) ~isnan(X.resp), data);

    pHit = mean(resp(oddball==1) == 1);
    nFA = sum(resp(oddball==0) == 1);

    if ((pHit == 1) && (nFA == 0))
        nCorrect = nCorrect + 1;
        
        if (nCorrect >= 2)
            break;
        end
        
        DrawFormattedText(G.pWindow, [ ...
            'Excellent!\n\n' ...
            'You correctly detected all the blinks!\n' ...
            'Let''s see if you can get it right one more time.\n\n\n\n' ...
            'Press the button to try again...'
            ], 'center', 'center', G.textColor, [], [], [], 1.5);
        Screen('Flip', G.pWindow);
    elseif (pHit < 1)
        DrawFormattedText(G.pWindow, [ ...
            'Unfortunately you did not detect all blinks.\n\n' ...
            'Let''s try it again!\n\n\n\n' ...
            'Press the button to try again...'
            ], 'center', 'center', G.textColor, [], [], [], 1.5);
        Screen('Flip', G.pWindow);
    elseif (nFA > 0)
        DrawFormattedText(G.pWindow, [ ...
            'Unfortunately, you pressed the button\n' ...
            'while there was not actually a blink.\n\n' ...
            'Let''s try it again!\n\n\n\n' ...
            'Press the button to try again...'
            ], 'center', 'center', G.textColor, [], [], [], 1.5);
        Screen('Flip', G.pWindow);
    end
    
    pause(0.5); 

    cfg = [];
    cfg.endTime = inf;
    cfg.validKeys = G.validKeys;
    getResponse(cfg);
end    

%% 3. Done
DrawFormattedText(G.pWindow, sprintf([ ...
    'Good job!\n\n' ...
    'The entire experiment will consist of %g blocks,\n' ...
    'of either the blink or the ducky task.\n\n' ...
    'At the end another eye-tracker calibration will be done,\n' ...
    'and you will be asked a few questions.\n\n' ...
    'We are now ready to begin the real experiment.\n\n\n\n' ...
    'Press the button to see the next instructions...'
    ], G.nBlock), 'center', 'center', G.textColor, [], [], [], 1.5);
Screen('Flip', G.pWindow);

pause(0.5); 

cfg = [];
cfg.endTime = inf;
cfg.validKeys = G.validKeys;
getResponse(cfg);


end
