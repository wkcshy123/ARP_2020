function F_R = Rollwiderstand(Fahrzeug, Rad, RB, v_km_h, Fahrgaeste, Steigung)
f_R_G = Rad.f_R(1) + Rad.f_R(2) * (v_km_h ./ 100) + Rad.f_R(3) * (v_km_h ./ 100) .^ 4; % Rollwiderstandskooeffizient [-]
F_R = (Fahrzeug.m_F + Fahrgaeste.Data.*60) * RB.g .* cos(Steigung) .* f_R_G;                                 % rollwiderstand [N]
end