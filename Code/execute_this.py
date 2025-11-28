import os
import pandas as pd
from functions import augment_data,transform_data,bq1,bq2,bq3

os.chdir(r'.')
path=r'..\Data\dataset.csv'
pd.options.mode.chained_assignment = None  # default='warn'


df=pd.read_csv(path,header=0)
df_aug=augment_data(df)
df_trans=transform_data(df_aug)
line='gr-np-47'
results1=bq1(df_trans,line)
print('Results for Question 1:')
print(results1)
results2=bq2(df_trans)
print('Results for Question 2:')
print(results2)
results3=bq3(df_trans)
print('Results for Question 3:')
print(results3)

