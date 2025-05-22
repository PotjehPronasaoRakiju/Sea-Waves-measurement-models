%unosimo karakteristike senzora LSM6DSOX
%https://www.mathworks.com/help/nav/ref/imusensor-system-object.html
%https://www.st.com/en/mems-and-sensors/lsm6dsox.html#documentation

mg = 0.00981;
imu = imuSensor('accel-gyro');

imu.SampleRate = 100;

imu.Accelerometer.MeasurementRange = 4*mg*1000;
imu.Accelerometer.Resolution = 0.122 * mg;
imu.Accelerometer.ConstantBias = [0 0 20*mg];
imu.Accelerometer.NoiseDensity = [2*mg 2*mg 2*mg];
%imu.Accelerometer.NoiseDensity = [0.075*mg 0.075*mg 0.075*mg];
imu.Accelerometer.TemperatureBias = [0.1 0.1 0.1];
imu.Accelerometer.TemperatureScaleFactor = [0.01 0.01 0.01];

imu.Gyroscope.MeasurementRange = 250;   %500
imu.Gyroscope.Resolution = 8.75e-3;     %17.5e-3
imu.Gyroscope.ConstantBias = [1 1 1];
imu.Gyroscope.NoiseDensity = [3.8e-3 3.8e-3 3.8e-3];
imu.Gyroscope.TemperatureBias = [0.007 0.007 0.007];


