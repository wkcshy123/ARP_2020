
basisWert = 0.1; %Zu änd. Wert
startwert = 0.02;

Parameter = startwert;

for i = 1:12
        %Diesel
        lambda = Parameter;
        out=sim('Simulationsmodell_Diesel',simtime);
        %Energieverbrauch in kWh/km und l/100km
        fahrstrecke = trapz(Geschwindigkeit.Data)/1e3; %gesamte Fahrstrecke in km
        energieverbrauch = trapz(out.LeistungsverbrauchGesamt.Data)/3.6e6; %Energieverbrauch in kWh
        energieverbrauch_kWhProkm = energieverbrauch/fahrstrecke; %kWh/km

        %Umrechung 9.8 kWh/l
        kraftstoffverbrauch_LiterPro100km = energieverbrauch_kWhProkm/9.8*100; %l/100km
        
        sensitivitaetsanalyse_LiterPro100km(i,1) = Parameter;
        sensitivitaetsanalyse_LiterPro100km(i, 2)= kraftstoffverbrauch_LiterPro100km;
        
        Parameter = Parameter + 0.01;
end
bar(sensitivitaetsanalyse_LiterPro100km(:,1),sensitivitaetsanalyse_LiterPro100km(:,2))
title('Sensitivität Rollwiderstandsbeiwert')
xlabel('Luftwiderstandsbeiwert')
ylabel('Kraftstoffverbrauch in Liter/100km')
%axis([-30 40 0 25000])