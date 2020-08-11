% % Parameter aus dem Paper "Novel Electric Bus Energy Consumption Model
% % Based on Probabilistic Synthetic Speed Profile Integrated With HVAC" in
% % Tabelle I und II

T_set = 20;     % [°C]
T_umgebung = 5; % [°C]
L_win = 20e-3;  % [m]
A_win = 31.8;   % [m]
u_cwin = 0.0566; 
L_chs = 50e-3;
A_chs = 138.2;
u_chs = 0.0738;
A = 170;
h_cint = 10.45;
h_cext = h_cint-v_km_h +10*v_km_h.^0.5;
m_air = 111;
c_p = 1.005;
phi_vnt = 0.2;
V_hvac = 1.13;
pho_air = 1.2258;
Ca = 0.1;
A_dor = 1.85;
R_p = 0.3;
beta_pas = 1.8;
v_fan = 27;
aux_leistung = 9;
i_fan = 106;
eta_hvac = 2;
R_eq = 1./(L_win/(A_win*u_cwin) + L_chs/(A_chs * u_chs) + 1./(h_cext.*A) +1/(A * h_cint)); 
R_eq = timeseries(R_eq,Geschwindigkeit.time);


