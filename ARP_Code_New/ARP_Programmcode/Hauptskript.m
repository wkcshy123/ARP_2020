%% Advanced Research Project 2020
%Gruppenmitglieder: Ismail Mehmed, Etnik Shatri, Feng Zhu, Drini Avdylaj
%Bearbeitungszeitraum: 13.07.20 - 12.10.20
clear all; close all; clc;

%% 1. Starten der Graphical User Interface
run('Parameter_Eingabemaske')

%% 2. Laden der Fahrzyklusdatei
load(fahrzyklusDateiPfad)

    %% 2.1. Fahrgästeanzahl
        %Wenn Datei fehlt -- Annahme: Konstant
    if exist('Fahrgaeste','var') == 0
        Fahrgaeste = timeseries(20, Geschwindigkeit.Time);
    end

%% 3. Berechnung der Steigungsdaten
Steigung = zeros(length(Geschwindigkeit.data),1);
%if exist('Latitude','var')
%    Steigung = SteigungsDaten(Geschwindigkeit, Latitude, Longitude);
%end
% Überprüfe Steigungsdaten => Falls NaN => 0
Steigung(isnan(Steigung))=0;

%% 4. Kennfelder laden
% model_selection: (1-DIESEL) (0-ELEKTRO)
%______________________________________DIESEL_______________________________________
if model_selection == 1
    %Kennfeld BSFC laden 
    run('Kennfeld_BSFC_v2.m')
    kennfeld = map;
    %Kennfeld Torque Converter laden
    load('torque_converter_graph_v2')
    torque_outputDivInput = torque_converter_graph_v2(:,1);
    converter_eff = torque_converter_graph_v2(:,2);

    load('torque_ratio')
    tr_speed_ratio = torque_ratio(:,1);
    tr_torque_ratio = torque_ratio(:,2);

    %Simulationszeit an Geschwindigkeitsprofil anpassen
    simtime = length(Geschwindigkeit.time);

    % Hilfsvariablen
    H_U = 0.0119; % Heizwert Diesel in kWh/g
    minMotordrehzahl = 800; % Mindestmotordrehzahl Gangwahl

    % Simulation in Simulink starten
    out=sim('Simulationsmodell_Diesel',simtime);

    %Energieverbrauch in kWh/km und l/100km
    fahrstrecke = trapz(Geschwindigkeit.Data)/1e3; %gesamte Fahrstrecke in km
    energieverbrauch = trapz(out.LeistungsverbrauchGesamt.Data)/3.6e6; %Energieverbrauch in kWh
    
    energieverbrauch_kWhProkm = energieverbrauch/fahrstrecke; %kWh/km
    
    %Umrechung 9.8 kWh/l
    kraftstoffverbrauch_LiterPro100km = energieverbrauch_kWhProkm/9.8*100; %l/100km
    
%______________________________________ELEKTRO_______________________________________
elseif model_selection == 0
    %Kennfeld BSFC laden 
    load('kennfeld_Elektrobus_v2.mat')

    %Simulationszeit an Geschwindigkeitsprofil anpassen
    simtime = length(Geschwindigkeit.time);


    % Hilfsvariablen

    % Simulation in Simulink starten
    out=sim('Simulationsmodell_Elektro',simtime);
    
    %Energieverbrauch in kWh/100km und kWh/km
    fahrstrecke = trapz(Geschwindigkeit.Data)/1e3; %gesamte Fahrstrecke in km
    energieverbrauch = trapz(out.LeistungsverbrauchGesamt.Data)/3.6e6; %Energieverbrauch in kWh
    
    energieverbrauch_kWhProkm = energieverbrauch/fahrstrecke;
    energieverbrauch_kWhPro100km = energieverbrauch_kWhProkm*100;
end
%_____________________________________________________________________________________
%% 5. Berechnung des Energieverbrauches

% 
% testWeg = trapz(Geschwindigkeit.Data);
% testEnergieverbrauchJ = trapz(out.LeistungsverbrauchInklLeerlauf.Data);
% testEnergieverbrauchkWhProkm = testEnergieverbrauchJ/(3.6e6)/(testWeg/1e3);

% testWeg = trapz(Geschwindigkeit.Data);
% testEnergieverbrauchJ = trapz(ans.LeistungsverbrauchGesamt.Data);
% testEnergieverbrauchkWhProkm = testEnergieverbrauchJ/(3.6e6)/(testWeg/1e3);