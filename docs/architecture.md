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
