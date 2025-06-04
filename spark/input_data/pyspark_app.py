
import pyspark

from pyspark.sql.functions import *
from pyspark.sql.types import *
from pyspark.sql import SparkSession
from pyspark.sql.functions import col, datediff, avg, count, sum, when, expr, round


# Initialize Spark Session
spark = SparkSession.builder \
    .appName("ShippingDataAnalysis") \
    .getOrCreate()

# Load the CSV data
df = spark.read.csv("s3a://spark-data-source-1/data_source/shipment/shipping_data.csv", header=True, inferSchema=True)
# df = spark.read.csv("shipping_data.csv", header=True, inferSchema=True)

# 1. Carrier Performance Analysis
print("\n=== Carrier Performance ===")
carrier_performance = df.groupBy("carrier") \
    .agg(
        count("*").alias("total_shipments"),
        avg("delay_days").alias("avg_delay_days"),
        round(avg("shipping_cost"), 2).alias("avg_shipping_cost"),
        (count(when(col("delivery_status") == "Delivered", True)) / count("*") * 100).alias("on_time_percentage")
    ) \
    .orderBy("avg_delay_days")

carrier_performance.show()
carrier_performance.write.csv("s3a://spark-job-data-output/carrier_performance/",mode="overwrite")

# 2. Route Efficiency Analysis
print("\n=== Route Efficiency ===")
route_efficiency = df.groupBy("origin_warehouse", "destination_city") \
    .agg(
        count("*").alias("total_shipments"),
        avg("route_distance_km").alias("avg_distance_km"),
        avg(datediff(col("delivery_date"), col("shipment_date"))).alias("avg_delivery_time_days"),
        avg("shipping_cost").alias("avg_shipping_cost")
    ) \
    .orderBy("avg_delivery_time_days")

route_efficiency.show()
route_efficiency.write.csv("s3a://spark-job-data-output/route_efficiency",mode="overwrite")

# 3. Cost vs. Weight/Volume Analysis
print("\n=== Cost vs. Weight/Volume ===")
cost_analysis = df.select(
    "carrier",
    "shipment_weight_kg",
    "shipment_volume_m3",
    "shipping_cost",
    "route_distance_km",
    (col("shipping_cost") / col("route_distance_km")).alias("cost_per_km")
).orderBy("cost_per_km")

cost_analysis.show()
cost_analysis.write.csv("s3a://spark-job-data-output/cost_analysis",mode="overwrite")

# 4. Delay Trends by Destination
print("\n=== Delay Trends by Destination ===")
delay_trends = df.groupBy("destination_city") \
    .agg(
        count("*").alias("total_shipments"),
        sum(when(col("delay_days") > 0, 1).otherwise(0)).alias("delayed_shipments"),
        (sum(when(col("delay_days") > 0, 1).otherwise(0)) / count("*") * 100).alias("delay_percentage")
    ) \
    .orderBy("delay_percentage", ascending=False)

delay_trends.show()
delay_trends.write.csv("s3a://spark-job-data-output/delay_trends",mode="overwrite")

# 5. Optimal Warehouse Analysis (Demand Heatmap)
print("\n=== Warehouse Demand Heatmap ===")
warehouse_demand = df.groupBy("origin_warehouse", "destination_city") \
    .agg(count("*").alias("shipment_count")) \
    .orderBy("shipment_count", ascending=False)

warehouse_demand.show()
warehouse_demand.write.csv("s3a://spark-job-data-output/warehouse_demand",mode="overwrite")
# Stop Spark Session
spark.stop()







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
# df = spark.read.csv('s3a://spark-job-data-input-test/data-source/emp_dataset.csv', header=True, inferSchema=True)

# # df = spark.read.csv('s3a://ayodeji-data-ingestion/random_profile/males/91d0d032d3154e669916870e33bb6dd7.snappy.parquet', header=True, inferSchema=True)

# print("I have accessed the dataset nows")

# df.groupBy("BusinessTravel").agg({"Age": "sum"}).sort("BusinessTravel").show()
# df = df.groupBy("BusinessTravel").agg({"Age": "sum"}).sort("BusinessTravel")
# rename_df = df.withColumnRenamed('sum(Age)', 'total_age')
# rename_df.show()
# rename_df.write.parquet("s3a://spark-job-data-output/spark_output_test/employee/",mode="overwrite")






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





