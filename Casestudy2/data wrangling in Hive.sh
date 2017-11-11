################# data wrangling in Hive ###################
###########################################################

### start hadoop, mysql, hive service 

service mysql start 
cd /usr/local/hadoop
./sbin/start-dfs.sh
jps
cd /usr/local/hive
./bin/hive

use dbtaobao; -- got to dbtaobao database
show tables; -- show all tables
show create table user_log; -- check the attributes of user_log

hive> show create table user_log;
OK
CREATE EXTERNAL TABLE `user_log`(
  `user_id` int, 
  `item_id` int, 
  `cat_id` int, 
  `merchant_id` int, 
  `brand_id` int, 
  `month` string, 
  `day` string, 
  `action` int, 
  `age_range` int, 
  `gender` int, 
  `province` string)
COMMENT 'Welcome to xmu dblab,Now create dbtaobao.user_log!'
ROW FORMAT SERDE 
  'org.apache.hadoop.hive.serde2.lazy.LazySimpleSerDe' 
WITH SERDEPROPERTIES ( 
  'field.delim'=',', 
  'serialization.format'=',') 
STORED AS INPUTFORMAT 
  'org.apache.hadoop.mapred.TextInputFormat' 
OUTPUTFORMAT 
  'org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat'
LOCATION
  'hdfs://localhost:9000/dbtaobao/dataset/user_log'
TBLPROPERTIES (
  'numFiles'='1', 
  'totalSize'='473395', 
  'transient_lastDdlTime'='1510358679')
Time taken: 0.137 seconds, Fetched: 28 row(s)
hive> 

hive> desc user_log;
OK
user_id                 int                                         
item_id                 int                                         
cat_id                  int                                         
merchant_id             int                                         
brand_id                int                                         
month                   string                                      
day                     string                                      
action                  int                                         
age_range               int                                         
gender                  int                                         
province                string                                      
Time taken: 0.06 seconds, Fetched: 11 row(s)
hive> 

#### do some queries 
hive> select brand_id from user_log limit 10;
OK
5476
5476
6109
5476
5476
5476
5476
5476
5476
6300
Time taken: 0.104 seconds, Fetched: 10 row(s)
hive> 


hive>  select month,day,cat_id from user_log limit 20;
OK
11      11      1280
11      11      1280
11      11      1181
11      11      1280
11      11      1280
11      11      1280
11      11      1280
11      11      1280
11      11      1280
11      11      962
11      11      81
11      11      1432
11      11      389
11      11      1208
11      11      1611
11      11      420
11      11      1611
11      11      1432
11      11      389
11      11      1432
Time taken: 0.11 seconds, Fetched: 20 row(s)
hive> 

hive> select ul.at, ul.ci  from (select action as at, cat_id as ci from user_log) as ul limit 20;
OK
0       1280
0       1280
0       1181
2       1280
0       1280
0       1280
0       1280
0       1280
0       1280
0       962
2       81
2       1432
0       389
2       1208
0       1611
0       420
0       1611
0       1432
0       389
0       1432
Time taken: 0.144 seconds, Fetched: 20 row(s)
hive> 

#### aggregation
hive> select count(*) from user_log; 
WARNING: Hive-on-MR is deprecated in Hive 2 and may not be available in the future versions. Consider using a different execution engine (i.e. spark, tez) or using Hive 1.X releases.
Query ID = hadoop_20171110191739_33dbeac1-5f4a-406b-9101-17fd1809439e
Total jobs = 1
Launching Job 1 out of 1
Number of reduce tasks determined at compile time: 1
In order to change the average load for a reducer (in bytes):
  set hive.exec.reducers.bytes.per.reducer=<number>
In order to limit the maximum number of reducers:
  set hive.exec.reducers.max=<number>
In order to set a constant number of reducers:
  set mapreduce.job.reduces=<number>
Job running in-process (local Hadoop)
2017-11-10 19:17:41,295 Stage-1 map = 100%,  reduce = 100%
Ended Job = job_local2129047019_0001
MapReduce Jobs Launched: 
Stage-Stage-1:  HDFS Read: 979558 HDFS Write: 0 SUCCESS
Total MapReduce CPU Time Spent: 0 msec
OK
10000
Time taken: 2.053 seconds, Fetched: 1 row(s)
hive> 

###### distinct and unique id query and count

hive> select count(distinct user_id) from user_log;
WARNING: Hive-on-MR is deprecated in Hive 2 and may not be available in the future versions. Consider using a different execution engine (i.e. spark, tez) or using Hive 1.X releases.
Query ID = hadoop_20171110191917_9d4a8672-af7c-4204-9bb4-6f3ed9ad3862
Total jobs = 1
Launching Job 1 out of 1
Number of reduce tasks determined at compile time: 1
In order to change the average load for a reducer (in bytes):
  set hive.exec.reducers.bytes.per.reducer=<number>
In order to limit the maximum number of reducers:
  set hive.exec.reducers.max=<number>
In order to set a constant number of reducers:
  set mapreduce.job.reduces=<number>
Job running in-process (local Hadoop)
2017-11-10 19:19:19,117 Stage-1 map = 100%,  reduce = 100%
Ended Job = job_local546122004_0002
MapReduce Jobs Launched: 
Stage-Stage-1:  HDFS Read: 1926348 HDFS Write: 0 SUCCESS
Total MapReduce CPU Time Spent: 0 msec
OK
358
Time taken: 1.459 seconds, Fetched: 1 row(s)
hive> 

###### get the unique order

hive> select count(*) from (select user_id,item_id,cat_id,merchant_id,brand_id,month,day,action from user_log group by user_id,item_id,cat_id,merchant_id,brand_id,month,day,action having count(*)=1)a;
WARNING: Hive-on-MR is deprecated in Hive 2 and may not be available in the future versions. Consider using a different execution engine (i.e. spark, tez) or using Hive 1.X releases.
Query ID = hadoop_20171110192320_188ff481-8279-4eae-a0a9-a45d900ebcc0
Total jobs = 2
Launching Job 1 out of 2
Number of reduce tasks not specified. Estimated from input data size: 1
In order to change the average load for a reducer (in bytes):
  set hive.exec.reducers.bytes.per.reducer=<number>
In order to limit the maximum number of reducers:
  set hive.exec.reducers.max=<number>
In order to set a constant number of reducers:
  set mapreduce.job.reduces=<number>
Job running in-process (local Hadoop)
2017-11-10 19:23:22,125 Stage-1 map = 100%,  reduce = 100%
Ended Job = job_local1552554706_0003
Launching Job 2 out of 2
Number of reduce tasks determined at compile time: 1
In order to change the average load for a reducer (in bytes):
  set hive.exec.reducers.bytes.per.reducer=<number>
In order to limit the maximum number of reducers:
  set hive.exec.reducers.max=<number>
In order to set a constant number of reducers:
  set mapreduce.job.reduces=<number>
Job running in-process (local Hadoop)
2017-11-10 19:23:23,399 Stage-2 map = 100%,  reduce = 100%
Ended Job = job_local1017693094_0004
MapReduce Jobs Launched: 
Stage-Stage-1:  HDFS Read: 2873138 HDFS Write: 0 SUCCESS
Stage-Stage-2:  HDFS Read: 2873138 HDFS Write: 0 SUCCESS
Total MapReduce CPU Time Spent: 0 msec
OK
4754
Time taken: 2.724 seconds, Fetched: 1 row(s)
hive> 

#### key words query 

hive> select count(distinct user_id) from user_log where action='2';
WARNING: Hive-on-MR is deprecated in Hive 2 and may not be available in the future versions. Consider using a different execution engine (i.e. spark, tez) or using Hive 1.X releases.
Query ID = hadoop_20171110192455_5cd89e94-e5d9-4585-bcd3-bea3aa40df12
Total jobs = 1
Launching Job 1 out of 1
Number of reduce tasks determined at compile time: 1
In order to change the average load for a reducer (in bytes):
  set hive.exec.reducers.bytes.per.reducer=<number>
In order to limit the maximum number of reducers:
  set hive.exec.reducers.max=<number>
In order to set a constant number of reducers:
  set mapreduce.job.reduces=<number>
Job running in-process (local Hadoop)
2017-11-10 19:24:57,193 Stage-1 map = 100%,  reduce = 100%
Ended Job = job_local553164350_0005
MapReduce Jobs Launched: 
Stage-Stage-1:  HDFS Read: 3819928 HDFS Write: 0 SUCCESS
Total MapReduce CPU Time Spent: 0 msec
OK
358
Time taken: 1.408 seconds, Fetched: 1 row(s)
hive> 

hive> select count(*) from user_log where action='2' and brand_id=2661;
WARNING: Hive-on-MR is deprecated in Hive 2 and may not be available in the future versions. Consider using a different execution engine (i.e. spark, tez) or using Hive 1.X releases.
Query ID = hadoop_20171110192640_559f5551-4e9b-4cfd-86e4-cef190a01823
Total jobs = 1
Launching Job 1 out of 1
Number of reduce tasks determined at compile time: 1
In order to change the average load for a reducer (in bytes):
  set hive.exec.reducers.bytes.per.reducer=<number>
In order to limit the maximum number of reducers:
  set hive.exec.reducers.max=<number>
In order to set a constant number of reducers:
  set mapreduce.job.reduces=<number>
Job running in-process (local Hadoop)
2017-11-10 19:26:42,080 Stage-1 map = 100%,  reduce = 100%
Ended Job = job_local1025461947_0006
MapReduce Jobs Launched: 
Stage-Stage-1:  HDFS Read: 4766718 HDFS Write: 0 SUCCESS
Total MapReduce CPU Time Spent: 0 msec
OK
3
Time taken: 1.427 seconds, Fetched: 1 row(s)
hive> 

####### customer behavior analysis
select count(distinct user_id) from user_log where action='2';
select count(distinct user_id) from user_log;
select user_id from user_log where action='2' group by user_id having count(action='2')>5;

create table scan(brand_id INT,scan INT) COMMENT 'This is the search of bigdatataobao' ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t' STORED AS TEXTFILE;
