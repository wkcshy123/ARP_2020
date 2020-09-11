'''
kleine Beispiel für Aufbauen eine vereinfachten SImulation.
Nachmachen nach dem offiziellen Tutorials: https://sumo.dlr.de/docs/Tutorials/OSMWebWizard.html
'''

import os
import sys
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns



def bus_speed_visullisation(path):
    sns.set()
    df = pd.read_csv(path, sep=';')
    a = df.groupby(['vehicle_id'])
    b = []
    for name, group in a:
        if 'bus' in name:
            group['vehicle_id'] = name
            group['vehicle_speed'] = group['vehicle_speed'].values * 3.6
            b.append(group.reset_index())
    writer = pd.ExcelWriter('D:SUMO_Data.xlsx')
    for x, ini in enumerate(b):
        ini.to_excel(writer, sheet_name='Sheet'+str(x), index=False)
        plt.plot(ini['vehicle_speed'])
        plt.ylabel('Spped in km/h')
        plt.xlabel('time in s')
        plt.title(ini['vehicle_id'][0])
        plt.show()
    writer.save()


def new_report(test_report):
    lists = os.listdir(test_report)
    lists.sort(key=lambda fn: os.path.getmtime(test_report + "/" + fn))
    if lists[-1] == 'xml':
        file_new = os.path.join(test_report, lists[-2])
    else:
        file_new = os.path.join(test_report, lists[-1])
    return file_new


if __name__ == '__main__':
    SUMO_HOME = os.environ.get("SUMO_HOME") # dieses Enviroment variable wird bei der Installierung des SUMO automatisch eingestellt
    FUNCTION_PATH = SUMO_HOME+'tools'
    sys.path.append(FUNCTION_PATH)
    FILENAME = 'test2'

    session_establish = input('session establish？（True/False）') # wenn du neue Simulation laufen lassen willst, dann True eingeben und
    if eval(session_establish):
        os.chdir(FUNCTION_PATH)
        os.system('python osmWebWizard.py')
    else:
        pass

    path_new = new_report(FUNCTION_PATH)
    os.chdir(path_new)
    os.system('sumo '
              '-c osm.sumocfg '
              '--end 1200 '
              '--max-num-vehicles 20 '
              '--fcd-output '+FILENAME+'.xml'
              )
    TABLE_PATH = FUNCTION_PATH+'\\xml'
    os.system('copy /y test2.xml "'+TABLE_PATH+'"')


    os.chdir(TABLE_PATH)
    os.system('python xml2csv.py '+FILENAME+'.xml')

    bus_speed_visullisation(TABLE_PATH+'\\'+FILENAME+'.csv')

