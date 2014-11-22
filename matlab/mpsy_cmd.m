function out = mpsy_cmd(cmd, params)
% Send message/command to mPsy presenataion.
% This is the main communication method to mPsy's presentation.
%
%   mpsy_cmd(cmd,params)
% 
%   Input:
%       cmd    - command of Python mPsy presentation
%       params - command arguments
%   Output:
%       out    - Python function call return value
%
%   Examples:
%
%       % request and decode recent mPsy events
%       evs = mpsy_cmd('events');
%       out = p_json(evs);       
% 
%
% See also mpsy_start, mpsy_alive
%
% This file is a part of mPsy (https://github.com/juricap/mPsy)
% Written by Peter Jurica (juricap@gmail.com)

    SERVER = 'localhost';
    url = sprintf('http://%s:5000/%s',SERVER,cmd);
    try
        if nargin < 2, params = '[]'; end
        if ~ischar(params), params = mat2json(params); end
        out = urlpostjson(url,params);
    catch err
        out = err;
    end
    if strfind(out,'ERROR')
        disp(out);
    end
end
