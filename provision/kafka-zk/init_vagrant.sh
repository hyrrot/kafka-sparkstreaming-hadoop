#!/bin/bash -ex

source /vagrant/provision/_common/kafka/install_kafka.sh

pushd kafka
    # Setup Zookeeper
    echo "tickTime=2000" >> config/zookeeper.properties
    echo "initLimit=5" >> config/zookeeper.properties
    echo "syncLimit=2" >> config/zookeeper.properties

    zookeeper_endpoints=""

    kafka_nodes=`cat /etc/hosts | grep "kafka-zk" | grep -v "127.0.0.1" | awk '{print $2}'`

    for line in $kafka_nodes ; do
        if [ ${line: -1} -eq $1 ]; then
            echo server.${line: -1}=0.0.0.0:2888:3888 ;
        else
            echo server.${line: -1}=${line}:2888:3888 ;
        fi
        zookeeper_endpoints="${line}:2181,$zookeeper_endpoints"
    done >> config/zookeeper.properties

    mkdir -p /tmp/zookeeper
    echo $1 > /tmp/zookeeper/myid
    mkdir logs
    echo $JAVA_HOME
    bin/zookeeper-server-start.sh config/zookeeper.properties > logs/zookeeper.out 2> logs/zookeeper.err &

    # Setup Broker
    #sed -i -e "s/broker.id=0/broker.id=$1/g" config/server.properties
    #sed -i -e "s/zookeeper.connect=localhost:2181/zookeeper.connect=${zookeeper_endpoints%,}/g" config/server.properties
    #bin/kafka-server-start.sh config/server.properties > logs/kafka.out 2> logs/kafka.err &

popd
