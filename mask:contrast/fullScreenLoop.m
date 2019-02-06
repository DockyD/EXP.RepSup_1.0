function fullScreenLoop

global G;

flag = 0;
keycode = 1;

while(find(keycode) ~= KbName('F8'))
    switch flag
        case 0
            text = 'Check';
            flag = 1;
        case 1
            text = 'Test';
            flag = 0;
    end
    DrawFormattedText(G.pWindow, text, 'center', 'center', G.textColor);
    Screen('Flip', G.pWindow);
    
    KbReleaseWait(G.keyboardNumber);
    [~, keycode] = KbWait(G.keyboardNumber);
end

end
