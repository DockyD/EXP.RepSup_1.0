tLoc = 1.5;
tMain = ( ...
    10*2.5 ...
    + 5*2.5 ...
    + 5*2.5 ...
    + 4*(2.5 + 0.13333333) ...
)/24;
tTrain = ( ...
    9*2.5 ...
    + 1*(2.5 + 0.13333333) ...
)/10;

nTrainBlock = 2;
nMainBlock = 6;
nLocBlock = 8;

nTrainTrial = 90;
nMainTrial = 144;
nLocTrial = 80;

tTotal = ...
    nLocBlock*nLocTrial*tLoc ...
    + nMainBlock*nMainTrial*tMain ...
    + nTrainBlock*nTrainTrial*tTrain;

fprintf('\n\n----------------------------------------\n');
fprintf('nLoc:\t %g\n', nLocBlock*nLocTrial);
fprintf('nMain:\t %g\n', nMainBlock*nMainTrial);
fprintf('nTrain:\t %g\n', nTrainBlock*nTrainTrial);
fprintf('----------------------------------------\n\n');
fprintf('tLocBlock:\t %.2fm\n', nLocTrial*tLoc/60);
fprintf('tMainBlock:\t %.2fm\n', nMainTrial*tMain/60);
fprintf('tTrainBlock:\t %.2fm\n', nTrainTrial*tTrain/60);
fprintf('----------------------------------------\n\n');
fprintf('tTotal:\t %.2fm\n', tTotal/60);
fprintf('----------------------------------------\n\n');



