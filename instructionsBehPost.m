function instructionsBehPost

global G;

%% 1. Instructions
DrawFormattedText(G.pWindow, [ ...
    'Well done! You''ve finished the largest part of the session.\n\n' ...
    'All that''s left now is to have a quick look at the "blink task".\n\n\n\n' ...
    'Press the spacebar to see the next instructions...'
    ], 'center', 'center', G.textColor, [], [], [], 1.5);
Screen('Flip', G.pWindow);

pause(0.5); 

cfg = [];
cfg.endTime = inf;
cfg.validKeys = G.validKeys;
getResponse(cfg);

DrawFormattedText(G.pWindow, [ ...
    'In the blink task, you''ll again see images.\n\n' ...
    'However, only the images that appeared as\n' ...
    'the second image in the previous task will be used.\n' ...
    'Moreover, the images will now be presented in isolation, \n' ...
    'and not in pairs.\n\n\n\n' ...
    'Press the spacebar to see the next instructions...'
    ], 'center', 'center', G.textColor, [], [], [], 1.5);
Screen('Flip', G.pWindow);

pause(0.5); 

cfg = [];
cfg.endTime = inf;
cfg.validKeys = G.validKeys;
getResponse(cfg);

DrawFormattedText(G.pWindow, [ ...
    'Your task is about the fixation dot.\n' ...
    'Every now and then the inner part of the fixation dot\n' ...
    'will disappear for a very short moment.\n' ...
    'That is, the fixation dot will briefly "blink".\n\n' ...
    'It is your task to detect these blinks,\n' ...
    'and press the spacebar as soon as you see one.\n\n' ...
    'If you have any questions, please ask the researcher now.\n' ...
    'Otherwise, we can have a look at a few examples now.\n\n' ...
    'Remember: press the spacebar when you see a blink.\n\n\n\n' ...
    'Press the spacebar to see the next instructions...'
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
            'Press the spacebar to try again...'
            ], 'center', 'center', G.textColor, [], [], [], 1.5);
        Screen('Flip', G.pWindow);
    elseif (pHit < 1)
        DrawFormattedText(G.pWindow, [ ...
            'Unfortunately you did not detect all blinks.\n\n' ...
            'Let''s try it again!\n\n\n\n' ...
            'Press the spacebar to try again...'
            ], 'center', 'center', G.textColor, [], [], [], 1.5);
        Screen('Flip', G.pWindow);
    elseif (nFA > 0)
        DrawFormattedText(G.pWindow, [ ...
            'Unfortunately, you pressed the spacebar\n' ...
            'while there was not actually a blink.\n\n' ...
            'Let''s try it again!\n\n\n\n' ...
            'Press the spacebar to try again...'
            ], 'center', 'center', G.textColor, [], [], [], 1.5);
        Screen('Flip', G.pWindow);
    end
    
    pause(0.5); 

    cfg = [];
    cfg.endTime = inf;
    cfg.validKeys = G.validKeys;
    getResponse(cfg);
end    

end
