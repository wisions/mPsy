function add_trials(trials)
% Send trials to mPsy Presentation's trials queue.
% this function appends trials to mPsy's queue. Use 'set_trials'
% to reset trials queue.
%
% Presentation plays trials as soon as they appear in the queue.
%
%   add_trials(trials)
% 
%   Input:
%       trials    - cell array of Trial objects
%
%   Examples:
%
%   % prepare 3 trials, each with a message and fixation dot, then 5s of Grating 
%   for trial = 1:3,
%       % assemble stimuli
%       nset = { Trial('Start', { Dot([400,300],Params()), ...
%                                 Text([400,300],Params('msg','Hello!')) }, 0, {key.SPACE} ), ...
%                Trial('Test',  { Grating([400,300],Params())}, 5000, {key.SPACE} ) };
%       % send trials to presentation
%       add_trials(nset);
%   end
%
%
% See also: set_trals, Trial
%
% This file is a part of mPsy (https://github.com/juricap/mPsy)
% Written by Peter Jurica (juricap@gmail.com)

    mpsy_cmd('add_trials',trials);
end
