
# import pyspark
# from pyspark.sql import SparkSession
# from pyspark.sql.functions import *
# from pyspark.sql.types import *

# # Initialize Spark with proper logging configuration
# spark = SparkSession.builder \
#     .appName('Aggregation on Single col') \
#     .config("spark.driver.extraJavaOptions", "-Dlog4j.configuration=file:/etc/spark/log4j.properties") \
#     .getOrCreate()

# # Reduce log noise (optional))
# spark.sparkContext.setLogLevel("WARN")

# print("Hello0000000000")
# df = spark.read.csv('s3a://spark-data-source-1/emp_dataset.csv', header=True, inferSchema=True)

# # df = spark.read.csv('s3a://ayodeji-data-ingestion/random_profile/males/91d0d032d3154e669916870e33bb6dd7.snappy.parquet', header=True, inferSchema=True)

# print("I have accessed emp_dataset.csv")

# df.groupBy("BusinessTravel").agg({"Age": "sum"}).sort("BusinessTravel").show()
# df = df.groupBy("BusinessTravel").agg({"Age": "sum"}).sort("BusinessTravel")
# rename_df = df.withColumnRenamed('sum(Age)', 'total_age')
# rename_df.show()
# rename_df.write.parquet("s3a://spark-job-data-output/spark_output/employee/",mode="overwrite")

# print('hello')



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

print("Hello0000000000")
df = spark.read.csv('s3a://spark-job-data-input-test/data-source/emp_dataset.csv', header=True, inferSchema=True)

# df = spark.read.csv('s3a://ayodeji-data-ingestion/random_profile/males/91d0d032d3154e669916870e33bb6dd7.snappy.parquet', header=True, inferSchema=True)

print("I have accessed the dataset now")

df.groupBy("BusinessTravel").agg({"Age": "sum"}).sort("BusinessTravel").show()
df = df.groupBy("BusinessTravel").agg({"Age": "sum"}).sort("BusinessTravel")
rename_df = df.withColumnRenamed('sum(Age)', 'total_age')
rename_df.show()
rename_df.write.parquet("s3a://spark-job-data-output/spark_output_test/employee/",mode="overwrite")
