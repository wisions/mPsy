
# in case you run from "examples" directory
# add main mPsy (stimuli.py) directory to the path
import sys
sys.path.append('..')

from stimuli import *

def main():
    fullscreen = False
    kwargs = {}
    if not fullscreen:
        kwargs = dict(width=1024,height=768)
    win = ExpWindow(fullscreen,**kwargs)

    w, h = win.width, win.height
    cx, cy = win.width //2, win.height //2

    # tell mPsy about remote control
    import web
    remote = web.Remote(5000)
    win.set_remote(remote)
    # capture event by the remote control
    win.set_logger(remote.event)
    
    # run experiment
    # mPsy takes Trials from the begining of the trials list
    # if the trials list is eempty mPsy waits
    # ESCAPE stops the experiment at any time
    run()

if __name__ == "__main__":
    main()

