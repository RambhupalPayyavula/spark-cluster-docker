# Spark Development Cluster

## 1. Quick Start

### Prerequisites
- Docker Desktop (Allocated at least 8GB RAM, 4 CPUs)
- Git

### Start the Cluster
Run the following command in the project root:
```bash
docker-compose up -d
```
*Note: The first time you run this, it will take a few minutes to build the images and download dependencies.*

### Stop the Cluster
```bash
docker-compose down
```
*Note: This preserves data in volumes. To delete all data, use `docker-compose down -v`.*

---

## 2. Architecture & Access

| Service | Description | URL / Port |
| :--- | :--- | :--- |
| **JupyterLab** | Primary Development Interface | [http://localhost:8888](http://localhost:8888) |
| **Spark Master** | Spark Standalone UI | [http://localhost:8080](http://localhost:8080) |
| **HDFS Namenode** | Browse Hadoop File System | [http://localhost:9870](http://localhost:9870) |
| **YARN ResourceManager** | Monitor YARN Applications | [http://localhost:8088](http://localhost:8088) |
| **HBase Master** | HBase Management UI | [http://localhost:16010](http://localhost:16010) |
| **HBase REST** | HBase REST API | [http://localhost:8090](http://localhost:8090) |
| **Postgres** | Relational Database | Port `5432` |
| **Redis** | Key-Value Store | Port `6379` |

**Authentication**:
- **JupyterLab**: Password is not set (TOKEN is empty).
- **Postgres**: User: `docker`, Password: `docker`, DB: `spark_labs`.

---

## 3. Developing with Spark

### 3.1 JupyterLab Environment
- **Persistent Data**: Save your notebooks and data in the `work` folder inside JupyterLab (mapped to `./shared-workspace` on your host).
- **Python**: Version 3.10 is installed.
- **Installing Packages**: Open a terminal in JupyterLab and run `pip install <package_name>`.

### 3.2 Connecting to Spark
The Docker environment comes with a pre-configured `SparkSession`. You can initialize it in two modes:

#### Mode A: Spark Standalone (Default for simple tests)
Runs on the standalone Spark cluster containers.
```python
from pyspark.sql import SparkSession

spark = SparkSession.builder \
    .appName("MyStandaloneApp") \
    .master("spark://jupyter-spark-master:7077") \
    .getOrCreate()
```

#### Mode B: Spark on YARN (Production simulation)
Submits the application to the YARN scheduler.
```python
from pyspark.sql import SparkSession

spark = SparkSession.builder \
    .appName("MyYarnApp") \
    .master("yarn") \
    .config("spark.deploy.mode", "client") \
    .getOrCreate()
```

### 3.3 Using Delta Lake
Delta Lake libraries are pre-loaded.
```python
# Write
df.write.format("delta").save("/opt/workspace/my-delta-table")

# Read
df = spark.read.format("delta").load("/opt/workspace/my-delta-table")
```

---

## 4. Working with Data

### 4.1 HDFS (Hadoop Distributed File System)
Access via `hdfs` scheme in Spark or CLI.
- **Spark**: `spark.read.csv("hdfs://namenode:9000/path/to/data")`
- **CLI**: Open a terminal in JupyterLab:
  ```bash
  # List files
  hdfs dfs -ls /
  
  # Create directory
  hdfs dfs -mkdir /my-data
  
  # Upload local file to HDFS
  hdfs dfs -put /opt/workspace/my-file.csv /my-data/
  ```

### 4.2 Postgres
Connect using JDBC. Drivers are pre-installed.
```python
df = spark.read \
    .format("jdbc") \
    .option("url", "jdbc:postgresql://postgres:5432/spark_labs") \
    .option("dbtable", "employees") \
    .option("user", "docker") \
    .option("password", "docker") \
    .load()
```

### 4.3 Redis
Access using the `redis` python library (install via pip first) or Spark-Redis connector (if configured).
```python
import redis
r = redis.Redis(host='redis', port=6379, db=0)
r.set('key', 'value')
```

---

## 5. Troubleshooting

- **"Safe Mode" in HDFS**: If HDFS is in safe mode, you cannot write to it. It usually turns off automatically after startup. To force leave:
  ```bash
  docker exec namenode hdfs dfsadmin -safemode leave
  ```
- **Spark UI (4040) Not Accessible**: The port 4040 is only open on your localhost *while* a SparkContext is active in your notebook/script.
- **Resource Issues**: If containers crash, check your Docker Desktop resource allocation. This stack requires at least 6-8GB of RAM.
