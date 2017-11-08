# case study customer web browsering behavior analysis 
# this case study will cover data preprocessing, storage, query and visulization 
# Linux、MySQL、Hadoop、HBase、Hive、Sqoop、R、Eclipse will be used in this case study
# The goals for this case study are as below:
# Learn how to install and implement Linux , MySQL、Hadoop、HBase、Hive、Sqoop、R、Eclipse
# Learn how to do big data analysis
# Learn how to import data between different databases
# visulize data by using R programming 
# query HBase databases with Jave in Eclipse

Please refer to the following website:http://dblab.xmu.edu.cn/post/7499/

Loading data to Hive 
cd /usr/local
ls
sudo mkdir bigdatacase  # create bigdatacase directory
sudo chown -R hadoop:hadoop ./bigdatacase # assign group use to bigdatacase dirctory
cd bigdatacase
mkdir dataset
cd /mydata
unzip user.zip -d /usr/local/bigdatacase/dataset
cd /usr/local/bigdatacase/dataset
ls
# now you will see raw_user.csv and small_user.csv data sets in dataset directory 
# let's look at the firt 5 records

hadoop@dblab-VirtualBox:/usr/local$ sudo chown -R hadoop:hadoop ./bigdatacase
hadoop@dblab-VirtualBox:/usr/local$ cd bigdatacase
hadoop@dblab-VirtualBox:/usr/local/bigdatacase$ cd /mydata
hadoop@dblab-VirtualBox:/mydata$ ls
data_format.zip  lost+found  raw_user.csv  small_user.csv  test.csv  train.csv  user_log.csv  user.zip
hadoop@dblab-VirtualBox:/mydata$ unzip user.zip -d /usr/local/bigdatacase/dataset
Archive:  user.zip
  inflating: /usr/local/bigdatacase/dataset/raw_user.csv  
  inflating: /usr/local/bigdatacase/dataset/small_user.csv  
hadoop@dblab-VirtualBox:/mydata$ cd /usr/local/bigdatacase/dataset
hadoop@dblab-VirtualBox:/usr/local/bigdatacase/dataset$ ls
raw_user.csv  small_user.csv
hadoop@dblab-VirtualBox:/usr/local/bigdatacase/dataset$ head -5 raw_user.csv
user_id,item_id,behavior_type,user_geohash,item_category,time
10001082,285259775,1,97lk14c,4076,2014-12-08 18
10001082,4368907,1,,5503,2014-12-12 12
10001082,4368907,1,,5503,2014-12-12 12
10001082,53616768,1,,9762,2014-12-02 15

# please note: behaviour_type contain browsering, save, add to cargo, puchase, the valuse are 1,2,3,4 respectively.

# data preprocessing
cd /usr/local/bigdatacase/dataset
sed -i '1d' raw_user.csv //1d means delete firt row，nd means delete n row
sed -i '1d' small_user.csv
head -5 raw_user.csv
head -5 small_user.csv

# To test your data processing flow and coding are working or not, please use small_user.csv file to save your time

# Let's do data wrangling, change some columns 

cd /usr/local/bigdatacase/dataset
vim pre_deal.sh 

#!/bin/bash
# input file 
infile=$1
# output file 
outfile=$2
#please note: $infile > $outfile must follow up with }’
awk -F "," 'BEGIN{
        srand();
        id=0;
        Province[0]="山东";Province[1]="山西";Province[2]="河南";Province[3]="河北";Province[4]="陕西";Province[5]="内蒙古";Province[6]="上海市";
        Province[7]="北京市";Province[8]="重庆市";Province[9]="天津市";Province[10]="福建";Province[11]="广东";Province[12]="广西";Province[13]="云南"; 
        Province[14]="浙江";Province[15]="贵州";Province[16]="新疆";Province[17]="西藏";Province[18]="江西";Province[19]="湖南";Province[20]="湖北";
        Province[21]="黑龙江";Province[22]="吉林";Province[23]="辽宁"; Province[24]="江苏";Province[25]="甘肃";Province[26]="青海";Province[27]="四川";
        Province[28]="安徽"; Province[29]="宁夏";Province[30]="海南";Province[31]="香港";Province[32]="澳门";Province[33]="台湾";
    }
    {
        id=id+1;
        value=int(rand()*34);       
        print id"\t"$1"\t"$2"\t"$3"\t"$5"\t"substr($6,1,10)"\t"Province[value]
    }' $infile > $outfile
	
awk -F "," 'processing logic' $infile > $outfile

cd /usr/local/bigdatacase/dataset
bash ./pre_deal.sh small_user.csv user_table.txt
head -10 user_table.txt
# you will see the following contents:
hadoop@dblab-VirtualBox:/usr/local/bigdatacase/dataset$ head -10 user_table.txt
1	10001082	285259775	1	4076	2014-12-08	广西
2	10001082	4368907	1	5503	2014-12-12	青海
3	10001082	4368907	1	5503	2014-12-12	贵州
4	10001082	53616768	1	9762	2014-12-02	内蒙古
5	10001082	151466952	1	5232	2014-12-12	天津市
6	10001082	53616768	4	9762	2014-12-02	湖南
7	10001082	290088061	1	5503	2014-12-12	河南
8	10001082	298397524	1	10894	2014-12-12	重庆市
9	10001082	32104252	1	6513	2014-12-12	甘肃
10	10001082	323339743	1	10894	2014-12-12	北京市

###
import to databases
####

#start Hdfs

cd /usr/local/hadoop
./sbin/start-all.sh

# check status 

jps

hadoop@dblab-VirtualBox:/usr/local/hadoop$ ./sbin/start-all.sh
  This script is Deprecated. Instead use start-dfs.sh and start-yarn.sh
Starting namenodes on [localhost]
localhost: starting namenode, logging to /usr/local/hadoop/logs/hadoop-hadoop-namenode-dblab-VirtualBox.out
localhost: starting datanode, logging to /usr/local/hadoop/logs/hadoop-hadoop-datanode-dblab-VirtualBox.out
Starting secondary namenodes [0.0.0.0]
0.0.0.0: starting secondarynamenode, logging to /usr/local/hadoop/logs/hadoop-hadoop-secondarynamenode-dblab-VirtualBox.out
starting yarn daemons
starting resourcemanager, logging to /usr/local/hadoop/logs/yarn-hadoop-resourcemanager-dblab-VirtualBox.out
localhost: starting nodemanager, logging to /usr/local/hadoop/logs/yarn-hadoop-nodemanager-dblab-VirtualBox.out
hadoop@dblab-VirtualBox:/usr/local/hadoop$   jps
9553 DataNode
9750 SecondaryNameNode
9401 NameNode
10362 Jps
10043 NodeManager
9916 ResourceManager
hadoop@dblab-VirtualBox:/usr/local/hadoop$ 

# put user_table.txt to hdfs 

cd /usr/local/hadoop
./bin/hdfs dfs -mkdir -p /bigdatacase/dataset

cd /usr/local/hadoop
./bin/hdfs dfs -put /usr/local/bigdatacase/dataset/user_table.txt /bigdatacase/dataset

hadoop@dblab-VirtualBox:/usr/local/hadoop$ ./bin/hdfs dfs -mkdir -p /bigdatacase/dataset
hadoop@dblab-VirtualBox:/usr/local/hadoop$ ./bin/hdfs dfs -put /usr/local/bigdatacase/dataset/user_table.txt /bigdatacase/dataset
hadoop@dblab-VirtualBox:/usr/local/hadoop$ cd /usr/local/hadoop
hadoop@dblab-VirtualBox:/usr/local/hadoop$ ./bin/hdfs dfs -cat /bigdatacase/dataset/user_table.txt | head -10
1       10001082        285259775       1       4076    2014-12-08      广西
2       10001082        4368907 1       5503    2014-12-12      青海
3       10001082        4368907 1       5503    2014-12-12      贵州
4       10001082        53616768        1       9762    2014-12-02      内蒙古
5       10001082        151466952       1       5232    2014-12-12      天津市
6       10001082        53616768        4       9762    2014-12-02      湖南
7       10001082        290088061       1       5503    2014-12-12      河南
8       10001082        298397524       1       10894   2014-12-12      重庆市
9       10001082        32104252        1       6513    2014-12-12      甘肃
10      10001082        323339743       1       10894   2014-12-12      北京市
cat: Unable to write to output stream.


# Creat database in Hadoop Hive 
# To do this, firstly, you need start local mysql sevice
service mysql start # you can do this in any directory
# start hive sevice, for this step, you have to start hadoop service before starting hive

cd /usr/local/hive
./bin/hive   

# let's create dblab database

create database dblab;
use dblab;
hive> create database dblab;
OK
Time taken: 1.072 seconds
hive> use dblab;
OK
Time taken: 0.025 seconds
hive> 

# let's create an external table

CREATE EXTERNAL TABLE dblab.bigdata_user(id INT,uid STRING,item_id STRING,behavior_type INT,item_category STRING,visit_date DATE,province STRING) COMMENT 'Welcome to xmu dblab!' ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t' STORED AS TEXTFILE LOCATION '/bigdatacase/dataset';

# query the data

hive> CREATE EXTERNAL TABLE dblab.bigdata_user(id INT,uid STRING,item_id STRING,behavior_type INT,item_category STRING,visit_date DATE,province STRING) COMMENT 'Welcome to xmu dblab!' ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t' STORED AS TEXTFILE LOCATION '/bigdatacase/dataset';
OK
Time taken: 0.489 seconds
hive> select * from bigdata_user limit 10;
OK
1       10001082        285259775       1       4076    2014-12-08      广西
2       10001082        4368907 1       5503    2014-12-12      青海
3       10001082        4368907 1       5503    2014-12-12      贵州
4       10001082        53616768        1       9762    2014-12-02      内蒙古
5       10001082        151466952       1       5232    2014-12-12      天津市
6       10001082        53616768        4       9762    2014-12-02      湖南
7       10001082        290088061       1       5503    2014-12-12      河南
8       10001082        298397524       1       10894   2014-12-12      重庆市
9       10001082        32104252        1       6513    2014-12-12      甘肃
10      10001082        323339743       1       10894   2014-12-12      北京市
Time taken: 1.933 seconds, Fetched: 10 row(s)
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
Time taken: 0.125 seconds, Fetched: 10 row(s)
hive> 

