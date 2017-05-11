#!/bin/bash -ex

KAFKA_DOWNLOAD_URL="http://ftp.yz.yamagata-u.ac.jp/pub/network/apache/kafka/0.10.2.1/kafka_2.12-0.10.2.1.tgz"

cd
wget -q $KAFKA_DOWNLOAD_URL
tar zxf kafka_2.12-0.10.2.1.tgz
ln -s kafka_2.12-0.10.2.1 kafka

