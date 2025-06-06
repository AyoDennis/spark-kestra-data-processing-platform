# **Terraform Infrastructure Documentation**

## **1. Purpose**
The Terraform infrastructure is designed to provision and manage the resources required for the **Logistics Big Data Platform**. It automates the creation of compute, storage, networking, and orchestration components in AWS, ensuring consistency, scalability, and security.

---

## **2. Stacks**
Below are the various services and resources that were used ito build the platform as whole

### **2.1 VPC Stack**
- **Purpose**: Creates a Virtual Private Cloud (VPC) with public and private subnets, routing, and endpoints.
- **Resources**:
  - VPC
  - Public and private subnets
  - Internet Gateway
  - Route table and association

---

### **2.2 S3 Module**
- **Purpose**: Creates S3 buckets for storing the statefile backend, shipping data (1.4m+ rows), processed data, processing files, and logs.
- **Resources**:
  - S3 buckets:
    - `spark-kestra-platform`
    - `spark-job-data-input`
    - `emr-cluster-spark-logs`
    - `spark-job-data-output`
  - All the buckets are also versioned, to prevent data loss

---
