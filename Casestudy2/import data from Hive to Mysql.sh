############### import data from Hive to Mysql*##########################
#########################################################################
#### start Hive, hadoop and mysql service

service mysql start
cd /usr/local/hadoop
./sbin/start-all.sh
jps
cd /usr/local/hive
./bin/hive

### create new table inner_user_log
create table dbtaobao.inner_user_log(user_id INT,item_id INT,cat_id INT,merchant_id INT,brand_id INT,month STRING,day STRING,action INT,age_range INT,gender INT,province STRING) COMMENT 'Welcome to XMU dblab! Now create inner table inner_user_log ' ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' STORED AS TEXTFILE;
#### insert data 

INSERT OVERWRITE TABLE dbtaobao.inner_user_log select * from dbtaobao.user_log;

hive> INSERT OVERWRITE TABLE dbtaobao.inner_user_log select * from dbtaobao.user_log;
WARNING: Hive-on-MR is deprecated in Hive 2 and may not be available in the future versions. Consider using a different execution engine (i.e. spark, tez) or using Hive 1.X releases.
Query ID = hadoop_20171110202804_0174141f-da71-4081-8f7c-77744b60f679
Total jobs = 3
Launching Job 1 out of 3
Number of reduce tasks is set to 0 since there's no reduce operator
Job running in-process (local Hadoop)
2017-11-10 20:28:05,736 Stage-1 map = 100%,  reduce = 0%
Ended Job = job_local804729229_0012
Stage-4 is selected by condition resolver.
Stage-3 is filtered out by condition resolver.
Stage-5 is filtered out by condition resolver.
Moving data to directory hdfs://localhost:9000/user/hive/warehouse/dbtaobao.db/inner_user_log/.hive-staging_hive_2017-11-10_20-28-04_378_2658239462697201620-1/-ext-10000
Loading data to table dbtaobao.inner_user_log
MapReduce Jobs Launched: 
Stage-Stage-1:  HDFS Read: 5227550 HDFS Write: 477330 SUCCESS
Total MapReduce CPU Time Spent: 0 msec
OK
Time taken: 1.545 seconds
hive>  select * from inner_user_log limit 10;
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
Time taken: 0.105 seconds, Fetched: 10 row(s)
hive> 

##### import data from Hive to Mysql by using Sqoop
###login mysql
mysql –u root –p
##### create database
show databases; # show database
create database dbtaobao; # create dbtaobao database
use dbtaobao; # switch database

#### create table user_log within dbtaobao database in Mysql with utf-8 encode 

CREATE TABLE `dbtaobao`.`user_log` (`user_id` varchar(20),`item_id` varchar(20),`cat_id` varchar(20),`merchant_id` varchar(20),`brand_id` varchar(20), `month` varchar(6),`day` varchar(6),`action` varchar(6),`age_range` varchar(6),`gender` varchar(6),`province` varchar(10)) ENGINE=InnoDB DEFAULT CHARSET=utf8;
### please note: `dbtaobao` ` is not single quote, it is an character under ~. Also sqoop will change data to string, so set up varchar in Mysql
mysql> exit;

### import data 

bin/sqoop export --connect jdbc:mysql://localhost:3306/dbtaobao --username root --password hadoop --table user_log --export-dir '/user/hive/warehouse/dbtaobao.db/inner_user_log' --fields-terminated-by ',';

####

mysql -u hadoop -p
mysql -u root -p

./bin/sqoop export ## import data from  hive to  mysql 
--connect jdbc:mysql://localhost:3306/dbtaobao
--username root #mysql root 
--password hadoop # login password
--table user_log # mysql table name 
--export-dir '/user/hive/warehouse/dbtaobao.db/user_log ' # file path in Hive 
--fields-terminated-by ',' # file deliminator in Hive 

#### query user_log in Mysql

mysql> use dbtaobao;
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A

Database changed
mysql> select * from user_log limit 10;
+---------+---------+--------+-------------+----------+-------+------+--------+-----------+--------+-----------+
| user_id | item_id | cat_id | merchant_id | brand_id | month | day  | action | age_range | gender | province  |
+---------+---------+--------+-------------+----------+-------+------+--------+-----------+--------+-----------+
| 414196  | 1109106 | 1188   | 3518        | 4805     | 11    | 11   | 0      | 4         | 0      | 宁夏      |
| 414196  | 380046  | 4      | 231         | 6065     | 11    | 11   | 0      | 5         | 2      | 陕西      |
| 414196  | 1109106 | 1188   | 3518        | 4805     | 11    | 11   | 0      | 7         | 0      | 山西      |
| 414196  | 1109106 | 1188   | 3518        | 4805     | 11    | 11   | 0      | 6         | 0      | 河南      |
| 414196  | 1109106 | 1188   | 3518        | 763      | 11    | 11   | 2      | 2         | 0      | 四川      |
| 414196  | 944554  | 1432   | 323         | 320      | 11    | 11   | 2      | 7         | 2      | 青海      |
| 414196  | 1110009 | 1188   | 298         | 7907     | 11    | 11   | 2      | 3         | 1      | 澳门      |
| 414196  | 146482  | 513    | 2157        | 6539     | 11    | 11   | 0      | 1         | 0      | 上海市    |
| 414196  | 944554  | 1432   | 323         | 320      | 11    | 11   | 0      | 2         | 1      | 宁夏      |
| 414196  | 1109106 | 1188   | 3518        | 4805     | 11    | 11   | 0      | 7         | 0      | 新疆      |
+---------+---------+--------+-------------+----------+-------+------+--------+-----------+--------+-----------+
10 rows in set (0.00 sec)
