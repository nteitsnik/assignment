import pandas as pd 

def augment_data(data):

    #Order by and reset index, setup for the next lines.
    
    data = data.sort_values(by=["production_line_id","timestamp"])
    data.reset_index(inplace=True,drop=True)
    #Assign status START in the First row of every production_line_id if it starts with ON
    #Assign status STOP in the Last row of every production_line_id if it finishes with ON

    for line_id, group in data.groupby('production_line_id'):
        

        # Assign START if missing
        if 'START' not in group['status'].values:
            min_index = group['timestamp'].idxmin()
            data.loc[min_index, 'status'] = 'START' 
            

        # Optionally: assign STOP if missing
        if 'STOP' not in group['status'].values:
            max_index = group['timestamp'].idxmax()
            data.loc[max_index, 'status'] = 'STOP'

    return data 

    
def transform_data(data):
    #Transform the dataset into a production_line_id - Start_Time - Stop_Time - Duration dataframe for insertion in the DWH.
    #To achieve this transform the timestamp to date format, create a column 'current_start' with the start time for the rows with START status
    #and forward fill.  
    data['timestamp']=pd.to_datetime(data['timestamp'], format='ISO8601')
    data['current_start'] = data['timestamp'].where(data['status'] == 'START')
    data['current_start'] = data['current_start'].ffill()
    #at last select only rows with STOP status. That way we get end times and corresponding start times in the same row. Calculate the duration.
    data=data[data['status']=='STOP']
    data.loc[:, 'duration']=data['timestamp']-data['current_start']
    df_final=pd.DataFrame(columns=['production_line_id','Start_Time','Stop_Time','Duration'])
    df_final[['production_line_id','Start_Time','Stop_Time','Duration']]=data[['production_line_id','current_start','timestamp','duration']]
    return df_final

def bq1(data,line):
    #Select the production_line_id of choice
    data_47=data[data['production_line_id']==line]
    return data_47


def bq2(data):
    #assign score +1 for every START, assign score -1 for every STOP, order STARTS and STOPS in chronological order.
    #the cumulative sum is the number of active production lines.
    #downtime is calculated as 5 hours minus uptime.
    starts=pd.DataFrame(data['Start_Time'])
    starts['ch']=1
    ends=pd.DataFrame(data['Stop_Time'])
    ends.rename(columns={'Stop_Time':'Start_Time'},inplace=True)
    ends['ch']=-1
    events = pd.concat([starts, ends]).sort_values('Start_Time').reset_index(drop=True)
    events['online'] = events['ch'].cumsum()
    events['next_time'] = events['Start_Time'].shift(-1)
    events['Duration']=events['next_time']-events['Start_Time']
    uptime_duration=events[events['online']==4]['Duration'].sum()
    downtime_duration=pd.Timedelta(hours=5)-uptime_duration
    results = pd.DataFrame({'Uptime_Duration': [uptime_duration],'Downtime_Duration': [downtime_duration]})
    return results

def bq3(data):
     #group by , select argmin. Convert it to downtime.
     grouped=data.groupby('production_line_id')['Duration'].sum()
     
     idx = grouped.idxmin()  
     result =  pd.DataFrame(pd.Timedelta(hours=5)-grouped.loc[[idx]]).reset_index()
     
     return result
        

    