import csv
import numpy as np

class Reader (object):
    
    def __init__(self, file):
        self.fileName = file
        self.time = np.array([])
        
