%period =13;
t3 = 1; %sekunde prije kraja koje se ne prikazuju
tx = N - Fs*t3;

M = 50;
wg = Fc/(Fs/2);    %maksimalna frekvencija vala je manja od 1 Hz , pa uzimamo 1 Hz za cutoff frekvenciju
fir_filter = fir1(M, wg,'low',blackman(M+1));

tau = M/2;  %kašnjenje zbor filtra
taug = N -tau; %ukupan broj uzoraka

angvel = zeros(N,3);
%angvel(1:(N-tau+1),:) = filter(fir_filter,1, gyroReading(tau:N,:));
angvel(1:taug,:) = filter(fir_filter,1, gyroReading(N-taug+1:N,:));
%angvel(taug+1:N,:) = zeros(tau,3);
angvel(:,1) = offset_removal(angvel(:,1), N);
angvel(:,2) = offset_removal(angvel(:,2), N);
angvel(:,3) = offset_removal(angvel(:,3), N);
angvel(taug+1:N,:) = zeros(tau,3);

figure
subplot(4,1,1)
plot(t, [gyroReading(:,1),true_angvel(:,1),angvel(:,1)])
legend('measured','true_vel','offset removed')
ylabel('kutna brzina()')

pitch = cumtrapz(t, angvel(:,1));
%taug = taug - tau;
pitch(1:taug,:) = filter(fir_filter, 1, pitch(N-taug+1:N,:));
%pitch(taug + 1 :N,:) = zeros(2*tau,1);
pitch = offset_removal(pitch, N);
pitch(taug + 1 :N,:) = zeros(N-taug,1);

subplot(4,1,2)
plot(t(1:tx), [pitch(1:tx),true_pitch(1:tx)])
legend('calculated','true')
ylabel('Pitch/stupnjevi')

roll = cumtrapz(t, angvel(:,2));
roll(1:taug,:)  = filter(fir_filter, 1, roll(N-taug+1:N,:));
%roll(taug + 1 :N,:)  = zeros(2*tau,1);
roll = offset_removal(roll, N);
roll(taug + 1 :N,:)  = zeros(N-taug,1);

subplot(4,1,3)
plot(t(1:tx), [roll(1:tx),true_roll(1:tx)])
legend('roll','true')
ylabel('Roll/stupnjevi')

yaw = cumtrapz(t, angvel(:,3));
yaw(1:taug,:) = filter(fir_filter, 1, yaw(N-taug+1:N,:));
%yaw(taug + 1 :N,:)= zeros(2*tau,1);
yaw = offset_removal(yaw, N);
yaw(taug + 1 :N,:)= zeros(N-taug,1);

subplot(4,1,4)
plot(t(1:tx), [yaw(1:tx),true_yaw(1:tx)])
legend('yaw','true')
ylabel('Yaw/stupnjevi')

true_angle = zeros(N,3);
calc_angle = zeros(N,3);
period = 15;

for i = 1: floor (N/ (period*Fs))
    head = (period*Fs)*(i-1)+1;
    tail = (period*Fs)*i;

    true_angle (head:tail,1) = amplitude_out(true_pitch(head:tail))*ones(tail-head+1,1);
    calc_angle (head:tail,1) = amplitude_out(pitch(head:tail))*ones(tail-head+1,1);

    true_angle (head:tail,2) = amplitude_out(true_roll(head:tail))*ones(tail-head+1,1);
    calc_angle (head:tail,2) = amplitude_out(roll(head:tail))*ones(tail-head+1,1);

    true_angle (head:tail,3) = amplitude_out(true_yaw(head:tail))*ones(tail-head+1,1);
    calc_angle (head:tail,3) = amplitude_out(yaw(head:tail))*ones(tail-head+1,1);
end

figure
plot( t(1:tx) , [calc_angle(1:tx,:), true_angle(1:tx,:)] )
legend('pitch', 'roll','yaw','true_pitch', 'true_roll','true_yaw')
title('Amplitude kutova')
xlabel('Time(s)')
ylabel('Kut(stupnjevi)')
grid on



angles = zeros(N,3);
angles(M:N,:) = calc_angle(1:N-M+1,:);


err = abs(angles-true_angle);

figure
%subplot(2,1,1)
plot( t(Fs:tx) , err(Fs:tx,:))
legend('pitch', 'roll','yaw')
title('Greška s vremenom, T = 15 s')
xlabel('Time(s)')
ylabel('Kut(stupnjevi)')
grid on

figure
%subplot(2,1,2)
histogram(err(1:tx,1),'NumBins',17,'BinEdges',0:8)
title('Greška')
xlabel('Kut(stupnjevi)')
hold on

histogram(err(1:tx,2),'NumBins',17,'BinEdges',0:8)
title('Greška')
xlabel('Kut(stupnjevi)')
hold on

histogram(err(1:tx,3),'NumBins',17,'BinEdges',0:8)
title('Histogram apsolutne vrijednosti greške, T = 15 s')
legend('Pitch','Roll','Yaw')
xlabel('Kut(stupnjevi)')


%angles = [pitch roll yaw];