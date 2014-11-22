
from stimuli import *

# create a function that will be triggered by events TRIAL, MOUSE, KEY ...
log = open('dots2.log','wb')

def record_event(event,time,trial,args):
    print >>log, event, time, trial.name, args

#############################################################################

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

response_screen = [ Pill((cx-100,cy),Params(th= 0.1,R=30,d=3)),
                    Pill((cx    ,cy),Params(th= 0.5,R=30,d=3)),
                    Pill((cx+100,cy),Params(th=pi/2,R=30,d=3)) ]

welcome_line  = [Text((cx,cy-50),Params(msg='Press SPACE when ready.'))]
farewell_line = [Text((cx,cy-50),Params(msg='Game over!'))]
response_line = [Text((cx,cy),Params(msg='Which was faster\nLeft or Right'))]
dot = [Dot((cx,cy),Params(c=0.5))]

# setup trials
trials = []

keys_none    = []
keys_default = [key.SPACE,key.NUM_1,key.NUM_2,key.NUM_3]
# key names are listed at http://www.pyglet.org/doc/api/pyglet.window.key-module.html

# add a message screen, wait until button press (duration=0 means wait)
trials += [ Trial('Start',welcome_line,0,keys_default) ]

# add three Trials each consisting of a Fixation, Stimulus and a Response screem
for i in xrange(3):
    trials += [Trial('Fixation',             dot, 1000, keys_none),
               Trial('Lattices',    stimuli_dots, 1500, keys_none),
               Trial('Response', response_screen,    0, keys_default, mouse=True)] # duration 0 means wait for response


trials += [Trial('End',farewell_line,0,keys_none)]

# tell mPsy about loggin function
win.set_logger(record_event)

# tell mPsy about trials
win.set_trials(trials)

# run experiment
run()

