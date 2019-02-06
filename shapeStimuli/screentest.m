try
    clear all;
    Screen('Preference', 'SkipSyncTests', 1);
    global G;
    G = [];
    G.maxWhite = 255;
    G.BGcolor = G.maxWhite;  
    G.objPath = 'Stimuli/ObjectsMEG/';
    G.subjCfgPath = 'subjCfg/';
    G.curSubj = 1;
    tmp = load([G.subjCfgPath, 'subjCfg', num2str(G.curSubj), '.mat']);
    G.subjCfg = tmp.subjCfg;
    G.validKeys = ['a']; 
    G.distToScreen = .8;
    G.screenWidth = .487;
    G.keyboardNumber = max(GetKeyboardIndices);
    G.pressLag = .005;
    G.MEG = 1;

    allScreens = Screen('Screens');
    G.pWindow = Screen('OpenWindow', allScreens(1), G.BGcolor);
    [G.screenResX, G.screenResY] = Screen('WindowSize', G.pWindow);
    Screen('BlendFunction', G.pWindow, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    G.screenCenter = [G.screenResX/2, G.screenResY/2];
    G.pixPerDeg = (tan(pi/180)*G.distToScreen*G.screenResX)/G.screenWidth;

    if IsOSX
        G.frameDur = 1/60;
    else    
        G.frameDur = 1/Screen('NominalFrameRate', G.pWindow);
    end    
    G.flipLag = .9 * G.frameDur;

    Screen('TextFont', G.pWindow, 'Arial');
    Screen('TextSize', G.pWindow, 16);
    Screen('TextStyle', G.pWindow, 0);

    Priority(MaxPriority(G.pWindow));
    HideCursor;
    ListenChar(2);

    Screen('BlendFunction', G.pWindow, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);

    G.locBlock.stimDurPreOddball = 0.3;
    G.locBlock.oddballDur = 0.1;
    G.locBlock.stimDurPostOddball = 0.1;
    G.locBlock.ISI = [.8 1.2];
    G.fixDotSize = .2;              % In degrees
    G.fixDotColor = G.maxWhite;

    % Load subject specific parameters
    loadSubjCfg;

     G.stim2 = cell(2, 1);       % Second stimulus: B and D
     G.stim2{1} = double(imread([G.objPath, G.subjCfg.stimFiles.B{1}])) * (G.maxWhite/255);
     G.stim2{2} = double(imread([G.objPath, G.subjCfg.stimFiles.B{2}])) * (G.maxWhite/255);
% 
% 
%         pStim = Screen('MakeTexture', G.pWindow, G.stim2{1});
%         Screen('DrawTexture', G.pWindow, pStim,[],[],0,0,.1);
%         time = Screen('Flip', G.pWindow,10);
%         WaitSecs(2)
%         Screen('DrawTexture', G.pWindow, pStim,[],[],[],[],1);
%         time = Screen('Flip', G.pWindow,20);
%         WaitSecs(2)
%         pStim = Screen('MakeTexture', G.pWindow, G.stim2{2});
%         Screen('DrawTexture', G.pWindow, pStim);
%         Screen('Flip', G.pWindow,30)
%         WaitSecs(2)


    %% Generate stimulus conditions
    %%legend:   [imageA/B, OddBall, High/Low contrast]
    %%          Fact 1 = bin for image A, High Contrast
    %%          Fact 2 = bin for image B, low Contrast
    %%          Fact 3 = bin for image A, High Contrast, OddBall
    %%          Fact 4 = bin for image B, low Contrast, OddBall
    trialOrder = carryoverCounterbalance(4,1,7,0);

    % fact1 = sum(trialOrder(:) == 1);
    % fact2 = sum(trialOrder(:) == 2);
    % fact3 = sum(trialOrder(:) == 3);
    % fact4 = sum(trialOrder(:) == 4);

    fact1 = [repmat([1,0,0],(sum(trialOrder(:) == 1)-3),1) ; (repmat([1,1,0],3,1))];
    fact2 = [repmat([2,0,0],(sum(trialOrder(:) == 2)-3),1) ; (repmat([2,1,0],3,1))];
    fact3 = [repmat([1,0,1],(sum(trialOrder(:) == 3)-3),1) ; (repmat([1,1,1],3,1))];
    fact4 = [repmat([2,0,1],(sum(trialOrder(:) == 4)-3),1) ; (repmat([2,1,1],3,1))];

    %shuffle bins
    fact1 = fact1(randperm(size(fact1,1)),:);
    fact2 = fact2(randperm(size(fact2,1)),:);
    fact3 = fact3(randperm(size(fact3,1)),:);
    fact4 = fact4(randperm(size(fact4,1)),:);

    %create trial list by drawing from bins. order should match trialOrder
    trials=zeros(length(trialOrder),3);
    for i = 1:length(trialOrder)

    if trialOrder(i) == 1
        trials(i,:) = fact1(1,:);
        fact1(1,:) = [];
    elseif trialOrder(i) == 2
       trials(i,:) = fact2(1,:);
       fact2(1,:) = [];
    elseif trialOrder(i) == 3
       trials(i,:) = fact3(1,:);
       fact3(1,:) = [];
    else
       trials(i,:) = fact4(1,:);
       fact4(1,:) = [];
    end

    end

    %% Loop over trials
    % Start with fixation dot
    Screen('DrawDots', G.pWindow, [0, 0], G.fixDotSize*G.pixPerDeg, 0, G.screenCenter, 1);
    Screen('DrawDots', G.pWindow, [0, 0], 0.5*G.fixDotSize*G.pixPerDeg, G.fixDotColor, G.screenCenter, 1);

    time = Screen('Flip', G.pWindow);
    log.preFixOnset = time;

    nextOnset = time + 2;

    for in = 1:length(trialOrder)
        log.ISI(in) = rand*range(G.locBlock.ISI) + G.locBlock.ISI(1);

        % Do trial
        cfg = [];
        cfg.stim = trials(in, 1);
        cfg.oddball = trials(in, 2);
        cfg.cont = trials(in,3);
        cfg.nextOnset = nextOnset;
        cfg.ISI = log.ISI(in);

        % 	[trialData, log.trial{in}] = contTrial(cfg);




        %% Present stimulus before oddball
        pStim = Screen('MakeTexture', G.pWindow, G.stim2{cfg.stim});

        if cfg.cont
        Screen('DrawTexture', G.pWindow, pStim,[],[],0,0,.1);
        else
        Screen('DrawTexture', G.pWindow, pStim);
        end

        % Superimpose fixation
        Screen('DrawDots', G.pWindow, [0, 0], G.fixDotSize*G.pixPerDeg, 0, G.screenCenter, 1);
        Screen('DrawDots', G.pWindow, [0, 0], 0.5*G.fixDotSize*G.pixPerDeg, G.fixDotColor, G.screenCenter, 1);

        % Flip
        time = Screen('Flip', G.pWindow, nextOnset - G.flipLag);
    % 


        nextOnset = time + G.locBlock.stimDurPreOddball;

        %% Present stimulus and oddball
        if cfg.cont
        Screen('DrawTexture', G.pWindow, pStim,[],[],0,0,.1);
        else
        Screen('DrawTexture', G.pWindow, pStim);
        end


        % Superimpose fixation
        Screen('DrawDots', G.pWindow, [0, 0], G.fixDotSize*G.pixPerDeg, 0, G.screenCenter, 1);
        if ~cfg.oddball
        Screen('DrawDots', G.pWindow, [0, 0], 0.5*G.fixDotSize*G.pixPerDeg, G.fixDotColor, G.screenCenter, 1);
        end

        % Flip
        time = Screen('Flip', G.pWindow, nextOnset - G.flipLag);

        timeOnset = time;

        nextOnset = time + G.locBlock.oddballDur;

    %     cfg = [];
    %     cfg.validKeys = G.validKeys;
    %     cfg.endTime = nextOnset - G.pressLag;    
    %     [data.resp, log.respTime] = getResponse(cfg);

        %% Present stimulus
        if cfg.cont
        Screen('DrawTexture', G.pWindow, pStim,[],[],0,0,.1);
        else
        Screen('DrawTexture', G.pWindow, pStim);
        end

        % Superimpose fixation
        Screen('DrawDots', G.pWindow, [0, 0], G.fixDotSize*G.pixPerDeg, 0, G.screenCenter, 1);
        Screen('DrawDots', G.pWindow, [0, 0], 0.5*G.fixDotSize*G.pixPerDeg, G.fixDotColor, G.screenCenter, 1);

        % Flip
        time = Screen('Flip', G.pWindow, nextOnset - G.flipLag);
    %     log.onsets = [log.onsets, time];

        nextOnset = time + G.locBlock.stimDurPostOddball;

    %     if isnan(data.resp)
    %     cfg = [];
    %     cfg.validKeys = G.validKeys;
    %     cfg.endTime = nextOnset - G.pressLag;    
    %     [data.resp, log.respTime] = getResponse(cfg);
    %     end

        %% Present post-stimulus fixation dot
        Screen('DrawDots', G.pWindow, [0, 0], G.fixDotSize*G.pixPerDeg, 0, G.screenCenter, 1);
        Screen('DrawDots', G.pWindow, [0, 0], 0.5*G.fixDotSize*G.pixPerDeg, G.fixDotColor, G.screenCenter, 1);

    %     G.B.sendTrigger(G.triggers.locBlock.stimOff);
        time = Screen('Flip', G.pWindow, nextOnset - G.flipLag);
    %     log.onsets = [log.onsets, time];

    %     if isnan(data.resp)
    %     cfg = [];
    %     cfg.validKeys = G.validKeys;
    %     cfg.endTime = time + cfg.ISI - G.pressLag;  
    %     [data.resp, log.respTime] = getResponse(cfg);
    %     end






%          nextOnset = log.trial{in}.lastOnset + log.ISI(in);
         nextOnset = time + log.ISI(in);



    end
        Screen('Close', pStim);
        G.close();
    catch X
        sca

end

%     
% % Make a shape:
% % Make a shape:
% m = objMakePlain('ellipsoid')
% % View it (use mouse to rotate):
% objView(m)
% 
% objMakePlain   % plain shape, no modulation
% objMakeSine    % add sinusoidal perturbations
% objMakeNoise   % add filtered noise to the shape
% objMakeBump    % add gaussian bumps
% objMakeCustom  % add perturbations defined by your own
%                % function, matrix, or image
% base shapes are sphere, ellipsoid, plane, disk, torus, and cylinder. 
% 
% 
% a=10*rand();
% b=0.6*rand();
% c=4*rand();
% o = objMakeBump('sphere',[a b c]);
% objectView(o)
