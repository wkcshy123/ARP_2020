temperatur = -30;
for i = 1:15
    out=sim('Simulationsmodell_Elektro',simtime);
    nebenverbr(i,1) = temperatur;
    nebenverbr(i, 2)=mean(out.Nebenverbraucher.Data);
    temperatur = temperatur + 5;
end
bar(nebenverbr(:,1),nebenverbr(:,2))
title('HVAC Verbrauch')
xlabel('Temperatur in °C')
ylabel('Leistungsverbrauch von HVAC in W')
axis([-30 40 0 25000])