function [dataFile, logFile] = mainBlock(cfg0)

global G;

log = [];
log.cfg0 = cfg0;
log.datestr = datestr(now, 'dd-mmm-yyyy_HH-MM-SS');
log.interrupt = [];

%% Generate stimulus conditions
% Normals
condNorm = [ ...
    repmat([1, 1, 0], [cfg0.nNormal(1, 1), 1]); ...
    repmat([1, 2, 0], [cfg0.nNormal(1, 2), 1]); ...
    repmat([2, 1, 0], [cfg0.nNormal(2, 1), 1]); ...
    repmat([2, 2, 0], [cfg0.nNormal(2, 2), 1]); ...
    repmat([3, 1, 0], [cfg0.nNormal(3, 1), 1]); ...
    repmat([3, 2, 0], [cfg0.nNormal(3, 2), 1]); ...
];    

nNorm = size(condNorm, 1);
condNorm = condNorm(randperm(nNorm), :);

% Oddballs
condOB = [ ...
    repmat([1, 1, 1], [cfg0.nOddball(1, 1), 1]); ...
    repmat([1, 2, 1], [cfg0.nOddball(1, 2), 1]); ...
    repmat([2, 1, 1], [cfg0.nOddball(2, 1), 1]); ...
    repmat([2, 2, 1], [cfg0.nOddball(2, 2), 1]); ...
    repmat([3, 1, 1], [cfg0.nOddball(3, 1), 1]); ...
    repmat([3, 2, 1], [cfg0.nOddball(3, 2), 1]); ...
];    

nOddball = size(condOB, 1);
condOB = condOB(randperm(nOddball), :);

% Spread oddballs over normal trials
nTrial = nNorm + nOddball;
group = ceil((1:nTrial)*(nOddball/nTrial));

indexOddball = zeros(nOddball, 1);
for iOddball = 1:nOddball
    curGroup = find(group==iOddball);
    indexOddball(iOddball) = curGroup(randi(length(curGroup)));
end    

% Combine normal and oddball trials
cond = zeros(nTrial, 3);

cond(setdiff(1:nTrial, indexOddball), :) = condNorm;
cond(indexOddball, :) = condOB;

%% Initialize
dataFile = [G.dataPath, 'dataSubj', num2str(G.curSubj), '_', log.datestr, '.mat'];
logFile = [G.logPath, 'logSubj', num2str(G.curSubj), '_', log.datestr, '.mat'];

data = cell(nTrial, 1);
log.trial = cell(nTrial, 1);

%% Loop over trials
% Start with fixation dot
Screen('DrawDots', G.pWindow, [0, 0], G.fixDotSize*G.pixPerDeg, 0, G.screenCenter, 1);
Screen('DrawDots', G.pWindow, [0, 0], 0.5*G.fixDotSize*G.pixPerDeg, G.fixDotColor, G.screenCenter, 1);
time = Screen('Flip', G.pWindow);
log.preFixOnset = time;

nextOnset = time + 2;

for in = 1:nTrial
    log.ISI(in) = rand*range(G.mainBlock.ISI) + G.mainBlock.ISI(1);
    
    % Do trial
    cfg = [];
    cfg.stim1 = cond(in, 1);
    cfg.stim2 = cond(in, 2);
    cfg.oddball = cond(in, 3);
    cfg.tempGap = cfg0.tempGap;
    cfg.nextOnset = nextOnset;
    cfg.ISI = log.ISI(in);
    
	[trialData, log.trial{in}] = mainTrial(cfg);

    nextOnset = log.trial{in}.lastOnset + log.ISI(in);

    % Store data    
    data{in} = [in, cfg0.tempGap, cond(in, :), trialData.resp, trialData.RT];
   
    % Save data to disk
    save(dataFile, 'data', '-v6');
    save(logFile, 'log', '-v6');
    
    % Interrupt trial?
    [~, ~, keyCode] = KbCheck;
    if (ismember(G.interrupt, find(keyCode)))
        DrawFormattedText(G.pWindow, 'Experiment temporarily interrupted by researcher.\n\nPlease wait...', 'center', 'center', G.textColor);
        Screen('Flip', G.pWindow);
        G.B.sendTrigger(G.triggers.control.interrupt);
        
        waitForResearcher;
        
        Screen('DrawDots', G.pWindow, [0, 0], G.fixDotSize*G.pixPerDeg, 0, G.screenCenter, 1);
        Screen('DrawDots', G.pWindow, [0, 0], 0.5*G.fixDotSize*G.pixPerDeg, G.fixDotColor, G.screenCenter, 1);

        G.B.sendTrigger(G.triggers.control.resume);
        time = Screen('Flip', G.pWindow);

        nextOnset = time + 2;
    end
end

trialType = cellfun(@(X) X.trialType, log.trial);

pHit = mean(trialType(ismember(trialType, [1, 3])) == 1);
nFA = sum(trialType == 2);
DrawFormattedText(G.pWindow, sprintf('End of the block\n\n\nPercentage correct presses: %2.1f%%\nNumber of incorrect presses: %g\n\n\n\nPress to continue...', pHit*100, nFA), 'center', 'center', G.textColor);
Screen('Flip', G.pWindow, nextOnset);

pause(0.5); 

cfg = [];
cfg.endTime = inf;
cfg.validKeys = G.validKeys;
getResponse(cfg);

end
