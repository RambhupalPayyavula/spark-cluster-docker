FROM jupyter-cluster-base

# -- Layer: Apache Spark

ARG spark_version=3.3.2
ARG hadoop_version=3
ARG scala_version=2.12
ARG delta_version=2.3.0

RUN apt-get update -y && \
    apt-get install -y curl && \
    curl https://archive.apache.org/dist/spark/spark-${spark_version}/spark-${spark_version}-bin-hadoop${hadoop_version}.tgz -o spark.tgz && \
    tar -xf spark.tgz && \
    mv spark-${spark_version}-bin-hadoop${hadoop_version} /usr/bin/ && \
    mkdir /usr/bin/spark-${spark_version}-bin-hadoop${hadoop_version}/logs && \
    rm spark.tgz && \
    curl https://repo1.maven.org/maven2/io/delta/delta-core_${scala_version}/${delta_version}/delta-core_${scala_version}-${delta_version}.jar -o /usr/bin/spark-${spark_version}-bin-hadoop${hadoop_version}/jars/delta-core_${scala_version}-${delta_version}.jar && \
    curl https://repo1.maven.org/maven2/io/delta/delta-storage/${delta_version}/delta-storage-${delta_version}.jar -o /usr/bin/spark-${spark_version}-bin-hadoop${hadoop_version}/jars/delta-storage-${delta_version}.jar

# -- Layer: Hadoop
ARG HADOOP_VERSION=3.3.6
ENV HADOOP_HOME=/opt/hadoop
ENV HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop
ENV PATH=$PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin

RUN curl -L https://archive.apache.org/dist/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz -o hadoop.tar.gz && \
    tar -xzf hadoop.tar.gz && \
    mv hadoop-${HADOOP_VERSION} /opt/hadoop && \
    rm hadoop.tar.gz

ENV SPARK_HOME /usr/bin/spark-${spark_version}-bin-hadoop${hadoop_version}
ENV SPARK_MASTER_HOST jupyter-spark-master
ENV SPARK_MASTER_PORT 7077
ENV SPARK_UI_PORT 4040
ENV PYSPARK_PYTHON python3

# -- Runtime

WORKDIR ${SPARK_HOME}
