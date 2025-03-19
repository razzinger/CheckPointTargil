# 🚀 Project Overview

This repository provides all necessary components for deploying a cloud-based infrastructure and CI/CD pipeline using **AWS, Docker, Terraform, and GitHub Actions**.

## 📂 Repository Structure

```
.
├── source/             # Contains the application source code
│   ├── frontend/       # Python frontend application
│   ├── backend/        # Python backend application
├── terraform/          # Infrastructure as Code (IaC) for AWS provisioning
├── docker_files/       # Dockerfiles to pack python applications IN
├── .github/workflows/  # GitHub Actions workflows for automation
```

## 🔧 Components

### Python Applications (Frontend & Backend)

- Located in the `source/` directory.
- Both applications are built as Docker images.
- Docker images are pushed to **Docker Hub**.

### Terraform Infrastructure

- Located in the `terraform/` directory.
- Defines AWS infrastructure components according to the **network diagram**.
- Resources include:
  - **Virtual Private Cloud (VPC)**
  - **Security Groups**
  - **AWS Elastic Container Service (ECS) with Fargate instances**
  - **AWS Application Load Balancer (ALB)**
  - **S3 Bucket**
  - **SQS Queue**
  - **AWS Secrets Manager**


### GitHub Actions Workflows

- Located in `.github/workflows/`
- Two automation workflows:
  1. **Terraform Deployment Workflow**
     - Triggers when changes are detected in the `terraform/` folder on the `master` branch.
     - Applies the latest Terraform configuration to provision/update AWS infrastructure.
  2. **Docker Build & Deploy Workflow**
     - Builds and pushes Docker images to **Docker Hub**.
     - Updates the **ECS service** with the latest container images.
     - Automatically triggers upon changes to the `source/` folder.

## 🚀 Deployment Workflow

### Infrastructure Deployment

- Push changes to the `terraform/` folder in the `master` branch.
- **GitHub Actions** will apply the changes using **Terraform**.

### Application Deployment

- Push changes to the `source/` folder.
- **GitHub Actions** will build the Docker images, push them to **Docker Hub**, and update the **ECS services**.

## ✅ Prerequisites

Before you begin, ensure you have:

- An **AWS account** with necessary permissions
- **Terraform** installed (`terraform/` directory)
- **Docker** installed and configured
- A **GitHub repository** with required secrets set up for **AWS** and **Docker Hub authentication**

## 📌 Usage

1. **Clone the repository:**
   git clone https://github.com/razzinger/CheckPointTargil.git
   cd your-repo

2. **Deploy Terraform infrastructure:**
   cd terraform
   terraform init
   terraform apply

3. **Push application changes:**
   git add .
   git commit -m "Updated application code"
   git push origin master

   - This triggers the **GitHub Actions pipeline** to build and deploy the applications.

## 💬 Contact

For any issues or contributions, open an **issue** or submit a **pull request**.

