from pyspark.sql import SparkSession
import time

print("Starting Long Running Spark App...")
spark = SparkSession.builder \
    .appName("LongRunningApp") \
    .getOrCreate()

print("Spark UI is now available at http://localhost:4040")
print("Sleeping for 1 hour... Press Ctrl+C to exit.")

try:
    time.sleep(3600)
except KeyboardInterrupt:
    print("Stopping app...")

spark.stop()
