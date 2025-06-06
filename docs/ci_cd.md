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
