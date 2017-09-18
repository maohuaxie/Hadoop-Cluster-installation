# Download Spark from http://spark.apache.org/downloads.html in namenode server

sudo tar -zxf ~/download file/spark-2.2.0-bin-without-hadoop.tgz -C /usr/local/

cd /usr/local

sudo mv ./spark-2.2.0-bin-without-hadoop/ ./spark

sudo chown -R hadoop ./spark

# set up enviroment in namenode server by running the following command

sudo nano .basrhrc 

export SPARK_HOME=/usr/local/spark

export PATH=$PATH:$SPARK_HOME/bin:$SPARK_HOME/sbin

source .bashrc

# Spark configuration

set up namenode as Master node, there datanode1, datanode2 and datanode3 as worker node

running the following command in nadenode server

# slaves

copy slaves.template to slaves

cd /usr/local/spark/

cp ./conf/slaves.template ./conf/slaves

Set up worker node in slaves file and edit slaves file, replace localhost to:

datanode1

datanode2

datanode3

# spark-env.sh

copy spark-env.sh.template to spark-env.sh

cp ./conf/spark-env.sh.template ./conf/spark-env.sh

edit spark-env.sh：

export SPARK_DIST_CLASSPATH=$(/usr/local/hadoop/bin/hadoop classpath)

export HADOOP_CONF_DIR=/usr/local/hadoop/etc/hadoop

export SPARK_MASTER_IP=192.168.107.200

SPARK_MASTER_IP specifiy Spark cluster master node IP address:

After configuration, copy namenode server /usr/local/spark directory to datanode1, datanode2 and datanode3.

Running the following command in namenode server:

cd /usr/local/

tar -zcf ~/spark.master.tar.gz ./spark

cd ~

scp ./spark.master.tar.gz datanode1:/home/hadoop

scp ./spark.master.tar.gz datanode2:/home/hadoop

scp ./spark.master.tar.gz datanode3:/home/hadoop

Runing the following command in datanode1, datanode2 and datanode3:

sudo rm -rf /usr/local/spark/

sudo tar -zxf ~/spark.master.tar.gz -C /usr/local

sudo chown -R hadoop /usr/local/spark

# Start Hadoop cluster before starting Spark cluster

Running the following command in namenode server:

cd /usr/local/hadoop/

sbin/start-all.sh

# Start Spark cluster master node in namenode server

Running the following command in namenode server:

cd /usr/local/spark/

sbin/start-master.sh

jps # after running jps, we can see more processing is running:

15093 Jps

14343 SecondaryNameNode

14121 NameNode

14891 Master

14509 ResourceManager

# start slave node:

Running the following command in namenode:

sbin/start-slaves.sh

Running jps command in datanode1,datanode2 and datanode3，you will see some worker processing is running:

37553 DataNode

37684 NodeManager

37876 Worker

37924 Jps

check wiht http://192.168.107.200:8080 you will see something there:
# stop Spark

sbin/stop-master.sh

sbin/stop-slaves.sh

# stop Hadoop

cd /usr/local/hadoop/

sbin/stop-all.sh
