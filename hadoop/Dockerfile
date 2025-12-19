FROM python:3.10-slim-bullseye

# -- Layer: OS + Java 11
RUN apt-get update -y && \
    apt-get install -y openjdk-11-jre-headless curl gnupg procps && \
    rm -rf /var/lib/apt/lists/*

ENV JAVA_HOME=/usr/lib/jvm/java-11-openjdk-arm64

# -- Layer: Hadoop
ARG HADOOP_VERSION=3.3.6
ENV HADOOP_HOME=/opt/hadoop
ENV HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop
ENV PATH=$PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin

RUN curl -L https://archive.apache.org/dist/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz -o hadoop.tar.gz && \
    tar -xzf hadoop.tar.gz && \
    mv hadoop-${HADOOP_VERSION} /opt/hadoop && \
    rm hadoop.tar.gz && \
    mkdir -p /opt/hadoop/logs

# Add entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

WORKDIR /opt/hadoop

ENTRYPOINT ["/entrypoint.sh"]
