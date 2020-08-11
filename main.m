clear
clc
close all

%% Die Datei Laden
start = 1;
testbench_RB = 1;
Fahrzeug_test = 1;
Rad_test = 1;
Motorart = 'EM';

%% Die Excel-Datei "Fahrzyklus.xlsx" auswaehlen
[Fahrzeug, M_kupplung, Rad, VKM, EM, RB] = import_transmission(start);% Datei laden
Fahrzyklus = eval(['RB.RB',num2str(testbench_RB),'.Fahrzyklus']);
name_fahrzeug = fieldnames(Fahrzeug);
name_RB = fieldnames(RB);
name_Rad = fieldnames(Rad);
Fahrzeug = Fahrzeug.(name_fahrzeug{Fahrzeug_test});
RB = RB.(name_RB{testbench_RB});
Rad = Rad.(name_Rad{Rad_test});

load(Fahrzyklus)                                        % laden Fahrzyklusdatei
Beschleunigung = gradient(Geschwindigkeit.data);        % die Beschleunigung berechnen 
Wegstrecke = trapz(Geschwindigkeit.data);

%% Umrechnen      
v_km_h = Geschwindigkeit.data .* 3.6;                   % Fahrzeuggeschwindigkeit in km/h [km/h]
omega = Geschwindigkeit.data ./ Rad.r_dyn;              % Rotationsgeschwindigkeit des Rads [rad/s]
i_F = schalten(Fahrzeug, v_km_h);                       % Schalten(Uebersetzung) im Fahrzyklus [-]

%% Die Widerst?nde Berechnen
F_L = Luftwiderstand(Fahrzeug, RB, Geschwindigkeit);
F_R = Rollwiderstand(Fahrzeug, Rad, RB, v_km_h);
F_St =Steigungswiderstand(Fahrzeug, RB);
[F_C, G] = Beschleunigungswiderstand(Fahrzeug, Rad, M_kupplung, VKM, EM, i_F, Beschleunigung);

%% Antriebskraft berechnen
F_Bedarf = F_L + F_R + F_St + F_C;                      % notwendige Antriebskraft des Fahrzeugs [N]
T_Bedarf = F_Bedarf * Rad.r_dyn;                        % notwendige Antriebsmoment des Fahrzeugs [Nm]
P_motor = F_Bedarf .* Geschwindigkeit.data;
%P_motor_unknow = Leistung(VKM, EM, Geschwindigkeit, F_Bedarf, G); % Die Leistung des Motors berechnen

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
Motor_antrieb = P_motor;
Motor_regenerativ = zeros(length(Geschwindigkeit.data),1);
if strcmp(Motorart, 'EM')
    for i=1:length(Motor_antrieb)
        if Motor_antrieb(i)<0
            Motor_regenerativ(i) = Motor_antrieb(i);
            Motor_antrieb(i) = 0;
        end
    end
    Energie_reg = trapz(Motor_regenerativ) * EM.EM1.eta_reg; % regenerative Leistung [ws]
    Energie_antrieb = trapz(Motor_antrieb) / EM.EM1.eta;     % Antriebsleistung [ws]
else
    Energie_reg = 0;                                                              % regenerative Leistung [ws]
    Energie_antrieb = trapz(Motor_antrieb(Motor_antrieb > 0)) / VKM.VKM1.eta;     % Antriebsleistung [ws]
end

%% Fehlt noch Kennfeld des Motors!!!!!!!!!!!!!
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


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
T_umgebung_list = (-40:5:40);
for i = 1:length(T_umgebung_list)
    T_umgebung = T_umgebung_list(i);
    out = sim('HVAC.slx','StopTime',t_end);
    Energie_hvac_kwh_per_km(i) = abs(out.simout.data(end)/3600/kmzahl/EM.EM1.eta/eta_hvac)+ Energie_fan_kwh_per_km; % HVAC-verbrauchen per km [kwh/km]
end
figure
bar(T_umgebung_list, Energie_hvac_kwh_per_km)


