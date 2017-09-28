# -*- coding: utf-8 -*-
"""
Created on Tue Sep 26 01:18:38 2017

@author: ANGELFRANCISCOMORALE
"""

import Tkinter as tk
import csv
import thread
import time
import sys
import os
#sys.path.insert(0, '/EMOTRIX/emokit')

#from emotiv import Emotiv
import gevent
from pydub import AudioSegment

class AudioPresentation():
    p = 0
    sounds = []
    time = 3000
    filename='data.csv'
    time_block = 5 #tiempo que dura cada estimulo (intervalos)
    sensors = ['F3','F4','AF3','AF4','O1','O2']
    content = []
    def __init__(self):
        self.root = tk.Tk()
        self.root.title('Emotrix 2017 Estimulación Auditiva')
        with open('order_first_run.txt') as f:
            self.content = f.readlines()
            self.content = [x.strip() for x in self.content]
            content2 = []
            for line in self.content:
                line = line.split(',', 1)
                content2.append(line)
            w = 500
            h = 500
            self.content = content2
            cwd = os.getcwd()
            print cwd
            for name in self.content:
                soundFile = name[0]
                emotion = name[1]
                extension = self.getAudioExtension(soundFile)
               # print str(soundFile)
                song = AudioSegment.from_mp3("/2017/auditivos/Papa_nana.mp3")
                #self.sounds.append(song)
            x = 0
            y = 0

        # make the root window the size of the image
        #self.root.geometry("%dx%d+%d+%d" % (w,h, x, y))
        #self.panel1 = tk.Label(self.root, image=self.images[0])
        #self.display = self.images[0]
        #self.panel1.pack(side=tk.TOP, fill=tk.BOTH, expand=tk.YES)
        #thread.start_new_thread(self.emotiv, ())
        #self.root.mainloop()
        #print "Display image1"
        ########EMOTIV###########
    def getAudioExtension(self,audioName):
        extension = audioName.split('.')[1]
        return extension
    def emotiv(self):
        headset = Emotiv()
        gevent.spawn(headset.setup)
        #gevent.sleep(0)
        print("Serial Number: %s" % headset.serial_number)

        self.num_blocks = len(self.images)
        cont_block = 0
        cont_seconds = 0
        temp_t = 0
        tag = self.content[0][1]
        #Se define el escritor de las lecturas en el archivo CSV
        writer = csv.writer(open(self.filename, 'w'), delimiter=',', quotechar='"', lineterminator='\n')
        row = ["Time"]
        for sensor in self.sensors:
            row.append(sensor)
            row.append(sensor + "_Quality")
        row.append(tag)
        writer.writerow(row)
        try:
            t0 = time.time()
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
                        #display images
                        self.panel1.configure(image=self.images[cont_block])
                        print "Display: "  + str(cont_block)
                        self.display = self.images[cont_block]
                row = [str(t)]
                try:
                    for sensor in self.sensors:
                        row.append(str(headset.sensors[sensor]['value']))
                        row.append(str(headset.sensors[sensor]['quality']))
                except:
                    print "Sensor incorrecto"
                    headset.close()
                row.append(tag)
                # Se exporta a csv
                writer.writerow(row)
                print row
                temp_t = t
                gevent.sleep(0)
        except KeyboardInterrupt:
            headset.close()
        finally:
            headset.close()
        ####################

def main():
    app = AudioPresentation()

if __name__ == '__main__':
    main()