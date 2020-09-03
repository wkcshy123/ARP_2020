function [Fahrzeug, M_kupplung, Rad, VKM, EM, RB]=ImportData(start)
switch start
    case 1
        [file,path] = uigetfile('*.xlsx');
        if isequal(file,0)
            disp('User selected Cancel');
        else
            xlsname=[path,file];
        end
        [Fahrzeug, M_kupplung, Rad, VKM, EM, RB] = read_transmission(xlsname);
    case 2
        path=uigetdir('C:\','select a new workfolder');
        if isequal(path,0)
            disp('User selected Cancel');
        else
            eval(['copyfile Muster\transmession_input.xlsx ',path,' f']);
            winopen transmession_input.xlsx;
            msgbox('please save xlsx file after edit of parameter ');
        end
end

    function [Fahrzeug, M_kupplung, Rad, VKM, EM, RB] = read_transmission(xlsname)
        xlRange_data={'D2:D12', 'D2:G5','D2:D4', 'D2:D5', 'D2:D6', 'D2:G6'};
        xlRange_label={'C3:C12', 'C3:C5','C3:C4', 'C3:C5', 'C3:C6', 'C3:C6'};
        sheet_idx=[1,2,3,4,5,6];
        raw=cell(2,6);
        for xx=1:6
            [~,~,raw{1,xx}]=xlsread(xlsname,sheet_idx(xx),xlRange_data{xx});
            [~,~,raw{2,xx}]=xlsread(xlsname,sheet_idx(xx),xlRange_label{xx});
        end
        %fieldname{1}={'name','m_F','r_dyn','A_quer','c_w','Antriebsart','f_R','J_VKM','J_EM','J_Get_An','J_Get_Ab_Rad','i_Get'};
        %fieldname{2}={'Fahrzyklus','rho_L','St_winkel','g'};
        
        %weleche Term darin ist Text
        str2num_idx=cell(1,6);
        str2num_idx{1}=[4,5];
        str2num_idx{2}=[1,2];
        str2num_idx{3}=[];
        str2num_idx{4}=[];
        str2num_idx{5}=[];
        str2num_idx{6}=[1];
        [~,name,~] = xlsfinfo(xlsname);
        for xx=1:6
            data=raw{1,xx};
            thisfieldname=raw{2,xx};
            thisstr2num_idx=str2num_idx{xx};
            for yy=1:length(data(1,:))
                if ~isnan(data{1,yy})
                    for zz=1:length(thisfieldname)
                        if ~ismember(zz,thisstr2num_idx)&&ischar(data{zz+1,yy})
                            eval([name{xx},'.(data{1,yy}).(thisfieldname{zz})=str2num(data{zz+1,yy})',';']);
                        else
                            eval([name{xx},'.(data{1,yy}).(thisfieldname{zz})=data{zz+1,yy}',';']);
                        end
                    end
                end
            end
        end
    end
end