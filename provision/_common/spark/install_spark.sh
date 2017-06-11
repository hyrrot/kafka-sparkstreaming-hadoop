#!/bin/bash -ex

SPARK_DOWNLOAD_URL=http://ftp.jaist.ac.jp/pub/apache/spark/spark-2.1.1/spark-2.1.1-bin-hadoop2.7.tgz
SPARK_ARCHIVE_FILENAME=${SPARK_DOWNLOAD_URL##*/}
SPARK_DIRECTORY_NAME=${SPARK_ARCHIVE_FILENAME%.*}

cp /vagrant/provision/_downloaded_files/$SPARK_ARCHIVE_FILENAME ~/
tar zxf ${SPARK_ARCHIVE_FILENAME}
ln -s $SPARK_DIRECTORY_NAME spark
