#########data visulization with ECharts####### 
Echarts is a javascript graph library, it works for different browser, can give us intutively graph 
software needed:
Ubuntu16.04
ECharts
MySQL
Web App server: tomcat
IDE:Eclipse

Build tomcat+mysql+JSP platform

### check java version first

hadoop@dblab-VirtualBox:~$ java -version
openjdk version "1.8.0_151"
OpenJDK Runtime Environment (build 1.8.0_151-8u151-b12-0ubuntu0.16.04.2-b12)
OpenJDK 64-Bit Server VM (build 25.151-b12, mixed mode)

#### download the tomcat can work with java version 
#### go to download folder and unzip the tomcat file
cd ~/download/
unzip apache-tomcat-8.0.41.zip -d ~
### start mysql service 
### develop visulization Web App with Eclipse 


### download mysql-connector-java-5.1.44.zip

cd ~/download/
unzip mysql-connector-java-5.1.44.zip -d ~
cd ~/mysql-connector-java-5.1.44/
mv ./mysql-connector-java-5.1.44-bin.jar ~/workspace/MyWebApp/WebContent/WEB-INF/lib/mysql-connector-java-5.1.44-bin.jar

### let's do Dynamic Web Project with Eclipse
First open Eclipse, click File menu and create new Dynamic Web Project
input project name, and then click new runtime, you will get new sever runtime Environment, please choose Apache Tomcat v8.0
after that you will ask to install Apache Tomcat v8.0
go to New Server Runtime Environment and click finish
go to Dynamic Web Project to create MyWebApp project
MyWebApp project contains the following contents:
src dirctory will have sever java file
webContent direcotry will have css file, font file, img file and js directory will have JavaScript file
lib directory will have mysql-connector jar file 
