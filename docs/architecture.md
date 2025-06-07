# **Architecture Documentation**

## **1. Purpose**
The purpose of this architecture is to build a **data platform** that supports:
- **Synthetic Data Generation**: Using Python to generate synthetic parquet datasets.
- **Data Processing**: Processing raw generated parquet datasets using Spark on Amazon EMR.
- **Orchestration**: Managing workflows and scheduling tasks using Kestra.
- **Storage**: Storing raw, processed data and logs in Amazon S3.
- **Networking**: Ensuring secure communication between components using a VPC with a public subnet.
- **Access Control**: Using IAM roles and policies to enforce least-privilege access to AWS resources.

---

## **2. Content**

### **Compute: EMR**
- **Purpose**: Amazon EMR is used to run Spark jobs for data processing.
- **Configuration**:
  - **Cluster**: Configured with one master node (`m5.xlarge`) and two worker nodes (`m5.xlarge`).
  - **Applications**: Spark is installed on the cluster.
  - **Bootstrap Actions**: This is handled by kestra, the configuration can be founf in `kestra/flows/emr_cluster`.
  - **Security Groups**:
    - Master and slave nodes have security groups allowing internal communication and SSH access.
  - **IAM Roles**:
    - `emr-service-role`: Allows the cluster to interact with AWS services.
    - `emr_instance_profile`: Grants EC2 instances in the cluster access to S3 and other resources.

---

### **Orchestration: Kestra**
- **Purpose**: Kestra is used to orchestrate workflows for data processing.
- **Configuration**:
  - **Deployment**: Kestra is deployed using Docker Compose.
  - **Components**:
    - **kestra server**: Accessible on port `8080`.
    - **Redis**: Used as the Celery broker.
  - **Flows**:
    - `emr_cluster.yaml`: Provisions the EMR cluster and processes raw parquet datasets using Spark on EMR.

---

### **Storage: S3**
- **Purpose**: Amazon S3 is used to store raw, processed, generated and Cluster logs data.
- **Buckets**:
  - `spark-job-data-input`:
    - **Folder**:
      - `spark_app/`: Stores Spark job script.
  - `spark-job-data-source-1`:
    - **Folder**:
      - `/data_source/shipment/`: Stores Generated data.
  - `spark-job-data-output`:
    - **Folders**:
      - `carrier_performance/`: Stores carrier performance data.
      - `cost_analysis/`: Stores cost analysis data.
      - `daily_trends/`: Stores daily trends data.
      - `route_efficiency/`: Stores route efficiency data.
      - `warehouse_demand/`: Stores warehouse demand data.
  - `emr-cluster-spark-logs`:
    - **Folder**:
      - `/test-emr-logs/`: Stores EMR logs.
  - `spark-kestra-platform/key/`:
    - **Folder**:
      - `key/`: Stores Terraform backend and state configuration.
- **Bucket Policies**:
  - Grant access to specific IAM roles (e.g., Kestra, EC2 and EMR roles) for reading and writing data.

---

### **Networking**
- **VPC**:
  - A custom VPC is created with the following:
    - **Public Subnets (1)**: For EMR instances
  - **Routing**:
    - Public subnet have an internet gateway for inbound and outbound traffic.
- **Security Groups**:
  - **EMR**:
    - Master and slave nodes allow internal communication and SSH access.

---

### **IAM Roles**
- **Kestra Role**:
  - Grants access to:
    - S3 buckets.
    - EMR clusters for job submission and monitoring.
- **EMR Roles**:
  - `emr-service-role`: Grants the EMR cluster access to AWS services.
  - `emr_instance_profile`: Grants EC2 instances in the cluster access to S3 and other resources.

---

## **3. Workflow**

### **Step 1: Data Processing**
1. **Trigger**:
   - The `data_processing.py` flow executes daily at `12:00 AM`.
2. **Workflow**:
   - Creates an EMR cluster.
   - Submits a Spark job (`data_processor.py`) to process raw parquet datasets/files generated that day from the data generation workflow.
   - Saves the processed data to the `spark-job-data-output` S3 bucket.
   - Terminates the EMR cluster after the job completes.

---
