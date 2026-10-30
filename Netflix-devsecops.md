
# 🎬 Netflix Clone DevSecOps CI/CD Pipeline

## 📌 Project Overview

This project demonstrates a complete **DevSecOps CI/CD pipeline** for deploying a Netflix Clone application using modern tools and best practices.

It integrates:

* Continuous Integration & Delivery
* Security Scanning (Shift Left)
* Containerization & Orchestration
* Monitoring & Alerting

---

## 🏗️ Architecture Overview

```
Developer → GitHub → Jenkins Pipeline
                      ├── Code Analysis (SonarQube)
                      ├── Dependency Check (OWASP / NPM Audit)
                      ├── File Scan (Trivy)
                      ├── Docker Build & Push
                      ├── Image Scan (Trivy)
                      ├── Deployment
                      │     ├── Docker Container
                      │     └── Kubernetes (EKS)
                      └── Monitoring (Prometheus + Grafana)
```

---

## 🚀 Tech Stack

### 🔧 DevOps Tools

* Jenkins (CI/CD)
* Docker
* Kubernetes (EKS)
* Terraform

### 🔐 Security Tools

* SonarQube (Code Quality)
* Trivy (Vulnerability Scanner)
* OWASP Dependency Check
* OWASP ZAP

### 📊 Monitoring

* Prometheus
* Grafana
* Node Exporter

### ☁️ Cloud

* AWS EC2
* AWS EKS
* IAM Roles

---

## 📂 Project Workflow

### 1️⃣ Source Control

* Developer pushes code to GitHub
* Webhook triggers Jenkins pipeline

---

### 2️⃣ CI/CD Pipeline (Jenkins)

Pipeline stages:

* Checkout Code
* SonarQube Analysis
* Quality Gate Check
* Install Dependencies
* Trivy File Scan
* Docker Build & Push
* Image Scan
* Deployment

---

### 3️⃣ Security & Quality Gates

| Tool                   | Purpose                 |
| ---------------------- | ----------------------- |
| SonarQube              | Static Code Analysis    |
| OWASP Dependency Check | Vulnerable dependencies |
| Trivy FS               | File system scan        |
| Trivy Image            | Docker image scan       |
| OWASP ZAP              | Dynamic testing         |

---

### 4️⃣ Build & Containerization

* Docker image built using:

```bash
docker build -t netflix .
```

* Push to Docker Hub:

```bash
docker push <docker-username>/netflix:latest
```

---

### 5️⃣ Deployment

#### Option 1: Docker

```bash
docker run -d -p 8081:80 netflix
```

#### Option 2: Kubernetes (EKS)

```bash
kubectl apply -f deployment.yml
kubectl apply -f service.yml
```

---

### 6️⃣ Monitoring

* **Prometheus** collects metrics
* **Grafana** visualizes dashboards
* **Node Exporter** monitors system metrics

Access:

* Prometheus → `http://<ip>:9090`
* Grafana → `http://<ip>:3000`

---

## ⚙️ Setup Instructions

### 🔹 Step 1: EC2 Setup

* Launch Ubuntu 24.04 instance
* Instance type: `t2.large`
* Storage: `50GB`
* Attach IAM Role with Admin access

---

### 🔹 Step 2: Install Tools

Run scripts:

```bash
script1.sh   # Terraform, kubectl, AWS CLI
script2.sh   # Jenkins, Docker, Java
trivy.sh     # Trivy
```

---

### 🔹 Step 3: SonarQube Setup

```bash
docker run -d -p 9000:9000 sonarqube:lts-community
```

Access:

```
http://<ip>:9000
```

---

### 🔹 Step 4: TMDB API Key

* Create account in TMDB
* Generate API Key
* Use in Docker build:

```bash
--build-arg TMDB_V3_API_KEY=<your-key>
```

---

### 🔹 Step 5: Prometheus & Grafana

* Install Prometheus
* Install Node Exporter
* Install Grafana

Add Prometheus as data source in Grafana.

---

### 🔹 Step 6: Jenkins Configuration

Install Plugins:

* JDK
* NodeJS
* SonarQube Scanner
* Docker
* OWASP Dependency Check
* Prometheus

---

### 🔹 Step 7: Email Notifications

Configure SMTP:

* Server: smtp.gmail.com
* Port: 465
* App Password required

---

### 🔹 Step 8: Terraform (EKS Setup)

Pipeline supports:

* `apply` → create cluster
* `destroy` → delete cluster

---

### 🔹 Step 9: Kubernetes Deployment

Update kubeconfig:

```bash
aws eks update-kubeconfig --region ap-south-1 --name EKS_CLUSTER
```

---

## 📜 Jenkins Pipeline (Final)

Key stages:

* SonarQube Scan
* Quality Gate
* Trivy FS Scan
* Docker Build & Push
* Trivy Image Scan
* Deploy to Docker
* Deploy to Kubernetes

---

## 📊 Monitoring Dashboards

Grafana Dashboard IDs:

* Node Exporter: `1860`
* Jenkins Metrics: `9964`

---

## ⚠️ Troubleshooting

### Docker Permission Issue

```bash
sudo chmod 777 /var/run/docker.sock
```

---

### Container Already Exists

```bash
docker ps -a
docker stop <id>
docker rm <id>
```

---

### Kubernetes Service Not Accessible

```bash
kubectl get svc
kubectl patch svc netflix-app -p '{"spec": {"type": "LoadBalancer"}}'
```

---

## 🧹 Cleanup

* Destroy EKS cluster:

```bash
terraform destroy
```

* Terminate EC2 instances

---

## ✅ Key Features

✔ End-to-End CI/CD Pipeline
✔ Integrated Security (DevSecOps)
✔ Automated Deployment
✔ Scalable Kubernetes Setup
✔ Real-time Monitoring

---

## 📌 Conclusion

This project showcases a **complete production-ready DevSecOps pipeline** integrating:

* Automation
* Security
* Scalability
* Observability

---

If you want, I can also:

* Convert this into **PDF**
* Add **architecture diagram**
* Or make it **resume-ready project description** 🚀
