# -*- coding: utf-8 -*-
"""
Created on Tue Sep 26 01:18:38 2017

@author: ANGELFRANCISCOMORALE
"""

#import Tkinter as tk
import csv, thread, time, sys, gevent
import os
import pyglet
pyglet.lib.load_library('avbin')
pyglet.have_avbin=True
sys.path.insert(0, '../../../emokit')

#from emotiv import Emotiv

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
        #self.root = tk.Tk()
        #self.root.title('Emotrix 2017 Estimulación Auditiva')
        cwd = os.getcwd()
        print cwd
        with open('auditivos/order_first_run.txt') as f:
            self.content = f.readlines()
            self.content = [x.strip() for x in self.content]
            content2 = []
            for line in self.content:
                line = line.split(',', 1)
                content2.append(line)
            self.content = content2
            player = pyglet.media.Player()
            for name in self.content:
                soundFile = name[0]
                #f = open(soundFile)
                print soundFile
                song = pyglet.media.StaticSource(pyglet.media.load('auditivos/'+soundFile))
                player.queue(song)
                #self.sounds.append(soundFile) 
                emotion = name[1]
                extension = self.getAudioExtension(soundFile)
               # print str(soundFile)
            player.play()
            player.seek(62)
        thread.start_new_thread(self.emotiv, ())
        thread.start_new_thread(self.selectEmotion, ())

        ########EMOTIV###########
    def getAudioExtension(self,audioName):
        extension = audioName.split('.')[1]
        return extension
    def selectEmotion(self):
        while True:
            self.selectedEmotion = raw_input('Enter your input:')
            if(self.selectedEmotion == 'a'):
                self.selectedEmotion = "happy"
            if(self.selectedEmotion == 's'):
                self.selectedEmotion = "sad"
            if(self.selectedEmotion == 'd'):
                self.selectedEmotion = "other"
            print self.selectedEmotion        
    def emotiv(self):
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
        row = ["Image/Color"]
        row.append("Time")
        row.append("Exact Time")
        for sensor in self.sensors:
            row.append(sensor)
            row.append(sensor + "_Quality")
        row.append("Emotion")
        row.append("Selected Emotion")
        writer.writerow(row)
        try:
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

def main():
    app = AudioPresentation()

if __name__ == '__main__':
    main()