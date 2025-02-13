%Define model constants

% Physical constants
R = 8.314;      % Gas constant (J/mol*K)
g = 9.81;       % Gravitational constant on Earth (m/s^2)
up = [0 0 1];   % World frame up direction

% Balloon variables
h = 20000;                  % Initial altitude (m)
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
propeller_ct = 0.07;      % Propeller thurst coefficient
propeller_cq = 0.2;   % Propeller torque coefficient
motor_joint_damp = 0;       % Motor joint damping coefficient (N*m/(deg/s))
motor_rotor_damp = 0.1;       % Motor rotor damping (N*m/(rad/s))