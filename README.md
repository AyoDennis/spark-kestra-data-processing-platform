# Logistics Big Data Platform
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


## Solution Elements

| Element | Purpose |
|:----------|:--------|
| [Architecture](https://github.com/AyoDennis/spark-kestra-data-processing-platform/blob/main/docs/architecture.md) | High-level overview and structure | 
| [CI/CD (GitHub Actions)](https://github.com/AyoDennis/spark-kestra-data-processing-platform/blob/main/docs/ci_cd.md) | Automates code deployment and infrastructure updates |
| [Data Processing (PySpark)](https://github.com/AyoDennis/spark-kestra-data-processing-platform/blob/main/docs/spark_configuration.md) | Simulates realistic shipping/logistics datasets and processing |
| [Infrastructure (Terraform)](https://github.com/AyoDennis/spark-kestra-data-processing-platform/blob/main/docs/terraform_infrastructure.md) | Automates cloud setup (IAM, S3, networking) |
| [Orchestration (Kestra)](https://github.com/AyoDennis/spark-kestra-data-processing-platform/blob/main/docs/kestra_configuration.md) | Manages data pipeline workflows |


## Architecture Overview

![image](https://github.com/AyoDennis/spark-kestra-data-processing-platform/blob/main/asset/platform_architecture.png)

**Architecture** outlining the platform’s design.

For Architecture documentation[ Click here](https://github.com/AyoDennis/spark-kestra-data-processing-platform/blob/main/docs/architecture.md)

## Technologies Used
- Cloud: AWS Servicess (S3, EMR, IAM, VPC, SSM)
- Big Data Framework: Apache Spark
- Workflow Orchestration: Kestra
- Infrastructure: Terraform
- Automation: GitHub Actions
- Programming Languages: Python, PySpark


## Deploymemt
For immediate use, refer to the [documentation](https://github.com/AyoDennis/spark-kestra-data-processing-platform/blob/main/docs/user_guide.md)

## Key Features
1. **Scalable Big Data Processing Platform** <br>
Leveraging the distributed processing framework of Apache Spark to seamlessly handle large datasets. The platform supports dynamic batch and real-time business needs.

2. **Cost-Optimized Cloud Infrastructure** <br>
Utilizes AWS on-demand resources to minimise costs without compromising on performance. Provisioned with Terraform for reproducible and version-controlled infrastructure.

3. **Modular and Maintainable Architecture** <br>
Designed for easy scalability and maintainability, utilizing AWS's shared responsibility model to abstract core backend operations such as spark updates/patching from users. The detailed code, including explicit input and output sources fosters efficient debugging and adaptation to needs.

4. **Automated Data Pipelines** <br>
Kestra, a unified orchestration platform is used for both provisioning the cluster and orchestrating it's complex workflows for optimal dataflow for downstream users.

5. **Monitoring and Logging** <br>
For monitoring and efficient troubleshooting, logging is enabled during data generation and processing to reduce operational bottlenecks.

6. **Data Lake Storage with AWS S3** <br>
Source, Input and Output date are stored in S3, serving as a data lake for retrieval to EMR (processing) and integration  to other downstream systems for advanced analytics.

7. **CI/CD Automation** <br>
GitHub Actions for continuous integration and continuous deployment, enabling automated testing, builds, and deployment of code and infrastructure.

8. **Production-Ready Setup** <br>
Designed with best practices to meet production-level requirements for performance, security, and maintainability, ensuring readiness for full deployment.

9. **Client Onboarding Ready** <br>
Built to be easily understood and managed by the client with a focus on user-friendly maintenance and smooth adoption for future scaling.

## Best Practices
- **Infrastructure as Code (IaC):** 
Entire provisioning of cloud resources (S3 buckets; IAM roles, users, policies; VPC subnet, internet gateway networking) using Terraform for reproducibility, version control, and easy updates. <br>

- **Modular Code Structure:** 
The repository is organized into modules: infrastructure, orchestration, data processing, and CI/CD, improving maintainability and collaboration. <br>

- **Environment Isolation:** 
Full isolation of raw and processed data in AWS S3. The lake is also treated as immutable, following data lake design principles.

- Detailed [documentation](https://github.com/AyoDennis/spark-kestra-data-processing-platform/tree/main/docs) to aid onboarding, repository cloning, and commercial deployment.
