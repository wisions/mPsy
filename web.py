
import os
import sys
import time
import json
from time import sleep
from Queue import Empty
from urlparse import urlparse
from BaseHTTPServer import BaseHTTPRequestHandler, HTTPServer

class VPRequestHandler(BaseHTTPRequestHandler):
    def do_GET(self):
        #print 'GET', time.time()
        if len(self.path) < 2 or 'favicon' in self.path:
            return self._response('OK')
        up = urlparse(self.path)
        data = {}
        if up.query:
            data.update( x.split('=') for x in up.query.split('&') )
        self._react(up.path[1:],data)

    def do_POST(self):
        #print 'POST', time.time()
        up = urlparse(self.path)
        sz = int(self.headers["content-length"])
        data = self.rfile.read(sz)
        data = json.loads(data)
        self._react(up.path[1:],data)
    
    def _react(self,cmd,params):
        msg = 'OK'
        #print 'CALLING:', cmd, params
        if self.server.q:
            self.server.q.put([cmd,params])
            # wait for response indefinitelly
            msg = self.server.r.get()
            #print 'RESPONSE', msg
        self._response(msg)

    def _response(self,msg):
        try:
            self.send_response(200)
        except:
            print "The other site timeouted!"
            return
        self.send_header('Content-Type', 'text/plain')
        self.send_header('Content-Length', str(len(msg)))
        self.end_headers()
        self.wfile.write(msg)

def main(q=None,r=None):
    HOST, PORT = '', 5000
    if len(sys.argv) > 1: HOST = sys.argv[1]
    if len(sys.argv) > 2: PORT = int(sys.argv[2])
    httpd = HTTPServer((HOST,PORT), VPRequestHandler)
    httpd.q = q
    httpd.r = r
    httpd.serve_forever()

from json import JSONEncoder
class PythonObjectEncoder(JSONEncoder):
    def default(self, obj):
        if isinstance(obj, (list, dict, str, unicode, int, float, bool, type(None))):
            return JSONEncoder.default(self,obj)
        return obj.default()

import stimuli
from lib import Params, Trial
class Remote:
    def __init__(self,port=5000,qcmd=None,qret=None):
        from multiprocessing import Process, Queue
        self.qcmd = qcmd
        self.qret = qret
        if qcmd is None: self.qcmd = Queue()
        if qret is None: self.qret = Queue()
        self.eventlog = []
        self.p = Process(target=main,args=(self.qcmd,self.qret))
        self.p.start()
    def stop(self):
        self.p.terminate()
    def __del__(self):
        self.stop()

    def event(self,event,time,trial,args):
        if event != 'REMOTE':
            self.eventlog.append([event,time,trial,args])
    def translate_events(self,ev):
        return json.dumps(ev,cls=PythonObjectEncoder)

    def make_json_trial(self,name,stims,T,keys=[],mouse=True):
        #stims = [ getattr(stimuli,stim['name'])(stim['args'][0],Params(**stim['args'][1])) for stim in stims ]
        out = []
        for stim in stims:
            print stim
            stim = getattr(stimuli,stim['name'])(stim['args'][0],Params(**stim['args'][1]))
            out.append( stim )
        return Trial(name,out,T,keys,mouse)
    def trials_from_json(self,trials):
        out = []
        for x in trials:
            assert x['name'] == 'Trial'
            out += [ self.make_json_trial(*x['args']) ]
        return out

def remote(port):
    rem = Remote()
    return rem#.qcmd, rem.qret

if __name__ == "__main__":
    from stimuli import *
    
    def make_trial(name,stims,T,keys=[],mouse=True):
        stims = [ globals()[stim['name']](stim['args'][0],Params(**stim['args'][1])) for stim in stims ]
        return Trial(name,stims,T,keys,mouse)

    def set_trials(trials):
        out = []
        for x in trials:
            assert x['name'] == 'Trial'
            out += [ make_trial(*x['args']) ]
        print out

    from multiprocessing import Process, Queue
    #q = Queue()
    #r = Queue()
    rem = Remote()
    q,r = rem.qcmd,rem.qret
    print 'waiting'
    while True:
        cmd, args = q.get()
        print cmd, args
        msg = 'ERROR: unknown command'
        if cmd == 'set_trials':
            try:
                set_trials(args)
                msg = 'OK'
            except Exception, e:
                msg = 'ERROR: Exception: %s'%(sys.exc_info(),)
        elif cmd == 'alive':
            msg = 'Yes, I am.'
        elif cmd == 'info':
            msg = '[1200,1920]'
        elif cmd == 'quit':
            r.put('OK')
            sleep(0.1)
            break
        #q.task_done()
        r.put(msg)
        sleep(0.001)
    
    rem.stop()

