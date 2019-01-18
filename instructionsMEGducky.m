function instructionsMEGducky

global G;

%% 1. Explain task and contingencies
DrawFormattedText(G.pWindow, [ ...
    'Good job so far!\n\n' ...
    'The next block will be the ducky task.\n\n' ...
    'You''ll continuously see two images that are presented in pairs.\n' ...
    'Your task is to press the button as soon as you see a rubber ducky.\n\n' ...
    'Recall that the first image tells you something\n' ...
    'about which image is coming up next.\n' ...
    'This will be shown schematically on the next screen\n\n\n\n' ...
    'Press the button to see the next instructions...'
    ], 'center', 'center', G.textColor, [], [], [], 1.5);
Screen('Flip', G.pWindow);

% Draw instructions image
im = imread('contingenciesMeg.jpg');
im = im * (G.maxWhite / 255);           % Scale brightness
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
    'If the first image is image A1,\n' ...
    'then there is 80% chance that the second image will be B1,\n' ...
    'and a 20% chance that the second image will be B2.\n' ... 
    'Thus, image A1 is most likely followed by image B1.\n\n' ...
    'The reverse holds for image A3 and B2.\n' ...
    'That is, image A3 is most likely followed by image B2.\n\n' ...
    'However, if the first image is A2,\n' ...
    'then B1 and B2 are equally likely to follow.\n' ...
    'Thus, image A2 does not predict anything about the second image.\n\n' ...
    'You may be wondering why you need to know this,\n' ...
    'if your only task is to detect the duckies.\n' ...
    'Indeed, this information is not useful for you.\n' ...
    'We simply want you to be aware of it.\n\n\n\n' ...
    'Press the button for the next instructions...'
    ], 'center', G.screenResY*.55, G.textColor, [], [], [], 1.5);
Screen('Flip', G.pWindow);

pause(0.5); 

cfg = [];
cfg.endTime = inf;
cfg.validKeys = G.validKeys;
getResponse(cfg);

% Temporal gap
if (G.subjCfg.tempGapOrder == 0)
    DrawFormattedText(G.pWindow, [ ...
        'Also, recall that in the first half of the experiment\n' ...
        'the two images will be shown immediately after each other,\n' ...
        'whereas in the second half there will be a short gap\n' ...
        'in between the two images.\n\n' ...
        'You will be notified of this change once we get there.\n\n\n\n' ...
        'Press the button to see the next instructions...'
        ], 'center', 'center', G.textColor, [], [], [], 1.5);
elseif (G.subjCfg.tempGapOrder == 1)
    DrawFormattedText(G.pWindow, [ ...
        'Also, recall that in the first half of the experiment\n' ...
        'there is a short gap in between the two images,\n' ...
        'whereas in the second half the images will be shown\n' ...
        'immediately after each.\n\n' ...
        'You will be notified of this change once we get there.\n\n\n\n' ...
        'Press the button to see the next instructions...'
        ], 'center', 'center', G.textColor, [], [], [], 1.5);
end
    
Screen('Flip', G.pWindow);

pause(0.5); 

cfg = [];
cfg.endTime = inf;
cfg.validKeys = G.validKeys;
getResponse(cfg);

% Ready to go
DrawFormattedText(G.pWindow, [ ...
    'We are now ready to continue the experiment,\n' ...
    'and begin with the first block of the ducky task.\n\n' ...
    'Remember: press the button as soon as you see a ducky.\n\n' ... 
    'Try to keep your eyes fixated at the central dot\n' ...
    'throughout the entire experiment.\n\n\n\n' ...
    'Press the button for the next instructions...'
    ], 'center', 'center', G.textColor, [], [], [], 1.5);
Screen('Flip', G.pWindow);

pause(0.5); 

cfg = [];
cfg.endTime = inf;
cfg.validKeys = G.validKeys;
getResponse(cfg);

end
