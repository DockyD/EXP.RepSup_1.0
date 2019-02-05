function [dataFile, logFile] = contBlock(cfg0)

global G;

log = [];
log.cfg0 = cfg0;
log.datestr = datestr(now, 'dd-mmm-yyyy_HH-MM-SS');
log.interrupt = [];

%% Generate stimulus conditions
%%legend:   [imageA/B, OddBall, High/Low contrast]
%%          Fact 1 = bin for image A, High Contrast
%%          Fact 2 = bin for image B, low Contrast
%%          Fact 3 = bin for image A, High Contrast, OddBall
%%          Fact 4 = bin for image B, low Contrast, OddBall

trialOrder = carryoverCounterbalance(4,1,7,0);

fact1 = sum(trialOrder(:) == 1);
fact2 = sum(trialOrder(:) == 2);
fact3 = sum(trialOrder(:) == 3);
fact4 = sum(trialOrder(:) == 4);

fact1 = (repmat([1,0,0],(sum(trialOrder(4:) == 1)),1))...
        +(repmat([1,1,0],3,1));

fact2 = (repmat([2,0,0],(fact2-3),1))...
        +(repmat([2,1,0],3,1));

fact3 = (repmat([1,0,1],(fact3-3),1))...
        +(repmat([1,1,1],3,1));

fact4 = (repmat([2,0,1],(fact4-3),1))...
        +(repmat([2,1,1],3,1));


fact1 = fact1(randperm(size(fact1,1)),:);
fact2 = fact2(randperm(size(fact2,1)),:);
fact3 = fact3(randperm(size(fact3,1)),:);
fact4 = fact4(randperm(size(fact4,1)),:);

trials=[]
for i = length(trialOrder)
    if trialOrder(i) = 1
        trials = [trials; fact1(1,:)]
        fact1[1] = []
    else if trialOrder(i) = 2
        trials = [trials; fact2(1,:)]
        fact2(1) = []
    else if trialOrder(i) = 3
        trials = [trials; fact3(1,:)]
        fact3(1) = []
    else
        trials = [trials; fact4(1,:)]
        fact4(1) = []


condNorm = [ ...
    repmat([1, 0, 0], (fac1 - 3), 1); ...
    repmat([2, 0, 0], (fac2-3), 1); ...
    repmat([1, 0, 1], (fac3-3), 1); ...
    repmat([2, 0, 1], (fac4-3), 1); ...
];    

nNorm = size(condNorm, 1);
condNorm = condNorm(randperm(nNorm), :);

% Oddballs
condOB = [ ...
    repmat([1, 1, 0], 3, 1); ...
    repmat([2, 1, 0], 3, 1); ...
    repmat([1, 1, 1], 3, 1); ...
    repmat([2, 1, 1], 3, 1); ...
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
cond = zeros(nTrial, 2);

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
    log.ISI(in) = rand*range(G.locBlock.ISI) + G.locBlock.ISI(1);
    
    % Do trial
    cfg = [];
    cfg.stim = cond(in, 1);
    cfg.oddball = cond(in, 2);
    cfg.cont = cond(in,3);
    cfg.nextOnset = nextOnset;
    cfg.ISI = log.ISI(in);
    
	[trialData, log.trial{in}] = contTrial(cfg);

    nextOnset = log.trial{in}.lastOnset + log.ISI(in);

    % Store data    
    data{in} = [in, cond(in, :), trialData.resp, trialData.RT, trialData.correct];
   
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

data = cell2mat(data);

pHit = mean(~isnan(data(data(:, 3) == 1, 4)), 1);
nFA = sum(~isnan(data(data(:, 3) == 0, 4)), 1);
DrawFormattedText(G.pWindow, sprintf('End of the block\n\n\nPercentage correct presses: %2.1f%%\nNumber of incorrect presses: %g\n\n\n\nPress to continue...', pHit*100, nFA), 'center', 'center', G.textColor);
Screen('Flip', G.pWindow, nextOnset);

pause(0.5); 

cfg = [];
cfg.endTime = inf;
cfg.validKeys = G.validKeys;
getResponse(cfg);

end
