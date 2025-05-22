mg = 0.000981;
Fs = imu.SampleRate;
N = 60 *2* Fs; %dvije minute
N = 60 * 10 *Fs; %broj uzoraka u deset minuta
%N = 60*60*Fs; %broj uzoraka u jednom satu
%N = 12*60*60*Fs; %broj uzoraka u 6 sati
%N = N*24;%jedan dan
%N = 7*24*60*60*Fs; %jedan tjedan


% Simulacija signala
%Fc = 1/ randi(30);
Fc = 0.256;
t = linspace(0, N/Fs, N).'; 
true_acc = zeros(N, 3);
true_vel = zeros(N, 3);
true_angvel = zeros(N, 3);

% Definicija gibanja
days = 3;
Fa = 1/(days*24*60*60*Fs);
phase = randi(N);
A = 0.5+0.2*sin(2*pi*Fa*t + phase);
%A = 0.7*ones(N,1);

z = A.*sin(2*pi*Fc*t);
true_vel (:,3) = A.*cos(2*pi*Fc*t)*(2*pi*Fc);
true_acc(:,3) =  A.*sin(2*pi*Fc*t)*(-(2*pi*Fc)^2);

%y = 0.01*A.*sin(2*pi*Fc*t);
%true_acc(:,2) =  A.*sin(2*pi*Fc*t)*(-(2*pi*Fc)^2);

% KUTNO GIBANJE
A_a = 15;
A_b = 5;

f_a = 21/50;
f_b = 4/60;

fi_a =0;
fi_b = pi/4;


true_yaw = A_a *sin(2*pi*f_a*t + fi_a) + A_b *sin(2*pi*f_b*t + fi_b);
true_angvel(:,3) = A_a*2*pi*f_a*cos(2*pi*f_a*t + fi_a) + A_b*2*pi*f_b* cos(2*pi*f_b*t + fi_b);

A_a = 15;
A_b = 10;

true_pitch = A_a *sin(2*pi*f_a*t + fi_a) + A_b *sin(2*pi*f_b*t + fi_b);
true_angvel(:,1) = A_a*2*pi*f_a*cos(2*pi*f_a*t + fi_a) + A_b*2*pi*f_b* cos(2*pi*f_b*t + fi_b);

A_a = 30;
A_b = 10;

true_roll = A_a *sin(2*pi*f_a*t + fi_a) + A_b *sin(2*pi*f_b*t + fi_b);
true_angvel(:,2) = A_a*2*pi*f_a*cos(2*pi*f_a*t + fi_a) + A_b*2*pi*f_b* cos(2*pi*f_b*t + fi_b);

%ZA PRIKAZ SVOJSTVA AKCELEROMETRA ZAKOMENTIRATI SLJEDEĆE LINIJE
% true_angvel = zeros(N,3);
% true_pitch = zeros(N,1);
% true_roll = zeros(N,1);
% true_yaw = zeros(N,1);


%ZA PRIKAZ SVOJSTVA ŽIROSKOPA ZAKOMENTIRATI SLJEDEĆU LINIJU
% true_acc = zeros(N,3);
% true_vel = zeros(N,3);
% z = zeros(N,1);


[accelReading, gyroReading] = imu(true_acc, true_angvel);

accelReading = accelReading * (-1) + 9.81;

test = accelReading;
metoda = 'Samo uklanjanje DC Offseta';


