
# **Spark Jobs Documentation**

## **1. Purpose**
Spark jobs are used for data generation and processing. They run on Amazon EMR clusters and interact with S3 for input and output data.

---

## **2. Workflow**

### **2.1 Data Generation**
- The `data_generator.py` script is ran on the terminal. One run would create 50,000 unique rows of shipping data 

### **2.2 Data Processor**
- **Script**: `data_processor.py`
- **Purpose**: Processes shipping data and saves it to the `carrier_performance/`, `route_efficiency`, `cost_analysis`, `delay_trends`, and `warehouse_demand` folders in the S3 `spark-job-data-output` bucket.
- **Inputs**:
  - Shipping data (Parquet) data from the `/data_source/shipment/` folder in the `spark_data_source`S3 bucket.
- **Outputs**:
  - Processed data in Parquet format.
- **Execution**:
  - Submitted to the EMR cluster by kestra's `spark-kestra` flow.

---

## **3. Logs**
- **Location**:
  - Spark job logs are stored in the `emr-cluster-spark-logs` S3 bucket.
- **Access**:
  - Logs can be accessed via the EMR console or directly from the S3 bucket.
