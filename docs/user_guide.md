# **Onboarding Guide**

## **1. Prerequisites**
Before you begin, ensure you have the following installed and configured on your local machine:

### **1.1 Tools**
- **AWS CLI**:
  - Install the AWS CLI: [AWS CLI Installation Guide](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html)
  - Configure the AWS CLI with your credentials:
    ```bash
    aws configure
    ```
- **Terraform**:
  - Install Terraform (version `1.5.0` or later): [Terraform Installation Guide](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)

### **1.2 AWS Access**
- Ensure you have access to the AWS account where the infrastructure will be deployed.
- Create the `builditall-secrets` in AWS Secrets Manager.

---

## **2. Repository Setup**

### **2.1 Clone the Repository**
Clone the repository to your local machine:
```bash
git clone https://github.com/AyoDennis/spark-kestra-data-processing-platform/tree/main.git
```

##**2.2 Install Python Dependencies**
Navigate to the `requirements.txt` file and install the required Python packages:
```bash
cd ..
pip install -r requirements.txt
```

---


## **3. Infrastructure Deployment**

### **3.1 Bootstrap the Terraform Backend**
The Terraform backend must be set up before deploying the infrastructure. This includes creating the S3 bucket, IAM and VPC stacks.

1. Navigate to the `infrastructure/` directory:
   ```bash
   cd infrastructure/
   ```
2. Initialize Terraform:
   ```bash
   terraform init
   ```
3. Apply the configuration:
   ```bash
   terraform apply
   ```

 ---

## **4. Kestra Setup**

### **4.1 Start Airflow Locally**
1. Navigate to the `kestra` directory:
   ```bash
   cd kestra
   ```
2. Start Airflow using Docker Compose:
   ```bash
   
   docker-compose up -d
   ```
3. Access the Airflow UI:
   - Open your browser and navigate to `http://localhost:8080`.
   - Use the default credentials:
     - **Username**: `kestra`
     - **Password**: `k3str4`
---

## **5. Spark Jobs**

### **5.1 Running Spark Jobs**
1. Spark jobs are located in the `spark` directory.
2. Submit a Spark job to the EMR cluster using the Airflow DAGs:
   - `data_generation_dag.py`: Submits the `data_generator.py` job.
   - `python data_processing_dag.py` generates the data.

---

## **6. CI/CD Pipelines**

### **6.1 Continuous Integration (CI)**
- The CI pipeline validates the Python code.
- **Trigger**: Runs on pull requests to the `main` branches.

### **6.2 Continuous Deployment (CD)**
- The CD pipeline deploys the pyspark scripts to S3.
- **Trigger**: Runs on pushes to the `main` branch.

---

### **7. Kestra Issues**
- **Webserver Not Starting**:
  - Check the logs:
    ```bash
    docker-compose logs kestra:latest
    ```
---
    
### **8. Spark Job Failures**
- Check the EMR logs in the `emr-cluster-spark-logs/test-emr-logs/` S3 bucket.

---

### **9. Additional Resources**
- [AWS Documentation](https://aws.amazon.com/documentation/)
- [Terraform Documentation](https://developer.hashicorp.com/terraform/docs)
- [Apache Airflow Documentation](https://airflow.apache.org/docs/)

---

