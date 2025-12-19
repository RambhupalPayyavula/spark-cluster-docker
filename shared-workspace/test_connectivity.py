from pyspark.sql import SparkSession
import redis
import psycopg2
import socket
import time

def check_port(host, port, retries=5, delay=2):
    for i in range(retries):
        sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        result = sock.connect_ex((host, port))
        sock.close()
        if result == 0:
            return True
        print(f"Waiting for {host}:{port}...")
        time.sleep(delay)
    return False

print("Testing Spark and Delta...")
try:
    spark = SparkSession.builder \
        .appName("Verification") \
        .config("spark.jars.packages", "io.delta:delta-core_2.12:2.3.0") \
        .config("spark.sql.extensions", "io.delta.sql.DeltaSparkSessionExtension") \
        .config("spark.sql.catalog.spark_catalog", "org.apache.spark.sql.delta.catalog.DeltaCatalog") \
        .getOrCreate()

    print(f"Spark Version: {spark.version}")
    data = spark.range(0, 5)
    data.write.format("delta").mode("overwrite").save("/opt/workspace/delta-test")
    read_data = spark.read.format("delta").load("/opt/workspace/delta-test")
    read_data.show()
    print("Spark and Delta OK!")
except Exception as e:
    print(f"Spark/Delta Failed: {e}")

print("Testing Postgres...")
try:
    # Wait for postgres to be ready
    if check_port("postgres", 5432):
        conn = psycopg2.connect(
            host="postgres",
            database="spark_labs",
            user="docker",
            password="docker"
        )
        print("Postgres OK!")
        conn.close()
    else:
        print("Postgres Port Unreachable")
except Exception as e:
    print(f"Postgres Failed: {e}")

print("Testing Redis...")
try:
    if check_port("redis", 6379):
        r = redis.Redis(host='redis', port=6379, db=0)
        r.set('foo', 'bar')
        print(f"Redis get 'foo': {r.get('foo')}")
        print("Redis OK!")
    else:
        print("Redis Port Unreachable")
except Exception as e:
    print(f"Redis Failed: {e}")

print("Testing HBase (Port 16000)...")
if check_port("hbase", 16000):
    print("HBase Master Port OK!")
else:
    print("HBase Master Port Failed!")
