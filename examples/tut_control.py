
# in case you run from "examples" directory
# add main mPsy (stimuli.py) directory to the path
import sys
sys.path.append('..')

from lib import *

def cont_default(self):
    return {'type':'Controller','name':self.__class__.__name__,'params':self.params}

def controller(**kwargs):
    return type('Controller',(),{'_defaults':Params(**kwargs),'default':cont_default})

class StairCase(controller(up=1,down=1,up_step=1,down_step=2)):
    def __init__(self,params):
        self.params = copy_params(self._defaults,params)
        self.responses = []
        self.values = [params.init]
        self.d = self.u = 0
        self.reversal = [0]
    
    def get_current(self):
        return self.values[-1]
       
    def update(self,r):
        p = self.params
        self.responses.extend(r)

        if len(self.values) == 1:
            self.direction = r and -1 or 0
            
        if r:
            self.d = self.d + 1;
            if self.d == p.down or max(self.reversal) < 1:
                self.values.append(self.values[-1] - p.down_step)
                self.d = self.u = 0
                if self.direction == 1:
                    self.reversal.append(sum(array(self.reversal)!=0) + 1)
                else:
                    self.reversal.append(0)
                self.direction = -1
            else:
                self.values.append(self.values[-1])
        else:
            self.u = self.u + 1;
            if self.u == p.up or max(self.reversal) < 1:
                self.values.append(self.values[-1]+p.up_step)
                self.d = self.u = 0
                if self.direction == -1:
                    self.reversal.append(sum(array(self.reversal)!=0) + 1)
                else:
                    self.reversal.append(0)
                self.direction = 1
            else:
                self.values.append(self.values[-1])
       
def Gumbel_inv(params,x):
    alpha,beta,gamma,lbda = params
    c = (x-gamma)/(1 - gamma - lbda) - 1
    c = -log(-c)
    c = log10(c)
    return alpha + c/beta

def Gumbel(params,x):
    alpha,beta,gamma,lbda = params
    return gamma+(1-gamma-lbda)*(1-exp(-1*10**(beta*(x-alpha))))


def test():
    sc_params = Params(init=0.3,
                       up=1, down=3, 
                       up_step=0.05, down_step=0.05)

    sc = StairCase(sc_params)

    trueParams = [0, 20, .5, 0.01]
    #Determine and display targetd proportion correct and stimulus intensity
    targetP = (sc_params.up_step/(sc_params.down_step+sc_params.up_step))**(1.0/sc_params.down)
    print 'Targeted proportion correct: %6.4f'%targetP

    targetX = Gumbel_inv(trueParams,targetP)
    print 'Targeted stimulus intensity given simulated observer: %6.4f'%targetX

    # Trial loop
    trial = 1;
    while trial <= 50:
        # Present trial here at stimulus intensity UD.xCurrent and collect
        # response
        # Here we simulate a response instead (0: incorrect, 1: correct)
        response = rand(1) < Gumbel(trueParams, sc.get_current())
        sc.update(response) # update StairCase state
        trial += 1

    # Create simple plot:
    from pylab import figure,suptitle,plot,xlabel,ylabel,show
    figure()
    suptitle('Up/Down Adaptive Procedure')
    i = arange(len(sc.values))+1
    vals = array(sc.values)
    resp = array(sc.responses)
    plot(i,vals,'k');
    good = resp != 0
    bad = resp == 0
    plot(i[good],vals[good],'ko',mfc='k');
    plot(i[bad], vals[bad], 'ko',mfc='w');
    plot([i[1],i[-1]], [targetX, targetX],'k--',lw=2)
    xlabel('Trial')
    ylabel('Stimulus Intensity')
    show()

if __name__ == "__main__":
    test()

