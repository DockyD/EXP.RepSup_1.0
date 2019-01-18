function [dataFile, logFile] = contTestBlock(cfg0)

global G;

log = [];
log.cfg0 = cfg0;
log.datestr = datestr(now, 'dd-mmm-yyyy_HH-MM-SS');
log.interrupt = [];

%% Generate stimulus conditions
cond = zeros(5, 5);
for a = 1:5
    cond(a, 1) = a-1;
    cond(a, 2:5) = setdiff(0:4, (a-1));
    cond(a, 2:5) = cond(a, randperm(4)+1);
end

cond = cond(randperm(5), :);
 
nTrial = 5;

%% Initialize
dataFile = [G.dataPath, 'dataSubj', num2str(G.curSubj), '_', log.datestr, '.mat'];
logFile = [G.logPath, 'logSubj', num2str(G.curSubj), '_', log.datestr, '.mat'];

data = cell(nTrial, 1);
log.trial = cell(nTrial, 1);

%% Loop over trials
for in = 1:nTrial
    % Do trial
    cfg = [];
    cfg.testStim = cond(in, 1);
    cfg.targStim = cond(in, 2:5);
    
	[trialData, log.trial{in}] = contTestTrial(cfg);

    % Store data
    data{in} = [in, cond(in, :), trialData.resp, trialData.RT];
   
    % Save data to disk
    save(dataFile, 'data', '-v6');
    save(logFile, 'log', '-v6');
end

end
