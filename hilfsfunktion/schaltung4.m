function [i_F, wirkungsgrad_getriebe, wirkungsgrad_motor] = schaltung4(Fahrzeug, Rad, Geschwindigkeit,T_Bedarf, kennfeld)
i_G = Fahrzeug.i_Get;
i_F = zeros(length(Geschwindigkeit.Data), 1) + i_G(1);                              % die Uebersetzungsvektor vordefinieren
wirkungsgrad_getriebe = zeros(length(Geschwindigkeit.Data), 1) + Fahrzeug.eta_getriebe(1);
wirkungsgrad_motor = zeros(length(Geschwindigkeit.Data), 1) + min(kennfeld,[],'all');
for i=1:length(Geschwindigkeit.Data)
    if T_Bedarf(i)<0
        i_F(i) = i_F(i-1);
        wirkungsgrad_getriebe(i) = wirkungsgrad_getriebe(i-1);
        wirkungsgrad_motor(i) = wirkungsgrad_motor(i-1);
        continue
    end
    wirkungsgrad_gang = zeros(1,length(i_G));
    for j=1:length(i_G)
        motordrehzahl(j) = ((Geschwindigkeit.Data(i) / Rad.r_dyn) * Fahrzeug.i_main_reducer * i_G(j)) * (60/(2*pi));   % motordehzahl in rpm 
        motordrehmoment(j) = T_Bedarf(i) / Fahrzeug.i_main_reducer / i_G(j) / Fahrzeug.eta_getriebe(j);
        try
            wirkungsgrad_gang(j) = kennfeld(round(motordrehmoment(j)/10/(1200/850))+1,round(motordrehzahl(j)/10)+1); 
        catch
            
        end
        if motordrehzahl(j)<=2500 && motordrehzahl(j)>=0 && motordrehmoment(j)>=0 && motordrehmoment(j)<=1200
            if wirkungsgrad_gang(j) == max(wirkungsgrad_gang)
                i_F(i) = i_G(j);
                wirkungsgrad_getriebe(i) = Fahrzeug.eta_getriebe(j);
                wirkungsgrad_motor(i) = wirkungsgrad_gang(j);
            end
        end   
    end
    wirkungsgrad_gang = fillmissing(wirkungsgrad_gang, 'constant', 0);
    if isequal(wirkungsgrad_gang, zeros(1,length(i_G))) 
            disp(['Das Zustand in ',num2str(i),'th Zeitpunkt ist nicht erreichbar!'])
            disp(['MotorDrehzahl[rpm] in jedem Gang [1-4] ',newline ,num2str(motordrehzahl)])
            disp(['MotorDrehmoment[Nm] in jedem Gang [1-4] ',newline ,num2str(motordrehmoment)])
    end
end
figure
plot(i_F)
end