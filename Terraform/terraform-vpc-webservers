
# 🌐 Terraform Project: VPC with Two Web Servers (User Data)

## 📌 Project Overview

This Terraform project provisions a complete AWS infrastructure including:

- Custom VPC
- Public Subnet
- Internet Gateway
- Route Table
- Security Group
- Two EC2 Instances (Web Servers)

Each EC2 instance uses **user_data** to automatically install Apache and host a web page.

---

## 🏗️ Architecture

```

VPC (10.0.0.0/16)
│
├── Public Subnet (10.0.1.0/24)
│   │
│   ├── EC2 Instance 1 (Apache - Server 1)
│   └── EC2 Instance 2 (Apache - Server 2)
│
├── Internet Gateway
└── Route Table (0.0.0.0/0 → IGW)

```

---

## ⚙️ Technologies Used

- Terraform
- AWS EC2
- AWS VPC
- Apache Web Server (httpd)
- Linux (Amazon Linux 2)

---

## 📁 Project Structure

```

terraform-vpc-web/
│── main.tf
│── variables.tf
│── outputs.tf

````

---

## 🔧 Variables

| Variable        | Description              | Default Value     |
|----------------|--------------------------|------------------|
| region         | AWS Region               | ap-south-1       |
| ami            | Amazon Linux 2 AMI       | (Mumbai AMI ID)  |
| instance_type  | EC2 Instance Type        | t3.micro         |

---

## 🚀 Resources Created

### 1. VPC
- CIDR: `10.0.0.0/16`

### 2. Subnet
- Public subnet with auto-assign public IP

### 3. Internet Gateway
- Enables internet access

### 4. Route Table
- Routes all traffic (`0.0.0.0/0`) to IGW

### 5. Security Group
- Allows:
  - HTTP (Port 80)
  - SSH (Port 22)

### 6. EC2 Instances (2)
- Apache installed using user_data
- Each serves a different webpage:
  - Server 1
  - Server 2

---

## ⚙️ User Data Script

Each EC2 instance runs the following script:

```bash
#!/bin/bash
yum update -y
yum install httpd -y
systemctl start httpd
systemctl enable httpd
echo "<h1>Server 1</h1>" > /var/www/html/index.html
````

(Server 2 uses "Server 2" in HTML)

---

## ▶️ How to Run

### Step 1: Initialize Terraform

```bash
terraform init
```

### Step 2: Preview Changes

```bash
terraform plan
```

### Step 3: Apply Configuration

```bash
terraform apply
```

---

## 📤 Outputs

After deployment, Terraform will output:

* Public IP of Web Server 1
* Public IP of Web Server 2

---

## 🌐 Access the Application

Open in browser:

```
http://<web1_public_ip>
http://<web2_public_ip>
```

