%% 0-15 km/h 1 Gang
 % 16-30 km/h 2 Gang
 % 31-45 km/h 3 Gang
 % 46-60 km/h 4 Gang
 % 61-75 km/h 5 Gang
 % 76-inf km/h 6 Gang

function [i_F, wirkungsgrad_getriebe] = schalten(Fahrzeug, v)
Ganganzahl = length(Fahrzeug.i_Get); % Wie viele Gang hat die Getriebe
v_Anfang = 0; 
i_F = zeros(length(v), 1);
wirkungsgrad_getriebe = zeros(length(v), 1);
for i = 1 : Ganganzahl
    if i ~= Ganganzahl
        mask = (v > v_Anfang) & (v <= v_Anfang +20);
        i_F(mask) = Fahrzeug.i_Get(i);
        wirkungsgrad_getriebe(mask) = Fahrzeug.eta_getriebe(i);
        v_Anfang = v_Anfang + 20;
    else
        mask = v > v_Anfang;
        i_F(mask) = Fahrzeug.i_Get(i);
        wirkungsgrad_getriebe(mask) = Fahrzeug.eta_getriebe(i);
    end
end
i_F(i_F == 0) = Fahrzeug.i_Get(1);
wirkungsgrad_getriebe(wirkungsgrad_getriebe == 0) = Fahrzeug.eta_getriebe(1);
end