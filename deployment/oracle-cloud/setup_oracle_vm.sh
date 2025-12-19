#!/bin/bash
set -e

# Repository URL (Update this if you fork the project)
REPO_URL="https://github.com/rockthejvm/spark-cluster-docker.git"
REPO_DIR="spark-cluster-docker"

echo ">>> Updating System..."
sudo apt-get update -y && sudo apt-get upgrade -y
# Note: If using Oracle Linux instead of Ubuntu, use: sudo dnf update -y

echo ">>> Installing Prerequisites..."
sudo apt-get install -y git curl apt-transport-https ca-certificates software-properties-common

echo ">>> Installing Docker..."
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo usermod -aG docker $USER

echo ">>> Installing Docker Compose..."
# Docker Compose is now a plugin in modern Docker versions
sudo apt-get install -y docker-compose-plugin

echo ">>> Cloning Repository..."
if [ -d "$REPO_DIR" ]; then
    echo "Directory $REPO_DIR already exists. Pulling latest..."
    cd $REPO_DIR
    git pull
else
    git clone $REPO_URL
    cd $REPO_DIR
fi

echo ">>> Building and Starting Cluster..."
# Ensure we are in the directory
echo "Starting Docker Compose (this may take a while)..."
docker compose up -d --build

echo ">>> SUCCESS! Cluster is running."
echo "Ensure you have opened the following ports in your Oracle VCN Security List:"
echo "- 8888 (JupyterLab)"
echo "- 8080 (Spark Master)"
echo "- 9870 (HDFS)"
echo "- 8088 (YARN)"
echo "- 16010 (HBase)"
