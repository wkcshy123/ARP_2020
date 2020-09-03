function [i_F, wirkungsgrad_getriebe] = schaltung1(Fahrzeug, Rad, Geschwindigkeit)
i_G = Fahrzeug.i_Get;
Gang = 1;
i_F = zeros(length(Geschwindigkeit.Data), 1);                              % die Uebersetzungsvektor vordefinieren
wirkungsgrad_getriebe = zeros(length(Geschwindigkeit.Data), 1);
for i=1:length(Geschwindigkeit.Data)
    motordrehzahl = ((Geschwindigkeit.Data(i) / Rad.r_dyn) * Fahrzeug.i_main_reducer * i_G(Gang)) * (60/(2*pi));   % motordehzahl in rpm 
    if motordrehzahl >= 2000                                                % falls motor drehzahl >= 2000, hochschalten
        if Gang ~= length(i_G)
            Gang = Gang + 1;
        end
    elseif motordrehzahl <= 900                                             % falls motor drehzahl <= 1000, unterschalten
        if Gang ~= 1
            Gang = Gang - 1;
        end
    end 
    wirkungsgrad_getriebe(i) = Fahrzeug.eta_getriebe(Gang); 
    i_F(i) = i_G(Gang);
end
figure
plot(i_F)


