FROM jupyter-cluster-base

# -- Layer: JupyterLab

ARG spark_version=3.3.2
ARG jupyterlab_version=3.6.3

RUN apt-get update -y && \
    apt-get install -y python3-pip && \
    pip3 install wget pyspark==${spark_version} jupyterlab==${jupyterlab_version} delta-spark==2.3.0

# -- Runtime

EXPOSE 8888
WORKDIR ${SHARED_WORKSPACE}
CMD jupyter lab --ip=0.0.0.0 --port=8888 --no-browser --allow-root --NotebookApp.token=
