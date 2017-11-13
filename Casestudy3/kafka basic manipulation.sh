### clean data 
user_log.csv data format:
1. user_id 
2. item_id 
3. cat_id 
4. merchant_id 
5. brand_id 
6. month 
7. day | 
8. action | {0,1,2,3}, 0: click ，1: add to cargo，2 purchase ，3: waiting list
9. age_range | 1: age <18, 2 age in [18,24]，3: age in [25,29]，4 age in [30,34]，5 age in [35,39]，6 age in [40,49]，7 and 8 age >=50, 0 and NULL unknow data
11. province | state 

train.csv and test.csv data format:

user_id 
age_range 
gender | gender :0: female，1: male，2 and NULL unknow 
merchant_id 
label | 0: left customer，1: stay with customer，-1 outlier, NULL need to predict

The top 5 records for the data sets:

user_id,item_id,cat_id,merchant_id,brand_id,month,day,action,age_range,gender,province
328862,323294,833,2882,2661,08,29,0,0,1,内蒙古
328862,844400,1271,2882,2661,08,29,0,1,1,山西
328862,575153,1271,2882,2661,08,29,0,2,1,山西
328862,996875,1271,2882,2661,08,29,0,1,1,内蒙古

##### data preprocessing
### before doing this, make sure you have already install the kafka-python library
pip3 install kafka-python

And then, make the producer.py file

# coding: utf-8
import csv
import time
from kafka import KafkaProducer
 
# initiation a KafkaProducer instance to send message to Kafka 
producer = KafkaProducer(bootstrap_servers='localhost:9092')
# open the user_log.csv file 
csvfile = open("../data/user_log.csv","r")
# create a csv.reader 
reader = csv.reader(csvfile)
 
for line in reader:
    gender = line[9] # get the gender infor
    if gender == 'gender':
        continue # remove the header
    time.sleep(0.1) # very 0.1 second to send a message 
    # sending the message with topic as "sex"
    producer.send('sex',line[9].encode('utf8'))

### make consumer.py file

from kafka import KafkaConsumer
 
consumer = KafkaConsumer('sex')
for msg in consumer:
    print((msg.value).decode('utf8'))

#### put these files in /home/hadoop/mydir/labproject/scripts folder 

mkdir -p /home/hadoop/mydir/labproject/scripts

#### start kafka sevice 

cd /usr/local/kafka
bin/zookeeper-server-start.sh config/zookeeper.properties 
#### please note: in a new console to run the following code
bin/kafka-server-start.sh config/server.properties

### kafka installation 
cd ~/download
sudo tar -zxf kafka_2.11-0.10.1.0.tgz -C /usr/local
cd /usr/local
sudo mv kafka_2.11-0.10.1.0/ ./kafka
sudo chown -R hadoop ./kafka

### some concepts for kafka

1. Broker
Kafka cluster contains one or more servers which call broker
2. Topic
Bascially, message sending to kafka will be classified as Topic 
3. Partition
each topic will have one or more partition
4. Producer
Producedcer which is a Kafka broker will send message to kafka
5. Consumer
Consumer which is a Kafka broker will read the costumer message 
6. Consumer Group
each Consumer will belong to one specific Consumer Group（ we can specifiy Consumer's group name or will be default group）

cd /usr/local/kafka
bin/zookeeper-server-start.sh config/zookeeper.properties
### please note: do it in new console 
cd /usr/local/kafka
bin/kafka-server-start.sh config/server.properties
### please note: do it in new console 
cd /usr/local/kafka
bin/kafka-topics.sh --create --zookeeper localhost:2181 --replication-factor 1 --partitions 1 --topic dblab
### please note: do it in new console 
bin/kafka-topics.sh --list --zookeeper localhost:2181  
### please note: do it in new console 
bin/kafka-console-producer.sh --broker-list localhost:9092 --topic dblab
### please note: do it in new console 
hello hadoop
hello xmu
hadoop world
### please note: do it in new console 
cd /usr/local/kafka
bin/kafka-console-consumer.sh --zookeeper localhost:2181 --topic dblab --from-beginning
