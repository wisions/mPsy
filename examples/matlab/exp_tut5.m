
mimport('matlab');

win = mpsy_info();
cx = round(win.width/2);
cy = round(win.height/2);
set_background([0.5,0.5,0.5,1.0]);

% setup trials
trials = {};

% setup presentation screens
start    = { Text([cx,cy-50],Params('msg','Press UP when ready.')) };
response = { };
dot = { Dot([cx,cy],Params('c',0.5)) };

% setup trials
trials = {};

keys_none     = [];
keys_default  = [key.UP,key.DOWN];
keys_response = [key.LEFT,key.RIGHT];

% add a message screen, wait until button press (duration=0 means wait)
trials(end+1) = { Trial('Start',start,0,keys_default) };

% generate shuffled stimulus parameter set
[contrasts,speeds] = meshgrid([0.1 0.5 1.0],[-10,10]);
ps = [contrasts(:), speeds(:)];
ps = ps(randperm(size(ps,1)),:);

% add three Trials each consisting of a Fixation, 
% Stimulus and a Response screemn
for i = 1:size(ps,1)
    pcenter = Params('width',200.0,'speed',ps(i,2),'fs',20.0,'contr',ps(i,1));
    % setup presentation screens
    stimuli_gratings = { Grating([cx,cy],pcenter) };
    
    trials = [ trials, ...
               Trial('Fixation',             dot, 1000, keys_none   ), ...
               Trial('Gratings',stimuli_gratings,  500, keys_none   ), ...
               Trial('Response',        response,    0, keys_response) ];
end

% tell mPsy about trials
set_trials(trials);

% watch the events and write to a file
datafid = fopen('ext_tut5.log','wt');
cur_params = [];
while 1,
    pause(1.0);
    events = mpsy_events();
    if ~isempty(events) && strcmp(events{1}{1},'STOP'), break; end
    for j = 1:length(events),
        [evtype,evtime,trial,data] = deal(events{j}{:});
        if strcmp(evtype,'TRIAL') && strcmp(trial.name,'Gratings')
            params = trial.stimuli{1}.params;
            % remember the most recent grating parameters
            cur_params = [params.fs, params.contr, params.speed];
        elseif strcmp(evtype,'KEY') && ~isempty(cur_params)
            % write response and remembered grating parameters
            fprintf(datafid,'%f %f %f %f %s\n', ...
                evtime, ...
                cur_params(1), cur_params(2), cur_params(3), ...
                data{1});
            cur_params = [];
        end
    end
end
fclose(datafid);

