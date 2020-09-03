a = table2array(braunschweig);
Geschwindigkeit = timeseries(a(:,2),a(:,1))./3.6;
Beschleunigung = timeseries(gradient(Geschwindigkeit.data));
Geschwindigkeit = resample(Geschwindigkeit,1:1:1089);
Beschleunigung = resample(Beschleunigung,1:1:1089);

Beschleunigung.Data = filloutliers(Beschleunigung.Data,'next');

b = gradient(Position.speed);
Geschwindigkeit = timeseries(Position.speed);
Beschleunigung = timeseries(gradient(Geschwindigkeit.data));
Beschleunigung.data = circshift(Beschleunigung.Data,-1);

a = Position.speed.*3.6;
b = gradient(Position.speed);
b = b-min(b);
c = exp(b);
geoscatter(Position.latitude,Position.longitude,c,a,'LineWidth',1)


load R-Bus_diesel.mat;
plot(Geschwindigkeit)
hold on
load('braunschweig.mat')
plot(Geschwindigkeit);
ylabel('Geschwindigkeit in m/s')


subplot(3,1,1)
plot(Geschwindigkeit)
title('Braunschweig')
xlabel('Zeit in s')
ylabel('Geschwindigkeit in m/s')

subplot(3,1,2)
plot(Geschwindigkeit)
title('New York City')
xlabel('Zeit in s')
ylabel('Geschwindigkeit in m/s')

subplot(3,1,3)
plot(Geschwindigkeit)
title('Manhattan')
xlabel('Zeit in s')
ylabel('Geschwindigkeit in m/s')

b = P_motor_unknow;
for i=1:length(b)
    if b(i)<0
        b(i)=0;
    end
end
c = trapz(b);
c = c/0.8;
kmzahl = Wegstrecke(end)/1000;
c/3600000/kmzahl

b = {};
c = 1;
for i=1:1740:length(a)
    if i+1739 > length(a)
        b{c} = a(i:end)
        b{c}(isnan(b{c})==1) = 0;
    else
        b{c} = a(i:i+1739);
        b{c}(isnan(b{c})==1) = 0;
        c = c + 1;
    end
end

for i = 1:length(b)
    
end



cc = []
for i=1:30
    cc(i) = trapz(b{i})/3600;
end


for i=0:70
    try
        a{i+1} = importdata_SUMO('SUMO_Data.xlsx', ['sheet',num2str(i)]);
        a{1, i+1}(1,:) = [];
    catch
        break
    end
end

opts = spreadsheetImportOptions("NumVariables", 8);
opts.VariableNames = ["Var1", "timestep_time", "Var3", "vehicle_id", "Var5", "Var6", "Var7", "vehicle_speed"];
opts.SelectedVariableNames = ["timestep_time", "vehicle_id", "vehicle_speed"];
opts.VariableTypes = ["char", "double", "char", "categorical", "char", "char", "char", "double"];
a = readtable('SUMO_Data.xlsx',opts,'sheet','sheet0');




for i=1:80
    try
        disp(a(i))
    catch
        break
    end
end

%% fahrgaeste L-elektrisch
Position{:,'passenger'}=0;
Position{1:203, 'passenger'} = 21;
Position{206:235, 'passenger'} = 22;
Position{237:330, 'passenger'} = 23;
Position{332:423, 'passenger'} = 20;
Position{425:530, 'passenger'} = 16;
Position{531:end, 'passenger'} = 6;


%% fahrgaeste R-diesel
Position{:,'passenger'}=0;
Position{1:92, 'passenger'} = 7;
Position{93:162, 'passenger'} = 8;
Position{163:211, 'passenger'} = 9;
Position{212:288, 'passenger'} = 11;
Position{289:381, 'passenger'} = 12;
Position{382:477, 'passenger'} = 17;
Position{478:540, 'passenger'} = 15;
Position{541:697, 'passenger'} = 17;
Position{698:894, 'passenger'} = 12;
Position{895:981, 'passenger'} = 10;
Position{982:1071, 'passenger'} = 11;
Position{1073:1116, 'passenger'} = 12;
Position{1117:1236, 'passenger'} = 10;
Position{1237:1339, 'passenger'} = 12;
Position{1340:1406, 'passenger'} = 13;
Position{1407:1469, 'passenger'} = 12;
Position{1470:end, 'passenger'} = 14;


%% 
for i=1:length(Q)-1
    a(i) = atan((elevation_hgt(i+1)-elevation_hgt(i))/(Q(i+1)-Q(i)));
end

takt = false;
halt = zeros(length(Geschwindigkeit.Data),1);
for i=1:length(Geschwindigkeit.Data)-5
    if ~mod(i,60)
        takt = true;
    end
    if mean(Geschwindigkeit.Data(i:i+5))<0.1 && takt
        halt(i+1) = 1;
        takt = false;
    end
end
a = find(halt);
for j=1:length(a)-1
    if a(j+1)-a(j)<=60
        a(j+1) = a(j);
    end
end
a = unique(a);
b = zeros(length(halt),1);
for i=1:length(a)
    b(a(i):a(i)+10) = 1;
end







figure
yyaxis left
plot(Geschwindigkeit.Data)
yyaxis right
plot(T_Bedarf)



a = T_Bedarf>=10000 & Geschwindigkeit.Data >= 4;





















