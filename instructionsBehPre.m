function instructionsBehPre

global G;

%% 1. General
DrawFormattedText(G.pWindow, [ ...
    'Welcome, and thank you very much for\n' ...
    'participating in this experiment!\n\n' ...
    'The goal of this experiment is to investigate\n' ...
    'how the brain processes pairs of images.\n\n' ...
    'If you have any question during these instructions,\n' ...
    'please do not hesitate to ask the experimenter at any time.\n\n\n\n' ...
    'Press the spacebar to see the next instructions...'
    ], 'center', 'center', G.textColor, [], [], [], 1.5);
Screen('Flip', G.pWindow);

pause(0.5); 

cfg = [];
cfg.endTime = inf;
cfg.validKeys = G.validKeys;
getResponse(cfg);

DrawFormattedText(G.pWindow, [ ...
    'The entire experiment will consist of two sessions:\n' ...
    'a training session today, and an MEG session within the next few days.\n\n' ...
    'You''ll be asked to do two different, but similar tasks:\n' ...
    'the "ducky task" and the "blink task".\n\n' ...
    'Today we''ll focus almost exclusively on the ducky task.\n' ...
    'However, during the MEG session both tasks will be relevant.\n' ...
    'We''ll briefly look at the blink task at the very end of this session.\n\n\n\n' ...
    'Press the spacebar to see the next instructions...'
    ], 'center', 'center', G.textColor, [], [], [], 1.5);
Screen('Flip', G.pWindow);

pause(0.5); 

cfg = [];
cfg.endTime = inf;
cfg.validKeys = G.validKeys;
getResponse(cfg);

DrawFormattedText(G.pWindow, [ ...
    'In the ducky task you''ll continuously see pairs of objects,\n' ...
    'that are shown shortly after each other. However, every now and then,\n' ...
    'one of the objects is a rubber ducky. It is your task to press the space bar\n' ...
    'as soon as you see a ducky. Note that the duckies have varying colors.\n\n' ...
    'Let''s have a look at a couple of examples.\n\n' ...
    'Remember: press the spacebar when you see a ducky.\n\n\n\n' ...
    'Press the spacebar to begin the examples...'
    ], 'center', 'center', G.textColor, [], [], [], 1.5);
Screen('Flip', G.pWindow);

pause(0.5); 

cfg = [];
cfg.endTime = inf;
cfg.validKeys = G.validKeys;
getResponse(cfg);

%% 2. Practice ducky task
nCorrect = 0;
nTrial = 10;
if (G.subjCfg.tempGapOrder == 0)
    tempGap = 0;
elseif (G.subjCfg.tempGapOrder == 1)
    tempGap = 0.3;
end

while (1)
    Screen('DrawDots', G.pWindow, [0, 0], G.fixDotSize*G.pixPerDeg, 0, G.screenCenter, 1);
    Screen('DrawDots', G.pWindow, [0, 0], 0.5*G.fixDotSize*G.pixPerDeg, G.fixDotColor, G.screenCenter, 1);
    time = Screen('Flip', G.pWindow);

    nextOnset = time + 2;

    oddball = Shuffle(((0:(nTrial-1))/nTrial)' < 0.3);
    
    trialLog = cell(nTrial, 1);    
    for in = 1:nTrial
        ISI = rand*range(G.mainBlock.ISI) + G.mainBlock.ISI(1);
        
        cfg = [];
        cfg.stim1 = randi(3);
        cfg.stim2 = randi(2);
        cfg.oddball = oddball(in);
        cfg.tempGap = tempGap;
        cfg.nextOnset = nextOnset;
        cfg.ISI = ISI;

        [~, trialLog{in}] = mainTrial(cfg);

        nextOnset = trialLog{in}.lastOnset + ISI;
    end
    
    trialType = cellfun(@(X) X.trialType, trialLog);

    pHit = mean(trialType(ismember(trialType, [1, 3])) == 1);
    nFA = sum(trialType == 2);

    if ((pHit == 1) && (nFA == 0))
        nCorrect = nCorrect + 1;
        
        if (nCorrect >= 2)
            break;
        end
        
        DrawFormattedText(G.pWindow, [ ...
            'Excellent!\n\n' ...
            'You correctly detected all the duckies!\n' ...
            'Let''s see if you can get it right one more time.\n\n\n\n' ...
            'Press the spacebar to try again...'
            ], 'center', 'center', G.textColor, [], [], [], 1.5);
        Screen('Flip', G.pWindow);
    elseif (pHit < 1)
        DrawFormattedText(G.pWindow, [ ...
            'Unfortunately you did not detect all duckies.\n\n' ...
            'Let''s try it again!\n\n\n\n' ...
            'Press the spacebar to try again...'
            ], 'center', 'center', G.textColor, [], [], [], 1.5);
        Screen('Flip', G.pWindow);
    elseif (nFA > 0)
        DrawFormattedText(G.pWindow, [ ...
            'Unfortunately, you pressed the spacebar\n' ...
            'while there was not actually a ducky.\n\n' ...
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

%% 3. Explain contingencies 
DrawFormattedText(G.pWindow, [ ...
    'Good job! Now, let''s talk a bit about the images.\n\n' ...
    'There are five different images (apart from the duckies).\n' ...
    'Three of those are always presented as the first image,\n' ...
    'whereas the other two are always presented as the second.\n\n' ...
    'Moreover, the first image tells you something about\n' ...
    'which image is going to be next.\n\n' ...
    'This will be explained schematically on the next screen.\n\n\n\n' ...
    'Press the spacebar to see the next instructions...'
    ], 'center', 'center', G.textColor, [], [], [], 1.5);
Screen('Flip', G.pWindow);

% Draw instructions image
im = imread('contingenciesBeh.jpg');
pTexture = Screen('MakeTexture', G.pWindow, im);

Screen('DrawTexture', G.pWindow, pTexture);
Screen('Close', pTexture);

% Draw stimuli on instruction screen
pStim1 = cell(3, 1);
pStim1{1} = Screen('MakeTexture', G.pWindow, G.stim1{1});
pStim1{2} = Screen('MakeTexture', G.pWindow, G.stim1{2});
pStim1{3} = Screen('MakeTexture', G.pWindow, G.stim1{3});

pStim2 = cell(2, 1);
pStim2{1} = Screen('MakeTexture', G.pWindow, G.stim2{1});
pStim2{2} = Screen('MakeTexture', G.pWindow, G.stim2{2});


% A1, A2, A3
Screen('DrawTexture', G.pWindow, pStim1{1}, [], [433, 72, 433+133, 72+133]);
Screen('DrawTexture', G.pWindow, pStim1{2}, [], [893, 72, 893+133, 72+133]);
Screen('DrawTexture', G.pWindow, pStim1{3}, [], [1354, 72, 1354+133, 72+133]);

% B1, B1 left
Screen('DrawTexture', G.pWindow, pStim2{1}, [], [322, 353, 322+133, 353+133]);
Screen('DrawTexture', G.pWindow, pStim2{2}, [], [544, 353, 544+133, 353+133]);

% B1, B1 middle
Screen('DrawTexture', G.pWindow, pStim2{1}, [], [782, 353, 782+133, 353+133]);
Screen('DrawTexture', G.pWindow, pStim2{2}, [], [1004, 353, 1004+133, 353+133]);

% B1, B1 right
Screen('DrawTexture', G.pWindow, pStim2{1}, [], [1243, 353, 1243+133, 353+133]);
Screen('DrawTexture', G.pWindow, pStim2{2}, [], [1465, 353, 1465+133, 353+133]);

% Close textures
for i = 1:3; Screen('Close', pStim1{i}); end
for i = 1:2; Screen('Close', pStim2{i}); end

% Wait for response
pause(0.5); 

cfg = [];
cfg.endTime = inf;
cfg.validKeys = G.validKeys;
getResponse(cfg);

DrawFormattedText(G.pWindow, [ ...
    'If the first image is A1,\n' ...
    'then the second image will always be B1.\n\n' ...
    'Conversely, if the first image is A3,\n' ...
    'then the second image is always going to be B2.\n\n' ...
    'However, if the first image is A2,\n' ...
    'then both B1 and B2 may follow.\n\n' ...
    'You may be wondering why you need to know this,\n' ...
    'if your only task is to detect the duckies.\n' ...
    'Indeed, this information is not useful for you.\n' ...
    'We simply want you to be aware of it.\n\n\n\n' ...
    'Press the spacebar for the next instructions...'
    ], 'center', G.screenResY*.55, G.textColor, [], [], [], 1.5);
Screen('Flip', G.pWindow);

pause(0.5); 

cfg = [];
cfg.endTime = inf;
cfg.validKeys = G.validKeys;
getResponse(cfg);

%% 4. Finish instructions
DrawFormattedText(G.pWindow, [ ...
    'The session today will consist of 8 blocks,\n' ...
    'and each block takes approximately 7 minutes.\n\n' ...
    'After the 4th block, you''ll receive some additional\n' ...
    'instructions for the remaining 4 blocks.\n\n' ...
    'Finally, at the very end we''ll have a quick look at the "blink task".\n\n' ...
    'We are now ready to begin the session.\n' ...
    'Try to keep your eyes fixated at the central dot\n' ...
    'throughout the entire experiment.\n\n\n\n' ...
    'Please call the experimenter now.'
    ], 'center', 'center', G.textColor, [], [], [], 1.5);
Screen('Flip', G.pWindow);

%% End
waitForResearcher;

end
