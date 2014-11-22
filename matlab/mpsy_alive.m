function out = mpsy_alive()
% Check is mPsy's presentation process is running
%
%   out = mpsy_alive()
% 
%   Output:
%       out    - returns 1 is mPsy presentation is running and available
%
%   Examples:
%
%       % request and decode recent mPsy events
%       mpsy_start();
%       if mpsy_alive() < 1
%           return
%       end
% 
%
% See also: mpsy_start, mpsy_start_safe
%
% This file is a part of mPsy (https://github.com/juricap/mPsy)
% Written by Peter Jurica (juricap@gmail.com)

    out = 0;
    try,
        if strcmp(mpsy_cmd('alive'), 'OK'),
            out = 1;
        end
    catch,
        out = 0;
    end
    if out < 1, disp 'Stimulus server is not running.'; end
end
