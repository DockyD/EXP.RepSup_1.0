% Class "Bitsi"
% - Modified by Pim Mostert, july 2016

classdef BitsiPim<handle % extend handle so that properties are modifiable (weird matlab behavior)
    
    properties (SetAccess = public)
        serobj;
        debugmode = false;
        validResponses = 1:255;
        triggerLog = [];
    end
    
    methods
        function B = BitsiPim(comport)
            if (strcmp(comport, ''))
                fprintf('Bitsi: No Com port given, running in testing mode...\n')
                B.debugmode = true;
                
                KbName('UnifyKeyNames');
            end
            
            if (not(B.debugmode))
                delete(instrfind);
                B.serobj = serial(comport);
                
                % serial port configuration
                set(B.serobj, 'Baudrate',        115200);
                set(B.serobj, 'Parity',          'none');
                set(B.serobj, 'Databits',        8);       % number of data bits
                set(B.serobj, 'StopBits',        1);       % number of stop bits
                %set(B.serobj, 'Terminator',      'CR/LF'); % line ending character
                % see also:
                % http://www.mathworks.com/matlabcentral/newsreader/view_original/292759
                
                %set(B.serobj, 'InputBufferSize', 1);       % set read buffBuffer for read
                set(B.serobj, 'FlowControl',     'none');   %
                
                % open the serial port
                fopen(B.serobj);
                
                % since matlab pulls the DTR line, the arduino will reset
                % so we have to wait for the initialization of the controller
                oldState = pause('query');
                pause on;
                pause(2.5);
                pause(oldState);
                
                % read all bytes available at the serial port
                status = '[nothing]';
                
                if B.serobj.BytesAvailable > 0
                    status = fread(B.serobj, B.serobj.BytesAvailable);
                end
                
                %fprintf('BITSI says: %s', char(status));
                %fprintf('\n');
            end
        end
        
        
        function sendTrigger(B, code)
            % checking code range
            if code > 255
                error('Bitsi: Error, code should not exeed 255\n');
            end
            
            if code < 1
                error('Bitsi: Error, code should be bigger than 0\n');
            end
            
            if ~B.debugmode
                fwrite(B.serobj, code)
            end
            
            fprintf('Bitsi: trigger code %i\n', code);
            
            % log trigger
            B.triggerLog(end+1).value = code;
            B.triggerLog(end).timestamp = GetSecs();            
        end
        
        
        function x = numberOfResponses(B)
            x = B.serobj.BytesAvailable;
        end
        
        
        function clearResponses(B)
            if ~B.debugmode
                numberOfBytes = B.serobj.BytesAvailable;
                if numberOfBytes > 0
                    fread(B.serobj, numberOfBytes);
                end
            end
        end

       
        function [response, respTime] = getResponse(B, endTime)
            response = nan;
            respTime = nan;
            
            while (GetSecs < endTime)
                % if there wasn't a response before and there is a
                % serial character available
                if isnan(response) && (B.serobj.BytesAvailable > 0)
                    respTime = GetSecs;
                    response = fread(B.serobj, 1);

                    % allow only characters present in the
                    % validResponses array
                    if (any(B.validResponses == response))
                        break;
                    else
                        response = nan;
                        respTime = nan;
                    end
                end
            end
        end
        
        
        % close
        function close(B)
            if (not(B.debugmode))
                fclose(B.serobj);
                delete(B.serobj);
            end
        end
    end
end