
# Topics are covered in this case study as bleow:

1: realtime order data will be sending to kafka with topic "gender":

2: Spark Streaming will read "gender" topic data per 5 second and preprocessing these data:

3: Spark will send the preprocessing data to kafka as topic "result":

4: Flask will build a web App to take the data of topic "result":

5: With Flask-SocketIO, we can show the realtime data to customers:

6: with js socketio and js hightlights.js can show the data intutively and dynamiclly:

software required:

Ubuntu: 16.04

Spark: 2.1.0

Scala: 2.11.8

kafka: 0.8.2.2

Python: 3.x(3.0 higher version)

Flask: 0.12.1

Flask-SocketIO: 2.8.6

kafka-python： 1.3.3

software installation:

pip3 install flask

pip3 install flask-socketio

pip3 install kafka-python

PyCharm installation:

tar -zxvf ~/download/pycharm-community-2017.2.4.tar.gz

mv ~/downlaod/pycharm-community-2017.2.4 ~/pycharm

cd ~/pycharm

./bin/pycharm.sh
