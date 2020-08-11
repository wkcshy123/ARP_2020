function T = Bewertungskriterium(Geschwindigkeit, Beschleunigung, name)
load Vorlage.mat
%% Distance related
T{'Total distance',name} = trapz(Geschwindigkeit.data);         % [m]
%% Time related
T{'Total time',name} = length(Geschwindigkeit.data);            % [s]

stand= 0;
acc = 0;
dcc = 0;
bre = 0;
num_acc = 0;
num_stop = 0;
acc_threshold =  0.02;  %%%% muss angepasst werden!!!!!!!!!!!!!
dcc_threshold = -0.06;  %%%% muss angepasst werden!!!!!!!!!!!!!
bre_threshold = -0.23;  %%%% muss angepasst werden!!!!!!!!!!!!!
for i=1:length(Geschwindigkeit.data)
    if Geschwindigkeit.data(i) == 0 && Beschleunigung.data(i) == 0
        stand = stand+1;
    end
    if Beschleunigung.data(i) > acc_threshold    % angepasst acc-threshold=0.02m/s^2 nach gegebenen Datenblatt des Braunschweigzyklus
        acc = acc + 1;
    elseif Beschleunigung.data(i) < dcc_threshold % angepasst dcc-threshold=-0.06m/s^2 nach gegebenen Datenblatt des Braunschweigzyklus
        dcc = dcc + 1;
    end
    if Beschleunigung.data(i) < bre_threshold  % angepasst dcc-threshold=-0.23m/s^2 nach gegebenen Datenblatt des Braunschweigzyklus
        bre = bre + 1;
    end
end
for i=2:length(Geschwindigkeit.data)
    if Beschleunigung.data(i) > acc_threshold && Beschleunigung.data(i-1) <= acc_threshold
        num_acc = num_acc+1;
    end
    if (Beschleunigung.data(i) == 0 && Geschwindigkeit.data(i) == 0) && (Beschleunigung.data(i-1) ~= 0 && Geschwindigkeit.data(i-1) ~= 0)
        num_stop = num_stop + 1;
    end
end

T{'Standing time',name} = stand;                                    % [s]
T{'Driving time',name} = T{'Total time',name} - T{'Standing time',name};  % [s]
T{'Drive time spent accelerating',name} = acc;   % [s]
T{'Drive time spent decelerating',name} = dcc;   % [s]
T{'Cruise time',name} = T{'Driving time',name} - T{'Drive time spent accelerating',name} - T{'Drive time spent decelerating',name};  % [s]
T{'Time spent braking',name} = bre;% [s]
T{'% of time driving',name} = T{'Driving time',name} / T{'Total time',name}; % [-]
T{'% of cruising',name} = T{'Cruise time',name} / T{'Total time',name};% [-]
T{'% of time accelerating',name} = T{'Drive time spent accelerating',name} / T{'Total time',name};% [-]
T{'% of time decelerating',name} = T{'Drive time spent decelerating',name} / T{'Total time',name};% [-]
T{'% of time braking',name} = T{'Time spent braking',name} / T{'Total time',name};% [-]
T{'% of time standing',name} = T{'Standing time',name} / T{'Total time',name};% [-]

%% Speed related
T{'Average speed (trip)',name} = 3.6 * T{'Total distance',name} / T{'Total time',name};  %[km/h]
T{'Average driving speed',name} = 3.6 * T{'Total distance',name} / T{'Driving time',name}; %[km/h]
T{'Standard deviation of speed',name} = std(Geschwindigkeit.data .* 3.6); %[km/h]
T{'Speed: 75th - 25th percentile',name} = prctile(Geschwindigkeit.data .* 3.6, 75); %[km/h]
T{'Maximum speed',name} = max(Geschwindigkeit.data .* 3.6); %[km/h]

%% Acceleration related
T{'Average acceleration',name} = sum(Beschleunigung.data) / T{'Total time',name};
T{'Average positive accel.',name} = sum(Beschleunigung.data(Beschleunigung.data > 0)) / sum(Beschleunigung.data > 0);
T{'Average negative accel.',name} = sum(Beschleunigung.data(Beschleunigung.data < 0)) / sum(Beschleunigung.data < 0);
T{'Standard deviation of accel.',name} = std(Beschleunigung.data);
T{'Standard dev. of positive acceleration',name} = std(Beschleunigung.data(Beschleunigung.data > 0));
T{'Accel: 75th - 25th percentile',name} = prctile(Beschleunigung.data, 75);
T{'Number of accelerations',name} = num_acc;
T{'Accelerations per km',name} = 1000 * num_acc / T{'Total distance',name};

%% Stop related
T{'Number of stops',name} = num_stop;
T{'Stops per km Average',name} = 1000* num_stop / T{'Total distance',name};
T{'stop duration',name} = T{'Standing time',name} / T{'Number of stops',name};

abschnitt = {};
abschnitt_anzahl = 1;
Takt = false;
a = ~((Beschleunigung.data == 0) & (Geschwindigkeit.data == 0));
for i = 1:T{'Total time',name}
    if a(i) && ~Takt
        Takt = true;
        abschnitt{abschnitt_anzahl} = [i];
        continue
    end
    if a(i) && Takt
        abschnitt{abschnitt_anzahl}(end+1) = i;
    end
    if i ~= T{'Total time',name}
        if a(i) && ~a(i+1)
            Takt = false;
            abschnitt_anzahl = abschnitt_anzahl + 1;
        end
    end
end
abschnitt_distanz = zeros(length(abschnitt),1);
for j = 1:length(abschnitt)
    abschnitt_distanz(j) = trapz(Geschwindigkeit.data(abschnitt{1,j}(1):abschnitt{1,j}(end)));
end
T{'Average distance between stops',name} = mean(abschnitt_distanz);

%% Dynamicsoriented (die PArameter gleich NaN sind mir nicht klar wie zu berechnen)
T{'Relative positive acceleration',name} = sum(Beschleunigung.data(Beschleunigung.data > 0) .* Geschwindigkeit.data(Beschleunigung.data > 0)) / T{'Total distance',name};
T{'Positive kinetic energy',name} = NaN;
T{'Relative positive speed',name} = NaN;
T{'Relative real speed',name} = NaN;
T{'Relative square speed',name} = NaN;
T{'Relative positive square speed (RPSS)',name} = NaN;
T{'Relative real square speed',name} = NaN;
T{'Relative cubic speed',name} = NaN;
T{'Relative positive cubic speed',name} = NaN;
T{'Relative real cubic speed',name} = NaN;
T{'Root mean square of acceleration',name} = (trapz(Beschleunigung.data.^2) / T{'Total time',name})^0.5;

end

