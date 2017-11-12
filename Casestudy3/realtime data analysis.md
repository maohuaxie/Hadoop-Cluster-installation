# Topics are covered in this case study as bleow:

1: realtime order data will be sending to kafka with topic "gender":

2: Spark Streaming will read "gender" topic data per 5 second and preprocessing these data:

3: Spark will send the preprocessing data to kafka as topic "result":

4: Flask will build a web App to take the data of topic "result":

5: With Flask-SocketIO, we can show the realtime data to customers:

6: with js socketio and js hightlights.js can show the data intutively and dynamiclly:
