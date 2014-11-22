function out = mpsy_events()
    try
        evs = mpsy_cmd('events');
        out = p_json(evs);
    catch
        out = {{'STOP'}};
    end
end
