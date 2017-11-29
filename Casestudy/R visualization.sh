###### R visulization ######

# start mysql service 
service mysql start
mysql -u root -p

use dblab;
select * from user_action limit 10;


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

## go to R console
library(RMySQL)
conn <- dbConnect(MySQL(),dbname='dblab',username='root',password='hadoop',host="127.0.0.1",port=3306)
user_action <- dbGetQuery(conn,'select * from user_action')

> library(RMySQL)
> conn <- dbConnect(MySQL(),dbname='dblab',username='root',password='hadoop',host="127.0.0.1",port=3306)
> user_action <- dbGetQuery(conn,'select * from user_action')

> library(RMySQL)
Loading required package: DBI
> conn <- dbConnect(MySQL(),dbname='dblab',username='root',password='hadoop',host="127.0.0.1",port=3306)
> user_action <- dbGetQuery(conn,'select * from user_action')
> summary(user_action$behavior_type)
   Length     Class      Mode 
 23291027 character character 
> summary(as.numeric(user_action$behavior_type))
   Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
  1.000   1.000   1.000   1.106   1.000   4.000 
### we have 23291027 records, it take a while to finish loading the data

### summarize the customer behavior data

> summary(user_action$behavior_type)
   Length     Class      Mode 
   300000 character character 
> summary(as.numeric(user_action$behavior_type))
   Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
  1.000   1.000   1.000   1.105   1.000   4.000 
> library(ggplot2)
ggplot(user_action,aes(as.numeric(behavior_type)))+geom_histogram()Need help getting started? Try the cookbook for R:
http://www.cookbook-r.com/Graphs/
> ggplot(user_action,aes(as.numeric(behavior_type)))+geom_histogram()
`stat_bin()` using `bins = 30`. Pick better value with `binwidth`.
> 

### With ggplot2 graph, we can intuitively see the customer behavior type

## The picture are seperated in new pdf file, labeled as Figure1:

### get the top 10 sales items and total numbers:

temp <- subset(user_action,as.numeric(behavior_type)==4) 
count <- sort(table(temp$item_category),decreasing = T) 
print(count[1:10])


 conn <- dbConnect(MySQL(),dbname='dblab',username='root',password='hadoop',host="127.0.0.1",port=3306)
> user_action <- dbGetQuery(conn,'select * from user_action')
> library(ggplot2)
> ggplot(user_action,aes(as.numeric(behavior_type)))+geom_histogram()
`stat_bin()` using `bins = 30`. Pick better value with `binwidth`.
> temp <- subset(user_action,as.numeric(behavior_type)==4) 
> count <- sort(table(temp$item_category),decreasing = T) 
> print(count[1:10])

 6344  1863  5232 12189  7957  4370 13230 11537  1838  5894 
   79    46    45    42    40    34    33    32    31    30 


result <- as.data.frame(count[1:10]) 
ggplot(result,aes(Var1,Freq,col=factor(Var1)))+geom_point()

#### you will find the ggplot2 picture in a seperated pdf file, labeled as Figure2:

#### get the top sales months

month <- substr(user_action$visit_date,6,7) 
user_action <- cbind(user_action,month) 

> month <- substr(user_action$visit_date,6,7) 
> user_action <- cbind(user_action,month) 
> ggplot(user_action,aes(as.numeric(behavior_type),col=factor(month)))+geom_histogram()+facet_grid(.~month)
`stat_bin()` using `bins = 30`. Pick better value with `binwidth`.
> 

#### you will get the ggplot2 graph in a seperated pdf file, labeled as Figure3:

#### get top sales provinces 

library(recharts)
rel <- as.data.frame(table(temp$province))
provinces <- rel$Var1
x = c()
for(n in provinces){
x[length(x)+1] = nrow(subset(temp,(province==n)))
}
mapData <- data.frame(province=rel$Var1,
count=x, stringsAsFactors=F)  
eMap(mapData, namevar=~province, datavar = ~count) 

#### you will get the ggplot2 graph in a seperated pdf file, labeled as Figure4:
