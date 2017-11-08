######## Hive data analysis #######
please refer to http://dblab.xmu.edu.cn/blog/1005/
# start mysql service, start Hive sevice, start hadoop service 
service mysql start 
cd /usr/local/hadoop
./sbin/start-all.sh
jps
cd /usr/local/hive
./bin/hive   
use dblab;
show tables;
show create table bigdata_user;
hive> show tables;
OK
bigdata_user
Time taken: 2.015 seconds, Fetched: 1 row(s)
hive> show create table bigdata_user;
OK
CREATE EXTERNAL TABLE `bigdata_user`(
  `id` int, 
  `uid` string, 
  `item_id` string, 
  `behavior_type` int, 
  `item_category` string, 
  `visit_date` date, 
  `province` string)
COMMENT 'Welcome to xmu dblab!'
ROW FORMAT SERDE 
  'org.apache.hadoop.hive.serde2.lazy.LazySimpleSerDe' 
WITH SERDEPROPERTIES ( 
  'field.delim'='\t', 
  'serialization.format'='\t') 
STORED AS INPUTFORMAT 
  'org.apache.hadoop.mapred.TextInputFormat' 
OUTPUTFORMAT 
  'org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat'
LOCATION
  'hdfs://localhost:9000/bigdatacase/dataset'
TBLPROPERTIES (
  'numFiles'='1', 
  'totalSize'='15590180', 
  'transient_lastDdlTime'='1510156529')
Time taken: 0.105 seconds, Fetched: 24 row(s)
hive>

desc bigdata_user;

hive> desc bigdata_user;
OK
id                      int                                         
uid                     string                                      
item_id                 string                                      
behavior_type           int                                         
item_category           string                                      
visit_date              date                                        
province                string                                      
Time taken: 0.06 seconds, Fetched: 7 row(s)
hive> 

# do query the data

select behavior_type from bigdata_user limit 10;

hive> select behavior_type from bigdata_user limit 10;
OK
1
1
1
1
1
4
1
1
1
1
Time taken: 0.102 seconds, Fetched: 10 row(s)
hive> 

select visit_date,item_category from bigdata_user limit 20;

hive> select visit_date,item_category from bigdata_user limit 20;
OK
2014-12-08      4076
2014-12-12      5503
2014-12-12      5503
2014-12-02      9762
2014-12-12      5232
2014-12-02      9762
2014-12-12      5503
2014-12-12      10894
2014-12-12      6513
2014-12-12      10894
2014-12-12      2825
2014-11-28      2825
2014-12-15      3200
2014-12-03      10576
2014-11-20      10576
2014-12-13      10576
2014-12-08      10576
2014-12-14      7079
2014-12-02      6669
2014-12-12      5232
Time taken: 0.122 seconds, Fetched: 20 row(s)
hive> 

hive> select e.bh, e.it  from (select behavior_type as bh, item_category as it from bigdata_user) as e  limit 20;
OK
1       4076
1       5503
1       5503
1       9762
1       5232
4       9762
1       5503
1       10894
1       6513
1       10894
1       2825
1       2825
1       3200
1       10576
1       10576
1       10576
1       10576
1       7079
1       6669
1       5232
Time taken: 0.112 seconds, Fetched: 20 row(s)
hive> 

# let's do some basic statistics

select count(*) from bigdata_user;

hive> select count(*) from bigdata_user;
WARNING: Hive-on-MR is deprecated in Hive 2 and may not be available in the future versions. Consider using a different execution engine (i.e. spark, tez) or using Hive 1.X releases.
Query ID = hadoop_20171108122357_272d6f57-648d-47b6-a53f-7252c6d91232
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
2017-11-08 12:23:59,548 Stage-1 map = 100%,  reduce = 0%
2017-11-08 12:24:00,568 Stage-1 map = 100%,  reduce = 100%
Ended Job = job_local14233583_0001
MapReduce Jobs Launched: 
Stage-Stage-1:  HDFS Read: 31229512 HDFS Write: 0 SUCCESS
Total MapReduce CPU Time Spent: 0 msec
OK
300000
Time taken: 3.071 seconds, Fetched: 1 row(s)
hive> 

# query unique item nums 

select count(distinct uid) from bigdata_user;

hive> select count(distinct uid) from bigdata_user;
WARNING: Hive-on-MR is deprecated in Hive 2 and may not be available in the future versions. Consider using a different execution engine (i.e. spark, tez) or using Hive 1.X releases.
Query ID = hadoop_20171108122556_dee529da-fa89-4fca-a05d-66e636f7dc74
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
2017-11-08 12:25:58,137 Stage-1 map = 100%,  reduce = 100%
Ended Job = job_local1081679059_0002
MapReduce Jobs Launched: 
Stage-Stage-1:  HDFS Read: 62409872 HDFS Write: 0 SUCCESS
Total MapReduce CPU Time Spent: 0 msec
OK
270
Time taken: 1.402 seconds, Fetched: 1 row(s)
hive> 

select count(*) from (select uid,item_id,behavior_type,item_category,visit_date,province from bigdata_user group by uid,item_id,behavior_type,item_category,visit_date,province having count(*)=1)a;

hive> ;use dblabselect count(*) from (select uid,item_id,behavior_type,item_category,visit_date,province from bigdata_user group by uid,item_id,behavior_type,item_category,visit_date,province having count(*)=1)a;
WARNING: Hive-on-MR is deprecated in Hive 2 and may not be available in the future versions. Consider using a different execution engine (i.e. spark, tez) or using Hive 1.X releases.
Query ID = hadoop_20171108122937_10ab8476-f2a8-41d2-9bc6-d6d0969bb05f
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
2017-11-08 12:29:40,170 Stage-1 map = 0%,  reduce = 0%
2017-11-08 12:29:42,192 Stage-1 map = 100%,  reduce = 0%
2017-11-08 12:29:43,214 Stage-1 map = 100%,  reduce = 100%
Ended Job = job_local1577635863_0001
Launching Job 2 out of 2
Number of reduce tasks determined at compile time: 1
In order to change the average load for a reducer (in bytes):
  set hive.exec.reducers.bytes.per.reducer=<number>
In order to limit the maximum number of reducers:
  set hive.exec.reducers.max=<number>
In order to set a constant number of reducers:
  set mapreduce.job.reduces=<number>
Job running in-process (local Hadoop)
2017-11-08 12:29:44,502 Stage-2 map = 100%,  reduce = 100%
Ended Job = job_local819874205_0002
MapReduce Jobs Launched: 
Stage-Stage-1:  HDFS Read: 31180360 HDFS Write: 0 SUCCESS
Stage-Stage-2:  HDFS Read: 31180360 HDFS Write: 0 SUCCESS
Total MapReduce CPU Time Spent: 0 msec
OK
284331
Time taken: 7.417 seconds, Fetched: 1 row(s)
hive> 

# query and fiter by where clause

hive> select count(*) from bigdata_user where behavior_type='1' and visit_date<'2014-12-13' and visit_date>'2014-12-10';
WARNING: Hive-on-MR is deprecated in Hive 2 and may not be available in the future versions. Consider using a different execution engine (i.e. spark, tez) or using Hive 1.X releases.
Query ID = hadoop_20171108123129_73813c7d-db42-4097-92e5-7d8de1d4b0a2
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
2017-11-08 12:31:30,749 Stage-1 map = 100%,  reduce = 100%
Ended Job = job_local983049632_0003
MapReduce Jobs Launched: 
Stage-Stage-1:  HDFS Read: 62360720 HDFS Write: 0 SUCCESS
Total MapReduce CPU Time Spent: 0 msec
OK
26329
Time taken: 1.454 seconds, Fetched: 1 row(s)
hive> 

# group by date and check the item sales num 

hive> select count(distinct uid), day(visit_date) from bigdata_user where behavior_type='4' group by day(visit_date);
WARNING: Hive-on-MR is deprecated in Hive 2 and may not be available in the future versions. Consider using a different execution engine (i.e. spark, tez) or using Hive 1.X releases.
Query ID = hadoop_20171108123250_aaac1af7-674e-46e9-8ddb-188e8ebc5e2a
Total jobs = 1
Launching Job 1 out of 1
Number of reduce tasks not specified. Estimated from input data size: 1
In order to change the average load for a reducer (in bytes):
  set hive.exec.reducers.bytes.per.reducer=<number>
In order to limit the maximum number of reducers:
  set hive.exec.reducers.max=<number>
In order to set a constant number of reducers:
  set mapreduce.job.reduces=<number>
Job running in-process (local Hadoop)
2017-11-08 12:32:52,114 Stage-1 map = 100%,  reduce = 100%
Ended Job = job_local2002952803_0004
MapReduce Jobs Launched: 
Stage-Stage-1:  HDFS Read: 93541080 HDFS Write: 0 SUCCESS
Total MapReduce CPU Time Spent: 0 msec
OK
37      1
48      2
42      3
38      4
42      5
33      6
42      7
36      8
34      9
40      10
43      11
98      12
39      13
43      14
42      15
44      16
42      17
66      18
38      19
50      20
33      21
34      22
32      23
47      24
34      25
31      26
30      27
34      28
39      29
38      30
Time taken: 1.389 seconds, Fetched: 30 row(s)
hive> 

# query and filter by where clause

select count(*) from bigdata_user where province='江西' and visit_date='2014-12-12' and behavior_type='4';

hive> select count(*) from bigdata_user where province='江西' and visit_date='2014-12-12' and behavior_type='4';
WARNING: Hive-on-MR is deprecated in Hive 2 and may not be available in the future versions. Consider using a different execution engine (i.e. spark, tez) or using Hive 1.X releases.
Query ID = hadoop_20171108123506_b4a9f8fa-675e-46de-854b-261fd4d27d87
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
2017-11-08 12:35:07,652 Stage-1 map = 100%,  reduce = 100%
Ended Job = job_local1903379597_0005
MapReduce Jobs Launched: 
Stage-Stage-1:  HDFS Read: 124721440 HDFS Write: 0 SUCCESS
Total MapReduce CPU Time Spent: 0 msec
OK
6
Time taken: 1.404 seconds, Fetched: 1 row(s)
hive> 


### 

select count(*) from bigdata_user where visit_date='2014-12-11'and behavior_type='4';

select count(*) from bigdata_user where visit_date ='2014-12-11';

select count(*) from bigdata_user where uid=10001082 and visit_date='2014-12-12';

hive>  select uid from bigdata_user where behavior_type='4' and visit_date='2014-12-12' group by uid having count(behavior_type='4')>5;
WARNING: Hive-on-MR is deprecated in Hive 2 and may not be available in the future versions. Consider using a different execution engine (i.e. spark, tez) or using Hive 1.X releases.
Query ID = hadoop_20171108124018_57168a98-f83f-45d8-b608-287e43f6a1b9
Total jobs = 1
Launching Job 1 out of 1
Number of reduce tasks not specified. Estimated from input data size: 1
In order to change the average load for a reducer (in bytes):
  set hive.exec.reducers.bytes.per.reducer=<number>
In order to limit the maximum number of reducers:
  set hive.exec.reducers.max=<number>
In order to set a constant number of reducers:
  set mapreduce.job.reduces=<number>
Job running in-process (local Hadoop)
2017-11-08 12:40:20,232 Stage-1 map = 100%,  reduce = 100%
Ended Job = job_local1841813833_0010
MapReduce Jobs Launched: 
Stage-Stage-1:  HDFS Read: 280623240 HDFS Write: 0 SUCCESS
Total MapReduce CPU Time Spent: 0 msec
OK
100226515
100300684
100555417
100605
10095384
10142625
101490976
101982646
102011320
102030700
102079825
102349447
102612580
102650143
103082347
103139791
103794013
103995979
Time taken: 1.427 seconds, Fetched: 18 row(s)
hive> 

create table scan(province STRING,scan INT) COMMENT 'This is the search of bigdataday' ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t' STORED AS TEXTFILE;
insert overwrite table scan select province,count(behavior_type) from bigdata_user where behavior_type='1' group by province;
select * from scan;

hive>  create table scan(province STRING,scan INT) COMMENT 'This is the search of bigdataday' ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t' STORED AS TEXTFILE;
OK
Time taken: 0.251 seconds
hive> insert overwrite table scan select province,count(behavior_type) from bigdata_user where behavior_type='1' group by province;
WARNING: Hive-on-MR is deprecated in Hive 2 and may not be available in the future versions. Consider using a different execution engine (i.e. spark, tez) or using Hive 1.X releases.
Query ID = hadoop_20171108124322_976fa4cb-8f57-4e83-b723-dfaee91c3ad1
Total jobs = 1
Launching Job 1 out of 1
Number of reduce tasks not specified. Estimated from input data size: 1
In order to change the average load for a reducer (in bytes):
  set hive.exec.reducers.bytes.per.reducer=<number>
In order to limit the maximum number of reducers:
  set hive.exec.reducers.max=<number>
In order to set a constant number of reducers:
  set mapreduce.job.reduces=<number>
Job running in-process (local Hadoop)
2017-11-08 12:43:24,367 Stage-1 map = 100%,  reduce = 100%
Ended Job = job_local758586214_0011
Loading data to table dblab.scan
MapReduce Jobs Launched: 
Stage-Stage-1:  HDFS Read: 311803600 HDFS Write: 493 SUCCESS
Total MapReduce CPU Time Spent: 0 msec
OK
Time taken: 1.611 seconds
hive> select * from scan;
OK
上海市  8352
云南    8337
内蒙古  8273
北京市  8326
台湾    8311
吉林    8424
四川    8426
天津市  8264
宁夏    8249
安徽    8210
山东    8360
山西    8471
广东    8364
广西    8307
新疆    8353
江苏    8267
江西    8266
河北    8351
河南    8332
浙江    8328
海南    8363
湖北    8380
湖南    8251
澳门    8517
甘肃    8286
福建    8437
西藏    8265
贵州    8426
辽宁    8295
重庆市  8421
陕西    8171
青海    8469
香港    8373
黑龙江  8291
Time taken: 0.11 seconds, Fetched: 34 row(s)
hive> 
 


