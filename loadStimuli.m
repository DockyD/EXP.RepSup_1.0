function loadStimuli

global G;

% A1, A2, A3
G.stim1 = cell(3, 1);       % First stimulus: A and C

G.stim1{1} = double(imread([G.objPath, G.subjCfg.stimFiles.A{1}])) * (G.maxWhite/255);
G.stim1{2} = double(imread([G.objPath, G.subjCfg.stimFiles.A{2}])) * (G.maxWhite/255);
G.stim1{3} = double(imread([G.objPath, G.subjCfg.stimFiles.A{3}])) * (G.maxWhite/255);

% B1, B2
G.stim2 = cell(2, 1);       % Second stimulus: B and D

G.stim2{1} = double(imread([G.objPath, G.subjCfg.stimFiles.B{1}])) * (G.maxWhite/255);
G.stim2{2} = double(imread([G.objPath, G.subjCfg.stimFiles.B{2}])) * (G.maxWhite/255);

% Duckies
G.stimDucky = cell(G.nDuckies, 1);

for iDucky = 1:G.nDuckies
    G.stimDucky{iDucky} = double(imread([G.duckyPath, 'Ducky', num2str(iDucky), '.jpg'])) * (G.maxWhite/255);
end

end
