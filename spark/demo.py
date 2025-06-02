
import pyspark
from pyspark.sql import SparkSession
from pyspark.sql.functions import *
from pyspark.sql.types import *

# Initialize Spark with proper logging configuration
spark = SparkSession.builder \
    .appName('Aggregation on Single col') \
    .config("spark.driver.extraJavaOptions", "-Dlog4j.configuration=file:/etc/spark/log4j.properties") \
    .getOrCreate()

# Reduce log noise (optional))
spark.sparkContext.setLogLevel("WARN")


df = spark.read.csv('s3://spark-data-input/data_source/emp_dataset.csv', header=True, inferSchema=True)

df.groupBy("BusinessTravel").agg({"Age": "sum"}).sort("BusinessTravel").show()
df = df.groupBy("BusinessTravel").agg({"Age": "sum"}).sort("BusinessTravel")
rename_df = df.withColumnRenamed('sum(Age)', 'total_age')
rename_df.show()
rename_df.write.parquet("s3a://spark-job-data-output/spark_output/employee/",mode="overwrite")
