function set_trials(trials)
% Send trials to mPsy Presentation's trials queue.
% This function resets trials queue, unplayed trials set previously are discarded.
%
% Presentation plays trials as soon as they appear in the queue.
%
%   set_trials(trials)
% 
%   Input:
%       trials    - cell array of Trial objects
%
%   Examples:
%
%   % prepare 3 trials, each with a message and fixation dot, then 5s of Grating 
%   trials = {};
%   for trial = 1:3,
%       % assemble stimuli
%       nset = { Trial('Start', { Dot([400,300],Params()), ...
%                                 Text([400,300],Params('msg','Hello!')) }, 0, {key.SPACE} ), ...
%                Trial('Test',  { Grating([400,300],Params())}, 5000, {key.SPACE} ) };
%       trials = [ trials, nset ];
%   end
%
%   % send rtails to presenation
%   set_trials(trials);
%       
%
% See also: add_trals, Trial
%
% This file is a part of mPsy (https://github.com/juricap/mPsy)
% Written by Peter Jurica (juricap@gmail.com)

    mpsy_cmd('set_trials',trials);
end
