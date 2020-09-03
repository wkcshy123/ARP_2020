function [i_F, wirkungsgrad_getriebe] = schaltung4(Fahrzeug, Rad, Geschwindigkeit,T_Bedarf)
i_G = Fahrzeug.i_Get;
i_F = zeros(length(Geschwindigkeit.Data), 1);                              % die Uebersetzungsvektor vordefinieren
wirkungsgrad_getriebe = zeros(length(Geschwindigkeit.Data), 1);
for i=1:length(Geschwindigkeit.Data)
    for j=1:length(i_G)
        motordrehzahl(j) = ((Geschwindigkeit.Data(i) / Rad.r_dyn) * Fahrzeug.i_main_reducer * i_G(j)) * (60/(2*pi));   % motordehzahl in rpm 
        motordrehmoment(j) = T_Bedarf(i) / Fahrzeug.i_main_reducer / i_G(j);
        if motordrehzahl(j)<2500 && motordrehzahl(j)>1000 && motordrehmoment(j)>600 && motordrehmoment(j)<1200
            i_F(i) = i_G(j);
            wirkungsgrad_getriebe(i) = Fahrzeug.eta_getriebe(j); 
            continue
        end
    end
end
i_F(i_F == 0) = Fahrzeug.i_Get(1);
wirkungsgrad_getriebe(wirkungsgrad_getriebe == 0) = Fahrzeug.eta_getriebe(1);
figure
plot(i_F)
end