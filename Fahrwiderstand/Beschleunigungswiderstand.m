function F_C = Beschleunigungswiderstand(Fahrzeug, Rad, M_kupplung, VKM, EM, i_F, Beschleunigung)
Traegmoment_Rad_Get_Ab = Fahrzeug.J_Get_Ab_Rad; % Traegeheitsmoment von Getriebe bis Rad 
Traegmoment_Get_An = Fahrzeug.J_Get_An; 
Traegmoment_EM = zeros(1,length(fieldnames(EM))); 
Traegmoment_VKM = zeros(1,length(fieldnames(VKM)));
name_EM = fieldnames(EM);
name_VKM = fieldnames(VKM);
name_kupplung = fieldnames(M_kupplung);
knoten = cell(length(name_kupplung), 2); 

for i = 1:length(name_kupplung)                       % jede Zeile der Variabel 'knoten' steht fuer eine Kupplung
    knoten{i,1} = M_kupplung.(name_kupplung{i}).ver1; % der erste verbundene Motor dieser Kupplung
    knoten{i,2} = M_kupplung.(name_kupplung{i}).ver2; % der zweite verbundene Motor dieser Kupplung
end

knoten = unique(reshape(knoten,[],1)); % die anzahl der Motoren, die mit der Kupplung verbunden werden,feststellen
AAM = zeros(length(knoten));           % eine adjacency matrix herstellen, diese Matrix beschreibt die Verbindungen zwischen
                                         % der Teilen in der Variabel 'knoten' 

for i = 1:length(name_kupplung)
    x1 = find(strcmp(M_kupplung.(name_kupplung{i}).ver1, knoten));
    x2 = find(strcmp(M_kupplung.(name_kupplung{i}).ver2, knoten));
    AAM(x1,x2) = M_kupplung.(name_kupplung{i}).aktiv; % aktiv = 100 als offene Kupplung, aktiv = 1 als geschlossene Kupplung
    AAM(x2,x1) = M_kupplung.(name_kupplung{i}).aktiv;
end

G = graph(AAM, knoten);                               % das topologische diagramm (Verbindungsbeziehungen) herstellen

%% finden die EM, die am Ende mit der Getriebe verbunden werden (also in Betriebe)
for i = 1:length(Traegmoment_EM)
    [~,d, ~] = shortestpath(G,name_EM{i},'Get'); % finden den kuerzesten Weg, von den Motor nach der Getriebe
    if d >= 100                                  % falls die Gewichtung groesser als 100, das heisst irgendeine Kupplung von diesem Motor nach Getriebe offen ist.
        J_thismotor = 0;
    else
        J_thismotor = EM.(name_EM{i}).J;         % falls die Gewichtung kleiner als 100, dann sind alle Kupplungen von diesem 
                                                    % Motor nach Getriebe geschlossen, das heisst die Traegheitsmoment disers Motors muss gerechnet werden 
    end
    Traegmoment_EM(i) = J_thismotor;
end

%% finden die VKM, die am Ende mit der Getriebe verbunden werden (also in Betriebe)
for i = 1:length(Traegmoment_VKM)
    [~,d, ~] = shortestpath(G,name_VKM{i},'Get'); % analog wie beim EM
    if d >= 100
        J_thismotor = 0;
    else
        J_thismotor = VKM.(name_VKM{i}).J;
    end
    Traegmoment_VKM(i) = J_thismotor;
end


Traegmoment_VKM_sum = sum(Traegmoment_VKM); % dann sind die Traegheitsmoment aufzusummieren
Traegmoment_EM_sum = sum(Traegmoment_EM);
J_Red_Ab = Traegmoment_Rad_Get_Ab + (Traegmoment_Get_An ...
    + Traegmoment_EM_sum + Traegmoment_VKM_sum) * i_F .^ 2; % reduzierte Tr¨¢egheitsmoment auf den Abtrieb [kg/m^2]

lambda = 1+ (J_Red_Ab / (Fahrzeug.m_F * Rad.r_dyn^2)); % Massenzuschlagfaktor [-]
F_C = (Fahrzeug.m_F * lambda) .* Beschleunigung;       % Beschleunigungswiderstand [N]
end