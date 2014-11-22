
mimport('matlab');

if ~mpsy_alive()
    mpsy_start_safe();
end

win = mpsy_info();
cx = round(win.width/2);
cy = round(win.height/2);

set_background([0.5,0.5,0.5]);

% prepare grating configuration
pleft = Params('width',400.0,'speed',20.0,'fs',40.0);
% p4 will be the same as p3, with speed 40.0
pright = copy_params(pleft,'speed',40.0);

% setup trials
trials = {};

speeds = 10 + 10*rand(6,2);

% setup presentation screens
stimuli_gratings = { Grating([cx-350,cy],pleft), ...
                     Grating([cx+350,cy],pright) };

welcome_line  = { Text([cx,cy-50],Params('msg','Press SPACE when ready.')) };
farewell_line = { Text([cx,cy-50],Params('msg','Game over!')) };
response_line = { Text([cx,cy],Params('msg','Which was faster\nLeft or Right')) };
dot = { Dot([cx,cy],Params('c',0.5)) };

% setup trials
trials = {};  

keys_none    = [];
keys_default = [key.SPACE,key.C,key.N,key.LEFT,key.RIGHT];

% add a message screen, wait until button press (duration=0 means wait)
trials(end+1) = { Trial('Start',welcome_line,0,keys_default) };

% add three Trials each consisting of a Fixation, 
% Stimulus and a Response screemn
for i = 1:3
    trials = [ trials, ...
               Trial('Fixation',             dot, 1000, keys_none   ), ...
               Trial('Gratings',stimuli_gratings, 1500, keys_none   ), ...
               Trial('Response',   response_line,    0, keys_default) ];
end

trials{end+1} = Trial('End', farewell_line, 0, keys_none);

% tell mPsy about trials
set_trials(trials);

% watch the events for 10 seconds
for i = 1:10,
    pause(1.0);
    events = mpsy_events;
    for j = 1:length(events),
        disp(events{j});
    end
end
