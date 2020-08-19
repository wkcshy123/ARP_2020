clear all
clc
close all

%% Die Datei Laden
start = 1;
testbench_RB = 1;
Fahrzeug_test = 1;
Rad_test = 1;
Motorart = 'EM';

% Die Excel-Datei "Fahrzyklus.xlsx" auswaehlen
[Fahrzeug, M_kupplung, Rad, VKM, EM, RB] = import_data(start);% Datei laden
Fahrzyklus = eval(['RB.RB',num2str(testbench_RB),'.Fahrzyklus']);
name_fahrzeug = fieldnames(Fahrzeug);
name_RB = fieldnames(RB);
name_Rad = fieldnames(Rad);
Fahrzeug = Fahrzeug.(name_fahrzeug{Fahrzeug_test});
RB = RB.(name_RB{testbench_RB});
Rad = Rad.(name_Rad{Rad_test});

load(Fahrzyklus)                                        % laden Fahrzyklusdatei
% Daten smooth sehr wichtig, bei L-Bus vor dem Somooth 1.9kwh/km, danach
% 1.5kwh/km Antriebenergieverbrauch
Beschleunigung = gradient(Geschwindigkeit.data);        % die Beschleunigung berechnen 
Wegstrecke = trapz(Geschwindigkeit.data);

%% Umrechnen      
v_km_h = Geschwindigkeit.data .* 3.6;                   % Fahrzeuggeschwindigkeit in km/h [km/h]
omega = Geschwindigkeit.data ./ Rad.r_dyn;              % Rotationsgeschwindigkeit des Rads [rad/s]
i_F = schalten(Fahrzeug, v_km_h);                       % Schalten(Uebersetzung) im Fahrzyklus [-]

%% Die Widerst?nde Berechnen
F_L = Luftwiderstand(Fahrzeug, RB, Geschwindigkeit);    % Luftwiderstand
F_R = Rollwiderstand(Fahrzeug, Rad, RB, v_km_h);        % Rollwiderstand
F_St =Steigungswiderstand(Fahrzeug, RB);                % Steigungswiderstand
[F_C, G] = Beschleunigungswiderstand(Fahrzeug, Rad, M_kupplung, VKM, EM, i_F, Beschleunigung); % Beschleunigungswiderstand

%% Antriebskraft berechnen
F_Bedarf = F_L + F_R + F_St + F_C;                      % notwendige Antriebskraft des Fahrzeugs [N]
T_Bedarf = F_Bedarf * Rad.r_dyn;                        % notwendige Antriebsmoment des Fahrzeugs [Nm]
P_motor = F_Bedarf .* Geschwindigkeit.data;             % Die Leistung des Motors berechnen [w]
%P_motor_unknow = Leistung(VKM, EM, Geschwindigkeit, F_Bedarf, G); 

subplot(4,1,1);
plot(T_Bedarf);
title('T_Bedarf vs t in [Nm]');
xlabel('Zeit in s');
subplot(4,1,2);
plot(omega);
title('omega vs t in [rad/s]');
xlabel('Zeit in s');
subplot(4,1,3);
plot(Beschleunigung);
title('Beschleunigung vs t in [m/s^2]');
xlabel('Zeit in s');
subplot(4,1,4);
plot(P_motor);
title('Leistung in [W]');
xlabel('Zeit in s');

%% Motorleistung in zwei Gruppen teilen, Verbrauchen/Regeneration
%% eta sollte kein Festwert sein !!!!!!!!!!!!!
Motor_antrieb = P_motor;
Motor_regenerativ = zeros(length(Geschwindigkeit.data),1);
%% Motor Map zeichnen
for i =1:length(omega)
    map(i,1) = omega(i)*9.5*i_F(i);     % Motor Drehzahl (9.5 ist der Faktor von rad/s zu rpm) 
    map(i,2) = T_Bedarf(i)/i_F(i);      % Motor Drehmoment
end
map(:,2) = normalize(map(:,2),'range',[-1,1]);  % Motor Drehmoment normalisieren
figure
scatter(map(:,1),map(:,2),10)                   % Scattermap zeichnen
xlim([0 2500])
title('Motor map')
ylabel('Motor torque normalized')
xlabel('Motor speed [rpm]')
%% Motor-Energie und regerative-Energie
% Fehlt noch Kennfeld des Motors!!!!!!!!!!!!!
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if strcmp(Motorart, 'EM')
    for i=1:length(Motor_antrieb)
        if Motor_antrieb(i)<0
            Motor_regenerativ(i) = Motor_antrieb(i);
            Motor_antrieb(i) = 0;
        end
    end
    Energie_reg = trapz(Motor_regenerativ) * EM.EM1.eta_reg; % regenerative Energie [ws]
    Energie_antrieb = trapz(Motor_antrieb) / EM.EM1.eta;     % Antriebsenergie [ws]
else
    Energie_reg = 0;                                                              % regenerative Energie spielt keine Rolle beim VKM
    Energie_antrieb = trapz(Motor_antrieb(Motor_antrieb > 0)) / VKM.VKM1.eta;     % Antriebsenergie [ws]
end

kmzahl = Wegstrecke / 1000;                              % Kilometerstand [km]
Energie_antrieb_kwh_per_km = Energie_antrieb / 3600000 / kmzahl  % Antriebsverbrauch per km [kmh/km] 
Energie_reg_kwh_per_km = Energie_reg / 3600000 / kmzahl          % Regenerationsenergie per km [kmh/km]
%% Nebenleistungen (HVAC, AUX)
Parameter                                                          % notwendige Parameter aus dem Paper laden
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




