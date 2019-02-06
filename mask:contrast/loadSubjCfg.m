function loadSubjCfg

global G;

tmp = load([G.subjCfgPath, 'subjCfg', num2str(G.curSubj), '.mat']);
G.subjCfg = tmp.subjCfg;

end
