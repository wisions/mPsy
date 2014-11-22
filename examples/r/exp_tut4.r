
source('mPsy.r')

# EXPERIMENT
win <- mpsy_info()
cx <- round(win[1]/2)
cy <- round(win[2]/2)

# prepare grating configuration
pleft <- Params(width=400.0,speed=20.0,fs=40.0)
# p4 will be the same as p3, with speed 40.0
pright <- copy_params(pleft,speed=40.0)


speeds <- 10 + 10*runif(12)
dim(speeds) <- c(6,2)

# setup presentation screens
stimuli_gratings = list( Grating(c(cx-350,cy),pleft), 
                         Grating(c(cx+350,cy),pright) )

welcome_line  = list( Text(c(cx,cy-50),Params(msg='Press SPACE when ready.')) )
farewell_line = list( Text(c(cx,cy-50),Params(msg='Game over!')) )
response_line = list( Text(c(cx,cy),Params(msg='Which was faster\nLeft or Right')) )
dot = list( Dot(c(cx,cy),Params(c=0.5)) )

keys_none    = list()
keys_default = list(key.SPACE,key.C,key.N,key.LEFT,key.RIGHT)

# setup trials

# add a message screen, wait until button press (duration=0 means wait)
#trials <- append(trials, list( Trial('Start',welcome_line,0,keys_default)))
trials <- list(Trial('Start',welcome_line,0,keys_default))

# add three Trials each consisting of a Fixation, 
# Stimulus and a Response screen
for (i in 1:3)
{
    trial = list( Trial('Fixation',             dot, 1000, keys_none   ),
                  Trial('Gratings',stimuli_gratings, 1500, keys_none   ),
                  Trial('Response',   response_line,    0, keys_default) )
    trials <- c(trials, trial)
}

trials <- c(trials,list(Trial('End', farewell_line, 0, keys_none)))

# tell mPsy about trials
set_trials(trials)

# watch the events for 10 seconds
for (i in 1:10)
{
    Sys.sleep(1.0)
    events = mpsy_events()
    if (length(events) > 0)
        for (j in 1:length(events))
        {
            ev = events[[j]]
            cat(sprintf("Event: \"%s\" triggered at %0.3f\n",ev[[1]],ev[[2]]))
        }
}

