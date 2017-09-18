In our cluster, we will have one name node and three data nodes. 
DataNodes store the actual data of Hadoop, while the NameNode stores the metadata information.
Follow the steps given below to have Hadoop Multi-Node cluster setup.
# Installing Java
First of all, you should check the existence of java in your system with “java -version”. The syntax of java version command is given below.

namenode@namenode:~$ java -version

openjdk version "1.8.0_141"

OpenJDK Runtime Environment (build 1.8.0_141-8u141-b15-3~14.04-b15)

OpenJDK 64-Bit Server VM (build 25.141-b15, mixed mode)


If java is not installed in your system, then follow the given steps for installing java.

sudo apt-get -y autoremove

sudo add-apt-repository ppa:openjdk-r/ppa

sudo apt-get update

sudo apt-get install openjdk-8-jdk

sudo apt-get install openjdk-8-jre

https://www.oracle.com/java/index.html
get the java_home directory and set the java_home directory:

sudo update-alternatives --config java

If java is still not working, try the folliwing steps

sudo rm -rf /usr/bin/java

sudo ln -sf /usr/lib/jvm/java-8-openjdk-amd64/bin/java /usr/bin/jar

# Set up Java Environment for Namenode and Datanode

sudo nano .bashrc

export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64

source .bashrc 

Test by typing Java –version

# Creating User Account

Create a Hadoop user account on both Namenode and datanode systems for Hadoop installation

$ sudo useradd -m hadoop -s /bin/bash

$ sudo passwd hadoop

$ sudo adduser hadoop sudo

Longin with hadoop user on both Namenode and datanode, do 

$ sudo apt-get update

# Mapping the nodes

You have to edit hosts file in /etc/ folder on all nodes, specify the IP address of each system followed by their host names.

$sudo nano /etc/hosts

192.168.107.200	namenode.namenode.com	namenode 

192.168.107.201  datanode1.namenode.com	datanode1

192.168.107.202  datanode2.namenode.com	datanode2   

192.168.107.203  datanode3.namenode.com	datanode3

# Edit the mancine hostname to namenode, datanode1, datanode2 and datanode3 respectively

$ sudo nano /etc/hostname

# Configuring Key Based Login

# ping namenode -c 3

[hadoop@namenode ~]$ cd ~

[hadoop@namenode ~]$ mkdir .ssh

[hadoop@namenode ~]$ ssh-keygen -t rsa -P ''

Generating public/private rsa key pair.

Enter file in which to save the key (/home/namenode/.ssh/id_rsa): 

Your identification has been saved in /home/namenode/.ssh/id_rsa.

Your public key has been saved in /home/namenode/.ssh/id_rsa.pub.
The key fingerprint is:

9a:a4:24:ef:d5:0c:42:6a:c8:9a:53:5f:b5:d4:ab:fb namenode@namenode

The key's randomart image is:

+--[ RSA 2048]----+
|                 |
|         .       |
|    .   o .      |
|.. o   o . .     |
|..= o + S .      |
|.+ = = * .       |
|+   + + +        |
| . . .   .       |
|    .   ..E      |
+-----------------+

[hadoop@namenode ~]$ cd .ssh

[hadoop@namenode .ssh]$ ls

id_rsa  id_rsa.pub  known_hosts

cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys

ssh datanode1 cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys

ssh datanode2 cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys

ssh datanode3 cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys

scp authorized_keys datanode1:~/.ssh/

scp authorized_keys datanode2:~/.ssh/

scp authorized_keys datanode3:~/.ssh/

mkdir ~/.ssh 

cat ~/id_rsa.pub >> ~/.ssh/authorized_keys

ssh datanode1

exit

Setup ssh in every node such that they can communicate with one another without any prompt for password

$ ssh localhost

$ sudo apt-get openssh-server 

$ ssh-keygen -t rsa -P ""

$ cat $HOME/.ssh/id_rsa.pub >> $HOME/.ssh/authorized_keys

$ scp ~/.ssh/id_rsa.pub hadoop@slave01:/home/hadoop/

$ scp ~/.ssh/id_rsa.pub hadoop@slave02:/home/hadoop/

# Installing Hadoop

In the Namenode server, download and install Hadoop using the following commands

wget http://apache.mesi.com.ar/hadoop/common/hadoop-2.7.4/hadoop-2.7.4.tar.gz

$ sudo tar -zxf ~/download directory/hadoop-2.7.3.tar.gz -C /usr/local    # archive to /usr/local 

$ cd /usr/local/

$ sudo mv ./hadoop-2.7.3/ ./hadoop  # rename to hadoop

$ sudo chown -R hadoop ./hadoop  # change the permission

# Edit the .bashrc file

$ export HADOOP_HOME=/usr/local/hadoop

$ export PATH=$PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin

$ source ~/.bashrc

# Configuring Hadoop

You have to configure Hadoop server by making the following changes as given below.

$ sudo nano core-site.xml

<configuration>
  
        <property>
        
                <name>fs.defaultFS</name>
                
                <value>hdfs://192.168.107.200:9000</value>
                
        </property>
        
        <property>
        
                <name>hadoop.tmp.dir</name>
                
                <value>file:/usr/local/hadoop/tmp</value>
                
                <description>Abase for other temporary directories.</description>
                
        </property>
        
</configuration>

$ sudo nano hdfs-site.xml

<configuration> 
  
        <property>
        
                <name>dfs.namenode.secondary.http-address</name>
                
                <value>http://192.168.107.200:50090</value>
                
        </property>
        
        <property>
        
                <name>dfs.replication</name>
                
                <value>3</value>
                
        </property>
        
        <property>
        
                <name>dfs.namenode.name.dir</name>
                
                <value>file:/usr/local/hadoop/tmp/dfs/name</value>
                
        </property>
        
        <property>
        
                <name>dfs.datanode.data.dir</name>
                
                <value>file:/usr/local/hadoop/tmp/dfs/data</value>
                
        </property>
        
</configuration>

$ sudo nano mapred-site.xml 

<configuration>
  
    <property>
    
        <name>mapred.job.tracker</name>
        
        <value>http://192.168.107.200:9001</value>
        
    </property>
    
</configuration>

$ sudo nano yarn-site.xml

<configuration>

<!-- Site specific YARN configuration properties -->

    <property>
    
        <name>yarn.nodemanager.aux-services</name>
        
        <value>mapreduce_shuffle</value>
        
    </property>
    
    <property>
    
        <name>yarn.resourcemanager.hostname</name>
        
        <value>master</value>
        
    </property>
    
</configuration>

# Edit /usr/local/hadoop/etc/hadoop/slaves files 

192.168.107.201

192.168.107.202

192.168.107.203

After configuration, copy the /usr/local/Hadoop directory in namenode to datanode1, datanode2 and datanode3.

in namenode server, running the following command

cd /usr/local/

rm -rf ./hadoop/tmp   # delete the tem file

rm -rf ./hadoop/logs/*   # delete the logs file

tar -zcf ~/hadoop.master.tar.gz ./hadoop

cd ~

scp ./hadoop.master.tar.gz datanode1:/home/hadoop

scp ./hadoop.master.tar.gz datanode2:/home/hadoop

run the following command in datanode1, datanode2 and datanode3

sudo rm -rf /usr/local/hadoop/

sudo tar -zxf ~/hadoop.master.tar.gz -C /usr/local

sudo chown -R hadoop /usr/local/hadoop

# Starting Hadoop Services in namenode

cd /usr/local/hadoop

bin/hdfs namenode -format

sbin/start-all.sh

# checking status

JPS








