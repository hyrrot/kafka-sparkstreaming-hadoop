#!/bin/bash -ex

source /vagrant/provision/_common/spark/install_spark.sh

pushd spark
  ./sbin/start-master.sh
popd
