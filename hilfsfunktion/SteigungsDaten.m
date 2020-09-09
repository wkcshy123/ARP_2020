function [Steigung, elevationhgt] = SteigungsDaten(Geschwindigkeit, Latitude, Longitude)
Steigung = zeros(length(Geschwindigkeit.data),1);
Accumulativ_Wegstrecke = cumtrapz(Geschwindigkeit.data);
Position.latitude = Latitude;
Position.longitude = Longitude;
elevationhgt = GetHgtElevation(Position);            % Höhe Daten erhalten
schrittweit = 20;                                    % je 5 sekunden 
for i=1:schrittweit:length(Accumulativ_Wegstrecke)
    if i+schrittweit > length(Accumulativ_Wegstrecke)
        Steigung(i,1) = atan((elevationhgt(end)-elevationhgt(i))/(Accumulativ_Wegstrecke(end)-Accumulativ_Wegstrecke(i)));
        break
    end
    Steigung(i,1) = atan((elevationhgt(i+schrittweit)-elevationhgt(i))/(Accumulativ_Wegstrecke(i+schrittweit)-Accumulativ_Wegstrecke(i)));
end
Steigung(Steigung==0)=nan;
Steigung = fillmissing(Steigung,'previous');
Steigung(i:end) = Steigung(i);
end