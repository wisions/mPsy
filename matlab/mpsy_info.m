function out = mpsy_info()
    sz = json2mat(mpsy_cmd('info'));
    out.width = sz(1);
    out.height = sz(2);
    out.hwnd = sz(3);
end
