
# in case you run from "examples" directory
# add main mPsy (stimuli.py) directory to the path
import sys
sys.path.append('..')

from stimuli import *

fullscreen = True #False
win = ExpWindow(fullscreen)

cx, cy = win.width //2, win.height //2

# prepare lattice configuration
p_lattice =  Params(ap_fs=3.0, ap_sigma=100.0, ap_edge=4.0,
                    gamma=70.0, theta=10.0, dx=40.0, r=1.5,
                    dot_size=150.0, dot_sigma=0.25, dot_fs=0.0,
                    dot_edge=10.0, dot_c=0.4, dot_phi=0.2)

# setup presentation screens
stimuli_dots = [ DotLattice((cx,cy),p_lattice) ]

response_screen = [ Pill((cx-100,cy),Params(th=0.1,R=30,d=3)),
                    Pill((cx    ,cy),Params(th=0.5,R=30,d=3)),
                    Pill((cx+100,cy),Params(th=1.5,R=30,d=3)) ]

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
# duration 0 means wait for response

# add three Trials each consisting of a Fixation, Stimulus and a Response screem
for i in xrange(3):
    trials += [Trial('Fixation',             dot, 1000, keys_none),
               Trial('Lattices',    stimuli_dots,  500, keys_none),
               Trial('Response', response_screen,    0, keys_none, mouse=True)] 

trials += [Trial('End',farewell_line,0,keys_none)]

# tell mPsy about trials
win.set_trials(trials)

# run experiment
# mPsy takes Trials from the begining of the trials list
# if the trials list is eempty mPsy waits
# ESCAPE stops the experiment at any time
run()

