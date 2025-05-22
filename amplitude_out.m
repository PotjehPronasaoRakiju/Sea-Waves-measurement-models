function amp_out = amplitude_out(arr)
    %arr = z(1:period*Fs);
    % period = 10;
    % M=period*Fs;
    % arr = pitch(6*M : 7*M-1);
    % t1 = linspace(0, M/Fc, M).';
    % figure
    % plot(t1,arr)
    
    maximums = findpeaks(arr);
    minimums = findpeaks(-arr);

    if isempty(maximums)
        maximums = arr(end);
    end

    if isempty(minimums)
        minimums = arr(1);
    end

    %maximums(1) = [];
    %minimums(1) = [];
    
    if length(maximums)>length(minimums)
        maximums(end) = [];
    end
    
    if length(maximums)<length(minimums)
        minimums(end) = [];
    end
    
    amp_out = 0.5*median(maximums + abs(minimums));
end

