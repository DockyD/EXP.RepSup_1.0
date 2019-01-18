function [resp, respTime] = getResponse(cfg0)

global G;

if ~isfield(cfg0, 'endTime');
    cfg0.endTime = inf;
end    
if ~isfield(cfg0, 'validKeys')
    cfg0.validKeys = [];
end

if G.MEG
    oldKeys = G.B.validResponses;
    G.B.validResponses = cfg0.validKeys;

    G.B.clearResponses;

    [resp, respTime] = G.B.getResponse(cfg0.endTime);

    if ~isnan(resp)
        resp = find(cfg0.validKeys==resp);
    end

    G.B.validResponses = oldKeys;    
else    
    oldKeys = RestrictKeysForKbCheck(cfg0.validKeys);
    FlushEvents('keyDown');

    KeyIsDown = 0;
    keyCode = [];
    while (GetSecs < cfg0.endTime) && ~KeyIsDown
        [KeyIsDown, respTime, keyCode] = KbCheck(G.keyboardNumber);
    end

    key = find(keyCode);
    if ~isempty(key)
        key = key(1);       % Sometimes two keypresses at the same time may be detected

        resp = find(cfg0.validKeys==key);
    else
        resp = nan;            
        respTime = nan;
    end

    RestrictKeysForKbCheck(oldKeys);
end

end