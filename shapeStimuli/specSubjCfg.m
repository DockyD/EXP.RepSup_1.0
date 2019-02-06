clear all;

curSubj = 1;

subjCfgPath = 'subjCfg/';

subjCfg = [];
%load([subjCfgPath, 'subjCfg', num2str(curSubj), '.mat']);

rng('shuffle');

%% Select stimuli
stimPath = 'Stimuli/ObjectsMEG/';

files = arrayfun(@(X) X.name, dir(stimPath), 'uniformoutput', 0);
files = files(cellfun(@(X) X(1) ~= '.', files));

selFiles = randperm(length(files), 5);
subjCfg.stimFiles.A = files(selFiles(1:3));
subjCfg.stimFiles.B = files(selFiles(4:5));

stimA = cell(3, 1);
for a = 1:3
    stimA{a} = imread([stimPath, subjCfg.stimFiles.A{a}]);
end    

stimB = cell(2, 1);
for a = 1:2
    stimB{a} = imread([stimPath, subjCfg.stimFiles.B{a}]);
end    

figure;
subplot(3, 2, 1); imshow(stimA{1}); title('A1');
subplot(3, 2, 3); imshow(stimA{2}); title('A2');
subplot(3, 2, 5); imshow(stimA{3}); title('A3');
subplot(3, 2, 2); imshow(stimB{1}); title('B1');
subplot(3, 2, 4); imshow(stimB{2}); title('B2');

%% Counterbalancing of tempGap blocks
orderSubj1 = 0;
orderSubj2 = 1;
orderSubj3 = 0;
orderSubj4 = 1;
orderSubj5 = 0;
orderSubj6 = 1;
orderSubj7 = 0;
orderSubj8 = 1;
orderSubj9 = 0;
orderSubj10 = 1;
orderSubj11 = 0;
orderSubj12 = 1;
orderSubj13 = 0;
orderSubj14 = 1;
orderSubj15 = 0;
orderSubj16 = 1;
orderSubj17 = 0;
orderSubj18 = 1;
orderSubj19 = 0;
orderSubj20 = 1;
orderSubj21 = 0;
orderSubj22 = 1;
orderSubj23 = 0;
orderSubj24 = 1;
orderSubj100 = 0;

eval(['subjCfg.Order = orderSubj', num2str(curSubj), ';']);

%% Save subjCfg
fileName = [subjCfgPath, 'subjCfg', num2str(curSubj), '.mat'];
if ~exist(fileName)
    save(fileName, 'subjCfg');
else
    error('subjCfgalready exists for Subj%G', curSubj);
end
    