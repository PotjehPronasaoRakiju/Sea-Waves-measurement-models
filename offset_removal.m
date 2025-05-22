function arr= offset_removal(arr, M) %period u uzorcima
    %M=N;
    k = 8e-04; %= 1/ (RC), fc = k/2pi, generalno manji od 0.04 za dobre rezultate, 3*tau mora biti manji od 20 sekundi
    %k= 4e-05;
    input = arr(1:M);
    
    %arr = to_remove_offset(1:M,3);
    output = zeros(M,1);
    
    for i = 2:M
        output(i) = output(i-1) + k * (input(i)-output(i-1));
    end
    
    output = input - output;
    
    arr(1:M) = output;
end
