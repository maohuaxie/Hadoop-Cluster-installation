# case study customer web browsering behavior analysis 
# this case study will cover data preprocessing, storage, query and visulization 
# Linux、MySQL、Hadoop、HBase、Hive、Sqoop、R、Eclipse will be used in this case study
# The goals for this case study are as below:
# Learn how to install and implement Linux , MySQL、Hadoop、HBase、Hive、Sqoop、R、Eclipse
# Learn how to do big data analysis
# Learn how to import data between different databases
# visulize data by using R programming 
# query HBase databases with Jave in Eclipse

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

 
