#!/usr/bin/env python
# coding: utf-8


import numpy as np
import pandas as pd
import json
import sys
import os

path=sys.argv[3]

df=pd.read_csv(sys.argv[1],header=None)
df.columns=['x','y','label','dotindex']
df.label = df.label.astype('str')
labels = np.unique(df.loc[:,'label'].values)
dict0={}
series=[]
for label in labels:
    dic={'name':str(label),'data':df.loc[df.label==label].values.tolist(),'type':'scatter','colorBy':'series'}
    series.append(dic)
data={'series':series}
    
print('mkdir -p '+os.path.join(path,'data/umap/'))

os.system('mkdir -p '+os.path.join(path,'data/umap/'))
os.system('mkdir -p '+os.path.join(path,'data/syllabus/'))
os.system('mkdir -p '+os.path.join(path,'data/modify_log/'))

df.to_csv(os.path.join(path,'data/umap','umap_combine_0000.csv',header=None,index=False)

with open(os.path.join(path,'data/umap','umap_combine_0000.json'), "w") as outfile:
    json.dump(data, outfile)

    
df=pd.read_csv(sys.argv[2],header=None)
dic={}
for col in df.columns:
    data = df.loc[:,col].values.reshape((10,121))
    
    dic={'data':data.tolist()}
    with open("syllabus/syllabus_%05d.json"%(col), "w") as outfile:
        json.dump(dic, outfile)

