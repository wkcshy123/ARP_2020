function [i_F, wirkungsgrad_getriebe] = schaltung2(Fahrzeug, Rad, Geschwindigkeit,T_Bedarf)
i_G = Fahrzeug.i_Get;
Gang = 1;
i_F = zeros(length(Geschwindigkeit.Data), 1);                              % die Uebersetzungsvektor vordefinieren
wirkungsgrad_getriebe = zeros(length(Geschwindigkeit.Data), 1);
for i=1:length(Geschwindigkeit.Data)
    motordrehzahl = ((Geschwindigkeit.Data(i) / Rad.r_dyn) * Fahrzeug.i_main_reducer * i_G(Gang)) * (60/(2*pi));   % motordehzahl in rpm 
    motordrehmoment = T_Bedarf(i) / Fahrzeug.i_main_reducer / i_G(Gang);
    if ((0 <= motordrehmoment) && (motordrehmoment <= 500))                                                 
        if Gang ~= length(i_G)
            Gang = Gang + 1;
        end
    elseif motordrehmoment >= 1200                                         
        if Gang >= 3
            Gang = Gang - 2;
        elseif Gang > 1 && Gang <= 2
            Gang = Gang - 1;
        end
        
    end 
    wirkungsgrad_getriebe(i) = Fahrzeug.eta_getriebe(Gang); 
    i_F(i) = i_G(Gang);
end
figure
plot(i_F)
