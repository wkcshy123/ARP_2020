function F_L = Luftwiderstand(Fahrzeug, RB, Geschwindigkeit)
k_w = 0.5 * RB.rho_L * Fahrzeug.c_w * Fahrzeug.A_quer; % Luftwiderstandskooefizient [-]
F_L = k_w * Geschwindigkeit.data .^ 2;                 % Luftwiderstand [N]
end