
mimport('matlab');

win = mpsy_info();
cx = round(win.width/2);
cy = round(win.height/2);
set_background([0.5,0.5,0.5])

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

%Constants
ndots = 100;
speed = 2;
wid = 500;
width_mask = wid*3/2;


trials = {};
info    = { Text([cx,cy],Params('msg','Next?')) };
mask_for_dots = Mask([cx,cy],Params('width',width_mask,...
                'height',width_mask,'bgcolor',[0.5,0.5,0.5],...
                'sigma',0.25,'edge',14.0));


            
directions = [0 pi]; 

for i = 1:5, disp(i)
       
    dir =  directions(randi(2));
    d0 = speed*[cos(dir(1)), sin(dir(1))];

    trials = { Trial('Fixation',dot, 1000, keys_none   ), ...
     Trial('RDK', { RDK([cx,cy],Params('width',wid,'d0',d0,'n0',ndots,'n1',0)),...
       mask_for_dots }, 1000), ...
     Trial('Response', response, 0, keys_response )};
 
    set_trials(trials);
    
    % wait for response
    [t,tr,data] = mpsy_wait_for('KEY','Response');
    if isnan(t), disp('Stimulus presentation program has stopped!'); break;
    end
    
    if strcmp(data{1},'RIGHT'),    resp = 1;
    elseif strcmp(data{1},'LEFT'), resp = 0; end
    
end



