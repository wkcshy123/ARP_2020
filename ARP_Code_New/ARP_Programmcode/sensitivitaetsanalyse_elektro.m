
basisWert = 0.1; %Zu änd. Wert
startwert = 0.02;

Parameter = startwert;

for i = 1:12
        %Elektro
        
        lambda = Parameter;
        out=sim('Simulationsmodell_Elektro',simtime);
        
        fahrstrecke = trapz(Geschwindigkeit.Data)/1e3; %gesamte Fahrstrecke in km
        energieverbrauch = trapz(out.LeistungsverbrauchGesamt.Data)/3.6e6; %Energieverbrauch in kWh

        energieverbrauch_kWhProkm = energieverbrauch/fahrstrecke;
        energieverbrauch_kWhPro100km = energieverbrauch_kWhProkm*100;
        
        sensitivitaetsanalyse_kWhPro100km(i,1) = Parameter;
        sensitivitaetsanalyse_kWhPro100km(i, 2)= energieverbrauch_kWhPro100km;
        
        Parameter = Parameter + 0.01;
end

bar(sensitivitaetsanalyse_kWhPro100km(:,1),sensitivitaetsanalyse_kWhPro100km(:,2))
title('Sensitivität Luftwiderstandsbeiwert')
xlabel('Luftwiderstandsbeiwert')
ylabel('Energieverbrauch in kWh/100km')

%axis([-30 40 0 25000])