% 1 unter_speed
% 2 ober_speed
% 3 unter_drehmoment
% 4 ober_drehmoment
close
load Data001.mat

Drehzahl_bereich = [1000,2500];             % 500 - 2500 besser
Drehmoment_bereich = [750, 1200];

uebersetzung = Fahrzeug.i_Get;
mainreducer = Fahrzeug.i_main_reducer;
a = zeros(4, length(uebersetzung));
for i=1:length(uebersetzung)
    a(1,i) = (Drehzahl_bereich(1)/uebersetzung(i)/mainreducer)*(2*pi/60)*Rad.r_dyn*3.6;
    a(2,i) = (Drehzahl_bereich(2)/uebersetzung(i)/mainreducer)*(2*pi/60)*Rad.r_dyn*3.6;
    a(3,i) = (Drehmoment_bereich(1)*uebersetzung(i)*mainreducer);
    a(4,i) = (Drehmoment_bereich(2)*uebersetzung(i)*mainreducer);
end
figure
hold on
rectangle('Position', [a(1,1),a(3,1),(a(2,1)-a(1,1)),(a(4,1)-a(3,1))],'EdgeColor','r');
rectangle('Position', [a(1,2),a(3,2),(a(2,2)-a(1,2)),(a(4,2)-a(3,2))],'EdgeColor','b');
rectangle('Position', [a(1,3),a(3,3),(a(2,3)-a(1,3)),(a(4,3)-a(3,3))],'EdgeColor','g');
rectangle('Position', [a(1,4),a(3,4),(a(2,4)-a(1,4)),(a(4,4)-a(3,4))],'EdgeColor','c');
text(a(1,1)+(a(2,1)-a(1,1))*0.5, a(4,1),'1.Gang i=4.9')
text(a(1,2)+(a(2,2)-a(1,2))*0.5, a(4,2),'2.Gang i=1.36')
text(a(1,3)+(a(2,3)-a(1,3))*0.5, a(4,3),'3.Gang i=1.0')
text(a(1,4)+(a(2,4)-a(1,4))*0.5, a(4,4),'4.Gang i=0.73')
a = {};
for i=1:length(uebersetzung)   
    for j=1:length(Data001())
        b(j, 1) = (Data001(j,1)/uebersetzung(i)/mainreducer)*(2*pi/60)*Rad.r_dyn*3.6;
        b(j, 2) = (Data001(j,2)*uebersetzung(i)*mainreducer);
    end
    a{i} =  b;
end
for i=1:4
    data = a{i};
    plot(data(:,1),data(:,2),'LineWidth',2)
end

speed = Geschwindigkeit.Data.*3.6;                             % Motor Drehzahl (9.5 ist der Faktor von rad/s zu rpm)        % Motor Drehmoment (noch ./ eta_getriebe)%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%map(:,2) = normalize(map(:,2),'range',[-1,1]);        % Motor Drehmoment normalisieren
scatter(speed(T_Bedarf>=0),T_Bedarf(T_Bedarf>=0),10)                          % Scattermap zeichnen

xlabel('Geschwindigkeit in km/h')
ylabel('Drehmoment des Rads in Nm')