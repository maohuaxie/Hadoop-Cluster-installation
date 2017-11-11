#### case study 2 11/11 web sales data analysis ####

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

### 

cd /usr/local
ls
sudo mkdir dbtaobao
sudo chown -R hadoop:hadoop ./dbtaobao
cd dbtaobao
mkdir dataset

hadoop@dblab-VirtualBox:/usr/local$ ls -al
drwxr-xr-x 23 root   root   4096 11月 10 16:43 .
drwxr-xr-x 11 root   root   4096 4月  20  2016 ..
drwxr-xr-x  4 hadoop hadoop 4096 11月 10 12:04 bigdatacase
drwxr-xr-x  2 root   root   4096 4月  20  2016 bin
drwxr-xr-x  2 hadoop hadoop 4096 11月 10 16:43 dbtaobao
drwxrwxr-x  8 root   root   4096 9月  29 10:44 eclipse
drwxr-xr-x  2 root   root   4096 4月  20  2016 etc
drwxr-xr-x  7 hadoop hadoop 4096 11月  5 09:22 flume
drwxr-xr-x  2 root   root   4096 4月  20  2016 games
drwxr-xr-x 13 hadoop  10021 4096 10月 18 23:18 hadoop
drwxr-xr-x  8 hadoop root   4096 10月 23 22:36 hbase
drwxr-xr-x  9 hadoop hadoop 4096 11月  5 08:29 hive
drwxr-xr-x  2 root   root   4096 4月  20  2016 include
drwxr-xr-x  7 hadoop root   4096 10月 31 05:47 kafka
drwxr-xr-x  5 root   root   4096 11月 10 13:42 lib
lrwxrwxrwx  1 root   root      9 10月 18 07:37 man -> share/man
drwxr-xr-x  6 hadoop root   4096 11月  9  2015 maven
drwxr-xr-x  2 root   root   4096 4月  20  2016 sbin
drwxr-xr-x  2 hadoop root   4096 10月 23 09:25 sbt
drwxrwxr-x  7 hadoop hadoop 4096 10月 19 03:05 scala
drwxr-xr-x  8 root   root   4096 4月  20  2016 share
drwxr-xr-x 14 hadoop    500 4096 10月 24 02:41 spark
drwxr-xr-x  9 hadoop hadoop 4096 11月  9 21:13 sqoop
drwxr-xr-x  2 root   root   4096 4月  20  2016 src
hadoop@dblab-VirtualBox:/usr/local$ 

# check the data sets

hadoop@dblab-VirtualBox:~/download/$ unzip data_format.zip -d /usr/local/dbtaobao/dataset
Archive:  data_format.zip
  inflating: /usr/local/dbtaobao/dataset/test.csv  
  inflating: /usr/local/dbtaobao/dataset/train.csv  
  inflating: /usr/local/dbtaobao/dataset/user_log.csv  
hadoop@dblab-VirtualBox:~/download/$ cd /usr/local/dbtaobao/dataset
hadoop@dblab-VirtualBox:/usr/local/dbtaobao/dataset$ head -5 user_log.csv
user_id,item_id,cat_id,merchant_id,brand_id,month,day,action,age_range,gender,province
328862,323294,833,2882,2661,08,29,0,0,1,内蒙古
328862,844400,1271,2882,2661,08,29,0,1,1,山西
328862,575153,1271,2882,2661,08,29,0,2,1,山西
328862,996875,1271,2882,2661,08,29,0,1,1,内蒙古
hadoop@dblab-VirtualBox:/usr/local/dbtaobao/dataset$ 

# preprocessing the data

# delete the header of user_log.csv file

cd /usr/local/dbtaobao/dataset

sed -i '1d' user_log.csv //1d means delete first row ，3d means delete 3rd row and so forth

# let's look at the truncated data
head -5 user_log.csv

hadoop@dblab-VirtualBox:/usr/local/dbtaobao/dataset$ head -5 user_log.csv
328862,323294,833,2882,2661,08,29,0,0,1,内蒙古
328862,844400,1271,2882,2661,08,29,0,1,1,山西
328862,575153,1271,2882,2661,08,29,0,2,1,山西
328862,996875,1271,2882,2661,08,29,0,1,1,内蒙古
328862,1086186,1271,1253,1049,08,29,0,0,2,浙江

# create small data_sets for demo
cd /usr/local/dbtaobao/dataset

#!/bin/bash
# input file
infile=$1
# output file
outfile=$2
# please note: $infile > $outfile must follow up }’
awk -F "," 'BEGIN{
      id=0;
    }
    {
        if($6==11 && $7==11){
            id=id+1;
            print $1","$2","$3","$4","$5","$6","$7","$8","$9","$10","$11
            if(id==10000){
                exit
            }
        }
    }' $infile > $outfile

sudo chmod +x ./predeal.sh
./predeal.sh ./user_log.csv ./small_user_log.csv

### import data to database

Loading small_user_log.csv file to Hive, To do this, we need upload one copy to HDFS
and then, create a external tabe in Hive.

# start HDFS
cd /usr/local/hadoop
./sbin/start-dfs.sh
jps # check the status

# upload user_log.csv file to HDFS
# before that, we have to create dbtaobao folder within HDFS
cd /usr/local/hadoop
./bin/hdfs dfs -mkdir -p /dbtaobao/dataset/user_log

cd /usr/local/hadoop
./bin/hdfs dfs -put /usr/local/dbtaobao/dataset/small_user_log.csv /dbtaobao/dataset/user_log

## check the first 10 records for user_log table in HDFS

hadoop@dblab-VirtualBox:/usr/local/hadoop$ ./bin/hdfs dfs -mkdir -p /dbtaobao/dataset/user_log
hadoop@dblab-VirtualBox:/usr/local/hadoop$ ./bin/hdfs dfs -put /usr/local/dbtaobao/dataset/small_user_log.csv /dbtaobao/dataset/user_log
hadoop@dblab-VirtualBox:/usr/local/hadoop$ ./bin/hdfs dfs -cat /dbtaobao/dataset/user_log/small_user_log.csv | head -10
328862,406349,1280,2700,5476,11,11,0,0,1,四川
328862,406349,1280,2700,5476,11,11,0,7,1,重庆市
328862,807126,1181,1963,6109,11,11,0,1,0,上海市
328862,406349,1280,2700,5476,11,11,2,6,0,台湾
328862,406349,1280,2700,5476,11,11,0,6,2,甘肃
328862,406349,1280,2700,5476,11,11,0,4,1,甘肃
328862,406349,1280,2700,5476,11,11,0,5,0,浙江
328862,406349,1280,2700,5476,11,11,0,3,2,澳门
328862,406349,1280,2700,5476,11,11,0,7,1,台湾
234512,399860,962,305,6300,11,11,0,4,1,安徽
cat: Unable to write to output stream.
hadoop@dblab-VirtualBox:/usr/local/hadoop$ 

############ create database in Hive

## stare mysql service
## start hadoop service
## start Hive service 

service mysql start
cd /usr/local/hive
./bin/hive 

### create dbtaobao databse with HiveQL

create database dbtaobao;

use dbtaobao;

#### create external table

CREATE EXTERNAL TABLE dbtaobao.user_log(user_id INT,item_id INT,cat_id INT,merchant_id INT,brand_id INT,month STRING,day STRING,action INT,age_range INT,gender INT,province STRING) COMMENT 'Welcome to xmu dblab,Now create dbtaobao.user_log!' ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' STORED AS TEXTFILE LOCATION '/dbtaobao/dataset/user_log';

##### query user_log table in Hive 

select * from user_log limit 10;

hive> create database dbtaobao;
OK
Time taken: 0.266 seconds
hive> use dbtaobao;
OK
Time taken: 0.037 seconds
hive> CREATE EXTERNAL TABLE dbtaobao.user_log(user_id INT,item_id INT,cat_id INT,merchant_id INT,brand_id INT,month STRING,day STRING,action INT,age_range INT,gender INT,province STRING) COMMENT 'Welcome to xmu dblab,Now create dbtaobao.user_log!' ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' STORED AS TEXTFILE LOCATION '/dbtaobao/dataset/user_log';
OK
Time taken: 0.332 seconds
hive> select * from user_log limit 10;
OK
328862  406349  1280    2700    5476    11      11      0       0       1       四川
328862  406349  1280    2700    5476    11      11      0       7       1       重庆市
328862  807126  1181    1963    6109    11      11      0       1       0       上海市
328862  406349  1280    2700    5476    11      11      2       6       0       台湾
328862  406349  1280    2700    5476    11      11      0       6       2       甘肃
328862  406349  1280    2700    5476    11      11      0       4       1       甘肃
328862  406349  1280    2700    5476    11      11      0       5       0       浙江
328862  406349  1280    2700    5476    11      11      0       3       2       澳门
328862  406349  1280    2700    5476    11      11      0       7       1       台湾
234512  399860  962     305     6300    11      11      0       4       1       安徽
Time taken: 0.955 seconds, Fetched: 10 row(s)
hive> 
