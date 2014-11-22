function mpsy_start_safe(exe_name)
% Initiate Python mPsy presentation process specified through 'exe_name'.
% This function will start the Python experiment and 
% it will attemp to connect to its web remote interface.
%
% This function wait indefinitelly, attempting to connect every 1s,
% use Ctrl-C to interrupt.
%
%   mpsy_start_safe(exe_name)
% 
%   Input:
%       exe_name    - full path to Python experimetn executable 
%                     by default exp_tut_webremote.py
%
%   Examples:
%
%       mpsy_start_safe()
% 
%
% See also mpsy_start
%
% This file is a part of mPsy (https://github.com/juricap/mPsy)
% Written by Peter Jurica (juricap@gmail.com)

    if nargin < 1, exe_name = 'exp_tut_webremote.py'; end
    if ~mpsy_alive(), mpsy_start(exe_name); end
    while ~mpsy_alive(),
        disp 'starting the stimulus server ...'
        pause(1.0);
    end
    disp 'Waiting for your orders!'
end
