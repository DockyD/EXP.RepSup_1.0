function triggers = defTriggers()

triggers = [];

triggers.mainBlock.preFixOn = 10; 
triggers.mainBlock.stim1On = 20; 
triggers.mainBlock.tempGapOn = 30;
triggers.mainBlock.stim2On = 40; 
triggers.mainBlock.postFixOn = 50;
triggers.mainBlock.postBlankOn = 60;
  
%%%%%%%%%%%%%triggers.maskblock
%triggers for masks and triggers for high/low contrast stimuli

triggers.locBlock.stimOn = 100; 
triggers.locBlock.oddballOn = 110;
triggers.locBlock.stimOff = 150;

triggers.control.interrupt = 254;
triggers.control.resume = 255;

triggers.ET.stimOnset = 200;              % Range 201:234, for all ET positions

end

