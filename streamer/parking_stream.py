#! /usr/bin/python3                                                                                                      

from kafka import KafkaProducer                                                                                         
from random import randint                                                                                              
from time import sleep                                                                                                  
import sys
import pandas as pd
import pickle
                                                                                                                        
BROKER = "broker:9092"                                                                                    
TOPIC = 'nycparkingtickets'                                                                                                                                                                                 
                                                                                                                        
try:                                                                                                                    
    p = KafkaProducer(bootstrap_servers=BROKER)                                                                         
except Exception as e:                                                                                                  
    print(f"ERROR --> {e}")                                                                                             
    sys.exit(1)

#Loading the model and the labelencoders from saved pickle file
model = pickle.load(open("XGBoost_model.pkl", "rb"))[0]
le1 = pickle.load(open("XGBoost_model.pkl", "rb"))[1]
le2 = pickle.load(open("XGBoost_model.pkl", "rb"))[2]
le3 = pickle.load(open("XGBoost_model.pkl", "rb"))[3]

#Loading the data and pre-processing(feature engineering)
df = pd.read_csv('Parking_Violations_Issued_-_Fiscal_Year_2017.csv', nrows=10000)

df = df.drop(['Summons Number', 'Plate Type', 'Vehicle Body Type', 'Vehicle Make', 'Issuing Agency',
              'Street Code1', 'Street Code2', 'Street Code3', 'Vehicle Expiration Date', 'Issuer Squad',
              'Violation Time', 'Time First Observed', 'Intersecting Street', 'Date First Observed',
              'Violation Legal Code', 'Days Parking In Effect    ', 'From Hours In Effect', 'To Hours In Effect',
              'Vehicle Color', 'Unregistered Vehicle?', 'Meter Number', 'Violation Post Code',
              'No Standing or Stopping Violation', 'Hydrant Violation', 'Double Parking Violation',
              'Violation Description', 'House Number', 'Street Name', 'Violation County', 'Issue Date',
              'Issuer Command', 'Violation In Front Of Or Opposite'
              ], axis = 1)

cols = df.columns.values.tolist()

for col in cols:
  df = df[(df[col].notnull())]

df = df[(df['Vehicle Year']!= 0)]
df['Plate ID'] = df['Plate ID'].map(str)
df['Registration State'] = df['Registration State'].map(str)
df['Sub Division'] = df['Sub Division'].map(str)

X,y = df.drop('Violation Location',axis=1), df['Violation Location']


X['Plate ID'] = le1.transform(X['Plate ID'])
X['Registration State'] = le2.transform(X['Registration State'])
X['Sub Division'] = le3.transform(X['Sub Division'])



data = X.values.tolist()


while True:                                                                                                             
    for row in data:
        message = ''
        for val in row:
            message += str(val) + ' '                                                                                        
        print(f">>> '{message.split()}'")                                                                                           
        p.send(TOPIC, bytes(message, encoding="utf8"))                                                                      
        sleep(randint(1,4))