testWeg = trapz(Geschwindigkeit.Data);
testEnergieverbrauchJ = trapz(out.LeistungsverbrauchGesamt.Data);
testEnergieverbrauchkWhProkm = testEnergieverbrauchJ/(3.6e6)/(testWeg/1e3);