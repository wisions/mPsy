function mpsy_start(exe_name)
% Initiate Python mPsy presentation process specified through 'exe_name'.
% This function will attempt start the Python experiment.
% No checking of succesful execution is performed (use mpsy_start_safe).
%
%   mpsy_start(exe_name)
% 
%   Input:
%       exe_name    - full path to Python experimetn executable 
%                     by default exp_tut_webremote.py
%
%   Examples:
%
%       mpsy_start()
% 
%
% See also mpsy_start_safe
%
% This file is a part of mPsy (https://github.com/juricap/mPsy)
% Written by Peter Jurica (juricap@gmail.com)

    if nargin < 1, exe_name = 'exp_tut_webremote.py'; end
    %winopen(exe_name)
    python = 'c:\Python27_x86\python.exe';
    for pp = {'c:\Python27_x86\python.exe', ...
              'c:\Progra~1\PsychoPy2\python.exe',...
              'c:\Progra~2\PsychoPy2\python.exe',...
              'c:\Python\python.exe',...
              'C:\Program Files\PsychoPy2\python.exe',...
              'c:\Python27\python.exe'}
        if exist(pp{1}) > 0,
            python = pp{1};
            break;
        end
    end
    [python ' ' exe_name ' &']
    dos([python ' ' exe_name ' &']);
end
