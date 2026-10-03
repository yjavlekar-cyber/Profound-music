# 🎭 Profound — Official Artist Profile Platform

Welcome to the official source repository for **Profound**. This project is a cloud-native, production-grade web platform designed to host the artist profile, portfolios, and dynamic media galleries for Profound. 

The architecture leverages a lightweight frontend, a secure API backend, relational data persistence, and a modern **GitOps** continuous delivery pipeline.

---

## 🏗️ Architecture Overview

The platform is designed to be highly available, scalable, and fully automated from code commit to production deployment.

* **Frontend:** Static, high-performance HTML/CSS/JS served efficiently.
* **Backend:** Node.js runtime environment handling portfolio data and dynamic API requests.
* **Database:** PostgreSQL for robust, relational storage of artwork metadata, updates, and profile configurations.
* **Infrastructure as Code (IaC):** Terraform scripts provisioning a secure AWS EKS (Elastic Kubernetes Service) cluster, VPC, and networking layers.
* **Orchestration:** Custom Helm charts defining Kubernetes manifests for absolute environmental consistency.

---

## 🚀 CI/CD & GitOps Pipeline Flow

The repository operates on a fully automated, hands-off deployment lifecycle triggered by git push events:

```text
[ Code Commit ] 
       │
       ▼
[ CI Pipeline: GitHub Actions ]
       ├── Static Code Analysis (Linting & Security Scans)
       ├── Docker Image Build & Optimization
       └── Push Verified Images to Docker Hub
       │
       ▼
[ Helm Update ] 
       └── Pipeline updates values.yaml with new tags and pushes to GitHub
       │
       ▼
[ CD Pipeline: Argo CD ]
       ├── Tracks the deployment repository
       ├── Detects the changes pushed by GitHub Actions
       └── Pulls and synchronizes state onto the AWS EKS Cluster
```

---

## 📁 Repository Structure

```text
├── .github/workflows/   # CI/CD Pipeline definitions (GitHub Actions)
├── backend/             # Node.js API application source code
├── frontend/            # HTML/CSS static profile source files
├── terraform/           # Infrastructure as Code files (EKS, VPC, AWS resources)
├── k8s/                 # Helm charts and values.yaml definitions
├── Dockerfile.frontend  # Production container definition for the profile view
├── Dockerfile.backend   # Production container definition for the API layer
└── README.md            # Project documentation
```

---

## 🛠️ Local Development Quickstart

To run the application locally outside of Kubernetes using Docker Compose:

1. **Clone the repository:**
   ```bash
   git clone https://github.com
   cd profound-artist-profile
   ```

2. **Configure environmental variables:**
   Create a `.env` file in the root directory and specify your local PostgreSQL credentials.

3. **Spin up the stack:**
   ```bash
   docker compose up --build
   ```
   * Access the profile view at `http://localhost:8080`
   * Access the API layer at `http://localhost:5000`

---

## 🌐 Production Infrastructure Deployment

### Phase 1: Infrastructure Provisioning
```bash
cd terraform
terraform init
terraform apply -auto-approve
```

### Phase 2: Cluster Connection & Core Tooling
```bash
# Sync your terminal's kubectl context with AWS EKS
aws eks update-kubeconfig --region <your-aws-region> --name profound-cluster

# Install Ingress NGINX & Argo CD via Helm
helm install ingress-nginx ingress-nginx/ingress-nginx -n ingress-nginx --create-namespace
helm install argocd argo/argo-cd -n argocd --create-namespace
```

### Phase 3: Accessing the Portfolio Administration Dashboards
Extract the securely auto-generated Argo CD admin password using:
```bash
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 --decode; echo
```
