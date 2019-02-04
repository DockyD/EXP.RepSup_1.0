clear all

try
    
Screen('Preference', 'SkipSyncTests', 1)
    whichScreen = max(Screen('Screens')); % list the indexing of the screens
 
    [ window, rect ] = Screen('OpenWindow', whichScreen, [175 175 175]); 
    % initialize working window on the first screen, gray background
  
    WaitSecs(1);
    HideCursor; % hide cursor
    centerXY=[rect(3)/2 rect(4)/2]; % XY coordinates of the center of the screen

    Screen('DrawDots', window, centerXY, 20, [0 0 0]); % drawing a big black rectangular dot in the center of the screen
 
    Screen(window, 'flip');
    
    cond=repmat([1 2], 1, 5); %  % generate an array of conditions, 1 and 2 repeated 5 times (1 for red)

    cond=cond(randperm(10)); %randomise order of conditions    
    
    ISI=repmat([0:0.5:2], 1, 2); % inter-stimulus intervals will have 5 specific values
    ISI=ISI(randperm(10)); % randomize ISI
    
    keyFlags = zeros(1,256); % an array of zeros
    keyFlags([37 39])=1; % left and right arrows, left for red
    KbQueueCreate(0, keyFlags); % initialize the Queue
    
    RT=-ones(1, 10); % an array of ones for recording of reaction times
    RTkey=-ones(1, 10); % an array of minus ones for recording of the keys

    WaitSecs(2);
    
    for i=1:10;
        
        Screen('DrawDots', window, centerXY, 20, [250*(cond(i)==1) 250*(cond(i)==2) 0]); % colored dot

        [VBLTimestamp]=Screen(window, 'flip');
        KbQueueStart; % start recording
        
        Screen('DrawDots', window, centerXY, 20, [0 0 0]); % black dot
        Screen(window, 'flip', VBLTimestamp+1);
        
        WaitSecs(1); % in total waitong for responce up to 2 seconds
        
        KbQueueStop; % stop recording
                
        [pressed, firstPress, firstRelease, lastPress, lastRelease]=KbQueueCheck; % retrieve the created queue and clean it
        
        if pressed==1;
            RT(i)=firstPress(firstPress>0)-VBLTimestamp; % the post-cue of the first press of the keys
            RTkey(i)=find(firstPress>0);
        end;
            
        WaitSecs(ISI(i));
        
    end; % trial loop
        
    KbQueueRelease; % delets the queue
     
    sca

    t = clock;
    DateString = datestr(t, 'yyyy-mm-dd-HH-MM');
    filename=['RT_results_', DateString]
    save(filename, 'RT', 'RTkey', 'cond');
    
catch X
    
     sca  

    
end;