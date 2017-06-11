#!/bin/bash -ex

KAFKA_DOWNLOAD_URL="http://ftp.yz.yamagata-u.ac.jp/pub/network/apache/kafka/0.10.2.1/kafka_2.12-0.10.2.1.tgz"
KAFKA_ARCHIVE_FILENAME=${KAFKA_DOWNLOAD_URL##*/}
KAFKA_DIRECTORY_NAME=${KAFKA_ARCHIVE_FILENAME%.*}

cd
cp /vagrant/provision/_downloaded_files/$KAFKA_ARCHIVE_FILENAME ~/
tar zxf $KAFKA_ARCHIVE_FILENAME
ln -s $KAFKA_DIRECTORY_NAME kafka
