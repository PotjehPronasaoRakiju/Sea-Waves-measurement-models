function arr= offset_removal_avg(arr, N, M,Fs) 
    % arr = gyroReading(:,1);
    % M = 3*Fs;
    % mali_n = N;
    % 
    % figure
    % plot(t(1:mali_n),arr(1:mali_n))

    input = arr(1:N);
    output = zeros(1,N);
    maksimalni_period = 30; %ovdje zadajemo maksimalni period radi filtriranja
    no_of_samples = round(N*2/(Fs*maksimalni_period));
    
    y = fft(input);
    f = (-N/2:N/2-1)*Fs/N;
    pow = abs(fftshift(y)).^2;
    pow(round(N/2) + 1 - no_of_samples: round(N/2) +1 + no_of_samples) = 0;

    T_input = abs(1/(f(find(pow == max(pow) ,1, 'last'))));
    no_of_periods = floor(M/(T_input*Fs));
    no_of_samples = round(no_of_periods*T_input*Fs);

    for i = 1: floor(N/M)
        offset = mean(input((M*(i-1)+1):M*(i-1)+no_of_samples));
        output((M*(i-1)+1):M*(i-1) + no_of_samples)  = input((M*(i-1)+1):M*(i-1)+no_of_samples) - offset;
    end

    
    % j = floor(N/M);
    % for i = (M*(j-1)+no_of_samples + 1):N
    %      output(i) = input(i) - offset;
    % end

    arr = output;
end