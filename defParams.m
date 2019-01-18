function defParams

global G;

G.fixDotSize = .2;              % In degrees
G.fixDotColor = G.maxWhite;

G.nDuckies = 16;

% Main block
G.mainBlock.preFixDur = [.9, 1.1];
G.mainBlock.postFixDur = [.5];
G.mainBlock.ISI = [1 2];
G.mainBlock.stimDur = .5;

G.mainBlock.nNormal = [ ...
    24, 6; ... 
    15, 15; ...
    6, 24; ...
];
G.mainBlock.nOddball = [ ...
    3, 0; ... 
    2, 2; ...
    0, 3; ...
];

% Train block
G.trainBlock.nNormal = [ ...
    30, 0; ... 
    15, 15; ...
    0, 30; ...
];
G.trainBlock.nOddball = [ ...
    3, 0; ... 
    2, 2; ...
    0, 3; ...
];

% Localizer block
G.locBlock.stimDurPreOddball = 0.3;
G.locBlock.oddballDur = 0.1;
G.locBlock.stimDurPostOddball = 0.1;
G.locBlock.ISI = [.8 1.2];

G.locBlock.nNormal = [36, 36];        % Per stimulus
G.locBlock.nOddball = [4, 4];        % Per stimulus

% Eye-tracker block
[gridX, gridY] = meshgrid(-2:2);
positions = [gridX(:), gridY(:)];
positions = [positions; ...
    -.5, -.5; ...
    0, -.5; ...
    .5, -.5; ...
    -.5, 0; ...
    .5, 0; ...
    -.5, .5; ...
    0, .5; ...
    .5, .5 ...
];
positions = positions * 4*G.pixPerDeg;
G.ET.positions = positions;
G.ET.ITI = 1.5;         % in seconds

end