/**
  * Created by hyrrot on 2017/05/13.
  */

import org.apache.kafka.clients.consumer.ConsumerRecord
import org.apache.kafka.common.serialization.StringDeserializer
import org.apache.spark.streaming.kafka010._
import org.apache.spark.streaming.kafka010.LocationStrategies.PreferConsistent
import org.apache.spark.streaming.kafka010.ConsumerStrategies.Subscribe

import org.apache.spark.SparkContext
import org.apache.spark.SparkContext._
import org.apache.spark.SparkConf

import org.apache.spark.streaming._

import kafka.common.TopicAndPartition


object KafkaSparkStreamingHadoop {

  def main(args: Array[String]) {
    val conf = new SparkConf().setAppName("Simple Application")

    val sc = new SparkContext("local[2]", "streaming-example")
    val streamingContext = new StreamingContext(sc, Seconds(1))

    val kafkaParams = Map[String, Object](
      "bootstrap.servers" -> "192.168.1.14:9092",
      "key.deserializer" -> classOf[StringDeserializer],
      "value.deserializer" -> classOf[StringDeserializer],
      "group.id" -> "use_a_separate_group_id_for_each_stream",
      "auto.offset.reset" -> "latest",
      "enable.auto.commit" -> (false: java.lang.Boolean)
    )

    val t = new TopicAndPartition("", 0)

    val topics = Array("mytopic")
    val stream = KafkaUtils.createDirectStream[String, String](
      streamingContext,
      PreferConsistent,
      Subscribe[String, String](topics, kafkaParams)
    )

    // key = uuid
    // value = log line string
    // state = (request string, response string)
    // Return value = (key, request string, response string)
    def trackStateFunc(batchTime: Time, key: String, value: Option[String], state: State[(String, String)]): Option[(String, String, String)] = {
      val currentReqAndRes = state.getOption.getOrElse(("", ""))
      val newValue = value match {
        case Some(logLine) =>
          logLine.split("|")(2) match {
            case "req" =>
              (logLine, currentReqAndRes._2)
            case "res" =>
              (currentReqAndRes._1, logLine)
          }
        case None => currentReqAndRes
      }

      state.update(newValue)
      Some((key, newValue._1, newValue._2))
    }

    streamingContext.checkpoint("/tmp")

    val stateSpec = StateSpec.function(trackStateFunc _)
                            .numPartitions(2)
                            .timeout(Seconds(60))


    val s = stream.map(record => (record.key, record.value))
    val p = s.map(record => (record._2.split("|")(0), record._2))
             .mapWithState(stateSpec)

    p.print()


    streamingContext.start()
    streamingContext.awaitTermination()





  }




}
