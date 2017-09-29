# -*- coding: utf-8 -*-
"""
Created on Tue Sep 26 01:18:38 2017

@author: ANGELFRANCISCOMORALE
"""

from Tkinter import *
import csv, thread, time, sys, gevent
import pyglet
import ExcelReader
pyglet.lib.load_library('avbin')
pyglet.have_avbin=True

sys.path.insert(0, 'C:/Users/ANGELFRANCISCOMORALE/OneDrive/Documents/Semestres/10mo/MP/Emotrix/emokit')

from emotiv import Emotiv

class AudioPresentation():
    p = 0
    sounds = []
    index = 0
    time = 3000
    filename='data.csv'
    time_block = 5 #tiempo que dura cada estimulo (intervalos)
    sensors = ['F3','F4','AF3','AF4','O1','O2']
    content = []
    def __init__(self):
        self.root = Tk()
        self.root.title('Emotrix 2017 Estimulación Auditiva')
        self.createWidgets()
        with open('order_first_run.txt') as f:
            self.content = f.readlines()
            self.content = [x.strip() for x in self.content]
            content2 = []
            for line in self.content:
                line = line.split(',', 1)
                content2.append(line)
            self.content = content2
            self.player = pyglet.media.Player()
            for name in self.content:
                soundFile = name[0]
                #f = open(soundFile)
                print soundFile
                song = pyglet.media.StaticSource(pyglet.media.load(soundFile))
                self.player.queue(song)
                #self.sounds.append(soundFile) 
                emotion = name[1]
                extension = self.getAudioExtension(soundFile)
               # print str(soundFile)
        w = self.root.winfo_screenwidth()
        h = self.root.winfo_screenheight()
        self.root.geometry("%dx%d+%d+%d" % (w,h, 0, 0))
        thread.start_new_thread(self.emotiv, ())
        thread.start_new_thread(self.selectEmotion, ())
        self.root.mainloop()

        ########EMOTIV###########
    def getAudioExtension(self,audioName):
        extension = audioName.split('.')[1]
        return extension
    def selectEmotion(self):
        while True:
            self.selectedEmotion = raw_input('1 - Feliz\n2 - Triste \n3 - Otro\n\nIngresa una opcion: ')
            if(self.selectedEmotion == '1'):
                self.selectedEmotion = "happy"
            if(self.selectedEmotion == '2'):
                self.selectedEmotion = "sad"
            if(self.selectedEmotion == '3'):
                self.selectedEmotion = "other"
            print self.selectedEmotion        
    def emotiv(self):
        print 'hola'
        headset = Emotiv()
        gevent.spawn(headset.setup)
        print("Serial Number: %s" % headset.serial_number)

        self.num_blocks = len(self.content)
        cont_block = 0
        cont_seconds = 0
        temp_t = 0
        tag = self.content[0][1]
        #Se define el escritor de las lecturas en el archivo CSV
        writer = csv.writer(open(self.filename, 'w'), delimiter=',', quotechar='"', lineterminator='\n')
        row = ["Audio"]
        row.append("Time")
        row.append("Exact Time")
        for sensor in self.sensors:
            row.append(sensor)
            row.append(sensor + "_Quality")
        row.append("Emotion")
        row.append("Selected Emotion")
        writer.writerow(row)
        try:
            print 'hola'
            t0 = time.time()
            tnow = time.time()
            while True:
                t = int(time.time()-t0)
                if temp_t != t:
                    cont_seconds += 1

                if cont_seconds > self.time_block:
                    cont_seconds = 0
                    cont_block += 1
                    if cont_block == self.num_blocks:
                        headset.close()
                        break
                    else:
                        tag = self.content[cont_block][1]
                        now = time.time()
                        
                row = [self.content[cont_block][0]]
                row.append(str(t))
                row.append(time.time())
                try:
                    for sensor in self.sensors:
                        row.append(str(headset.sensors[sensor]['value']))
                        row.append(str(headset.sensors[sensor]['quality']))
                except:
                    print "Sensor incorrecto"
                    headset.close()
                row.append(tag)
                row.append(self.selectedEmotion)
                if self.selectedEmotion != '':
                    self.selectedEmotion = ''
                # Se exporta a csv
                writer.writerow(row)
                #print row
                temp_t = t
                gevent.sleep(0)
        except KeyboardInterrupt:
            headset.close()
        finally:
            headset.close()
        ####################
    def playMusic(self):
        self.player.play()
        self.player.seek(62)
    def createWidgets(self):
        self.matrix = ExcelReader.getMatrix()
        self.studentNamesLabel = Label(self.root,text='Nombre estudiante: ',width=40)
        self.studentNamesLabel.grid(row=0,column=0)
        self.studentNames = Spinbox(self.root,values=self.getColumnValues('nombre'), width=40, state="readonly", wrap=True, command=self.updateProfile)
        self.studentNames.grid(row=0,column=1)
        self.IDLabel = Label(self.root,text='ID',width=50)
        self.IDLabel.grid(row=1,column=0)
        self.ID = Entry(self.root, width=50)
        self.ID.grid(row=1,column=1)
        self.CodigoLabel = Label(self.root,text='Código',width=50)
        self.CodigoLabel.grid(row=2,column=0)
        self.Codigo = Entry(self.root, width=50)
        self.Codigo.grid(row=2,column=1)
        self.CarneLabel = Label(self.root,text='Carné',width=50)
        self.CarneLabel.grid(row=3,column=0)
        self.Carne = Entry(self.root, width=50)
        self.Carne.grid(row=3,column=1)
        self.CorreoLabel = Label(self.root,text='Correo',width=50)
        self.CorreoLabel.grid(row=4,column=0)
        self.Correo = Entry(self.root, width=50)
        self.Correo.grid(row=4,column=1)
        self.CarreraLabel = Label(self.root,text='Año y carrera',width=50)
        self.CarreraLabel.grid(row=5,column=0)
        self.Carrera = Entry(self.root, width=50)
        self.Carrera.grid(row=5,column=1)
        self.TelefonoLabel = Label(self.root,text='Teléfono',width=50)
        self.TelefonoLabel.grid(row=6,column=0)
        self.Telefono = Entry(self.root, width=50)
        self.Telefono.grid(row=6,column=1)
        
        #self.VisualGUI = Button(self.root,text="Estimulos Visuales",command=self.visualGUI)
        #self.VisualGUI.grid(row=8,column=0)
        #self.AuralGUI = Button(self.root,text="Estimulos Auditivos",command=self.auralGUI)
        #self.AuralGUI.grid(row=8,column=1)
    def getColumnValues(self,colName):
        columnas ={
            'numero': 0,
            'codigo': 1,
            'nombre': 2,
            'carne': 3,
            'correo': 4,
            'anio': 5,
            'telefono': 6,
            'fecha': 7,
            'hora' : 8 
        }
        values = []
        for i in self.matrix[1:len(self.matrix)]:
            if i[columnas[colName]] is None:
                values.append('')
            else:
                values.append(i[columnas[colName]])
        return values 
    def updateProfile(self):
        currentName = self.studentNames.get()
        #GetIndex
        names = self.getColumnValues('nombre')
        i = names.index(currentName)+1
        ID = self.matrix[i][0]
        codigo = self.matrix[i][1]
        carne = self.matrix[i][3]
        correo = self.matrix[i][4]
        carrera = self.matrix[i][5]
        telefono = self.matrix[i][6]
        self.ID.delete(0,END)
        self.ID.insert(0,ID)
        self.Codigo.delete(0,END)
        self.Codigo.insert(0,codigo)
        self.Carne.delete(0,END)
        self.Carne.insert(0,carne)
        self.Correo.delete(0,END)
        self.Correo.insert(0,correo)
        self.Carrera.delete(0,END)
        self.Carrera.insert(0,carrera)
        self.Telefono.delete(0,END)
        self.Telefono.insert(0,telefono)        
"""    def visualGUI(self):
        app = ImagePresentation()
    def auralGUI(self):
        app = AudioPresentation()"""

def main():
    app = AudioPresentation()

if __name__ == '__main__':
    main()