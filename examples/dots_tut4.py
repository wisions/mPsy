
from stimuli import *
from random import shuffle

# 
# create an object of which function '__call__' is called on all events like
# TRIAL_START, MOUSE, KEY ...
class DataFile:
    def __init__(self,fname):
        self.log = open(fname,'wb')  # a general log, timestamps of stimulus onsets, reponses ...
    def __call__(self,event,time,trial,args):
        if event == 'TRIAL' and trial.name == 'Lattices':
            # store the stimulus parameter
            self.trial_params = trial.stimuli[0].params
        elif event == 'MOUSE' and trial.name == 'Response':
            # find the closest response pill
            i = argmin([ abs(s.pos[0]-args[0]) for s in trial.stimuli ])
            p = self.trial_params
            print >>self.log, '%0.2f,%0.1f,%0.1f,%0.1f'%(p.r,degs(p.gamma),degs(p.theta),degs(trial.stimuli[i].th))
        elif event == 'KEY' and trial.name == 'Response':
            # find the selected response pill
            i = keys_response.index(args[1])
            p = self.trial_params
            print >>self.log, '%0.2f,%0.1f,%0.1f,%0.1f'%(p.r,degs(p.gamma),degs(p.theta),degs(trial.stimuli[i].th))

#############################################################################

fullscreen = True #False
win = ExpWindow(fullscreen)

w, h = win.width, win.height
cx, cy = win.width //2, win.height //2

# prepare grating configuration
p_lattice =  Params(ap_fs=0.0, ap_sigma=130.0, ap_edge=4.0,
                    gamma=pi/2, theta=0.0, dx=60.0, r=1.5,
                    dot_size=100.0, dot_sigma=0.3, dot_fs=0.0,
                    dot_edge=10.0, dot_c=0.4, dot_phi=0.2)

# setup presentation screens
stimuli_dots = [ DotLattice((cx,cy),p_lattice) ]

# this time response screen is different for every trial
# we make a function that will generate proper response choice
def response_screen(t1,t2,t3):
    out = [ Pill((cx-150,cy),Params(th=t1,R=55,d=5)),
            Pill((cx    ,cy),Params(th=t2,R=55,d=5)),
            Pill((cx+150,cy),Params(th=t3,R=55,d=5)) ]
    return out

def theta(p):
    t = p.theta
    g = p.gamma
    return [t,t+g,t+g/2]


welcome_line  = [Text((cx,cy-50),Params(msg='Press SPACE when ready.'))]
farewell_line = [Text((cx,cy-50),Params(msg='Thank you for participation!'))]
dot = [Dot((cx,cy),Params(c=0.5))]

# setup trials
trials = []

keys_none     = []
keys_space    = [key.SPACE]
keys_response = [key.NUM_1,key.NUM_2,key.NUM_3]
# key names are listed at http://www.pyglet.org/doc/api/pyglet.window.key-module.html

# add a message screen, wait until button press (duration=0 means wait)
trials += [ Trial('Start',welcome_line,0,keys_space) ]

# prepare 6*5 ratios
ratios = [ 1.0, 1.1, 1.2, 1.3, 1.4 ]*20

shuffle(ratios)
gamma = rads(60.0)

# and shuffle them

# add three Trials each consisting of a Fixation, Stimulus and a Response screem
for i,r in enumerate(ratios):
    # generate a new lattice, rotated by a random angle
    th = 0.0 #2*pi*rand()
    new_params = copy_params(p_lattice,r=r,gamma=gamma,theta=th)
    lattice = [DotLattice((cx,cy),new_params)]
    # create response button that correspond to presented stimuli
    options = theta(new_params)
    # shuffle(options)
    responses = response_screen( *options )
    # add the trial
    trials += [ Trial('Fixation',       dot, 1000, keys_none),
                Trial('Lattices',   lattice,  300, keys_none),
                Trial('Blank'   ,        [],  300, keys_none),
                Trial('Response', responses,    0, keys_response, mouse=True) ]


trials += [Trial('End',farewell_line,0,keys_none)]

# tell mPsy about trials
win.set_trials(trials)

# tell mPsy about events listener
win.set_logger(DataFile('dots_tut3_%s.txt'%time.strftime('%Y%m%d%H%M%S',time.localtime())))

# run experiment
# mPsy takes Trials from the begining of the trials list
# if the trials list is eempty mPsy waits
# ESCAPE stops the experiment at any time
run()

