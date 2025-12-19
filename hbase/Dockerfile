FROM eclipse-temurin:8-jre

ARG HBASE_VERSION=2.5.5

RUN apt-get update && apt-get install -y curl && \
    curl -L https://archive.apache.org/dist/hbase/${HBASE_VERSION}/hbase-${HBASE_VERSION}-bin.tar.gz -o hbase.tar.gz && \
    tar -zxvf hbase.tar.gz && \
    mv hbase-${HBASE_VERSION} /opt/hbase && \
    rm hbase.tar.gz && \
    apt-get clean

ENV HBASE_HOME=/opt/hbase
ENV PATH=$PATH:$HBASE_HOME/bin

WORKDIR /opt/hbase

# HBase configuration
RUN echo "export HBASE_MANAGES_ZK=true" >> conf/hbase-env.sh

# Expose ports
# 2181: Zookeeper
# 16000: Master
# 16010: Master Web UI
# 16020: RegionServer
# 16030: RegionServer Web UI
EXPOSE 2181 16000 16010 16020 16030

CMD ["/bin/bash", "-c", "/opt/hbase/bin/start-hbase.sh && tail -f /opt/hbase/logs/*"]
