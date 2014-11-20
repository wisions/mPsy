
from __future__ import division
import sys
from numpy import *
from pylab import amap
import PIL

width = 512
if len(sys.argv) > 1:
    width = int(sys.argv[1])

GRAY = False
if len(sys.argv) > 2 and sys.argv[2] == 'g':
    GRAY = True

fwidth = float(width)
Y,X = mgrid[:fwidth,:fwidth]
Y = Y/width-0.5
X = X/width-0.5

g0 = exp(-0.5*((X**2+Y**2)**10)/(0.3**20)).reshape(width,width,1)
g = exp(-0.5*((X**2+Y**2)**4)/(0.2**8)).reshape(width,width,1)
code = 'mps'
f = amap(ord,code)/8.0

if GRAY:
    im0 = 127.5*cos(2*pi*8*X.reshape(width,width,1))
    im  = 127.5*cos(2*pi*f.reshape(1,1,len(code))*X.reshape(width,width,1))
    logo = (127.5 + (g0*im0)*(1-g) + g*im).astype('u1')
else:
    im0 = (127.5*cos(2*pi*8*X.reshape(width,width,1))+127.5).astype('u1')
    im  = (127.5*cos(2*pi*f.reshape(1,1,len(code))*X.reshape(width,width,1))+127.5).astype('u1')
    logo = ((g0*im0)*(1-g) + g*im).astype('u1')

m = (255*((abs(X)**1.5+abs(Y)**1.5) < 0.3)).astype('u1')

mask = PIL.Image.fromarray(m)
im = PIL.Image.fromarray(logo)
im.putalpha(mask)
im.save('logo_mpsy%d%s.png'%(width,GRAY and '_g' or ''))

