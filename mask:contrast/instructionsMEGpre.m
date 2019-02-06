function instructionsMEGpre

global G;

%% 1. Instructions
DrawFormattedText(G.pWindow, [ ...
    'Excellent!\n\n' ...
    'Next we will show you the main task you will be completing today.\n' ...
    'Your task today will be very simple:.\n\n' ...
    'Your job will be to keep your eyes on a small dot at the center of the screen.\n\n' ...
    'Occasionally this dot will "blink"" (it will disappear for a moment).\n\n' ...
    'When this happens your job will be to press the button.\n\n\n\n' ...
    'Press the button to see the next instructions...'
    ], 'center', 'center', G.textColor, [], [], [], 1.5);
Screen('Flip', G.pWindow);

pause(0.5); 

cfg = [];
cfg.endTime = inf;
cfg.validKeys = G.validKeys;
getResponse(cfg);

DrawFormattedText(G.pWindow, [ ...
    'And thats it! It should be a very easy task and we expect you to detect nearly all the blinks that occur.\n' ...
    'While watching for blinks, images will continuously be shown in the background.\n\n' ...
    'These images are not related to your task, so please try to keep your eyes fixated on the central dot.\n\n' ...
    'If this all makes sense then we can begin with a few examples\n\n' ...
    'If you have a question now, or at any other time during this experiment, please let the experimenter know right away.\n\n\n\n' ...
    'Press the button to begin.'
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
    'Your task will be the same for all blocks.\n\n' ...
    'At the end another eye-tracker calibration will be done,\n' ...
    'As always, if you have any questions then please let us know.\n\n' ...
    'Otherwise, we are now ready to begin the real experiment.\n\n\n\n' ...
    'Press the button to begin!'
    ], G.nBlock), 'center', 'center', G.textColor, [], [], [], 1.5);
Screen('Flip', G.pWindow);

pause(0.5); 

cfg = [];
cfg.endTime = inf;
cfg.validKeys = G.validKeys;
getResponse(cfg);


end
