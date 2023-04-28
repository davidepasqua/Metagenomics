#!/usr/bin/env python
# coding: utf-8

# In[1]:


import re
import pandas as pd
import os

#############  set paths ###################

dir_name = "PRJNA818796"

path = "/Users/davide/Desktop/metagenomics/16s/" + dir_name

files_dir = path +"/files/"

with open(files_dir+'biosample_result.txt') as f:
    file = f.read()
    print(file)

# extract features from the biosample file and put them into a dictionary

dic = {}
features = list(set([match.group().strip('/=') for match in re.finditer(r'/.*=', file)]))
for feature in features:
    dic[feature] = [re.search('".*"', match.group()).group().strip('"') for match in re.finditer(f'/{feature}.*', file)]

print(dic)

# In[3]: create a dataframe with the features

df = pd.DataFrame.from_dict(dic)


# In[4]:


runinfo = pd.read_csv(files_dir + "SraRunInfo.csv")


# In[5]:


run = runinfo["Run"]

bioproject = []

for num in range(len(run)):
	bioproject.append(dir_name)



# In[7]: insert if the "Run" column and Bioproject, important for downstream analysis 


df.insert(0, "Run", run)

df.insert(0, "Bioproject", bioproject)

# In[8]:


df.to_csv(files_dir + "metadata.tsv", sep ="\t", index = False)


# In[9]:


############################### create manifest ###############################


# In[10]:

# forward files path 
forward_file_list = [os.path.join(path, f) for f in os.listdir(path) if f.endswith("1.fastq")]


# In[19]:


forward_file_list.sort()


# In[ ]:


forward_file_list


# In[21]:


# reverse files path 
reverse_file_list = [os.path.join(path, f) for f in os.listdir(path) if f.endswith("2.fastq")]


# In[22]:


reverse_file_list.sort()


# In[23]:


reverse_file_list


# In[24]:


data = {'sample-id': run,
        'forward-absolute-filepath': forward_file_list,
        'reverse-absolute-filepath': reverse_file_list}

df = pd.DataFrame(data)


# In[25]:


df


# In[27]:


df.to_csv(files_dir+"manifest.tsv", sep="\t", index = False)


# In[ ]:




