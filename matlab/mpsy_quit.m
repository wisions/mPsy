function mpsy_quit()
% Stop remote mPsy presentation proces.
%
%   mpsy_quit()
% 
%   This function has no Input or Output parameters.
%
%   Examples:
%
%       mpsy_quit()
% 
%
% See also mpsy_cmd, mpsy_alive
%
% This file is a part of mPsy (https://github.com/juricap/mPsy)
% Written by Peter Jurica (juricap@gmail.com)

    mpsy_cmd('quit');
    disp 'Experiment finished. Exiting!'
end
