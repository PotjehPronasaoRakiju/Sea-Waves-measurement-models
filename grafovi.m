period = 60; %period sakupljanja podataka u sekundama
t0 = 0.25; %vrijeme kada krećemo prikazivati grafove greški (postotak grafa)
t1 = 0.25; %vrijeme kada krećemo prikazivati grafove gibanja (postotak)
t2 = 0.95; %vrijeme kada stajemo s prikazom gibanja (postotak)

t0 = round(N*t0/Fs);
t01 = round(N*0.95/Fs);
t1 = round(N*t1/Fs);
t2 = round(N*t2/Fs);

%%DEFINICIJA FILTRA
%wg = Fc/(0.5*Fs/2);    %maksimalna frekvencija vala je manja od 1Hz, pa uzimamo 1 Hz za cutoff frekvenciju
w1 = 1/ (35*Fs/2);
w2 = 1/(0.5*Fs/2);
M = 200; %red filtra
tau = M/2;
%fir_filter = fir1(M, wg,'low',hamming(M+1));
fir_filter = fir1(M, [w1, w2],'bandpass',hamming(M+1));

%%KOMPENZACIJA
angles_rad = deg2rad(angles);
test = zeros(N,3);
for i = 1:taug
    kutovi = angles_rad(i,:);
    rot_m = eul2rotm(kutovi, "zxy");
    test(i,:) = (rot_m* accelReading(N-taug+i,:)')';
end

acc = zeros(N,3);
acc_1 = zeros(N,3);
acc_2 = zeros(N,3);
acc(1:(N-tau+1),:) = filter(fir_filter,1, test(tau:N,:));


acc_1(:,3) = offset_removal(acc(:,3),N);
acc_2(:,3) = offset_removal_avg(acc(:,3),N,period * Fs, Fs);

vel_1 = cumtrapz(t,acc_1(:,3));
vel_2 = cumtrapz(t,acc_2(:,3));

vel_1(1:(N-tau+1),:) = filter(fir_filter,1, vel_1(tau:N,:));
vel_2(1:(N-tau+1),:) = filter(fir_filter,1, vel_2(tau:N,:));

vel_1(N-tau :N,:) = zeros(tau+1,1);
vel_2(N-tau :N,:) = zeros(tau+1,1);

vel_1 = offset_removal(vel_1,N);
vel_2 = offset_removal_avg(vel_2, N, period*Fs,Fs)';
k=1;
vel_1 =k * vel_1;

z_out_1 = cumtrapz(t,vel_1);
z_out_2 = cumtrapz(t,vel_2);

z_out_1(1:(N-tau+1),:) = filter(fir_filter,1, z_out_1(tau:N,:));
z_out_2(1:(N-tau+1),:) = filter(fir_filter,1, z_out_2(tau:N,:));

z_out_1(N-tau :N,:) = zeros(tau+1,1);
z_out_2(N-tau :N,:) = zeros(tau+1,1);

z_out_1 = offset_removal(z_out_1, N);
z_out_2 = offset_removal_avg(z_out_2,N, period * Fs,Fs)';
k=1;
z_out_1 = k*z_out_1;

figure
subplot(3,1,1)
plot(t(t1*Fs: t2*Fs), [acc(t1*Fs: t2*Fs,3), acc_1(t1*Fs: t2*Fs,3),acc_2(t1*Fs: t2*Fs,3) true_acc(t1*Fs: t2*Fs,3)])
legend('input','RC','avg', 'Idealno')
title('Očitavanje akcelerometra' )
ylabel('Akceleracija (m/s^2)')
grid on

subplot(3,1,2)
plot(t(t1*Fs: t2*Fs), [vel_1(t1*Fs: t2*Fs), vel_2(t1*Fs: t2*Fs), true_vel(t1*Fs: t2*Fs,3)])
legend('Simulirano RC','Simulirano AVG', 'Prema formuli')
title('Brzina')
ylabel('Brzina (m/s)')
grid on

subplot(3,1,3)
plot(t(t1*Fs: t2*Fs),[z_out_1(t1*Fs: t2*Fs), z_out_2(t1*Fs: t2*Fs), z(t1*Fs: t2*Fs)])
legend('Simulirano RC','Simulirano AVG', 'Početno gibanje')
title('Položaj')
ylabel('Položaj (m)')
grid on

sgtitle(metoda)

%%GREŠKE, USPOREDBE


figure
subplot(4,1,1)
plot(t(t0*Fs:t01*Fs), [abs(z_out_1(t0*Fs:t01*Fs) - z(t0*Fs:t01*Fs)), abs(z_out_2(t0*Fs:t01*Fs) - z(t0*Fs:t01*Fs))])
legend('Rc','AVG')
title('Greška oblika signala')
xlabel('Time(s)')
ylabel('Greška (m)')
grid on

true_amplitude = zeros(N,1);
calc_amplitude_1 = zeros(N,1);
calc_amplitude_2 = zeros(N,1);
for i = 1: floor (N/ (period*Fs))
    head = (period*Fs)*(i-1)+1;
    tail = (period*Fs)*i;
    true_amplitude (head:tail) = amplitude_out(z(head:tail))*ones(tail-head+1,1);
    calc_amplitude_1 (head:tail) = amplitude_out(z_out_1(head:tail))*ones(tail-head+1,1);
    calc_amplitude_2 (head:tail) = amplitude_out(z_out_2(head:tail))*ones(tail-head+1,1);
end

subplot(4,1,2)
plot(t(t0*Fs:t01*Fs),[calc_amplitude_1(t0*Fs:t01*Fs), calc_amplitude_2(t0*Fs:t01*Fs), true_amplitude(t0*Fs:t01*Fs)])
legend('Calculated RC','Calculated AVG' ,'True')
title('Amplituda')
xlabel('Time(s)')
ylabel('Amplituda(m)')
title('Amplituda vala')
grid on

amp_err_rc = abs(calc_amplitude_1(t0*Fs:t01*Fs)-true_amplitude(t0*Fs:t01*Fs))*100;
amp_err_avg = abs(calc_amplitude_2(t0*Fs:t01*Fs)-true_amplitude(t0*Fs:t01*Fs))*100;

subplot(4,1,3)
plot(t(t0*Fs:t01*Fs),amp_err_rc)
title('Greška amplitude nakon obrade')
legend('RC')
xlabel('Time(s)')
ylabel('Greška(cm)')
title('Greška amplitude pomoću RC')
grid on

% 
subplot(4,1,4)
plot(t(t0*Fs:t01*Fs),amp_err_avg)
title('Greška amplitude nakon obrade')
legend('AVG')
xlabel('Time(s)')
ylabel('Greška(cm)')
title('AVG')
grid on


