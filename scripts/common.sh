#!/bin/bash

# Specify here the versions for all products
HADOOP_VERSION=2.7.1
SPARK_VERSION=1.5.0
SPARK_HADOOP_VERSION=2.6
FLINK_VERSION=0.9.1
JAVA_ARCHIVE=jdk-8u45-linux-i586.tar.gz

# YOU SHOULDN'T CHANGE ANYTHING FROM HERE
#java
JAVA_MAJOR_VERSION=`echo $JAVA_ARCHIVE | cut -d '-' -f 2 | cut -c1`
JAVA_BUILD_VERSION=`echo $JAVA_ARCHIVE | cut -d '-' -f 2 | cut -c3-4`
#hadoop
HADOOP_PREFIX=/usr/local/hadoop
HADOOP_CONF=$HADOOP_PREFIX/etc/hadoop
HADOOP_VERSION=hadoop-$HADOOP_VERSION
HADOOP_ARCHIVE=$HADOOP_VERSION.tar.gz
HADOOP_MIRROR_DOWNLOAD=../resources/hadoop-$HADOOP_VERSION.tar.gz
HADOOP_RES_DIR=/vagrant/resources/hadoop
#spark
SPARK_VERSION=spark-$SPARK_VERSION
SPARK_ARCHIVE=$SPARK_VERSION-bin-hadoop$SPARK_HADOOP_VERSION.tgz
SPARK_MIRROR_DOWNLOAD=../resources/spark-$SPARK_VERSION-bin-hadoop$SPARK_HADOOP_VERSION.tgz
SPARK_RES_DIR=/vagrant/resources/spark
SPARK_CONF_DIR=/usr/local/spark/conf
#ssh
SSH_RES_DIR=/vagrant/resources/ssh
RES_SSH_COPYID_ORIGINAL=$SSH_RES_DIR/ssh-copy-id.original
RES_SSH_COPYID_MODIFIED=$SSH_RES_DIR/ssh-copy-id.modified
RES_SSH_CONFIG=$SSH_RES_DIR/config

function resourceExists {
	FILE=/vagrant/resources/$1
	if [ -e $FILE ]
	then
		return 0
	else
		return 1
	fi
}

function fileExists {
	FILE=$1
	if [ -e $FILE ]
	then
		return 0
	else
		return 1
	fi
}

#echo "common loaded"
