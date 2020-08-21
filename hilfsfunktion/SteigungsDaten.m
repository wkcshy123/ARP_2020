function Steigung = SteigungsDaten(Geschwindigkeit, Latitude, Longitude)
Steigung = zeros(length(Geschwindigkeit.data),1);
Accumulativ_Wegstrecke = cumtrapz(Geschwindigkeit.data);
Position.latitude = Latitude;
Position.longitude = Longitude;
elevationhgt = GetHgtElevation(Position);            % Höhe Daten erhalten
for i=1:20:length(Accumulativ_Wegstrecke)
    if i+20 > length(Accumulativ_Wegstrecke)
        Steigung(i,1) = atan((elevationhgt(end)-elevationhgt(i))/(Accumulativ_Wegstrecke(end)-Accumulativ_Wegstrecke(i)));
        break
    end
    Steigung(i,1) = atan((elevationhgt(i+20)-elevationhgt(i))/(Accumulativ_Wegstrecke(i+20)-Accumulativ_Wegstrecke(i)));
end
Steigung(Steigung==0)=nan;
Steigung = fillmissing(Steigung,'nearest');
Steigung(i:end) = mean(Steigung);
end