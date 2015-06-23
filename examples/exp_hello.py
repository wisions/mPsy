
# in case you run from "examples" directory
# add main mPsy (stimuli.py) directory to the path
import sys
sys.path.append('..')

from stimuli import *

fullscreen = True #False
win = ExpWindow(fullscreen)

w, h = win.width, win.height
cx, cy = win.width //2, win.height //2

# prepare grating configuration
pleft = Params(width=400.0,speed=20.0,fs=30.0)
# p4 will be the same as p3, with speed 40.0
pright = copy_params(pleft, speed = 40.0)

# setup presentation screens
stimuli = [ Rectangle((cx,cy)) ]

welcome_line  = [Text((cx,cy-50),Params(msg='Press SPACE when ready.'))]
farewell_line = [Text((cx,cy-50),Params(msg='Game over!'))]

# setup trials
trials = []

keys_none    = []
keys_default = [key.SPACE,key.C,key.N,key.LEFT,key.RIGHT]

# add a message screen, wait until button press (duration=0 means wait)
trials += [ Trial('Start',  welcome_line, 0, keys_default) ]
trials += [ Trial('Test' ,       stimuli, 0, keys_default) ]
trials += [ Trial('End'  , farewell_line, 0, keys_none) ]

# tell mPsy about trials
win.set_trials(trials)

# run experiment
# mPsy takes Trials from the begining of the trials list
# if the trials list is eempty mPsy waits
# ESCAPE stops the experiment at any time
run()

