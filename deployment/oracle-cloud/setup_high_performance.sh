#!/bin/bash
set -e

# Repository URL (Update this if you fork the project)
REPO_URL="https://github.com/rockthejvm/spark-cluster-docker.git"
REPO_DIR="spark-cluster-docker"

echo ">>> Updating System..."
# Detect package manager
if command -v apt-get &> /dev/null; then
    sudo apt-get update -y && sudo apt-get upgrade -y
    sudo apt-get install -y git curl apt-transport-https ca-certificates software-properties-common
elif command -v dnf &> /dev/null; then
    sudo dnf update -y
    sudo dnf install -y git curl
else
    echo "Unknown package manager. Please install git and docker manually."
fi

echo ">>> Installing Docker..."
if ! command -v docker &> /dev/null; then
    curl -fsSL https://get.docker.com -o get-docker.sh
    sudo sh get-docker.sh
    sudo usermod -aG docker $USER
    echo "Docker installed."
else
    echo "Docker already installed."
fi

echo ">>> Cloning Repository..."
if [ -d "$REPO_DIR" ]; then
    echo "Directory $REPO_DIR already exists. Pulling latest..."
    cd $REPO_DIR
    git pull
else
    git clone $REPO_URL
    cd $REPO_DIR
fi

echo ">>> OPTIMIZING FOR HIGH PERFORMANCE (Oracle 24GB RAM) ..."
# We have 24GB RAM.
# Default: 1GB per worker.
# New: 4GB per worker (Total 8GB for 2 workers).
# Remaining 16GB is valid for OS + Hadoop + HBase + Jupyter + Caches.

# Use sed to replace configuration in docker-compose.yml
# 1. Bump Memory to 4g
sed -i 's/SPARK_WORKER_MEMORY=1g/SPARK_WORKER_MEMORY=4g/g' docker-compose.yml

# 2. Bump Cores to 2 (Since we have 4 OCPUs which acts like 4 cores, 2 workers * 2 cores = 4 cores. Perfect fit).
sed -i 's/SPARK_WORKER_CORES=1/SPARK_WORKER_CORES=2/g' docker-compose.yml
# (Note: Current default is already 2, but ensuring it.)

echo "Configuration updated:"
grep "SPARK_WORKER_MEMORY" docker-compose.yml

echo ">>> Building and Starting Cluster..."
# Ensure Docker Compose plugin is used
docker compose up -d --build

echo ">>> SUCCESS! High-Performance Cluster is running."
echo "Your Spark Workers now have 4GB RAM each."
