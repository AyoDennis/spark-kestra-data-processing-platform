# Scalable Big Data Platform that Transformed Global Logistics
## Background
### The Shipping Dilemma
In H1 2025, SwiftShip Logistics, a mid-sized freight company, faced mounting challenges:

* 30% of shipments were delayed by 2+ days
* Fuel costs had spiked by 40% year-over-year
* Customers like eMart (their largest retail client) threatened to switch competitors

### The Data Revelation: Solution 
As a consultant Data Platform Engineer, I listened intently to the CTO's painpoints and mapped it to a solution:

| Pain Point	| Data Solution	|
|-------------|--------------- |
| Unpredictable Delays |	Carrier performance analytics	|
| Rising Costs	| Cost-per-mile optimization	|
| Warehouse Congestion	| Demand heatmaps	|

### The Data Revelation: Bringing it all together 
To successfully implement this solution, I proposed a data-driven overhaul, which entails:

An automated platform designed to efficiently handle big data workloads (ingestion, processing, analytics). This platform is also designed to be cost-effective, low-maintenance, and seamless for client onboarding.


## Solution Snapshots

| Component | Purpose |
|:----------|:--------|
| [Architecture](https://github.com/AyoDennis/spark-kestra-data-processing-platform/blob/main/docs/architecture.md) | High-level overview and structure | 
| [CI/CD (GitHub Actions)](https://github.com/AyoDennis/spark-kestra-data-processing-platform/blob/main/docs/ci_cd.md) | Automates code deployment and infrastructure updates |
| [Infrastructure (Terraform](https://github.com/AyoDennis/spark-kestra-data-processing-platform/blob/main/docs/terraform_infrastructure.md) | Automates cloud setup (IAM, S3, networking) |
| [Orchestration (Kestra)](https://github.com/AyoDennis/spark-kestra-data-processing-platform/blob/main/docs/kestra_configuration.md) | Manages data pipeline workflows |
| [Spark jobs (PySpark)](https://github.com/Data-Bishop/Team5-BuildItAll-Data-Platform/blob/main/docs/spark_jobs.md) | Simulates realistic e-commerce datasets and processing |

## ☁️ Architecture Overview
![workflow](/assests/workflow.svg)
Clear [architecture documentation](https://github.com/Data-Bishop/Team5-BuildItAll-Data-Platform/blob/main/docs/architecture.md) outlining the platform’s design.

For Architecture documentation[ Click here](https://github.com/Data-Bishop/Team5-BuildItAll-Data-Platform/blob/main/docs/architecture.md)

## 🛠️ Technologies Used
- Cloud: AWS (S3, IAM)
- Big Data Framework: Apache Spark
- Workflow Orchestration: Apache Airflow
- Infrastructure: Terraform
- Automation: GitHub Actions
- Programming Languages: Python, PySpark


## Deploymemt
For immediate use, refer to the [documentation](https://github.com/Data-Bishop/Team5-BuildItAll-Data-Platform/blob/main/docs/onboarding_guuide.md)

## Key Features
1. Scalable Big Data Processing
Built with Apache Spark for seamless handling of large datasets. The platform supports both batch and real-time processing to meet dynamic business needs.

2. Cost-Optimized Cloud Infrastructure
Utilizes AWS to ensure efficient use of resources, optimizing costs without compromising performance. Built with Terraform for reproducible and version-controlled infrastructure.

3. Modular and Maintainable Architecture
Designed for easy scalability and maintainability, making future updates or onboarding new team members a smooth process. The modular setup ensures flexibility in adapting to evolving business requirements.

4. Automated Data Pipelines
Apache Airflow is used for orchestrating complex workflows, ensuring seamless data movement from raw to processed datasets, with monitoring and error handling built-in.

5. Data Storage with AWS S3
Structured in raw and processed data zones on S3, ensuring efficient data storage and easy access for analytics or future processing.

6. CI/CD Automation
GitHub Actions for continuous integration and continuous deployment, enabling automated testing, builds, and deployment of code and infrastructure.

7. Production-Ready Setup
Designed with best practices to meet production-level requirements for performance, security, and maintainability, ensuring readiness for full deployment.

8. Client Onboarding Ready
Built to be easily understood and managed by the client with a focus on user-friendly maintenance and smooth adoption for future scaling.

## Best Practices
- Infrastructure as Code (IaC):
All cloud resources (S3 buckets, IAM roles, networking) are provisioned using Terraform, ensuring reproducibility, version control, and easy updates.
- Modular Code Structure:
The repository is neatly organized into modules: infrastructure, orchestration, data generation, and CI/CD, improving maintainability and collaboration.
- Environment Separation:
Clear separation between raw and processed data zones in AWS S3, following data lake design principles.
- Comprehensive [documentations](https://github.com/Data-Bishop/Team5-BuildItAll-Data-Platform/tree/main/docs) to support onboarding, repository cloning, and commercial deployment.













<-- # kestra-data-processing-platform -->

# Shipping Data Analysis with PySpark on AWS EMR

This project analyzes synthetic shipping data for **logistics optimization** using PySpark. It calculates carrier performance, route efficiency, and cost metrics, then saves results to **S3** and prints summaries to the console. Designed for AWS EMR. 

## 📌 Table of Contents
- [Features](#-features)
- [Prerequisites](#-prerequisites)
- [Setup](#-setup)
- [Usage](#-usage)
- [Outputs](#-outputs)
- [Customization](#-customization)

## 🌟 Features
- **Data Generation**: Synthetic shipping data with carriers, routes, costs, and delays.
- **Key Analyses**:
  - Carrier performance (on-time %, avg delay, cost).
  - Route efficiency (avg delivery time, distance).
  - Cost vs. weight/volume.
- **AWS EMR Integration**: Reads/Writes data to/from S3.
- **Output Formats**: CSV (for humans) + Parquet (for Spark).

## 🛠 Prerequisites
1. **AWS Account** with:
   - S3 bucket for data/scripts.
   - EMR cluster access.
2. **Tools**:
   - `aws-cli` (for S3 uploads).
   - PySpark (included in EMR).
3. **Python Libraries** (for data generation):
   ```bash
   pip install pandas faker```



## 🔧 Setup

1. Generate Synthetic Data

Run the Python script to create sample data:

bash
python generate_shipping_data.py  # Output: shipping_data.csv
2. Upload to S3

bash
aws s3 cp shipping_data.csv s3://your-bucket/data/
aws s3 cp emr_shipping_analysis.py s3://your-bucket/scripts/
3. EMR Cluster Configuration

Applications: Spark, Hadoop.
Instance Type: m5.xlarge (adjust based on data size).
IAM Role: Ensure access to S3 (e.g., AmazonS3FullAccess).
🚀 Usage

Submit Job to EMR

bash
spark-submit \
  --master yarn \
  --deploy-mode cluster \
  s3://your-bucket/scripts/emr_shipping_analysis.py
Parameters

Input Path: Set INPUT_PATH in the script (e.g., s3a://your-bucket/data/shipping_data.csv).
Output Path: Configure OUTPUT_PATH (e.g., s3a://your-bucket/output/).
📊 Outputs

1. Console

=== Carrier Performance ===
+------+---------------+--------------+------------------+
|carrier|total_shipments|avg_delay_days|on_time_percentage|
+------+---------------+--------------+------------------+
|   DHL|            250|          0.75|            72.40%|
...
2. S3 (After Job Completion)

s3://your-bucket/output/
├── carrier_performance/  # CSV
│   ├── part-00000.csv
├── route_efficiency/     # Parquet
│   ├── part-00000.parquet
🎨 Customization

1. Data Generation

Modify generate_shipping_data.py to:

Add/remove carriers (CARRIERS list).
Adjust cost formulas (shipping_cost logic).
2. Analysis

Extend emr_shipping_analysis.py with:

New Metrics (e.g., fuel cost, emissions).
Visualizations (use matplotlib in follow-up scripts).
3. EMR Optimization

Cluster Size: Scale executors for large datasets.
S3 Partitioning: Add .partitionBy("carrier") for faster queries.
📜 License

MIT License. See LICENSE for details.


---

### Key Notes for Users:
1. **AWS Credentials**: Ensure EMR nodes have IAM roles with S3 access.
2. **Cost Control**: Monitor EMR cluster uptime to avoid unexpected charges.
3. **Testing**: Run locally with small data before EMR submission.

Let me know if you’d like to add sections (e.g., troubleshooting, example queries)!
I need it to be more detailed
Here’s a highly detailed README.md for your project, covering every aspect from setup to advanced configurations:

markdown













# Shipping Data Analytics Pipeline with PySpark on AWS EMR

## 📌 Table of Contents
1. [Project Overview](#-project-overview)
2. [Architecture Diagram](#-architecture-diagram)
3. [Prerequisites](#-prerequisites)
4. [Setup Instructions](#-setup-instructions)
   - [Local Development Setup](#local-development-setup)
   - [AWS Infrastructure Setup](#aws-infrastructure-setup)
5. [Data Pipeline](#-data-pipeline)
   - [Data Generation](#1-data-generation)
   - [Data Analysis](#2-data-analysis)
6. [Output Specifications](#-output-specifications)
7. [Performance Optimization](#-performance-optimization)
8. [Security Considerations](#-security-considerations)
9. [Troubleshooting](#-troubleshooting)
10. [Cost Management](#-cost-management)
11. [Extensions](#-extensions)
12. [License](#-license)

## 🌐 Project Overview
This project implements an end-to-end data pipeline for logistics optimization:
- **Input**: Synthetic shipping data (carriers, routes, costs)
- **Processing**: PySpark on AWS EMR (5 nodes)
- **Output**: Analytics metrics + partitioned datasets in S3
- **Use Cases**: 
  - Carrier performance benchmarking
  - Route optimization
  - Cost forecasting

## 📐 Architecture Diagram
[Python Data Generator] → [S3 Raw Zone] → [EMR Spark Cluster]
→ [S3 Processed Zone (CSV/Parquet)] → [Athena/QuickSight]


## 🧰 Prerequisites

### Hardware
- Minimum local specs for testing:
  - 8GB RAM
  - 20GB disk space
- EMR cluster recommendations:
  - Master: m5.2xlarge (8 vCPU, 32GB RAM)
  - Workers: 3 x r5.xlarge (4 vCPU, 32GB RAM each)

### Software
| Component       | Version  | Installation Guide |
|----------------|----------|--------------------|
| Python         | 3.8+     | [pyenv](https://github.com/pyenv/pyenv) |
| AWS CLI        | v2       | [AWS Docs](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html) |
| Spark          | 3.2.1    | Included in EMR 6.7 |
| Hadoop         | 3.3.1    | Included in EMR 6.7 |

### AWS Services
- S3 buckets (Raw/Processed zones)
- EMR cluster with:
  - Spark application
  - S3FullAccess IAM role
  - EC2 key pair for SSH

## 🛠 Setup Instructions

### Local Development Setup
1. Create virtual environment:
   ```bash
   python -m venv .venv
   source .venv/bin/activate
   pip install -r requirements.txt  # pandas==1.4.3 faker==15.3.4
Generate test data (1GB):
bash
python generate_shipping_data.py --records 1000000 --output large_dataset.csv

### AWS Infrastructure Setup

* S3 Bucket Structure:
s3://your-logistics-bucket/
├── raw/
│   └── shipping_data_<date>.csv
├── scripts/
│   └── emr_shipping_analysis.py
└── processed/
    ├── carrier_metrics/
    └── route_analytics/

* EMR Cluster Creation (CLI):
bash```
aws emr create-cluster \
--name "Shipping Analytics" \
--release-label emr-6.7.0 \
--applications Name=Spark \
--ec2-attributes KeyName=your-key-pair \
--instance-type m5.2xlarge \
--instance-count 3 \
--use-default-roles```

## 🔄 Data Pipeline

1. Data Generation

Configuration file (config/generation_params.yaml):

yaml
carriers:
  - FedEx
  - UPS
  - DHL
  - USPS
  - Amazon Logistics

warehouses:
  - NY_Warehouse
  - CA_Warehouse
  - TX_Warehouse

delay_distribution:
  on_time: 70%
  1_day: 15%
  2_days: 10%
  3+_days: 5%
2. Data Analysis

PySpark job parameters:

python
# Analysis config
ANALYSIS_CONFIG = {
    "carrier_metrics": {
        "group_by": ["carrier", "quarter"],
        "metrics": ["avg_cost", "on_time_rate", "delay_percentile_95"]
    },
    "route_analysis": {
        "partition_by": ["origin_warehouse", "destination_state"],
        "optimization_thresholds": {
            "max_delay_days": 3,
            "cost_per_km": 0.15
        }
    }
}
📊 Output Specifications

File Formats

Output Type	Format	Compression	S3 Path Pattern
Carrier Metrics	Parquet	Snappy	s3://bucket/processed/carriers/dt=YYYY-MM-DD/
Route Analytics	CSV	Gzip	s3://bucket/processed/routes/
Schema Details

Carrier Metrics Schema:

sql
CREATE EXTERNAL TABLE carrier_metrics (
    carrier STRING,
    quarter STRING,
    avg_cost DECIMAL(10,2),
    on_time_rate DECIMAL(5,2),
    delay_95_percentile INT
)
PARTITIONED BY (dt STRING)
STORED AS PARQUET
LOCATION 's3://bucket/processed/carriers/';
⚡ Performance Optimization

Spark Configurations

python
# In emr_shipping_analysis.py
spark = SparkSession.builder \
    .config("spark.sql.shuffle.partitions", "200") \
    .config("spark.executor.memory", "8g") \
    .config("spark.dynamicAllocation.enabled", "true") \
    .config("spark.speculation", "true") \
    .getOrCreate()
Partitioning Strategy

python
df.write \
  .partitionBy("year", "month", "carrier") \
  .bucketBy(50, "destination_state") \
  .format("parquet") \
  .save(output_path)
🔒 Security Considerations

IAM Policies:
json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:GetObject",
                "s3:PutObject"
            ],
            "Resource": "arn:aws:s3:::your-logistics-bucket/*"
        }
    ]
}
Data Encryption:
Enable S3 SSE-KMS
Set Spark encryption:
python
.config("spark.io.encryption.enabled", "true")
🐛 Troubleshooting

Common Issues

Error	Solution
NoSuchBucket	Verify bucket exists in correct region
AccessDenied	Check EMR instance profile permissions
OutOfMemory	Increase executor memory or reduce partition size
Logging

Access EMR logs via:

AWS Console → EMR → Cluster → Logs
CLI:
bash
aws s3 cp s3://elasticmapreduce/<cluster-id>/containers/ ~/emr-logs/ --recursive
💰 Cost Management

Cost Estimation (us-east-1)

Resource	Qty	Unit Cost	Daily Cost
m5.2xlarge	1	$0.384/hr	$9.22
r5.xlarge	3	$0.252/hr	$18.14
S3 Storage	1TB	$0.023/GB	$23.00
Total Estimated Monthly Cost: ~$1,500

Cost Optimization Tips

Use Spot Instances for workers (60-90% savings)
Implement S3 Lifecycle Policies
Schedule clusters to auto-terminate after 1 hour idle
🚀 Extensions

Future Enhancements

Real-time Processing:
Kinesis Data Streams for live shipping updates
ML Integration:
Predict delays using Spark ML
Dashboarding:
Connect to QuickSight via Athena
📜 License

Apache 2.0 - See LICENSE for full terms.


---

### Key Improvements:
1. **Detailed Configuration**: Added YAML/JSON examples for all components
2. **Cost Breakdown**: Transparent pricing estimates
3. **Enterprise Features**: Security, partitioning, and performance tuning
4. **Maintenance Guide**: Troubleshooting and logging procedures

This README serves both as documentation and an operations manual. Let me know if you'd like to emphasize any specific area further!
New chat
