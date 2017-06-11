#!/bin/bash -ex

source /vagrant/provision/_common/spark/install_spark.sh

ip_address=`cat /etc/hosts | grep "spark-master${1}" | grep -v "127.0.0.1" | awk '{print $1}'`

pushd spark
  ./sbin/start-master.sh --host ${ip_address}
popd
