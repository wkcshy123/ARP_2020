%==========================================================================
function elevation_hgt=GetHgtElevation(DriveData,ploton)
%==========================================================================
%performs an interpolation of the topology data of the Radio Shuttle
%Topology Mission (RSTM) to estimate the elevation for given longitude and
%latitude data
%Arved Esser, last changes: 05.02.2020
%==========================================================================

%---turn plotting of if number of inputs is one
if nargin < 2
    ploton=0;
end

%---define source folder for elevation data in .hgt format
elevation_data_folder = ['/Users/zf/Downloads/ARP_Programmcode-3/ARP_Programmcode/02 Hilfsfunktion_Steigung/ele_hgt_data'];

%---initialize old file name
corr_hgt_file_old='';

inds_non_available=[];

%---preallocate elevation
%#---------------------------Fahrzyklusdaten statt
%DriveData
%ARP

elevation_hgt=zeros(size(DriveData.longitude));
%---main loop
for ii=1:length(DriveData.longitude)
    DriveData.longitude(ii);
    if DriveData.longitude(ii)>10
        corr_hgt_file=strcat('N',num2str(floor(DriveData.latitude(ii))),'E0',num2str(floor(DriveData.longitude(ii))),'.hgt');
    else
        corr_hgt_file=strcat('N',num2str(floor(DriveData.latitude(ii))),'E00',num2str(floor(DriveData.longitude(ii))),'.hgt');
    end
    %if filename has changed: load elevation data and build interpolation
    %function
    if ~strcmp(corr_hgt_file,corr_hgt_file_old)
        path_and_file_name=strcat(elevation_data_folder,'/',corr_hgt_file);
        if ~exist(path_and_file_name)
            disp('function get_hgt_elevation: elevation data for requested location not available!')
            inds_non_available=[inds_non_available ii];
            continue  
        end
        ele_data = readhgt(path_and_file_name);
        [lon_grid,lat_grid]=meshgrid(ele_data.lon,ele_data.lat);
        interpFunc = griddedInterpolant(lon_grid',lat_grid',double(ele_data.z)');
    end
    %update old file name
    corr_hgt_file_old=corr_hgt_file;
    
    %---perform elevation interpolation
    elevation_hgt(ii)=double(interpFunc(DriveData.longitude(ii),DriveData.latitude(ii)));
    elevation_hgt(inds_non_available)=elevation_hgt(ii);
    inds_non_available=[];
end

%---optional plotting
if ploton
    figure()
    try
        plot(DriveData.elevation)
    end
    hold on
    plot(elevation_hgt)
    legend('logger elevation','RSTM elevation')
end
end