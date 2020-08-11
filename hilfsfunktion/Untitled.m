a = table2array(braunschweig);
Geschwindigkeit = timeseries(a(:,2),a(:,1))./3.6;
Beschleunigung = timeseries(gradient(Geschwindigkeit.data),Geschwindigkeit.time);
Geschwindigkeit = resample(Geschwindigkeit,1:1:1089);
Beschleunigung = resample(Beschleunigung,1:1:1089);



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



