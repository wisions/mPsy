function out = mpsyfunc(name,args)
% Helper function wrapping Python callables.
%
%   mpsyfunc(name,args)
% 
%   Input:
%       name    - name of Python function called by mPsy presentation 
%       args    - arguments to pass to Python function
%
%   Examples:
%
%       % mock stimulus constructor of Grating stimulus
%       Grating = @(varargin) vpfunc('Grating',{varargin});
%
%
% See also: mpsy_start
%
% This file is a part of mPsy (https://github.com/juricap/mPsy)
% Written by Peter Jurica (juricap@gmail.com)

    out = struct('type','call','name',name,'args',args);
end
