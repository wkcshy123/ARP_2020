    %Energieverbrauch in kWh/100km und kWh/km
    fahrstrecke = trapz(Geschwindigkeit.Data)/1e3; %gesamte Fahrstrecke in km
    energieverbrauch = trapz(out.LeistungsverbrauchOhneRekuperation.Data)/3.6e6; %Energieverbrauch in kWh
    energieverbrauch = energieverbrauch + trapz(out.Nebenverbraucher.Data)/3.6e6;
    
    energieverbrauch_kWhProkm = energieverbrauch/fahrstrecke;
    energieverbrauch_kWhPro100km = energieverbrauch_kWhProkm*100;