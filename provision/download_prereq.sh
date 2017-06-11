#!/bin/bash -e

KAFKA_DOWNLOAD_URL="http://ftp.yz.yamagata-u.ac.jp/pub/network/apache/kafka/0.10.2.1/kafka_2.12-0.10.2.1.tgz"
SPARK_DOWNLOAD_URL="http://ftp.jaist.ac.jp/pub/apache/spark/spark-2.1.1/spark-2.1.1-bin-hadoop2.7.tgz"
JDK_DOWNLOAD_URL="http://download.oracle.com/otn-pub/java/jdk/8u112-b15/jdk-8u112-linux-x64.tar.gz"

DOWNLOAD_DIR=$(dirname $0)/_downloaded_files


if [ ! -e $DOWNLOAD_DIR/${KAFKA_DOWNLOAD_URL##*/} ]; then
  wget ${KAFKA_DOWNLOAD_URL} -P $DOWNLOAD_DIR
fi

if [ ! -e $DOWNLOAD_DIR/${SPARK_DOWNLOAD_URL##*/} ]; then
  wget ${SPARK_DOWNLOAD_URL} -P $DOWNLOAD_DIR
fi

if [ ! -e $DOWNLOAD_DIR/${JDK_DOWNLOAD_URL##*/} ]; then
  wget --no-check-certificate --no-cookies \
  --header "Cookie: oraclelicense=accept-securebackup-cookie" \
  http://download.oracle.com/otn-pub/java/jdk/8u112-b15/jdk-8u112-linux-x64.tar.gz \
  -P $DOWNLOAD_DIR
fi
