# -*- coding: utf-8 -*-
"""
Created on Tue Jul 27 10:23:44 2021

@author: Dell
"""
from PIL import Image

import glob
#print(glob.glob("*.png"))
# based on SO Answer: https://stackoverflow.com/a/43258974/5086335
# for file in glob.glob("*.png"):
file = 'C:/ashu-hp-backup/Ashu-hp-backup/desktop/Desktop/sohail/USV paper/figures_NPP/Revision 1/Theta-coherence.png'
im = Image.open(file)
rgb_im = im.convert('RGB')
rgb_im.save(file.replace("png", "jpg"), quality = 95)