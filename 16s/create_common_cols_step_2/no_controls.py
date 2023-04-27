#!/usr/bin/env python
# coding: utf-8

# In[14]:


import pandas as pd
import os 


######## 
source_name = "Nasopharyngeal"



# In[15]:
path ="/Users/davide/Desktop/tirocinio/dati/PRJNA751478/output_finale/"

file = path+"metadata.tsv"

# In[16]:

df = pd.read_csv(file,sep = "\t")

# In[18]:


print(df)


# In[25]:


inp_col = []
source_col = []


# In[28]:


for num in range(len(list(df["Run"]))):
    inp_col.append("Covid-19")
    source_col.append(source_name)


# In[29]:


df.insert(len(df.columns),"variable.phenotype",inp_col)


# In[30]:


df.insert(len(df.columns),"source",source_col)


# In[ ]:

os.remove(file)

df.to_csv(path+"metadata.tsv",sep = "\t",index = False)



# In[ ]:





# In[ ]:





# In[ ]:





# In[ ]:




