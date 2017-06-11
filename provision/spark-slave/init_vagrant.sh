#!/bin/bash -ex

source /vagrant/provision/_common/spark/install_spark.sh

pushd spark
  ./sbin/start-slave.sh spark://spark-master1:7077 --memory 1536M
popd

