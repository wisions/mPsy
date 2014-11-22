
source('mPsy.r')

# EXPERIMENT
win <- mpsy_info()
cx <- round(win[1]/2)
cy <- round(win[2]/2)

# prepare grating configuration
p_lattice =  Params(ap_fs=0.0, ap_sigma=130.0, ap_edge=4.0,
                    gamma=pi/2, theta=0.0, dx=60.0, r=1.5,
                    dot_size=100.0, dot_sigma=0.3, dot_fs=0.0,
                    dot_edge=10.0, dot_c=0.4, dot_phi=0.2)

# setup presentation screens
stimuli_dots = list( DotLattice(c(cx,cy),p_lattice) )

# this time response screen is different for every trial
# we make a function that will generate proper response choice
response_screen = function(t1,t2,t3,t4)
{
    list( Pill(c(cx+100,cy+100),Params(th=t1,R=55,d=5)),
          Pill(c(cx+100,cy-100),Params(th=t2,R=55,d=5)),
          Pill(c(cx-100,cy-100),Params(th=t3,R=55,d=5)),
          Pill(c(cx-100,cy+100),Params(th=t4,R=55,d=5)) )
}

theta = function(p)
{
    t = as.double(p['theta'])
    g = as.double(p['gamma'])
    bvec = r*exp(1i*g)
    c(t,t+g,t+angle(bvec+1),t+angle(bvec-1))
}

welcome_line  = list( Text(c(cx,cy-50),Params(msg='Press SPACE when ready.')) )
farewell_line = list( Text(c(cx,cy-50),Params(msg='Thank you for participation!')) )
dot = list( Dot(c(cx,cy),Params(c=0.5)) )

keys_none     = list()
keys_space    = list(key.SPACE)
keys_response = list(key.NUM_1,key.NUM_2,key.NUM_3)
# key names are listed at http://www.pyglet.org/doc/api/pyglet.window.key-module.html

# add a message screen, wait until button press (duration=0 means wait)
trials <- list( Trial('Start',welcome_line,0,keys_space) )

# prepare 6*5 ratios
ratios = c()
for (i in 1:1) ratios = c(ratios,c(1.0,1.1,1.2,1.3,1.4))
# and shuffle them
ratios = sample(ratios)
gamma = rads(90.0)

# add three Trials each consisting of a Fixation, Stimulus and a Response screen
for (r in ratios)
{
    # generate a new lattice, rotated by a random angle
    th = 2*pi*runif(1)
    new_params = copy_params(p_lattice,r=r,gamma=gamma,theta=th)
    lattice = list( DotLattice(c(cx,cy),new_params) )
    # create response button that correspond to presented stimuli
    options = theta(new_params)
    # shuffle them
    options = sample(options)
    responses = do.call(response_screen, as.list(options))
    # add the trial
    trial = list( Trial('Fixation',       dot, 1000, keys_none),
                  Trial('Lattices',   lattice,  300, keys_space),
                  Trial('Blank'   ,    list(),  300, keys_none),
                  Trial('Response', responses,    0, keys_response, mouse=1) )
    trials = c(trials,trial)
}

trials <- c( trials, list(Trial('End',farewell_line,0,keys_none)) )

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
            if (ev[[1]]=='TRIAL' && ev[[3]]['name']=='Lattices')
            {
                th = ev[[3]][['stimuli']][[1]]['params'][[1]]['theta']
                cat(sprintf("Event: \"%s\" triggered at %0.3f, theta = %0.2f\n",
                            ev[[1]],ev[[2]],th))
            }
            else
                cat(sprintf("Event: \"%s\" triggered at %0.3f, response '%s'\n",
                            ev[[1]],ev[[2]],toJSON(ev[[4]])))
        }
}

