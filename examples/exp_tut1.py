
from stimuli import *

fullscreen = True #False
win = ExpWindow(fullscreen)
win.set_background([0.5,0.5,0.5])

w, h = win.width, win.height
cx, cy = win.width //2, win.height //2

# prepare grating configuration
pleft = Params(width=400.0,speed=20.0,fs=30.0)
# p4 will be the same as p3, with speed 40.0
pright = copy_params(pleft, speed = 40.0)

# setup presentation screens
stimuli_gratings = [ Grating((cx-350,cy),pleft),
                     Grating((cx+350,cy),pright) ]

welcome_line  = [Text((cx,cy-50),Params(msg='Press SPACE when ready.'))]
farewell_line = [Text((cx,cy-50),Params(msg='Game over!'))]
response_line = [Text((cx,cy),Params(msg='Which was faster\nLeft or Right'))]
dot = [Dot((cx,cy),Params(c=0.5))]


# setup trials
trials = []

keys_none    = []
keys_default = [key.SPACE,key.C,key.N,key.LEFT,key.RIGHT]

# add a message screen, wait until button press (duration=0 means wait)
trials += [ Trial('Start',welcome_line,0,keys_default) ]

# add three Trials each consisting of a Fixation, Stimulus and a Response screem
for i in xrange(3):
    trials += [Trial('Fixation',             dot, 1000, keys_none   ),
               Trial('Gratings',stimuli_gratings, 1500, keys_none   ),
               Trial('Response',   response_line,    0, keys_default)]

trials += [Trial('End',farewell_line,0,keys_none)]

# tell mPsy about trials
win.set_trials(trials)

# run experiment
# mPsy takes Trials from the begining of the trials list
# if the trials list is eempty mPsy waits
# ESCAPE stops the experiment at any time
run()

