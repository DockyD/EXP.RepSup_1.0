

    try
        clear all;
        Screen('Preference', 'SkipSyncTests', 1);
        G = [];
        G.maxWhite = 42;
        G.BGcolor = G.maxWhite;  
        G.objPath = 'Stimuli/ObjectsMEG/';
        G.subjCfgPath = 'subjCfg/';
        G.curSubj = 1;
        tmp = load([G.subjCfgPath, 'subjCfg', num2str(G.curSubj), '.mat']);
        G.subjCfg = tmp.subjCfg;
        
        Screen('BlendFunction', theWindow, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);

        allScreens = Screen('Screens');
        G.pWindow = Screen('OpenWindow', allScreens(1), G.BGcolor);

        G.stim2 = cell(2, 1);       % Second stimulus: B and D
        G.stim2{1} = double(imread([G.objPath, G.subjCfg.stimFiles.B{1}])) * (G.maxWhite/255);
        G.stim2{2} = double(imread([G.objPath, G.subjCfg.stimFiles.B{2}])) * (G.maxWhite/255);
        
        pStim = Screen('MakeTexture', G.pWindow, G.stim2{1});
        Screen('DrawTexture', G.pWindow, pStim,[],[],0,0,.1);
        time = Screen('Flip', G.pWindow);
        WaitSecs(2)
        Screen('DrawTexture', G.pWindow, pStim,[],[],[],[],1);
        time = Screen('Flip', G.pWindow);
        WaitSecs(2)
        pStim = Screen('MakeTexture', G.pWindow, G.stim2{2});
        Screen('DrawTexture', G.pWindow, pStim);
        Screen('Flip', G.pWindow,2)
        WaitSecs(2)
        
        

        Screen('Close', pStim);
        G.close();
    catch X
        sca
    end

