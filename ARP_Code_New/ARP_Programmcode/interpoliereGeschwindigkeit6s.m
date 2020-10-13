clear all
clc
run importiereGeschwindigkeitFuerValidierung
jj=1;
GeschwindigkeitNeu = zeros(length(Geschwindigkeit.Data)*5,1);
GeschwindigkeitNeu = timeseries(GeschwindigkeitNeu);

for ii=1:length(Geschwindigkeit.Data)
    GeschwindigkeitNeu.Data(jj) = Geschwindigkeit.Data(ii);
    interpolWerte(ii) = jj;
    for kk = (jj+1):(jj+4)
        GeschwindigkeitNeu.Data(kk) = NaN;
    end
    jj=jj+5;
end
idx = ~isnan(GeschwindigkeitNeu.Data);
GeschwindigkeitNeu.Data = interp1(find(idx),GeschwindigkeitNeu.Data(idx),(1:numel(GeschwindigkeitNeu.Data))');


%km/h in m/s

GeschwindigkeitNeu.Data = GeschwindigkeitNeu.Data ./ 3.6;

%Ersetze Geschwindigkeit durch GeschwindigkeitNeu

Geschwindigkeit = GeschwindigkeitNeu;
