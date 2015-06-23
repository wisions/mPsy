
# in case you run from "examples" directory
# add main mPsy (stimuli.py) directory to the path
import sys
sys.path.append('..')

from stimuli import *

# create an object of which function '__call__' is called on all events like
# TRIAL, MOUSE, KEY ...
class DataFile:
    def __init__(self,fname):
        self.log = open(fname,'wb')  # a general log, timestamps of stimulus onsets, reponses ...
    def __call__(self,event,time,trial,args):
        if event == 'TRIAL' and trial.name == 'Gratings':
            s0, s1 = trial.stimuli
            self.params = [s0.params, s1.params]
        if event == 'KEY' and trial.name == 'Response':
            pl,pr = self.params
            # store spatial frequency and speed of left and right
            # also store response key and correctness
            correct = 0
            if (pl.speed >= pr.speed and args == 'LEFT') or \
                    (pl.speed <= pr.speed and args == 'RIGHT'):
                correct = 1
            print >>self.log, '%s,%f,%f,%f,%f,%s,%d'%(trial.name,pl.fs,pr.fs,pl.speed,pr.speed,args,correct)


#############################################################################

fullscreen = True #False
win = ExpWindow(fullscreen)

w, h = win.width, win.height
cx, cy = win.width //2, win.height //2

# prepare grating configuration
pleft = Params(width=400.0,speed=20.0,fs=40.0)
# p4 will be the same as p3, with speed 40.0
pright = copy_params(pleft, speed = 40.0)

# setup trials
trials = []

speeds = 10 + 10*rand(6,2)

# add a message screen and a fixation mark, wait until button press (duration=0 means wait)

trials += [ Trial('Start',[Dot((cx,cy),Params(c=0.5)),Text((cx,cy-50),Params(msg='Press SPACE when ready.'))],1000,
                  keys=[key.SPACE,key.C,key.N,key.LEFT,key.RIGHT]) ]

# add three Trials each consisting of a Fixation, Stimulus and a Response screem
for i in xrange(3):
    # setup two gratings
    stimuli_gratings = [ Grating((cx-350,cy),copy_params(pleft,speed=speeds[i,0])),
                         Grating((cx+350,cy),copy_params(pleft,speed=speeds[i,1])) ]
    trials += [Trial('Fixation',[Dot((cx,cy),Params(c=0.5))],1000),
               Trial('Gratings',stimuli_gratings,1500),
               Trial('Response',[Text((cx,cy),Params(msg='Which was faster\nLeft or Right'))],0,
                     keys=[key.C,key.N,key.LEFT,key.RIGHT])]

# add a message screen that waits until button press
trials += [Trial('Break',[Text((cx,cy-50),Params(msg='Take a break. Press SPACE when ready.'))],0,keys=[key.SPACE])]

for i in xrange(3):
    stimuli_gratings = [ Grating((cx-350,cy),copy_params(pleft,speed=speeds[i+3,0])),
                         Grating((cx+350,cy),copy_params(pleft,speed=speeds[i+3,1])) ]
    trials += [Trial('Fixation',[Dot((cx,cy),Params(c=0.5))],1000),
               Trial('Gratings',stimuli_gratings,1500),
               Trial('Response',[Text((cx,cy),Params(msg='Which was faster\nLeft or Right'))],0,
                     keys=[key.C,key.N,key.LEFT,key.RIGHT])]

trials += [Trial('End',[Text((cx,cy),Params(msg='Game over!'))],0)]

# tell mPsy about trials
win.set_trials(trials)

# tell mPsy about events listener
win.set_logger(DataFile('tut3_%s.txt'%time.strftime('%Y%m%d%H%M%S',time.localtime())))

# run experiment
# mPsy takes Trials from the begining of the trials list
# if the trials list is eempty mPsy waits
# ESCAPE stops the experiment at any time
run()

