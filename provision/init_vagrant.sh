#!/bin/bash -ex

# Install JDK
cd
cp /vagrant/provision/_downloaded_files/jdk-8u112-linux-x64.tar.gz ~/
tar zxf jdk-8u112-linux-x64.tar.gz
ln -s jdk1.8.0_112 jdk

echo "export JAVA_HOME=~/jdk" >> ~/.bashrc
