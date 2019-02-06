function loadStimuli

global G;

% B1, B2 
% change to A1,A2?
G.stim2 = cell(2, 1);       % Second stimulus: B and D

G.stim2{1} = double(imread([G.objPath, G.subjCfg.stimFiles.B{1}])) * (G.maxWhite/255);
G.stim2{2} = double(imread([G.objPath, G.subjCfg.stimFiles.B{2}])) * (G.maxWhite/255);

%contrast images generated here?

%mask generated here?


end
