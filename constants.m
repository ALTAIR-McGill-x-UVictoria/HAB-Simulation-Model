%Define model constants

seed = randi(1000);

% Physical constants
R = 8.314;      % Gas constant (J/mol*K)
g = 9.81;       % Gravitational constant on Earth (m/s^2)
up = [0 0 1];   % World frame up direction

% Balloon variables
h = 20000;                  % Initial altitude (m)
vz = 4;                     % Initial climbing velocity (m/s)
vx = 0;                     % Initial velocity over x (m/s)
vy = 0;                     % Initial velocity over y (m/s)
m_gas = 930;                % Mass of gas (g)
M_gas = 4.002602;           % Molar mass of gas (g/mol)
m_balloon = 600;            % Mass of the balloon (g)
m_payload = 4014;           % Mass of the payload (g)
r_balloon = 2.6;            % Radius of the balloon for simulink (m)
dim_payload = [25 25 15];   % Size of the payload (cm)
swivel_damp = 0.0001;        % Swivel damping coefficient (N*m/(deg/s))
cone_radius = 40;           % Cone radius for the balloon (cm)
cone_height = 40;           % Cone radius for the balloon (cm)
cone_mass = 50;             % Cone mass for the balloon (g)
balloon_damp = 0.01;        % Balloon damping coefficient (N*m/(deg/s))
arm_radius = 2.5;           % Radius of the arms (cm)
arm_length = 60.96;         % Length of the arms (cm)
arm_mass = 1400;            % Mass of each arm (g)
motor_mass = 122;           % Mass of the motors (g)
propeller_diameter = 30.48; % Length of the propeller (cm)
propeller_mass = 13;        % Mass of the propeller (g)
propeller_ct = 0.1;         % Propeller thurst coefficient
propeller_cq = 0.02;        % Propeller torque coefficient
motor_joint_damp = 0.0;     % Motor joint damping coefficient (N*m/(deg/s))
motor_rotor_damp = 0.0005;  % Motor rotor damping (N*m/(rad/s))
motor_voltage = 14;         % Motor DC voltage (V)
motor_backemf = 0.001;      % Motor Back-emf (V/rpm)
motor_arm_induc = 12e-6;    % Motor armature inductance (H)
motor_arm_resit = 3.9;      % Motor armature resistance (ohm)
imu_accel_freq = 190;       % Accelerometer natural frequency (rad/sec)
imu_accel_damping = 0.707;  % Accelerometer damping ratio
imu_accel_bias = [0 0 0];   % Accelerometer measurement bias
imu_gyro_freq = 190;        % Gyro natural frequency (rad/sec)
imu_gyro_damping = 0.707;   % Gyro damping ratio
imu_gyro_bias = [0 0 0];    % Gyro measurement bias
wind_gain = 1;              % Gain for adjusting the speed of the winds

% Training variables
numEpisodes = 2000;         % Number of episodes for training
t_max = 30;                 % Max episode duration (s)
k1 = 20;                    % Stability reward coefficient
k2 = 10;                    % Orientation reward coefficient
k3 = 30;                    % Motor smoothness penalty coefficient
k4 = 10;                    % Wind alignment coefficient
k5 = 20;                    % Motor efficiency coefficient
k6 = 15;                    % Action balance penalty coefficient
sampleTime = 0.04;          % Adjust based on simulation step size
actorLearnRate = 3e-4;      % Learning rate for policy network
criticLearnRate = 3e-4;     % Learning rate for value function
expBufferLen = 1e6;         % Buffer size for experience replay
batchSize = 64;             % Batch size for training
discountFactor = 0.99;      % Discount factor (future rewards importance)
targetSmoothFactor = 0.005; % Target smoothing (for stable Q-value updates)