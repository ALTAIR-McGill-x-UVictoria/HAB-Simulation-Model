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
dim_payload = [50 50 50];   % Size of the payload (cm)