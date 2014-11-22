function import(path)
    addpath(path);
    evalin('caller','init__');
end
