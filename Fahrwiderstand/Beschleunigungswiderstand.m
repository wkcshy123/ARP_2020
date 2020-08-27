function F_C = Beschleunigungswiderstand(Fahrzeug, Beschleunigung, Fahrgaeste)
F_C = (Fahrzeug.m_F + Fahrgaeste.Data .* 60) .* Beschleunigung;       % Beschleunigungswiderstand [N]
end