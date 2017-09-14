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







