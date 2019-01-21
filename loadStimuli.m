function loadStimuli

global G;

% A1, A2, A3
G.stim1 = cell(3, 1);       % First stimulus: A and C

G.stim1{1} = double(imread([G.objPath, G.subjCfg.stimFiles.A])) * (G.maxWhite/255);
G.stim1{2} = double(imread([G.objPath, G.subjCfg.stimFiles.B])) * (G.maxWhite/255);

%contrast images generated here?

%mask generated here


end
