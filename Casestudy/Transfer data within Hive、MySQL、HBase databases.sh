############# Transfer data within Hive、MySQL、HBase databases ####

# start mysql service 
service mysql start
# start hadoop service 
cd /usr/local/hadoop
./sbin/start-all.sh
# check status
jps

hadoop@dblab-VirtualBox:/usr/local/hadoop$ jps
6597 DataNode
7096 NodeManager
6969 ResourceManager
7404 Jps
6445 NameNode
6797 SecondaryNameNode
# start Hive
cd /usr/local/hive
./bin/hive

# create tabel user_action

create table dblab.user_action(id STRING,uid STRING, item_id STRING, behavior_type STRING, item_category STRING, visit_date DATE, province STRING) COMMENT 'Welcome to XMU dblab! ' ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t' STORED AS TEXTFILE;
# check the created table in hdfs
cd /usr/local/hadoop
./bin/hdfs dfs -ls /user/hive/warehouse/dblab.db/user_action

hadoop@dblab-VirtualBox:/usr/local/hadoop$ ./bin/hdfs dfs -ls /user/hive/warehouse/dblab.db/user_action
Found 1 items
-rwxr-xr-x   1 hadoop supergroup   15590180 2017-11-08 23:18 /user/hive/warehouse/dblab.db/user_action/000000_0

hive> select * from user_action limit 10;
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
Time taken: 0.091 seconds, Fetched: 10 row(s)
hive> 

mysql –u root –p
show databases;

mysql> show databases;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| hive               |
| mysql              |
| performance_schema |
| spark              |
| sys                |
+--------------------+
6 rows in set (0.02 sec)

mysql> 

create database dblab;
show variables like "char%";


mysql> create database dblab;
Query OK, 1 row affected (0.01 sec)

mysql> use dblab;
Database changed
mysql> show variables like "char%";
+--------------------------+----------------------------+
| Variable_name            | Value                      |
+--------------------------+----------------------------+
| character_set_client     | utf8                       |
| character_set_connection | utf8                       |
| character_set_database   | utf8                       |
| character_set_filesystem | binary                     |
| character_set_results    | utf8                       |
| character_set_server     | utf8                       |
| character_set_system     | utf8                       |
| character_sets_dir       | /usr/share/mysql/charsets/ |
+--------------------------+----------------------------+
8 rows in set (0.00 sec)

mysql> 


# create table user_action within dblad database 


mysql> slect * from user_action;
ERROR 1064 (42000): You have an error in your SQL syntax; check the manual that corresponds to your MySQL server version for the right syntax to use near 'slect * from user_action' at line 1
mysql> select * from user_action;
ERROR 1146 (42S02): Table 'dblab.user_action' doesn't exist
mysql> CREATE TABLE `dblab`.`user_action` (`id` varchar(50),`uid` varchar(50),`item_id` varchar(50),`behavior_type` varchar(10),`item_category` varchar(50), `visit_date` DATE,`province` varchar(20)) ENGINE=InnoDB DEFAULT CHARSET=utf8;
Query OK, 0 rows affected (0.03 sec)

mysql> show tables;
+-----------------+
| Tables_in_dblab |
+-----------------+
| user_action     |
+-----------------+
1 row in set (0.00 sec)

mysql> select * from user_action;
Empty set (0.01 sec)

mysql> 

# install sqoop

cd ~ 
cd download 
sudo tar -zxvf  sqoop-1.4.6.bin__hadoop-2.0.4-alpha.tar.gz -C /usr/local 
cd /usr/local
sudo mv sqoop-1.4.6.bin__hadoop-2.0.4-alpha sqoop 
sudo chown -R hadoop:hadoop sqoop 
# update sqoop-env.sh
cd sqoop/conf/
cat sqoop-env-template.sh  >> sqoop-env.sh  
vim sqoop-env.sh 

export HADOOP_COMMON_HOME=/usr/local/hadoop
export HADOOP_MAPRED_HOME=/usr/local/hadoop
export HBASE_HOME=/usr/local/hbase
export HIVE_HOME=/usr/local/hive
#export ZOOCFGDIR= 

# update ~/.bashrc file

sudo nano ~/.bashrc

export SQOOP_HOME=/usr/local/sqoop
export PATH=$PATH:$SBT_HOME/bin:$SQOOP_HOME/bin
export CLASSPATH=$CLASSPATH:$SQOOP_HOME/lib

source ~/.bashrc

# copy mysql driver to $SQOOP_HOME/lib

cd ~/download
sudo tar -zxvf  mysql-connector-java-5.1.44.tar.gz  
ls 
cp ./mysql-connector-java-5.1.44/mysql-connector-java-5.1.44-bin.jar /usr/local/sqoop/lib
# check mysql connection with sqoop

# import data

cd /usr/local/sqoop
./bin/sqoop export --connect jdbc:mysql://localhost:3306/dblab --username root --password hadoop --table user_action --export-dir '/user/hive/warehouse/dblab.db/user_action' --fields-terminated-by '\t';

./bin/sqoop export  # copy data from hive to mysql 
--connect jdbc:mysql://localhost:3306/dblab 
--username root  # login mysql root user
--password hadoop  # password
--table user_action  # mysql table selected  
--export-dir '/user/hive/warehouse/dblab.db/user_action '  # file exported from hive 
--fields-terminated-by '\t'   # file deliminator for Hive 


mysql> use dblab;
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A

Database changed
mysql> select * from user_action limit 10;
+------+----------+-----------+---------------+---------------+------------+-----------+
| id   | uid      | item_id   | behavior_type | item_category | visit_date | province  |
+------+----------+-----------+---------------+---------------+------------+-----------+
| 1    | 10001082 | 285259775 | 1             | 4076          | 2014-12-08 | 广西      |
| 2    | 10001082 | 4368907   | 1             | 5503          | 2014-12-12 | 青海      |
| 3    | 10001082 | 4368907   | 1             | 5503          | 2014-12-12 | 贵州      |
| 4    | 10001082 | 53616768  | 1             | 9762          | 2014-12-02 | 内蒙古    |
| 5    | 10001082 | 151466952 | 1             | 5232          | 2014-12-12 | 天津市    |
| 6    | 10001082 | 53616768  | 4             | 9762          | 2014-12-02 | 湖南      |
| 7    | 10001082 | 290088061 | 1             | 5503          | 2014-12-12 | 河南      |
| 8    | 10001082 | 298397524 | 1             | 10894         | 2014-12-12 | 重庆市    |
| 9    | 10001082 | 32104252  | 1             | 6513          | 2014-12-12 | 甘肃      |
| 10   | 10001082 | 323339743 | 1             | 10894         | 2014-12-12 | 北京市    |
+------+----------+-----------+---------------+---------------+------------+-----------+
10 rows in set (0.00 sec)

## import data from mysql to Hbase with sqoop

## start hadoop mysql and Hbase sevice 
cd /usr/local/hbase
./bin/start-hbase.sh

cd /usr/local/hbase
./bin/hbase shell

# create user_action
create 'user_action', { NAME => 'f1', VERSIONS => 5}

# import data

cd /usr/local/sqoop
./bin/sqoop  import  --connect jdbc:mysql://localhost:3306/dblab --username root --password hadoop --table user_action --hbase-table user_action --column-family f1 --hbase-row-key id --hbase-create-table -m 1

./bin/sqoop  import  --connect  jdbc:mysql://localhost:3306/dblab
--username  root
--password  hadoop 
--table user_action
--hbase-table user_action # HBase table name 
--column-family f1 # column name
--hbase-row-key id #HBase row key
--hbase-create-table # if no table, create new table
-m 1 # map numer 


        Map-Reduce Framework
                Map input records=300000
                Map output records=300000
                Input split bytes=87
                Spilled Records=0
                Failed Shuffles=0
                Merged Map outputs=0
                GC time elapsed (ms)=282
                Total committed heap usage (bytes)=468189184
        File Input Format Counters 
                Bytes Read=0
        File Output Format Counters 
                Bytes Written=0
17/11/09 21:13:57 INFO mapreduce.ImportJobBase: Transferred 0 bytes in 11.9724 seconds (0 bytes/sec)
17/11/09 21:13:57 INFO mapreduce.ImportJobBase: Retrieved 300000 records.


=> Hbase::Table - user_action
hbase(main):004:0> scan 'user_action',{LIMIT=>10}
ROW                                                COLUMN+CELL                                                                                                                                       
 1                                                 column=f1:behavior_type, timestamp=1510280028015, value=1                                                                                         
 1                                                 column=f1:item_category, timestamp=1510280028015, value=4076                                                                                      
 1                                                 column=f1:item_id, timestamp=1510280028015, value=285259775                                                                                       
 1                                                 column=f1:province, timestamp=1510280028015, value=\xE5\xB9\xBF\xE8\xA5\xBF                                                                       
 1                                                 column=f1:uid, timestamp=1510280028015, value=10001082                                                                                            
 1                                                 column=f1:visit_date, timestamp=1510280028015, value=2014-12-08                                                                                   
 10                                                column=f1:behavior_type, timestamp=1510280028015, value=1                                                                                         
 10                                                column=f1:item_category, timestamp=1510280028015, value=10894                                                                                     
 10                                                column=f1:item_id, timestamp=1510280028015, value=323339743                                                                                       
 10                                                column=f1:province, timestamp=1510280028015, value=\xE5\x8C\x97\xE4\xBA\xAC\xE5\xB8\x82                                                           
 10                                                column=f1:uid, timestamp=1510280028015, value=10001082                                                                                            
 10                                                column=f1:visit_date, timestamp=1510280028015, value=2014-12-12                                                                                   
 100                                               column=f1:behavior_type, timestamp=1510280028015, value=1                                                                                         
 100                                               column=f1:item_category, timestamp=1510280028015, value=10576                                                                                     
 100                                               column=f1:item_id, timestamp=1510280028015, value=275221686                                                                                       
 100                                               column=f1:province, timestamp=1510280028015, value=\xE7\xA6\x8F\xE5\xBB\xBA                                                                       
 100                                               column=f1:uid, timestamp=1510280028015, value=10001082                                                                                            
 100                                               column=f1:visit_date, timestamp=1510280028015, value=2014-12-02                                                                                   
 1000                                              column=f1:behavior_type, timestamp=1510280028015, value=1                                                                                         
 1000                                              column=f1:item_category, timestamp=1510280028015, value=3381                                                                                      
 1000                                              column=f1:item_id, timestamp=1510280028015, value=168463559                                                                                       
 1000                                              column=f1:province, timestamp=1510280028015, value=\xE5\xAE\x81\xE5\xA4\x8F                                                                       
 1000                                              column=f1:uid, timestamp=1510280028015, value=100068031                                                                                           
 1000                                              column=f1:visit_date, timestamp=1510280028015, value=2014-12-02                                                                                   
 10000                                             column=f1:behavior_type, timestamp=1510280028689, value=1                                                                                         
 10000                                             column=f1:item_category, timestamp=1510280028689, value=12488                                                                                     
 10000                                             column=f1:item_id, timestamp=1510280028689, value=45571867                                                                                        
 10000                                             column=f1:province, timestamp=1510280028689, value=\xE6\xB9\x96\xE5\x8D\x97                                                                       
 10000                                             column=f1:uid, timestamp=1510280028689, value=100198255                                                                                           
 10000                                             column=f1:visit_date, timestamp=1510280028689, value=2014-12-05                                                                                   
 100000                                            column=f1:behavior_type, timestamp=1510280031554, value=1                                                                                         
 100000                                            column=f1:item_category, timestamp=1510280031554, value=6580                                                                                      
 100000                                            column=f1:item_id, timestamp=1510280031554, value=78973192                                                                                        
 100000                                            column=f1:province, timestamp=1510280031554, value=\xE5\xB1\xB1\xE4\xB8\x9C                                                                       
 100000                                            column=f1:uid, timestamp=1510280031554, value=101480065                                                                                           
 100000                                            column=f1:visit_date, timestamp=1510280031554, value=2014-11-29                                                                                   
 100001                                            column=f1:behavior_type, timestamp=1510280031554, value=1                                                                                         
 100001                                            column=f1:item_category, timestamp=1510280031554, value=3472                                                                                      
 100001                                            column=f1:item_id, timestamp=1510280031554, value=34929314                                                                                        
 100001                                            column=f1:province, timestamp=1510280031554, value=\xE8\xB4\xB5\xE5\xB7\x9E                                                                       
 100001                                            column=f1:uid, timestamp=1510280031554, value=101480065                                                                                           
 100001                                            column=f1:visit_date, timestamp=1510280031554, value=2014-12-15                                                                                   
 100002                                            column=f1:behavior_type, timestamp=1510280031554, value=1                                                                                         
 100002                                            column=f1:item_category, timestamp=1510280031554, value=10392                                                                                     
 100002                                            column=f1:item_id, timestamp=1510280031554, value=401104894                                                                                       
 100002                                            column=f1:province, timestamp=1510280031554, value=\xE4\xB8\x8A\xE6\xB5\xB7\xE5\xB8\x82                                                           
 100002                                            column=f1:uid, timestamp=1510280031554, value=101480065                                                                                           
 100002                                            column=f1:visit_date, timestamp=1510280031554, value=2014-11-29                                                                                   
 100003                                            column=f1:behavior_type, timestamp=1510280031554, value=1                                                                                         
 100003                                            column=f1:item_category, timestamp=1510280031554, value=5894                                                                                      
 100003                                            column=f1:item_id, timestamp=1510280031554, value=217913901                                                                                       
 100003                                            column=f1:province, timestamp=1510280031554, value=\xE6\x96\xB0\xE7\x96\x86                                                                       
 100003                                            column=f1:uid, timestamp=1510280031554, value=101480065                                                                                           
 100003                                            column=f1:visit_date, timestamp=1510280031554, value=2014-12-04                                                                                   
 100004                                            column=f1:behavior_type, timestamp=1510280031554, value=1                                                                                         
 100004                                            column=f1:item_category, timestamp=1510280031554, value=12189                                                                                     
 100004                                            column=f1:item_id, timestamp=1510280031554, value=295053167                                                                                       
 100004                                            column=f1:province, timestamp=1510280031554, value=\xE5\xB1\xB1\xE4\xB8\x9C                                                                       
 100004                                            column=f1:uid, timestamp=1510280031554, value=101480065                                                                                           
 100004                                            column=f1:visit_date, timestamp=1510280031554, value=2014-11-26                                                                                   
10 row(s) in 0.3480 seconds

hbase(main):005:0> 

### import data from local to HBase with HBase Java API 

## please make sure you start hadoop and hbase sevice before running this code 

cd /usr/local/hadoop
./sbin/start-all.sh

cd /usr/local/hbase
./bin/start-hbase.sh

## get data 
## actrually, we can write java code to get data from HDFS and load them to HBase. However, here, we are going to 
##import data to HBase from local disk with JAVA script.  
## Firstly, copy user_action data form HDFS to Linux local disk.

cd /usr/local/bigdatacase/dataset
/usr/local/hadoop/bin/hdfs dfs -get /user/hive/warehouse/dblab.db/user_action # please note: you have to start Hive service 

cat ./user_action/* | head -10  
cat ./user_action/00000* > user_action.output 
head user_action.output  

hadoop@dblab-VirtualBox:/usr/local/bigdatacase/dataset$ cat ./user_action/* | head -10
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

hadoop@dblab-VirtualBox:/usr/local/bigdatacase/dataset$ cat ./user_action/00000* > user_action.output 
hadoop@dblab-VirtualBox:/usr/local/bigdatacase/dataset$ head user_action.output
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
hadoop@dblab-VirtualBox:/usr/local/bigdatacase/dataset$ ls
pre_deal.sh  raw_user.csv  small_user.csv  user_action  user_action.output  user_table.txt

#### write code to import data 

import java.io.BufferedReader;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.List;
 
import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.hbase.HBaseConfiguration;
import org.apache.hadoop.hbase.KeyValue;
import org.apache.hadoop.hbase.client.Get;
import org.apache.hadoop.hbase.client.HBaseAdmin;
import org.apache.hadoop.hbase.client.HTable;
import org.apache.hadoop.hbase.client.Put;
import org.apache.hadoop.hbase.client.Result;
import org.apache.hadoop.hbase.client.ResultScanner;
import org.apache.hadoop.hbase.client.Scan;
import org.apache.hadoop.hbase.util.Bytes;
 
public class HBaseImportTest extends Thread {
    public Configuration config;
    public HTable table;
    public HBaseAdmin admin;
 
    public HBaseImportTest() {
        config = HBaseConfiguration.create();
//      config.set("hbase.master", "master:60000");
//      config.set("hbase.zookeeper.quorum", "master");
        try {
            table = new HTable(config, Bytes.toBytes("user_action"));
            admin = new HBaseAdmin(config);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
 
    public static void main(String[] args) throws Exception {
        if (args.length == 0) {       // First parameter is .Jar file, second one is the path where file stored 
            throw new Exception("You must set input path!");
        }
 
        String fileName = args[args.length-1];  //input the last part of file path
        HBaseImportTest test = new HBaseImportTest();
        test.importLocalFileToHBase(fileName);
    }
 
    public void importLocalFileToHBase(String fileName) {
        long st = System.currentTimeMillis();
        BufferedReader br = null;
        try {
            br = new BufferedReader(new InputStreamReader(new FileInputStream(
                    fileName)));
            String line = null;
            int count = 0;
            while ((line = br.readLine()) != null) {
                count++;
                put(line);
                if (count % 10000 == 0)
                    System.out.println(count);
            }
        } catch (IOException e) {
            e.printStackTrace();
        } finally {
 
            if (br != null) {
                try {
                    br.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
 
            try {
                table.flushCommits();
                table.close(); // must close the client
            } catch (IOException e) {
                e.printStackTrace();
            }
 
        }
        long en2 = System.currentTimeMillis();
        System.out.println("Total Time: " + (en2 - st) + " ms");
    }
 
    @SuppressWarnings("deprecation")
    public void put(String line) throws IOException {
        String[] arr = line.split("\t", -1);
        String[] column = {"id","uid","item_id","behavior_type","item_category","date","province"};
 
        if (arr.length == 7) {
            Put put = new Put(Bytes.toBytes(arr[0]));// rowkey
            for(int i=1;i<arr.length;i++){
                put.add(Bytes.toBytes("f1"), Bytes.toBytes(column[i]),Bytes.toBytes(arr[i]));
            }
            table.put(put); // put to server
        }
    }
 
    public void get(String rowkey, String columnFamily, String column,
            int versions) throws IOException {
        long st = System.currentTimeMillis();
 
        Get get = new Get(Bytes.toBytes(rowkey));
        get.addColumn(Bytes.toBytes(columnFamily), Bytes.toBytes(column));
 
        Scan scanner = new Scan(get);
        scanner.setMaxVersions(versions);
 
        ResultScanner rsScanner = table.getScanner(scanner);
 
        for (Result result : rsScanner) {
            final List<KeyValue> list = result.list();
            for (final KeyValue kv : list) {
                System.out.println(Bytes.toStringBinary(kv.getValue()) + "\t"
                        + kv.getTimestamp()); // mid + time
            }
 
        }
        rsScanner.close();
 
        long en2 = System.currentTimeMillis();
        System.out.println("Total Time: " + (en2 - st) + " ms");
    }
 
}


### import data to HBase
### Firstly, go to HBase to clean the previous data.

truncate 'user_action'

scan 'user_action',{LIMIT=>10}

hbase(main):005:0> truncate 'user_action'
Truncating 'user_action' table (it may take a while):
 - Disabling table...
 - Truncating table...
0 row(s) in 3.7090 seconds

hbase(main):006:0> scan 'user_action',{LIMIT=>10}
ROW                                                COLUMN+CELL                                                                                                                                       
0 row(s) in 0.3450 seconds

hbase(main):007:0> 

# import data from local to hbase with JAVA API
/usr/local/hadoop/bin/hadoop jar /usr/local/bigdatacase/hbase/ImportHBase.jar HBaseImportTest /usr/local/bigdatacase/dataset/user_action.output
/usr/local/hadoop/bin/hadoop jar  # hadoop jar file path
/usr/local/bigdatacase/hbase/ImportHBase.jar  #jar file path
HBaseImportTest   #main function 
/usr/local/bigdatacase/dataset/user_action.output  #main function with args to specify file path

p-mapreduce-client-common-2.7.1.jar:/usr/local/hadoop/contrib/capacity-scheduler/*.jar
17/11/10 12:06:24 INFO zookeeper.ZooKeeper: Client environment:java.library.path=/usr/local/hadoop/lib/native
17/11/10 12:06:24 INFO zookeeper.ZooKeeper: Client environment:java.io.tmpdir=/tmp
17/11/10 12:06:24 INFO zookeeper.ZooKeeper: Client environment:java.compiler=<NA>
17/11/10 12:06:24 INFO zookeeper.ZooKeeper: Client environment:os.name=Linux
17/11/10 12:06:24 INFO zookeeper.ZooKeeper: Client environment:os.arch=amd64
17/11/10 12:06:24 INFO zookeeper.ZooKeeper: Client environment:os.version=4.4.0-98-generic
17/11/10 12:06:24 INFO zookeeper.ZooKeeper: Client environment:user.name=hadoop
17/11/10 12:06:24 INFO zookeeper.ZooKeeper: Client environment:user.home=/home/hadoop
17/11/10 12:06:24 INFO zookeeper.ZooKeeper: Client environment:user.dir=/usr/local/bigdatacase
17/11/10 12:06:24 INFO zookeeper.ZooKeeper: Initiating client connection, connectString=localhost:2181 sessionTimeout=90000 watcher=hconnection-0x752c2f420x0, quorum=localhost:2181, baseZNode=/hbase
17/11/10 12:06:24 INFO zookeeper.ClientCnxn: Opening socket connection to server localhost/127.0.0.1:2181. Will not attempt to authenticate using SASL (unknown error)
17/11/10 12:06:24 INFO zookeeper.ClientCnxn: Socket connection established to localhost/127.0.0.1:2181, initiating session
17/11/10 12:06:24 INFO zookeeper.ClientCnxn: Session establishment complete on server localhost/127.0.0.1:2181, sessionid = 0x15fa3afdcd20009, negotiated timeout = 90000
10000
20000
30000
40000
50000
60000
70000
80000
90000
100000
110000
120000
130000
140000
150000
160000
170000
180000
190000
200000
210000
220000
230000
240000
250000
260000
270000
280000
290000
300000
Total Time: 201705 ms
hadoop@dblab-VirtualBox:/usr/local/bigdatacase$ ^C
hadoop@dblab-VirtualBox:/usr/local/bigdatacase$ 


hbase(main):005:0> truncate 'user_action'
Truncating 'user_action' table (it may take a while):
 - Disabling table...
 - Truncating table...
0 row(s) in 3.7090 seconds

hbase(main):006:0> scan 'user_action',{LIMIT=>10}
ROW                                                COLUMN+CELL                                                                                                                                       
0 row(s) in 0.3450 seconds
# check the result

hbase(main):007:0> scan 'user_action',{LIMIT=>10}
ROW                                                COLUMN+CELL                                                                                                                                       
 1                                                 column=f1:behavior_type, timestamp=1510333585144, value=1                                                                                         
 1                                                 column=f1:date, timestamp=1510333585144, value=2014-12-08                                                                                         
 1                                                 column=f1:item_category, timestamp=1510333585144, value=4076                                                                                      
 1                                                 column=f1:item_id, timestamp=1510333585144, value=285259775                                                                                       
 1                                                 column=f1:province, timestamp=1510333585144, value=\xE5\xB9\xBF\xE8\xA5\xBF                                                                       
 1                                                 column=f1:uid, timestamp=1510333585144, value=10001082                                                                                            
 10                                                column=f1:behavior_type, timestamp=1510333585182, value=1                                                                                         
 10                                                column=f1:date, timestamp=1510333585182, value=2014-12-12                                                                                         
 10                                                column=f1:item_category, timestamp=1510333585182, value=10894                                                                                     
 10                                                column=f1:item_id, timestamp=1510333585182, value=323339743                                                                                       
 10                                                column=f1:province, timestamp=1510333585182, value=\xE5\x8C\x97\xE4\xBA\xAC\xE5\xB8\x82                                                           
 10                                                column=f1:uid, timestamp=1510333585182, value=10001082                                                                                            
 100                                               column=f1:behavior_type, timestamp=1510333585397, value=1                                                                                         
 100                                               column=f1:date, timestamp=1510333585397, value=2014-12-02                                                                                         
 100                                               column=f1:item_category, timestamp=1510333585397, value=10576                                                                                     
 100                                               column=f1:item_id, timestamp=1510333585397, value=275221686                                                                                       
 100                                               column=f1:province, timestamp=1510333585397, value=\xE7\xA6\x8F\xE5\xBB\xBA                                                                       
 100                                               column=f1:uid, timestamp=1510333585397, value=10001082                                                                                            
 1000                                              column=f1:behavior_type, timestamp=1510333586910, value=1                                                                                         
 1000                                              column=f1:date, timestamp=1510333586910, value=2014-12-02                                                                                         
 1000                                              column=f1:item_category, timestamp=1510333586910, value=3381                                                                                      
 1000                                              column=f1:item_id, timestamp=1510333586910, value=168463559                                                                                       
 1000                                              column=f1:province, timestamp=1510333586910, value=\xE5\xAE\x81\xE5\xA4\x8F                                                                       
 1000                                              column=f1:uid, timestamp=1510333586910, value=100068031                                                                                           
 10000                                             column=f1:behavior_type, timestamp=1510333595884, value=1                                                                                         
 10000                                             column=f1:date, timestamp=1510333595884, value=2014-12-05                                                                                         
 10000                                             column=f1:item_category, timestamp=1510333595884, value=12488                                                                                     
 10000                                             column=f1:item_id, timestamp=1510333595884, value=45571867                                                                                        
 10000                                             column=f1:province, timestamp=1510333595884, value=\xE6\xB9\x96\xE5\x8D\x97                                                                       
 10000                                             column=f1:uid, timestamp=1510333595884, value=100198255                                                                                           
 100000                                            column=f1:behavior_type, timestamp=1510333663337, value=1                                                                                         
 100000                                            column=f1:date, timestamp=1510333663337, value=2014-11-29                                                                                         
 100000                                            column=f1:item_category, timestamp=1510333663337, value=6580                                                                                      
 100000                                            column=f1:item_id, timestamp=1510333663337, value=78973192                                                                                        
 100000                                            column=f1:province, timestamp=1510333663337, value=\xE5\xB1\xB1\xE4\xB8\x9C                                                                       
 100000                                            column=f1:uid, timestamp=1510333663337, value=101480065                                                                                           
 100001                                            column=f1:behavior_type, timestamp=1510333663338, value=1                                                                                         
 100001                                            column=f1:date, timestamp=1510333663338, value=2014-12-15                                                                                         
 100001                                            column=f1:item_category, timestamp=1510333663338, value=3472                                                                                      
 100001                                            column=f1:item_id, timestamp=1510333663338, value=34929314                                                                                        
 100001                                            column=f1:province, timestamp=1510333663338, value=\xE8\xB4\xB5\xE5\xB7\x9E                                                                       
 100001                                            column=f1:uid, timestamp=1510333663338, value=101480065                                                                                           
 100002                                            column=f1:behavior_type, timestamp=1510333663340, value=1                                                                                         
 100002                                            column=f1:date, timestamp=1510333663340, value=2014-11-29                                                                                         
 100002                                            column=f1:item_category, timestamp=1510333663340, value=10392                                                                                     
 100002                                            column=f1:item_id, timestamp=1510333663340, value=401104894                                                                                       
 100002                                            column=f1:province, timestamp=1510333663340, value=\xE4\xB8\x8A\xE6\xB5\xB7\xE5\xB8\x82                                                           
 100002                                            column=f1:uid, timestamp=1510333663340, value=101480065                                                                                           
 100003                                            column=f1:behavior_type, timestamp=1510333663341, value=1                                                                                         
 100003                                            column=f1:date, timestamp=1510333663341, value=2014-12-04                                                                                         
 100003                                            column=f1:item_category, timestamp=1510333663341, value=5894                                                                                      
 100003                                            column=f1:item_id, timestamp=1510333663341, value=217913901                                                                                       
 100003                                            column=f1:province, timestamp=1510333663341, value=\xE6\x96\xB0\xE7\x96\x86                                                                       
 100003                                            column=f1:uid, timestamp=1510333663341, value=101480065                                                                                           
 100004                                            column=f1:behavior_type, timestamp=1510333663342, value=1                                                                                         
 100004                                            column=f1:date, timestamp=1510333663342, value=2014-11-26                                                                                         
 100004                                            column=f1:item_category, timestamp=1510333663342, value=12189                                                                                     
 100004                                            column=f1:item_id, timestamp=1510333663342, value=295053167                                                                                       
 100004                                            column=f1:province, timestamp=1510333663342, value=\xE5\xB1\xB1\xE4\xB8\x9C                                                                       
 100004                                            column=f1:uid, timestamp=1510333663342, value=101480065                                                                                           
10 row(s) in 0.1550 seconds
# # It took about 2 hours to finish ETL 23290000 files from local to Hbase with Java API, ETL data from mysql to Hbase was much fast than this.
23190000
23200000
23210000
23220000
23230000
23240000
23250000
23260000
23270000
23280000
23290000
Total Time: 12943513 ms
hadoop@dblab-VirtualBox:~$ 


