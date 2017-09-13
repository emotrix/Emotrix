# -*- coding: utf-8 -*-
# **********************************************************************************************************************
# Archivo:      Reader.py
# Proposito:    Este archivo es el encargado de leer los archivos csv
# Autor:        Diego Jacobs    13160
# **********************************************************************************************************************

import csv
import numpy as np
from BlockData import BlockData

class Reader(object):
    """
    docstring here
        :param object: 
    """
    
    def __init__(self, fileData, tagsToIgnore):
        """
        docstring here
            :param self: 
            :param fileData: 
            :param tagsToIgnore: 
        """
        self.fileName = fileData
        self.ignoreTags = tagsToIgnore
        self.time = np.array([])
        self.f3 = np.array([])
        self.f4 = np.array([])
        self.af3 = np.array([])
        self.af4 = np.array([])
        self.tag = np.array([])
        self.blocks = []

    def readFile(self):
        """
        docstring here
            :param self: 
        """
        try:
            fileToRead = open(self.fileName, "rb")
            reader = csv.reader(fileToRead, delimiter='\t', quotechar='"')

            time, f3, f4, af3, af4, tag = [], [], [], [], [], []
            for row in reader:
                if len(row) == 6:
                    if row[5] in self.ignoreTags:
                        continue
                    f3_value = int(row[1].split(':')[1].split(',')[1])
                    f3_quality = int(row[1].split(':')[1].split(',')[0])
                    f4_value = int(row[2].split(':')[1].split(',')[1])
                    f4_quality = int(row[2].split(':')[1].split(',')[0])
                    af3_value = int(row[3].split(':')[1].split(',')[1])
                    af3_quality = int(row[3].split(':')[1].split(',')[0])
                    af4_value = int(row[4].split(':')[1].split(',')[1])
                    af4_quality = int(row[4].split(':')[1].split(',')[0])
                    #Filtro
                    if min(f3_quality, f4_quality, af3_quality, af4_quality) >= 1:
                        time.append(int(row[0]))
                        f3.append(f3_value)
                        f4.append(f4_value)
                        af3.append(af3_value)
                        af4.append(af4_value)
                        tag.append(row[5])
        except:
            print 'No encontrado: ' + self.fileName + '.csv'
            fileToRead.close()

        #Los arreglos se transforman a arreglos de numpy, para que sea mas eficiente.
        self.time = np.append(self.time, np.array(time))
        self.tag = np.append(self.tag, np.array(tag))
        self.f3 = np.append(self.f3, np.array(f3))
        self.f4 = np.append(self.f4, np.array(f4))
        self.af3 = np.append(self.af3, np.array(af3))
        self.af4 = np.append(self.af4, np.array(af4))

        
    #Metodo para obtener los datos en bloques de 1 segundo.
    def getBlocksData(self):
        self.blocks = []
        before = self.tag[0]
        lower_limit_i = 0
        i = 0
        size = 256
        overlap = 20
        for t in np.append(self.tag, 'fin'):
            if t != before:
                previous_second = self.time[lower_limit_i]
                for j in range(lower_limit_i, i-128, overlap):
                    #Se descarta el primer segundo de cada bloque
                    if j != lower_limit_i:
                        block = BlockData(tag=before, time=self.time[j], f3=self.f3[j:j+size], f4=self.f4[j:j+size], af3=self.af3[j:j+size], af4=self.af4[j:j+size])
                        self.blocks.append(block)
                lower_limit_i = i
                before = t
            i += 1
        return self.blocks

r = Reader("/home/emotrix/Documents/EMOTRIX/emotrix/2017/user2.csv", ["RELAX", "NOPE"])
r.readFile()
print r.getBlocksData()
