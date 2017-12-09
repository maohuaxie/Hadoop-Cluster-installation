# Docker install Hadoop multiple nodes platform
For installing Docker, you have to update your linux kernel to over 3.10. Checking your linux kernel with uname -r 
uname -r
## update apt
sudo apt-get update
sudo apt-get install apt-transport-https ca-certificates
## add on new GPG key
sudo apt-key adv \
               --keyserver hkp://ha.pool.sks-keyservers.net:80 \
               --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
## add on Docker source 
echo deb https://apt.dockerproject.org/repo ubuntu-xenial main | sudo tee /etc/apt/sources.list.d/docker.list
## update apt again 
sudo apt-get update

## check Docker source 

apt-cache policy docker-engine

docker-engine:
  Installed: (none)
  Candidate: 17.05.0~ce-0~ubuntu-xenial
  Version table:
     17.05.0~ce-0~ubuntu-xenial 500
        500 https://apt.dockerproject.org/repo ubuntu-xenial/main amd64 Packages
     17.04.0~ce-0~ubuntu-xenial 500
        500 https://apt.dockerproject.org/repo ubuntu-xenial/main amd64 Packages
     17.03.1~ce-0~ubuntu-xenial 500
        500 https://apt.dockerproject.org/repo ubuntu-xenial/main amd64 Packages
     17.03.0~ce-0~ubuntu-xenial 500
        500 https://apt.dockerproject.org/repo ubuntu-xenial/main amd64 Packages
     1.13.1-0~ubuntu-xenial 500
        500 https://apt.dockerproject.org/repo ubuntu-xenial/main amd64 Packages
     1.13.0-0~ubuntu-xenial 500
        500 https://apt.dockerproject.org/repo ubuntu-xenial/main amd64 Packages
     1.12.6-0~ubuntu-xenial 500
        500 https://apt.dockerproject.org/repo ubuntu-xenial/main amd64 Packages
     1.12.5-0~ubuntu-xenial 500
        500 https://apt.dockerproject.org/repo ubuntu-xenial/main amd64 Packages
     1.12.4-0~ubuntu-xenial 500
        500 https://apt.dockerproject.org/repo ubuntu-xenial/main amd64 Packages
     1.12.3-0~xenial 500
        500 https://apt.dockerproject.org/repo ubuntu-xenial/main amd64 Packages
     1.12.2-0~xenial 500
        500 https://apt.dockerproject.org/repo ubuntu-xenial/main amd64 Packages
     1.12.1-0~xenial 500
        500 https://apt.dockerproject.org/repo ubuntu-xenial/main amd64 Packages
     1.12.0-0~xenial 500
        500 https://apt.dockerproject.org/repo ubuntu-xenial/main amd64 Packages
     1.11.2-0~xenial 500
        500 https://apt.dockerproject.org/repo ubuntu-xenial/main amd64 Packages
     1.11.1-0~xenial 500
        500 https://apt.dockerproject.org/repo ubuntu-xenial/main amd64 Packages
     1.11.0-0~xenial 500
        500 https://apt.dockerproject.org/repo ubuntu-xenial/main amd64 Packages
		
### Install Docker
sudo apt-get install docker-engine

### start Docker
sudo service docker start

### check whether Docker is working or not with hello-word source code provided by Docker community

sudo docker run hello-world

Unable to find image 'hello-world:latest' locally
latest: Pulling from library/hello-world
ca4f61b1923c: Pull complete 
Digest: sha256:be0cd392e45be79ffeffa6b05338b98ebb16c87b255f48e297ec7f98e123905c
Status: Downloaded newer image for hello-world:latest

Hello from Docker!
This message shows that your installation appears to be working correctly.

To generate this message, Docker took the following steps:
 1. The Docker client contacted the Docker daemon.
 2. The Docker daemon pulled the "hello-world" image from the Docker Hub.
    (amd64)
 3. The Docker daemon created a new container from that image which runs the
    executable that produces the output you are currently reading.
 4. The Docker daemon streamed that output to the Docker client, which sent it
    to your terminal.

To try something more ambitious, you can run an Ubuntu container with:
 $ docker run -it ubuntu bash

Share images, automate workflows, and more with a free Docker ID:
 https://cloud.docker.com/

For more examples and ideas, visit:
 https://docs.docker.com/engine/userguide/
 
when you see this, you are good to go.
Hello from Docker!
This message shows that your installation appears to be working correctly. 

### Only root user can excute Docker commmand right now. we need add new user and group to Docker.

sudo groupadd docker

### add current user to docer 
sudo usermod -aG docker maohuaxie

### install ubuntu on Docker, docker pull could pull ubuntu to local from Docker hub

docker pull ubuntu

### check the Docker pull status 
maohuaxie@maohuaxie-virtual-machine:~$ sudo docker pull ubuntu
Using default tag: latest
latest: Pulling from library/ubuntu
660c48dd555d: Pull complete 
4c7380416e78: Pull complete 
421e436b5f80: Pull complete 
e4ce6c3651b3: Pull complete 
be588e74bd34: Pull complete 
Digest: sha256:7c67a2206d3c04703e5c23518707bdd4916c057562dd51c74b99b2ba26af0f79
Status: Downloaded newer image for ubuntu:latest
maohuaxie@maohuaxie-virtual-machine:~$ docker images
Got permission denied while trying to connect to the Docker daemon socket at unix:///var/run/docker.sock: Get http://%2Fvar%2Frun%2Fdocker.sock/v1.29/images/json: dial unix /var/run/docker.sock: connect: permission denied
maohuaxie@maohuaxie-virtual-machine:~$ sudo docker images
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
hello-world         latest              f2a91732366c        2 weeks ago         1.85kB
ubuntu              latest              20c44cd7596f        3 weeks ago         123MB

### if you find the above info, that means Docker pull is good
cd ~
mkdir build
docker run -it -v /home/maohuaxie/build:/root/build --name ubuntu ubuntu
* docker run # running a mirror
* -i # interactive ；-t # assign tty，we can think of a control panel；
* -v 
* --name ubuntu 
* ubuntu 

maohuaxie@maohuaxie-virtual-machine:~$ sudo docker run -it -v /home/maohuaxie/build:/root/build --name ubuntu ubuntu
docker: Error response from daemon: Conflict. The container name "/ubuntu" is already in use by container "1875a1eefc07b97050702891c5e058295aeddde2d73eb94d0519bda70876df6d". You have to remove (or rename) that container to be able to reuse that name.
See 'docker run --help'.
maohuaxie@maohuaxie-virtual-machine:~$ sudo docker rm /ubuntu
/ubuntu
maohuaxie@maohuaxie-virtual-machine:~$ sudo docker run -it -v /home/maohuaxie/build:/root/build --name ubuntu ubuntu
root@3ba3d66ebfd0:/#
## conficuration of new installed ubuntu platform 
apt-get update
apt-get install nano
apt-get install ssh
/etc/init.d/ssh start

## set up sshd
ssh-keygen -t rsa # enter 
cat id_dsa.pub >> authorized_keys
## install JDK
export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64/
export PATH=$PATH:$JAVA_HOME/bin
source ~/.bashrc
## keep Docker file
docker login

maohuaxie@maohuaxie-virtual-machine:~$ sudo docker login
[sudo] password for maohuaxie: 
Login with your Docker ID to push and pull images from Docker Hub. If you don't have a Docker ID, head over to https://hub.docker.com to create one.
Username: maohuaxie
Password: 
Login Succeeded
maohuaxie@maohuaxie-virtual-machine:~$ 

### after login, please save the docer to current status
maohuaxie@maohuaxie-virtual-machine:~$ sudo docker ps
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES
3ba3d66ebfd0        ubuntu              "/bin/bash"         2 hours ago         Up 2 hours                              ubuntu
maohuaxie@maohuaxie-virtual-machine:~$ 

sudo docker commit 3ba3d66ebfd0 ubuntu/jdkinstalled
sha256:6a5bd5d0ccf815242229c3c979a45577b337a9b59ce7f77e00cb899b770b1779
maohuaxie@maohuaxie-virtual-machine:~$

maohuaxie@maohuaxie-virtual-machine:~$ sudo docker images
REPOSITORY            TAG                 IMAGE ID            CREATED              SIZE
ubuntu/jdkinstalled   latest              6a5bd5d0ccf8       About a minute ago   576MB
hello-world           latest              f2a91732366c        2 weeks ago          1.85kB
ubuntu                latest              20c44cd7596f        3 weeks ago          123MB
maohuaxie@maohuaxie-virtual-machine:~$ 

### install hadoop 

sudo docker run -it -v /home/maohuaxie/build:/root/build --name ubuntu-jdkinstalled ubuntu/jdkinstalled

## Download hadoop file and save to /home/hadoop/build, and then under Docer /root/build folder, we can finde Hadoop install file
cd /root/build
tar -zxvf hadoop-2.7.3.tar.gz -C /usr/local

## For now, we finshed installation of hadoop singel nodes

cd /usr/local/hadoop
./bin/hadoop version

## set up hadoop cluster
## suppose you are in /usr/local/hadoop foler
vim etc/hadoop/hadoop-env.sh
## replace export JAVA_HOME=${JAVA_HOME} with the following one
export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64/

## vim core-site.xml

<configuration>
      <property>
          <name>hadoop.tmp.dir</name>
          <value>file:/usr/local/hadoop/tmp</value>
          <description>Abase for other temporary directories.</description>
      </property>
      <property>
          <name>fs.defaultFS</name>
          <value>hdfs://master:9000</value>
      </property>
</configuration>

## vim hdfs-site.xml

root@b3d80b512ae8:/usr/local/hadoop/etc/hadoop# vim core-site.xml
root@b3d80b512ae8:/usr/local/hadoop/etc/hadoop# vim hdfs-site.xml

<configuration>
    <property>
        <name>dfs.namenode.name.dir</name>
        <value>file:/usr/local/hadoop/namenode_dir</value>
    </property>
    <property>
        <name>dfs.datanode.data.dir</name>
        <value>file:/usr/local/hadoop/datanode_dir</value>
    </property>
    <property>
        <name>dfs.replication</name>
        <value>3</value>
    </property>
</configuration>


### change mapred-site.xml.template to mapred-site.xml, and input the following content
root@b3d80b512ae8:/usr/local/hadoop/etc/hadoop# cp mapred-site.xml.template mapred-site.xml         
root@b3d80b512ae8:/usr/local/hadoop/etc/hadoop# vim mapred-site.xml

 <configuration>
    <property>
        <name>mapreduce.framework.name</name>
        <value>yarn</value>
    </property>
  </configuration>


### configuration of yarn file   
vim yarn-site.xml

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

### For now, we need save the Doker file

docker commit b3d80b512ae8 ubuntu/hadoopinstalled

### open three new consoles 

# first one 
sudo docker run -it -h master --name master ubuntu/hadoopinstalled
# second one
sudo docker run -it -h slave01 --name slave01 ubuntu/hadoopinstalled
# third one
sudo docker run -it -h slave02 --name slave02 ubuntu/hadoopinstalled

### assign ip address to master, slaveo1 and slaveo2 virtual-machine. 
cat /etc/hosts # print out the ip address
172.18.0.4      master
172.18.0.5      slave01
172.18.0.6      slave02

## copy ip address to master, slave01 and slave02 machine
## ping machine with master machine
ssh slave01
ssh slave02

###

vim etc/hadoop/slaves

slave01
slave02

##
cd /usr/local/hadoop
bin/hdfs namenode -format
sbin/start-all.sh
