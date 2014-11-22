function [evtime,trial,data] = mpsy_wait_for(evt,evname)
% Block until the first Event 'evt'. If 'evname' is specified
% block until Event 'evt' with specified name of Trial object.
% This function periodically checks mPsy presentation for events,
% discard all event which do not match arguments.
%
%   [evtime,trial,data] = mpsy_wait_for(evt,evname)
% 
%   Input:
%       evt     - event type 'TRIAL','KEY', ...
%       evname  - optional name of trial
%   Output:
%       evtime  - time of event in mPsy presentation
%       trial   - trial object (useful for testing trial's stimuli properties)
%       data    - event parameters (vary with types)
%
%   Examples:
%
%   % wait for response
%   [t,tr,data] = mpsy_wait_for('KEY','Response');
%   if isnan(t),
%       disp('Stimulus presentation program has stopped!');
%       return;
%   end
%   if strcmp(data{1},'RIGHT'),
%       resp = 1;
%   elseif strcmp(data{1},'LEFT'), 
%       resp = 0; 
%   end
% 
%
% See also mpsy_cmd, mpsy_events
%
% This file is a part of mPsy (https://github.com/juricap/mPsy)
% Written by Peter Jurica (juricap@gmail.com)

    if nargin < 2, evname = ''; end
    while 1,
        pause(0.25);
        events = mpsy_events();
        if ~isempty(events) && strcmp(events{1}{1},'STOP'), break; end
        for j = 1:length(events),
            [evtype,evtime,trial,data] = deal(events{j}{:});
            if strcmp(evtype,evt)
                if ~isempty(evname)
                    if strcmp(trial.name,evname), return; end
                else
                    return;
                end
            end
        end
    end
    
    evtime = nan;
    trial = {};
    data = {};
end

