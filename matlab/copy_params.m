function out = copy_params(p,varargin)
    out = p;
    for i = 1:length(varargin)/2,
        out.(varargin{2*i-1}) = varargin{2*i};
    end
end

