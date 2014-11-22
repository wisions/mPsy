
mimport('matlab');

win = mpsy_info();
cx = round(win.width/2);
cy = round(win.height/2);

set_background([0.5,0.5,0.5])

info    = { Text([cx,cy],Params('msg','Next?')) };
mask_for_dots = Mask([cx,cy],Params('width',600.0,'height',600.0, ...
                                    'bgcolor',[0.5,0.5,0.5],'sigma',0.25,'edge',14.0));

trials = {};

for i = 1:10,
    dirs = 2*pi*rand(1,2);
    speed0 = 2.0;
    speed1 = 1.0;
    d0 = speed0.*[ cos(dirs(1)),sin(dirs(1)) ];
    d1 = speed1.*[ cos(dirs(2)),sin(dirs(2)) ];
    trials = [ trials, ...
               Trial('RDK', { RDK([cx,cy],Params('width',400.0,'d0',d0,'d1',d1)), mask_for_dots }, 1000, [] ), ...
               Trial('Break', info, 0, {key.SPACE} )];
end

set_trials(trials);

