function out = mpsy_response()
% Query mPsy presentation for response.
%
%   mpsy_response()
% 
%   Output:
%       out    - cell array with response from Python
%
%   Examples:
%
%       out = mpsy_response();
% 
%
% This file is a part of mPsy (https://github.com/juricap/mPsy)
% Written by Peter Jurica (juricap@gmail.com)

    out = mpsy_cmd('response');
end
