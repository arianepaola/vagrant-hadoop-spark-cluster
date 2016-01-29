#!/bin/bash


HADOOP_HOME=/usr/local/hadoop
SPARK_HOME=/usr/local/spark
FLINK_HOME=/usr/local/flink

$HADOOP_PREFIX/sbin/hadoop-daemon.sh --config $HADOOP_CONF_DIR --script hdfs start namenode
$HADOOP_PREFIX/sbin/hadoop-daemons.sh --config $HADOOP_CONF_DIR --script hdfs start datanode

$HADOOP_YARN_HOME/sbin/yarn-daemon.sh --config $HADOOP_CONF_DIR start resourcemanager
$HADOOP_YARN_HOME/sbin/yarn-daemons.sh --config $HADOOP_CONF_DIR start nodemanager

# UI
echo "NameNode        : http://10.211.55.101:50070/dfshealth.html"
echo "ResourceManager : http://10.211.55.101:8088/cluster"

# could be restarted some day
#$HADOOP_YARN_HOME/sbin/yarn-daemon.sh start proxyserver --config $HADOOP_CONF_DIR
#$HADOOP_PREFIX/sbin/mr-jobhistory-daemon.sh start historyserver --config $HADOOP_CONF_DIR

if [ "$1" = "flink" ]
then
    $FLINK_HOME/bin/yarn-session.sh -n 3 -tm 1500
else
    echo "No argument, assuming spark"
    $SPARK_HOME/sbin/start-all.sh
    echo "Spark master : http://10.211.55.101:8080"
fi
