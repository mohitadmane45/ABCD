#!/usr/bin/env python
# coding: utf-8

# ### Import libraris

# In[5]:


import numpy as np
import pandas as pd 
import matplotlib.pyplot as plt
import seaborn as sns 
import warnings 
warnings.filterwarnings('ignore')


# ### Reading the data 

# In[6]:


pd.set_option('display.max_columns',None)


# In[8]:


data= pd.read_excel(r"C:\Users\dell\Downloads\Restaurant.xlsx")
data


# In[9]:


data


# In[10]:


data.shape


# ### The shape of the data shows me that there are 8652 rows and 21 columns

# In[11]:


data.info()


# In[12]:


data.describe()


# In[13]:


data.describe().T


# ### Data cleaning 

# In[14]:


get_ipython().system('pip install missingno')


# In[15]:


import missingno as msno

missing = msno.matrix(data)


missing.set_title('Missing Data for restaurent dataset',fontsize=20)


# ### From the above observations no data seems to be missing

# In[16]:


for i in data.columns:
    print({i:data[i].unique()})


# ### As we can observe the data is not missing in any columns but there are few columns where the data value is zero('0') which is irrelavant with respect to that columns. So we will conside the zero ("0") values of those columns as null/missing.  
# ### The columns which are having irrelevant zer("0") values are 
# ### 1.Longitude  
# ### 2.Latitude
# ### 3.Average cost for two 

# In[17]:


data.columns 


# In[18]:


data[['Longitude', 'Latitude','Average Cost for two']] = data[['Longitude', 'Latitude','Average Cost for two']].replace (0,np.NaN)
data


# In[19]:


data.isna().sum()


# In[21]:


data.dropna(how="any",subset=['Longitude','Latitude'],inplace=True)


# In[22]:


data.isnull().sum()


# In[23]:


data.dropna(inplace=True)


# In[138]:


data.isnull().sum()


# In[24]:


data.shape


# ### Check the duplicate data in data set

# In[25]:


print(f'Duplicates in restaurant dataset: {data.iloc[:,1:].duplicated().sum()},({np.round(100*data.iloc[:,1:].duplicated().sum()/len(data),1)}%')


# ### When we tried to check for the duplicated values in the dataset, no duplicacy was observed. So we can conclude that there are no duplicate values in the dataset.

# In[26]:


# Drop duplicates
data=data.drop_duplicates(subset=data.columns[1:], keep='first')


# ### Feature engineering 

# In[27]:


unique_counts = pd.DataFrame.from_records([(col, data[col].nunique()) for col in data.columns],columns=['Column_Name', 'Num_Unique']).sort_values(by=['Num_Unique'])


# In[28]:


unique_counts


# In[29]:


data.drop(["Country Code"],inplace=True,axis=1)


# In[30]:


data.drop(columns=['Currency','Address','Locality Verbose','Switch to order menu','Restaurant ID'], inplace=True,axis=1)


# In[31]:


data.columns 


# In[32]:


data.shape


# In[33]:


for i in data.columns[(data.dtypes =='object').values].tolist():
    print(i,'\n')
    print(data[i].value_counts())
    print('---------------------------------')


# In[37]:


get_ipython().system('pip install folium')


# In[39]:


data


# In[48]:


import folium

#select the latitude and longitude columns 
latitude = data['Latitude'].tolist()
longitude =data['Longitude'].tolist()


#creating a map centered on the mean latitude and longitude 
map_center = [sum(latitude)/len(latitude),sum(longitude)/len(longitude)]
mymap = folium.Map(location=map_center,zoom_start=4)

#adding markers to map
for lat,lon in zip(latitude,longitude):
    folium.Marker(location=[lat,lon]).add_to(mymap)

#display map 
mymap


# In[50]:


#select the latitude and longitude columns 
latitude = data['Latitude'].tolist()        #sample latitude data for india 
longitude =data['Longitude'].tolist()          #sample longitude data for india 


#creating a map centered on the mean latitude and longitude omn india 
mymap = folium.Map(location=[20.5937,78.9629],zoom_start=5)
#adding markers to map
for lat,lon in zip(latitude,longitude):
    folium.Marker(location=[lat,lon]).add_to(mymap)

#display map 
mymap


# ### Enlisting top 5 & 10 cities in the data 

# In[60]:


city_names=data.City.value_counts().index


# In[61]:


city_values=data.City.value_counts().values


# In[64]:


plt.pie(city_values[:5], labels=city_names[:5],autopct = '%1.2f%%');


# In[65]:


plt.pie(city_values[:10], labels=city_names[:10],autopct = '%1.2f%%');


# In[67]:


data.groupby(['Aggregate rating','Rating color','Rating text']).size()


# In[68]:


data.groupby(['Aggregate rating','Rating color','Rating text']).size().reset_index()


# In[77]:


rating = data.groupby(['Aggregate rating','Rating color','Rating text']).size().reset_index().rename(columns={0:'Rating count'})


# In[78]:


rating


# ### From the observation 
# ### When rating is between 4.5 to 4.9 it means excellent
# ### When rating is between 4.0 to 4.4 it means very good
# ### When rating is between 3.5 to 3.9 it means good 
# ### When rating is between 2.5 to 3.4 it means Average 
# ### When rating is between 1.8 to 2.4 it means poor

# In[74]:


plt.figure(figsize=(20,10))
sns.barplot(x= 'Aggregate rating',y='Rating count',data=rating);


# In[81]:


plt.figure(figsize=(20,10))
sns.barplot(x= 'Aggregate rating',y='Rating count',data=rating,
            hue='Rating color');


# In[83]:


no_ratings = data[data['Rating color']=='White']


# In[85]:


no_ratings


# In[91]:


(no_ratings.groupby(['Aggregate rating','City']).size().reset_index().rename(columns={0:'Rating count'}))


# In[101]:


city = no_ratings.City.value_counts().index


# In[102]:


city


# In[103]:


value = no_ratings.City.value_counts().values


# In[104]:


value


# In[105]:


plt.pie(value,labels=city,autopct = '%1.2f%%');

