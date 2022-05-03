#!/usr/bin/env python
# coding: utf-8

# In[26]:


## MAIN AIM OF THIS CODE
## input1 ==> fileIndex(str)


import pandas as pd
import numpy as np
import json
import sys


fileIndex=sys.argv[1]
dirName=sys.argv[2]
with open(dirName+'/data/modify_log/'+fileIndex+'.json', 'r') as f:
    file=f.read()

change_data = json.loads(file)

origin_data=pd.read_csv(dirName+'/data/umap/umap_combine_'+fileIndex+'.csv',header=None)
origin_data.columns=['x','y','label','dotindex']
origin_data.label = origin_data.label.astype('str')
change_dic = change_data['dataIndex']
for dic in change_dic:
    if len(dic['dataIndex'])>0:
        index = origin_data.loc[origin_data.label==dic['seriesName']].iloc[dic['dataIndex']].index
        origin_data.loc[index,'label']=change_data['givenLabel']
origin_data.to_csv(dirName+'/data/umap/umap_combine_%04d.csv'%(int(fileIndex)+1),header=None,index=False)

labels = np.unique(origin_data.loc[:,'label'].values)
dict0={}
series=[]
for label in labels:
    dic={'name':str(label),'data':origin_data.loc[origin_data.label==label].values.tolist(),'type':'scatter','colorBy':'series'}
    series.append(dic)
data={'series':series}
with open(dirName+"/data/umap/umap_combine_%04d.json"%(int(fileIndex)+1), "w") as outfile:
    json.dump(data, outfile)
print('%04d'%(int(fileIndex)+1))
