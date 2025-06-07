# **Onboarding Guide**## **1. Prerequisites**
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
