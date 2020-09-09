clear all
clc
close all
% Motorkennfeld!!!!!!!
%% Die Datei Laden
start = 1;
test_RB = 1;
Fahrzeug_test = 1;
Rad_test = 1;

% Die Excel-Datei "Fahrzyklus.xlsx" auswaehlen
[Fahrzeug, ~, Rad, VKM, EM, RB] = ImportData(start);% Datei laden
Studycase = eval(['RB.RB',num2str(test_RB),'.Fahrzyklus']);
name_fahrzeug = fieldnames(Fahrzeug);
name_RB = fieldnames(RB);
name_Rad = fieldnames(Rad);
Fahrzeug = Fahrzeug.(name_fahrzeug{Fahrzeug_test});
RB = RB.(name_RB{test_RB});
Rad = Rad.(name_Rad{Rad_test});
Motorart = Fahrzeug.Antriebsart;
load(Fahrzeug.Motorkennzeichen)                         % hier wird Motorkennfeld geladen
load(Studycase)                                         % laden Fahrzyklusdatei
Beschleunigung = gradient(Geschwindigkeit.data);        % die Beschleunigung berechnen 
Wegstrecke = trapz(Geschwindigkeit.data);
if ~exist('Fahrgaeste','var')
    Fahrgaeste = timeseries(12, Geschwindigkeit.Time);  % Fahrgästeanzahl   [-]
end

%% Steigungsdaten
Steigung = zeros(length(Geschwindigkeit.data),1);
if exist('Latitude','var')
    [Steigung, Hoehe] = SteigungsDaten(Geschwindigkeit, Latitude, Longitude);
end
%% Umrechnen      
v_km_h = Geschwindigkeit.data .* 3.6;                   % Fahrzeuggeschwindigkeit in km/h [km/h]
omega = Geschwindigkeit.data ./ Rad.r_dyn;              % Rotationsgeschwindigkeit des Rads [rad/s]%
%[i_F, wirkungsgrad_getriebe] = schalten(Fahrzeug, v_km_h);                      
%[i_F, wirkungsgrad_getriebe] = schaltung1(Fahrzeug, Rad, Geschwindigkeit);
%% Die Widerst?nde Berechnen
F_L = Luftwiderstand(Fahrzeug, RB, Geschwindigkeit);                          % Luftwiderstand
F_R = Rollwiderstand(Fahrzeug, Rad, RB, v_km_h, Fahrgaeste, Steigung);        % Rollwiderstand
F_St = Steigungswiderstand(Fahrzeug, RB, Fahrgaeste, Steigung);               % Steigungswiderstand
%F_C = Beschleunigungswiderstand1(Fahrzeug, Rad, M_kupplung, VKM, EM, i_F, Beschleunigung, Fahrgaeste); % Beschleunigungswiderstand
F_C = Beschleunigungswiderstand(Fahrzeug, Beschleunigung, Fahrgaeste);

%% Antriebskraft berechnen
F_Bedarf = F_L + F_R + F_St + F_C;                      % notwendige Antriebskraft des Fahrzeugs [N]
T_Bedarf = F_Bedarf * Rad.r_dyn;                        % notwendige Reifenmoment des Fahrzeugs [Nm]
P_bedarf = F_Bedarf .* Geschwindigkeit.data;            % Die notwendige Leistung auf Reifen [W]

[i_F, wirkungsgrad_getriebe, wirkungsgrad_motor] = schaltung4(Fahrzeug, Rad, Geschwindigkeit, T_Bedarf, kennfeld);       % hier wird Motorkennfeld genutzt! Schalten(Uebersetzung) im Fahrzyklus [-]

subplot(5,1,1);
plot(T_Bedarf);
title('T-Bedarf vs t in [Nm]');
xlabel('Zeit in s');
subplot(5,1,2);
plot(omega .* (60/(2*pi)));
title('omega-reifen vs t in [rpm]');
xlabel('Zeit in s');
subplot(5,1,3);
plot(v_km_h);
title('Geschwindigkeit vs t in [km/h]');
xlabel('Zeit in s');
subplot(5,1,4);
plot(Beschleunigung);
title('Beschleunigung vs t in [m/s^2]');
xlabel('Zeit in s');
subplot(5,1,5);
plot(P_bedarf);
title('Leistung in [W]');
xlabel('Zeit in s');

%% Motorleistung in zwei Gruppen teilen, Verbrauchen/Regeneration
Motor_antrieb = P_bedarf;
Motor_regenerativ = zeros(length(Geschwindigkeit.data),1);
%% Motor Map zeichnen
map(:,1) = omega * (60/(2*pi)) .* i_F .* Fahrzeug.i_main_reducer./10;                             % Motor Drehzahl.  (Skalierungsfaktor 10)
map(:,2) = T_Bedarf ./ i_F ./ Fahrzeug.i_main_reducer ./ wirkungsgrad_getriebe./10./(1200/850);               % Motor Drehmoment (Skalierungsfaktor 10*1200/800)
figure
hold on
scatter(map(:,1),map(:,2),10)                          % Scattermap zeichnen
contour(kennfeld)
title('Motor map')
ylabel('Motor torque/10/(1200/850) [Nm]')
xlabel('Motor speed/10 [rpm]')

%% Motor-Energie und regerative-Energie
if strcmp(Motorart, 'EM')
    for i=1:length(Motor_antrieb)
        if Motor_antrieb(i)<0
            Motor_regenerativ(i) = Motor_antrieb(i);
            Motor_antrieb(i) = 0;
        end
    end
    % vorraussetzung1: v>5.0km/h  (anhand der Doktorarbeit)
    % vorraussetzung2: -4m/s^2<a<0
    Motor_regenerativ = Motor_regenerativ(Geschwindigkeit.data>=5/3.6 & 0>Beschleunigung>=-4);
    Energie_reg = trapz(Motor_regenerativ .* wirkungsgrad_getriebe(Geschwindigkeit.data>=5/3.6 & 0>Beschleunigung>=-4)) * EM.EM1.eta_reg; % regenerative Energie [ws]  (noch * eta_getriebe)%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    Energie_antrieb = trapz(Motor_antrieb ./ wirkungsgrad_getriebe ./ (wirkungsgrad_motor./100));     % Antriebsenergie [ws]       (noch / eta_getriebe)%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
elseif strcmp(Motorart, 'VKM')
    Energie_reg = 0;                                                                  % regenerative Energie spielt keine Rolle beim VKM
    Energie_antrieb = trapz(Motor_antrieb(Motor_antrieb > 0) ./ wirkungsgrad_getriebe(Motor_antrieb > 0) ./ (wirkungsgrad_motor(Motor_antrieb > 0)./100));     % Antriebsenergie [ws] (noch / eta_getriebe)%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end

kmzahl = Wegstrecke / 1000;                                        % Kilometerstand [km]
Energie_antrieb_kwh_per_km = Energie_antrieb / 3600000 / kmzahl    % Antriebsverbrauch per km [kmh/km] 
Energie_reg_kwh_per_km = Energie_reg / 3600000 / kmzahl            % Regenerationsenergie per km [kmh/km]

%% Nebenleistungen (HVAC, AUX)
Parameter                                                          % notwendige Parameter aus dem Paper laden
halten = HaltstelleSchaetzen(Geschwindigkeit, min_zeitintervall_haltestellen, haltezeit);
t_end = num2str(length(Geschwindigkeit.data));                     % Simulationszeit
out = sim('HVAC.slx','StopTime',t_end);                            % SImulation der HVAC-Verbrauch
Energie_fan = v_fan * i_fan / 1000 * (length(Geschwindigkeit.data)/3600); 
Energie_fan_kwh_per_km = Energie_fan/kmzahl;                       % Fan-Verbrauchen per km [kwh/km]
Energie_hvac_kwh_per_km = out.simout.data(end)/3600/kmzahl;        % HVAC-verbrauchen per km [kwh/km]
Energie_aux = aux_leistung * (length(Geschwindigkeit.data)/3600);  % Aux-Verbrauchen [kwh]
Energie_aux_kwh_per_km = Energie_aux / kmzahl                      % Aux-Verbrauchen per km [kwh/km]
Energie_HVAC_kwh_per_km = (Energie_hvac_kwh_per_km/EM.EM1.eta/eta_hvac) + Energie_fan_kwh_per_km  % gesamte HVAC-verbrauchen per km [kwh/km]

%% Die Empfindlichkeit des HVAC gegen Temperatur Aenderung
T_umgebung_list = (-40:5:40);                   % Aussentemperaturbereich als -40~40
Energie_hvac_kwh_per_km_empfindlichkeit_gegen_Temp = zeros(1,length(T_umgebung_list));
for i = 1:length(T_umgebung_list)               % fuer jede Temperatur einmal simulieren daimt wird fuer jede Temperatur ein Energieverbrauch errechnet
    T_umgebung = T_umgebung_list(i);
    out = sim('HVAC.slx','StopTime',t_end);
    Energie_hvac_kwh_per_km_empfindlichkeit_gegen_Temp(i) = abs(out.simout.data(end)/3600/kmzahl/EM.EM1.eta/eta_hvac)+ Energie_fan_kwh_per_km; % HVAC-verbrauchen per km [kwh/km]
end
figure
bar(T_umgebung_list, Energie_hvac_kwh_per_km_empfindlichkeit_gegen_Temp)
xlabel('Aussen Temperatur [°C]')
ylabel('HVAC Verbrauchen [kwh/km]')
title('Empfindlichkeit des HVAC-Verbrauchen gegen Temperatur Aenderung')




