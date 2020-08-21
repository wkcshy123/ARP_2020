function halten = HaltstelleSchaetzen(Geschwindigkeit, min_zeitintervall_haltestellen, haltezeit)
takt = false;
halt = zeros(length(Geschwindigkeit.Data),1);
for i=1:length(Geschwindigkeit.Data)-5
    if ~mod(i,min_zeitintervall_haltestellen)
        takt = true;
    end
    if mean(Geschwindigkeit.Data(i:i+5))<0.1 && takt
        halt(i+1) = 1;
        takt = false;
    end
end
a = find(halt);
for j=1:length(a)-1
    if a(j+1)-a(j)<=min_zeitintervall_haltestellen
        a(j+1) = a(j);
    end
end
a = unique(a);
halten= zeros(length(halt),1);
for i=1:length(a)
    halten(a(i):a(i)+haltezeit) = 1;
end
halten = timeseries(halten);
end