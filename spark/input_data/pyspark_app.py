
import pyspark
from pyspark.sql import SparkSession
from pyspark.sql.functions import *
from pyspark.sql.types import *
from pyspark.sql.functions import col, datediff, avg, count, sum, when, expr, round


# Initialize Spark Session
spark = SparkSession.builder \
    .appName("ShippingDataAnalysis") \
    .getOrCreate()

# Load the CSV data
df = spark.read.parquet("s3a://spark-data-source-1/data_source/shipment/shipping_data.snappy.parquet", header=True, inferSchema=True)

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
carrier_performance.write.parquet("s3a://spark-job-data-output/carrier_performance/",mode="overwrite")

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
route_efficiency.write.parquet("s3a://spark-job-data-output/route_efficiency",mode="overwrite")

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
cost_analysis.write.parquet("s3a://spark-job-data-output/cost_analysis",mode="overwrite")

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
delay_trends.write.parquet("s3a://spark-job-data-output/delay_trends",mode="overwrite")

# 5. Optimal Warehouse Analysis (Demand Heatmap)
print("\n=== Warehouse Demand Heatmap ===")
warehouse_demand = df.groupBy("origin_warehouse", "destination_city") \
    .agg(count("*").alias("shipment_count")) \
    .orderBy("shipment_count", ascending=False)

warehouse_demand.show()
warehouse_demand.write.parquet("s3a://spark-job-data-output/warehouse_demand",mode="overwrite")

# Stop Spark Session
spark.stop()
