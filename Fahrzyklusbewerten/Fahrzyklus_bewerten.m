clear 
clc
close all
%% Fahrzyklus bewerten DEMO (Standardzyklus, Logger-Daten-H-Bus, SUMO)
%% Standard Fahrzuklus
load manhattan.mat
T_manhattan = Bewertungskriterium(Geschwindigkeit, Beschleunigung, 'T_manhattan');
load braunschweig.mat;
T_braunschweig = Bewertungskriterium(Geschwindigkeit, Beschleunigung, 'T_braunschweig');
T_gesamt = [T_braunschweig, T_manhattan];

%% logger-Daten des H-Bus
load matlab.mat
b = {};
c = 1;
% grosse Datenmenge zerlegen in ca. 3 min (1740s) Ausschnitt
for i=1:1740:length(a)
    if i+1739 > length(a)
        b{c} = a(i:end)./3.6;
        b{c}(isnan(b{c})==1) = 0;
    else
        b{c} = a(i:i+1739)./3.6;
        b{c}(isnan(b{c})==1) = 0;
        c = c + 1;
    end
end
% Analyse
for j = 1:length(b)
    c = gradient(b{j});
    Beschleunigung= timeseries(circshift(c,-1),linspace(1,length(b{j}),length(b{j})));
    Geschwindigkeit = timeseries(b{j},linspace(1,length(b{j}),length(b{j})));
    eval(['T_Logger',num2str(j),'=Bewertungskriterium(Geschwindigkeit, Beschleunigung, ','"T_Logger',num2str(j),'");']);
    eval(['T_gesamt = [T_gesamt,','T_Logger',num2str(j),'];']);
end

%% Simulationsdaten aus SUMO
% Daten loading... 
opts = spreadsheetImportOptions("NumVariables", 8);
opts.VariableNames = ["Var1", "timestep_time", "Var3", "vehicle_id", "Var5", "Var6", "Var7", "vehicle_speed"];
opts.SelectedVariableNames = ["timestep_time", "vehicle_id", "vehicle_speed"];
opts.VariableTypes = ["char", "double", "char", "categorical", "char", "char", "char", "double"];
for i=0:inf
    try
        SUMO{1, i+1} = readtable('SUMO_Data.xlsx',opts, 'sheet', ['sheet',num2str(i)]);
        SUMO{1, i+1}(1,:) = [];
    catch
        break
    end
end
% Analyse
for j = 1:length(SUMO)
    c = gradient(SUMO{j}.vehicle_speed ./ 3.6);
    Beschleunigung= timeseries(circshift(c,-1), height(SUMO{j}));
    Geschwindigkeit = timeseries(SUMO{j}.vehicle_speed ./ 3.6, height(SUMO{j}));
    eval(['T_SUMO',num2str(j),'=Bewertungskriterium(Geschwindigkeit, Beschleunigung, ','"T_SUMO',num2str(j),'");']);
    eval(['T_gesamt = [T_gesamt,','T_SUMO',num2str(j),'];']);
end

%% Transformieren
T_gesamt = rows2vars(T_gesamt);

