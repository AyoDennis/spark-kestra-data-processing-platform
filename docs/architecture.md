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
