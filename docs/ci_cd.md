# **Codebase Documentation**

## **1. Repository Structure**
The repository is organized into directories and files that represent the different components of the **Logistics Big Data Platform**. Below is an overview of the structure:
```graphql
spark-kestra-data-pricessing-platform/
├── .github/
│   └── workflows/                # GitHub Actions workflows for CI/CD
│       ├── ci.yml                # Continuous Integration and Deployment workflow
├── docs/                         # Documentation folders
│   ├── architecture.md              
│   ├── ci_cd.md                
│   ├── kestra_configuration.md
│   ├── spark_configuration.md
│   ├── terraform_infrastructure.md
│   ├──user_guide.md
├── infrastructure/               # Terraform configuration for AWS resources
│   ├── backend.tf/               # Bootstrap resources for Terraform backend
│   ├── iam.tf/                   # Terraform resources for AWS IAM user, policies, and roles 
│   ├── provider.tf/              # AWS provider configuration
│   ├── s3.tf/                    # Terraform resources for AWS S3 Buckets 
│   ├── vpc.tf/                   # Terraform resources for AWS VPC resources, including VPC, Subnet, Internet Gateway, Route Table
├── kestra/                       # Kestra orchestration setup
│   ├── flows/                    # kestra flow
│   │   ├── emr_cluster.yaml      # YAML for EMR configuration and orchestration
│   │   ├── docker-cpmpose.yml    # Docker Compose configuration for kestra container orchestration
├── spark/                        # Spark job scripts
│   ├── data_generator.py         # Python script for synthetic data generation
│   ├── data_processor.py         # Spark job for data processing
├── .gitignore                    # Git ignore rules
```
---

## **2. CI/CD**

### **2.1 Continuous Integration (CI)**
The CI pipeline ensures code quality and validates Terraform configurations. It is defined in `.github/workflows/ci_cd.yml`.

#### **CI Workflow Steps**
1. **Terraform Validation**:
   - Validates the Terraform configuration files.
   - Ensures proper formatting using `terraform fmt`.
   - Runs `terraform validate` to check for syntax errors.
2. **Python Linting**:
   - Uses `isort` to check import sorting in Python files.
   - Uses `flake8` to enforce Python code style and linting rules.

#### **Trigger**:
- Runs on every pull request to the `main` branch.

---

### **2.2 Continuous Deployment (CD)**
The CD pipeline is the final stage of the automated action that uploads necessary files to S3. It is defined in the later part of the `.github/workflows/ci_cd.yml`.

#### **CD Workflow Steps**
1.  **Sync spark script to S3**:
   - Syncs spark job, data generation and kestra flow to the appropriate S3 buckets.

#### **Trigger**:
- Runs on every push to the `main` branch.

---
