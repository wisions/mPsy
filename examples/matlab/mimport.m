function mimport(path)
    addpath(path);
    evalin('caller','init__');
end
