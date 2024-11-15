%Define model constants

% Physical constants
R = 8.314;      % Gas constant (J/mol*K)
G = 6.6743e-11; % Gravitational constant (N*m^2/kg^2)
Me = 5.97e24;   % Earth's mass (kg)
Re = 6371.0e3;  % Earth's radius (m)
up = [0 0 1];   % World frame up direction

% Balloon variables
h = 20000;          % Altitude (m)
m_gas = 1600;       % Mass of gas (g)
M_gas = 4.002602;   % Molar mass of gas (g/mol);
m_balloon = 500;    % Mass of the balloon (g)
m_payload = 2500;   % Mass of the payload (g)
