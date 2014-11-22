
mimport('matlab');

win = mpsy_info();
cx = round(win.width/2);
cy = round(win.height/2);
set_background([0.5,0.5,0.5,1.0]);

% setup presentation screens
start    = { Text([cx,cy-50],Params('msg','Press UP when ready.')) };
response = { Text([cx,cy-50],Params('msg','LEFT or RIGHT')) };
dot = { Dot([cx,cy],Params('c',0.5)) };

% setup trials
trials = {};

keys_none     = [];
keys_default  = [key.UP,key.DOWN];
keys_response = [key.LEFT,key.RIGHT];

% add a message screen, wait until button press (duration=0 means wait)
trials(end+1) = { Trial('Start',start,0,keys_default) };

% generate shuffled stimulus parameter set
[fs,speeds] = meshgrid([10.0,20.0],[-10,-5,5,10]);
ps = [fs(:), speeds(:)];
ips = randperm(size(ps,1));
ps = [ps(ips,:), ones(size(ps,1),1);];

% add three Trials each consisting of a Fixation, 
% Stimulus and a Response screemn
run = 1;
while run,
    for i = 1:size(ps,1)
        cur_params = ps(i,:);
        pcenter = Params('width',200.0,'speed',ps(i,2),'fs',ps(i,1),'contr',ps(i,3));
        % setup presentation screens
        stimuli_gratings = { Grating([cx,cy], pcenter) };

        trials = { Trial('Fixation',             dot, 1000, keys_none   ), ...
                   Trial('Gratings',stimuli_gratings,  500, keys_none   ), ...
                   Trial('Response',        response,    0, keys_response) };

        % tell mPsy about trials
        set_trials(trials);

        % wait for response
        correct = ps(i,2) > 0;
        [t,tr,data] = mpsy_wait_for('KEY','Response');
        if isnan(t), 
            disp('Stimulus presentation program has stopped!');
            run = 0;
            break;
        end

        if strcmp(data{1},'RIGHT'), resp = 1;
        elseif strcmp(data{1},'LEFT'), resp = 0; end

        [ps(i,:), resp, correct]
        if resp == correct
            ps(i,3) = min(1.0,ps(i,3)*2.0);
            fprintf('Increasing contrast for fs=%0.2f and speed=%0.2f. [c=%0.2f]\n',ps(i,1),ps(i,2),ps(i,3));
        else
            ps(i,3) = ps(i,3)/2.0;
            fprintf('Decreasing contrast for fs=%0.2f and speed=%0.2f. [c=%0.2f]\n',ps(i,1),ps(i,2),ps(i,3));
        end
    end
    % one run is done, shuffle the parameters again
    ips = randperm(size(ps,1));
    ps = ps(ips,:);
end

% the final measurement will be available in the workspace as variable "ps"
ps
