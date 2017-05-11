#!/bin/bash -ex

# Install JDK
cd
wget -q --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/8u112-b15/jdk-8u112-linux-x64.tar.gz
tar zxf jdk-8u112-linux-x64.tar.gz
ln -s jdk1.8.0_112 jdk

echo "export JAVA_HOME=~/jdk" >> ~/.bashrc