#!/bin/bash -ex

source /vagrant/provision/_common/kafka/install_kafka.sh

pushd kafka

    kafka_nodes=`cat /etc/hosts | grep "kafka-zk" | grep -v "127.0.0.1" | awk '{print $2}'`
    for line in $kafka_nodes ; do
        zookeeper_endpoints="${line}:2181,$zookeeper_endpoints"
    done

    # Setup Broker
    sed -i -e "s/broker.id=0/broker.id=$1/g" config/server.properties
    sed -i -e "s/zookeeper.connect=localhost:2181/zookeeper.connect=${zookeeper_endpoints%,}/g" config/server.properties
    mkdir logs
    bin/kafka-server-start.sh config/server.properties > logs/kafka.out 2> logs/kafka.err &

    # Setup topic
    if [ $1 -eq $2 ]; then
      sleep 30
      ./bin/kafka-topics.sh --zookeeper ${zookeeper_endpoints%,} --create --topic mytopic --partitions 3 --replication-factor 2
    fi

popd
