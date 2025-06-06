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


### **2.3 IAM Policy**
- **Purpose**: Provisions IAM roles and security groups required for Amazon EMR clusters.
- **Resources**:
  - IAM roles and policies:
    - `emr-service-role`
    - `emr_instance_profile`
  - Security groups for EMR master and slave nodes.

---

#### **2.4 Backend Module**
The Terraform state is stored remotely in an S3 bucket to enable collaboration and state locking.
- **Purpose**: Configures the remote backend for Terraform state storage.
- **Resources**:
  - S3 bucket (`spark-kestra-platform`) for storing the Terraform state file.

---

## **3. Deployment**
Terraform is deployed using the **GitHub CD pipeline**. The pipeline automates the following steps:
1. **Terraform Initialization**:
   - Initializes the Terraform backend and downloads required providers.
2. **Terraform Plan**:
   - Generates an execution plan to show the changes Terraform will make.
3. **Terraform Apply**:
   - Applies the changes to provision or update the infrastructure.

The pipeline ensures consistent and automated deployments, reducing the risk of manual errors.

---
