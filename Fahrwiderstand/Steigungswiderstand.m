function  F_St =Steigungswiderstand(Fahrzeug, RB)
F_St = Fahrzeug.m_F * RB.g * sin(RB.St_winkel);        % Steigungswiderstand [N]
end