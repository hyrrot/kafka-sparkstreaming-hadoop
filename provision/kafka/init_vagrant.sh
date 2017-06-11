#!/bin/bash -ex

KAFKA_DOWNLOAD_URL="http://ftp.yz.yamagata-u.ac.jp/pub/network/apache/kafka/0.10.2.1/kafka_2.12-0.10.2.1.tgz"
KAFKA_ARCHIVE_FILENAME=${KAFKA_DOWNLOAD_URL##*/}
KAFKA_DIRECTORY_NAME=${KAFKA_ARCHIVE_FILENAME%.*}

cd
wget -q $KAFKA_DOWNLOAD_URL
tar zxf $KAFKA_ARCHIVE_FILENAME
ln -s $KAFKA_DIRECTORY_NAME kafka

pushd kafka
    # Setup Zookeeper
    echo "tickTime=2000" >> config/zookeeper.properties
    echo "initLimit=5" >> config/zookeeper.properties
    echo "syncLimit=2" >> config/zookeeper.properties

    kafka_nodes=`cat /etc/hosts | grep "kafka" | grep -v "127.0.0.1" | awk '{print $2}'`

    for line in $kafka_nodes ; do
        if [ ${line: -1} -eq $1 ]; then
            echo server.${line: -1}=0.0.0.0:2888:3888 ;
        else
            echo server.${line: -1}=${line}:2888:3888 ;
        fi
    done >> config/zookeeper.properties

    mkdir -p /tmp/zookeeper
    echo $1 > /tmp/zookeeper/myid
    mkdir logs
    echo $JAVA_HOME
    bin/zookeeper-server-start.sh config/zookeeper.properties > logs/zookeeper.out 2> logs/zookeeper.err &

    # Setup Broker
    sed -i -e "s/broker.id=0/broker.id=$1/g" config/server.properties
    sed -i -e "s/zookeeper.connect=localhost:2181/zookeeper.connect=${zookeeper_endpoints%,}/g" config/server.properties
    bin/kafka-server-start.sh config/server.properties > logs/kafka.out 2> logs/kafka.err &


popd
