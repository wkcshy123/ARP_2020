clear all
clc
close all
%% Fahrzyklus bewerten DEMO (Standardzyklus, Logger-Daten-H-Bus, SUMO)
% Jede *.mat Datei besteht aus 2 Variabel (Geschwindigkeit, Beschleunigung)
% und beide im Form von "timeseries"

%% Standard Fahrzuklus
load manhattan.mat
T_manhattan = Bewertungskriterium(Geschwindigkeit, Beschleunigung, 'T_manhattan');
load braunschweig.mat;
T_braunschweig = Bewertungskriterium(Geschwindigkeit, Beschleunigung, 'T_braunschweig');
T_gesamt = [T_braunschweig, T_manhattan];
load L-Bus_elektrisch.mat;
T_L_Bus = Bewertungskriterium(Geschwindigkeit, Beschleunigung, 'T_L_Bus');
T_gesamt = [T_gesamt, T_L_Bus];
load R-Bus_diesel.mat;
T_R_Bus = Bewertungskriterium(Geschwindigkeit, Beschleunigung, 'T_R_Bus');
T_gesamt = [T_gesamt, T_R_Bus];
%% logger-Daten des H-Bus
load logger-daten-H-bus.mat
fahrzyklus_ausschnitt = {};
anzahl = 1;
% grosse Datenmenge zerlegen in ca. 3 min (1740s) Ausschnitt
for i=1:1740:length(Geschwindigkeit)
    if i+1739 > length(Geschwindigkeit)
        fahrzyklus_ausschnitt{anzahl} = Geschwindigkeit(i:end)./3.6;
        fahrzyklus_ausschnitt{anzahl}(isnan(fahrzyklus_ausschnitt{anzahl})==1) = 0;
    else
        fahrzyklus_ausschnitt{anzahl} = Geschwindigkeit(i:i+1739)./3.6;
        fahrzyklus_ausschnitt{anzahl}(isnan(fahrzyklus_ausschnitt{anzahl})==1) = 0;
        anzahl = anzahl + 1;
    end
end
% Analyse
for j = 1:length(fahrzyklus_ausschnitt)
    anzahl = gradient(fahrzyklus_ausschnitt{j});
    Beschleunigung= timeseries(circshift(anzahl,-1),linspace(1,length(fahrzyklus_ausschnitt{j}),length(fahrzyklus_ausschnitt{j})));
    Geschwindigkeit = timeseries(fahrzyklus_ausschnitt{j},linspace(1,length(fahrzyklus_ausschnitt{j}),length(fahrzyklus_ausschnitt{j})));
    eval(['T_Logger',num2str(j),'=Bewertungskriterium(Geschwindigkeit, Beschleunigung, ','"T_Logger',num2str(j),'");']);
    eval(['T_gesamt = [T_gesamt,','T_Logger',num2str(j),'];']);
    eval(['clear T_Logger',num2str(j)])
end

%% Simulationsdaten aus SUMO
% Daten loading... 
opts = spreadsheetImportOptions("NumVariables", 8);
opts.VariableNames = ["Var1", "timestep_time", "Var3", "vehicle_id", "Var5", "Var6", "Var7", "vehicle_speed"];
opts.SelectedVariableNames = ["timestep_time", "vehicle_id", "vehicle_speed"];
opts.VariableTypes = ["char", "double", "char", "categorical", "char", "char", "char", "double"];
[~, sheet, ~]=xlsfinfo('SUMO_Data.xlsx');
parfor i=0:length(sheet)-1
    SUMO{1, i+1} = readtable('SUMO_Data.xlsx',opts, 'sheet', ['sheet',num2str(i)]);
    SUMO{1, i+1}(1,:) = [];   
end
% Analyse
for j = 1:length(SUMO)
    Beschleunigung = gradient(SUMO{j}.vehicle_speed ./ 3.6);
    Beschleunigung= timeseries(circshift(Beschleunigung,-1), height(SUMO{j}));
    Geschwindigkeit = timeseries(SUMO{j}.vehicle_speed ./ 3.6, height(SUMO{j}));
    eval(['T_SUMO',num2str(j),'=Bewertungskriterium(Geschwindigkeit, Beschleunigung, ','"T_SUMO',num2str(j),'");']);
    eval(['T_gesamt = [T_gesamt,','T_SUMO',num2str(j),'];']);
    eval(['clear T_SUMO',num2str(j)])
end

%% Transformieren
T_gesamt = rows2vars(T_gesamt);

