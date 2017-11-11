############# predict return customer with Spark ##########
############################################################

## preprocessing test.csv and train.csv data sets
## descript data sets

user_id 
age_range | 1: age <18,2 age in [18,24]，3 age in [25,29]，4 age in [30,34]，5 age in [35,39]，6 age in [40,49]，7 and 8 age >=50, 0 and NULL unkown 
gender | gender:0 female，1 male，2 and NULL unkown 
merchant_id | 
label ，0 not return customer，1 return customer，-1 outlier, NULL only exist in text file, it is required to predict
## we have to clean test.csv file and delete lable1 value if value is -1, keep null value and assume null value is 1:

cd /usr/local/dbtaobao/dataset
vim predeal_test.sh

#!/bin/bash
infile=$1
outfile=$2
$infile > $outfile must follow up }’
awk -F "," 'BEGIN{
      id=0;
    }
    {
        if($1 && $2 && $3 && $4 && !$5){
            id=id+1;
            print $1","$2","$3","$4","1
            if(id==10000){
                exit
            }
        }
    }' $infile > $outfile
	
	
sudo chmod +x ./predeal_test.sh
./predeal_test.sh ./test.csv ./test_after.csv

cd /usr/local/dbtaobao/dataset
vim predeal_train.sh

#!/bin/bash
infile=$1
outfile=$2
$infile > $outfile must followup }’
awk -F "," 'BEGIN{
         id=0;
    }
    {
        if($1 && $2 && $3 && $4 && ($5!=-1)){
            id=id+1;
            print $1","$2","$3","$4","$5
            if(id==10000){
                exit
            }
        }
    }' $infile > $outfile

sudo chmod +x ./predeal_train.sh
./predeal_train.sh ./train.csv ./train_after.csv

### predict return customer 
## start hadoop, spark service 
cd /usr/local/hadoop/
sbin/start-dfs.sh

### copy data to HDFS

bin/hadoop fs -mkdir -p /dbtaobao/dataset
bin/hadoop fs -put /usr/local/dbtaobao/dataset/train_after.csv /dbtaobao/dataset
bin/hadoop fs -put /usr/local/dbtaobao/dataset/test_after.csv /dbtaobao/dataset

### start mysql service 

service mysql start
mysql -uroot -p

use dbtaobao;

### start Spark shell

Spark MLlib buid in SVM pakage will be used to predict the return customer 
####

Welcome to
      ____              __
     / __/__  ___ _____/ /__
    _\ \/ _ \/ _ `/ __/  '_/
   /___/ .__/\_,_/_/ /_/\_\   version 2.1.0
      /_/
         
Using Scala version 2.11.8 (OpenJDK 64-Bit Server VM, Java 1.8.0_151)
Type in expressions to have them evaluated.
Type :help for more information.

scala> import org.apache.spark.SparkConf
import org.apache.spark.SparkConf

scala> import org.apache.spark.SparkContext
import org.apache.spark.SparkContext

scala> import org.apache.spark.mllib.regression.LabeledPoint
import org.apache.spark.mllib.regression.LabeledPoint

scala> import org.apache.spark.mllib.linalg.{Vectors,Vector}
import org.apache.spark.mllib.linalg.{Vectors, Vector}

scala> import org.apache.spark.mllib.classification.{SVMModel, SVMWithSGD}
import org.apache.spark.mllib.classification.{SVMModel, SVMWithSGD}

scala> import org.apache.spark.mllib.evaluation.BinaryClassificationMetrics
import org.apache.spark.mllib.evaluation.BinaryClassificationMetrics

scala> import java.util.Properties
import java.util.Properties

scala> import org.apache.spark.sql.types._
import org.apache.spark.sql.types._

scala> import org.apache.spark.sql.Row
import org.apache.spark.sql.Row

scala> 

##### loading train data

val train_data = sc.textFile("/dbtaobao/dataset/train_after.csv")
val test_data = sc.textFile("/dbtaobao/dataset/test_after.csv")


### train model 

val train= train_data.map{line =>
  val parts = line.split(',')
  LabeledPoint(parts(4).toDouble,Vectors.dense(parts(1).toDouble,parts
(2).toDouble,parts(3).toDouble))
}
val test = test_data.map{line =>
  val parts = line.split(',')
  LabeledPoint(parts(4).toDouble,Vectors.dense(parts(1).toDouble,parts(2).toDouble,parts(3).toDouble))
}

#### evaluate model
model.clearThreshold()
val scoreAndLabels = test.map{point =>
  val score = model.predict(point.features)
  score+" "+point.label
}
scoreAndLabels.foreach(println

model.setThreshold(0.0)
scoreAndLabels.foreach(println)

model.clearThreshold()
val scoreAndLabels = test.map{point =>
  val score = model.predict(point.features)
  score+" "+point.label
}
//
val rebuyRDD = scoreAndLabels.map(_.split(" "))

val schema = StructType(List(StructField("score", StringType, true),StructField("label", StringType, true)))

val rowRDD = rebuyRDD.map(p => Row(p(0).trim, p(1).trim))

val rebuyDF = spark.createDataFrame(rowRDD, schema)

val prop = new Properties()
prop.put("user", "root") 
prop.put("password", "hadoop") 
prop.put("driver","com.mysql.jdbc.Driver") 

rebuyDF.write.mode("append").jdbc("jdbc:mysql://localhost:3306/dbtaobao", "dbtaobao.rebuy", prop)
