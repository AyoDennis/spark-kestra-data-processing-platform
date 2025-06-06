# **Kestra Documentation**

## **1. Purpose**

Kestra is a unified orchestration platform to simplify business workflows. It provides an easy-to-use platform that supports both resource provisioning and orchestration. It schedules and monitors flows, ensuring that workflows are executed in the correct order and at the right time.

## **2. Components**
### **2.1 Kestra Deployment**
- **Kestra Server (kestra/kestra:latest)**: Kestra is deployed using Docker Compose.
- **Services**:
  - **Postgres**: Persistent storage for:
  - -  Workflow definitions
    -  Execution logs/history
    -  Task metadata.
  - **Kestra**: Orchestration engine (workflow execution, scheduling, API). It also
  - - HTTP server (port 8080) for UI/API access.
    - Executes workflows and triggers.
    - Communicates with PostgreSQL for state tracking.

### **2.2 Pyspark applications**
- **Location**: Theae are stored in the `spark/` directory.
- **Files**:
  - `data_generation.py`: Generates synthetic shipment data to be used in EMR.
  - `pyspark_app.py`: Processes raw data into structured formats using Spark on EMR.

### **2.3 Configuration**
- **Docker Compose**:
  - The `docker-compose.yml` file defines the services and their dependencies.

---

## **3. Workflow**
### **3.1 Data Generation DAG**
- **Trigger**: Runs daily at `9:00 AM`.
- **Steps**:
  1. Creates an EMR cluster.
  2. Submits the `data_generator.py` Spark job to generate synthetic data.
  3. Saves the generated data to the `raw/` folder in the S3 bucket.
  4. Terminates the EMR cluster.

### **3.2 Data Processing DAG**
- **Trigger**: Runs daily at `6:00 PM`.
- **Steps**:
  1. Creates an EMR cluster.
  2. Submits the `data_processor.py` Spark job to process raw data into structured formats.
  3. Saves the processed data to the `processed/` folder in the S3 bucket.
  4. Terminates the EMR cluster.

---

## **4. Access**
### **4.1 Airflow UI**
- **Access Method**:
  - Use SSH port forwarding or AWS SSM to access the Airflow UI.
  - Navigate to `http://localhost:8080` in your browser.

### **4.2 Logs**
- **Location**:
  - Airflow logs are stored in the `builditall-logs/airflow/` folder in the S3 bucket.

---
