#!/bin/bash

role=$1

if [ "$role" == "namenode" ]; then
    if [ ! -d "/opt/hadoop/data/nameNode/current" ]; then
        echo "Formatting Namenode..."
        $HADOOP_HOME/bin/hdfs namenode -format
    fi
    $HADOOP_HOME/bin/hdfs namenode
elif [ "$role" == "datanode" ]; then
    $HADOOP_HOME/bin/hdfs datanode
elif [ "$role" == "resourcemanager" ]; then
    $HADOOP_HOME/bin/yarn resourcemanager
elif [ "$role" == "nodemanager" ]; then
    $HADOOP_HOME/bin/yarn nodemanager
else
    echo "Unknown role: $role"
    exit 1
fi
