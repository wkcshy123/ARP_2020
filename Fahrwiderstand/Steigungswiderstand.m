function  F_St =Steigungswiderstand(Fahrzeug, RB, Fahrgaeste, Steigung)
F_St = (Fahrzeug.m_F + Fahrgaeste.Data.*60) * RB.g .* sin(Steigung);        % Steigungswiderstand [N]
end