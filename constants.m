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
m_gas = 1600;               % Mass of gas (g)
M_gas = 4.002602;           % Molar mass of gas (g/mol)
m_balloon = 500;            % Mass of the balloon (g)
m_payload = 5000;           % Mass of the payload (g)
dim_payload = [25 25 15];   % Size of the payload (cm)
swivel_damp = 0.05;         % Swivel damping coefficient (N*m/(deg/s))
cone_radius = 40;           % Cone radius for the balloon (cm)
cone_height = 40;           % Cone radius for the balloon (cm)
cone_mass = 50;             % Cone mass for the balloon (g)
arm_radius = 2.5;           % Radius of the arms (cm)
arm_length = 100;           % Length of the arms (cm)
arm_mass = 50;              % Mass of each arm (g)
motor_mass = 120;           % Mass of the motors (g)
propeller_diameter = 30;    % Length of the propeller (cm)
propeller_mass = 20;        % Mass of the propeller (g)
propeller_ct = 0.07;        % Propeller thurst coefficient
propeller_cq = 0.2;         % Propeller torque coefficient
motor_joint_damp = 0;       % Motor joint damping coefficient (N*m/(deg/s))
motor_rotor_damp = 0.0;     % Motor rotor damping (N*m/(rad/s))
motor_voltage = 12;         % Motor DC voltage (V)
motor_backemf = 0.072e-3;   % Motor Back-emf (V/rpm)
motor_arm_induc = 12e-6;    % Motor armature inductance (H)
motor_arm_resit = 3.9;      % Motor armature resistance (ohm)
imu_accel_freq = 190;       % Accelerometer natural frequency (rad/sec)
imu_accel_damping = 0.707;  % Accelerometer damping ratio
imu_accel_bias = [0 0 0];   % Accelerometer measurement bias
imu_gyro_freq = 190;        % Gyro natural frequency (rad/sec)
imu_gyro_damping = 0.707;   % Gyro damping ratio
imu_gyro_bias = [0 0 0];    % Gyro measurement bias

% Training variables
numEpisodes = 1000;         % Number of episodes for training
t_max = 5;                 % Max episode duration (s)
k1 = 0.2;                   % Stability reward coefficient
k2 = 0.1;                   % Orientation reward coefficient
k3 = 0.05;                  % Efficiency reward coefficient
k4 = 100;                   % Motor smoothness penalty coefficient
k5 = 0.05;                  % Countdown-weighted penalty coefficient
k6 = 0.05;                  % Time-to-stabilization penalty coefficient
k7 = -1000;                 % Failure penalty coefficient
failure_threshold = 20;     % Maximum displacement for failure (m)
sampleTime = 0.04;          % Adjust based on simulation step size
actorLearnRate = 1e-4;      % Learning rate for policy network
criticLearnRate = 1e-3;     % Learning rate for value function
expBufferLen = 1e6;         % Buffer size for experience replay
batchSize = 64;             % Batch size for training
discountFactor = 0.99;      % Discount factor (future rewards importance)
targetSmoothFactor = 0.005; % Target smoothing (for stable Q-value updates)