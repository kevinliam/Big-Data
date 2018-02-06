#!/usr/bin/env python

import glob
import pandas
import re
import os

#create dictionary. We will use it to store new file names
KK_15={}
KK_15=pandas.read_csv('KK_15.txt', delimiter=',')
KK_15.set_index('well')

#print(KK_15)
#temp = KK_15.iloc[1:1,1:3]
#print(temp)
#glob is a simpler alternative to OS module to read the contents of a folder
raw_list=glob.glob('*.ab1')
#create dictionary. We will use it to store old file names
subset={}
temprow={}
temp_code={}
temp_locus={}
newname={}
#populate dictionary with values. This seems to translate to "run through 
#raw_list as many times are here are values in raw_list. Each time the row value
#becomes the value for "oldname".
for oldname in raw_list:
	well = re.search('[-]([A-Z][0-9]+)_',oldname).group(1)
	#This returns the entire row for which the well values equal each other
	temp_row = KK_15[KK_15.well == well]
	#Get the value for the code column of the matching row
	temp_code = temp_row['code']
	#Get the value for the locus column of the matching row
	#WARNING: Slashes and perhaps other characters in these columns
	#break the script
	temp_locus = temp_row['locus']
	#Build string with the code and locus values
	newname = temp_code + "_" + temp_locus + ".ab1"
	old_path = os.path.join("/home/kevin/Desktop/KK_15", oldname)
	new_path = os.path.join("/home/kevin/Desktop/KK_15", str(newname))
	#Rename file with new name
	os.rename(old_path, new_path)
	
print "Congratulations! You just saved yourself hours of time!"







