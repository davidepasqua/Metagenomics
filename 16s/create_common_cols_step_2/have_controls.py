import pandas as pd 
import os


# In[2]:

source_name = "Nasopharyngeal" ##### mettere maiuscola 

print(source_name)

# name of the column in the file with the phenotype 
inp_col = "diagnosis"

path = "/Users/davide/Desktop/tirocinio/dati/PRJNA751478/output_finale/"

file = path+ "metadata.tsv"


print(file)
# In[16]:

df = pd.read_csv(file,sep = "\t")


# In[5]:


df



variable.phenotype = list(df[inp_col])


# In[8]:


print(variable.phenotype)


# In[9]:


for i,elem in enumerate(variable.phenotype):
	elem = str(elem)
	if elem.startswith("Reco") or elem.startswith("C") or elem.startswith("SARS") or elem.startswith("pos") or elem.startswith("severe") or elem.startswith("mild") or elem.startswith("fatal") or elem.startswith("Homo sapiens_COVI") or elem.startswith("POS") or elem.startswith("Pos"):
		variable.phenotype[i] = "Covid-19"
	elif elem.startswith("Healt") or elem.startswith("HC") or elem.startswith("healthy") or elem.startswith("control") or elem.startswith("neg") or elem.startswith("Homo sapiens_healt") or elem.startswith("NEGA") or elem.startswith("Neg"): 
		variable.phenotype[i] = "HC"
	else:
		variable.phenotype[i] ="other"
	







# In[11]:


df.insert(len(df.columns),"variable.phenotype",variable.phenotype)


# In[ ]:


df.drop([inp_col],axis=1)


# In[ ]:


source_col = []


# In[ ]:


for num in range(len(variable.phenotype)):
	source_col.append(source_name)


# In[ ]:


df.insert(len(df.columns),"source",source_col)


# In[ ]:


df


# In[ ]:


os.remove(path+"metadata.tsv")


# In[ ]:


df.to_csv(path+"metadata.tsv",sep = "\t",index = False)
