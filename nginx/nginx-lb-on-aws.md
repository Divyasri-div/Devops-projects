# AWS EC2 Load-Balanced Web Tier (Amazon Linux)

## 📘 Overview
Deploy a simple web tier on **Amazon Linux** using:
- Three Apache (`httpd`) app servers
- One Nginx load balancer (round-robin)
- AWS Security Groups for access control

---

## 🧱 Architecture
        +----------------------+
        |   Client / Browser   |
        +----------+-----------+
                   |
                   v
        +----------+-----------+
        |  Nginx Load Balancer |
        |  demo-lb (10.0.1.10) |
        +----------+-----------+
                   |
   -----------------------------------------
   |                    |                   |
   v                    v                   v
+--------+ +--------+ +--------+
| app1 | | app2 | | app3 |
| httpd | | httpd | | httpd |
|10.0.1.11| |10.0.1.12| |10.0.1.13|
+--------+ +--------+ +--------+
---

## ⚙️ Prerequisites
- AWS account with EC2 access  
- One SSH key pair (`.pem` file)  
- Basic Linux CLI familiarity  

---

## 🚀 Step-by-Step Deployment

### 1️.Launch EC2 Instances
| Name | AMI | Type | SG | Purpose |
|------|-----|------|----|----------|
| demo-lb | **Amazon Linux 2/2023** | t2.micro | `lb-sg` | Nginx load balancer |
| demo-app1 | Amazon Linux | t2.micro | `web-sg` | Apache app1 |
| demo-app2 | Amazon Linux | t2.micro | `web-sg` | Apache app2 |
| demo-app3 | Amazon Linux | t2.micro | `web-sg` | Apache app3 |

---

### 2️.Configure Security Groups
**`lb-sg` (load balancer)**  
| Type | Protocol | Port | Source |
|------|-----------|------|--------|
| HTTP | TCP | 80 | 0.0.0.0/0 |
| SSH  | TCP | 22 | My IP |
| Outbound | All traffic | All | 0.0.0.0/0 |

**`web-sg` (app servers)**  
| Type | Protocol | Port | Source |
|------|-----------|------|--------|
| HTTP | TCP | 80 | lb-sg |
| SSH  | TCP | 22 | My IP |
| Outbound | All traffic | All | 0.0.0.0/0 |

---

### 3️. Connect via SSH
```bash
ssh -i mykey.pem ec2-user@<instance_public_ip>
```


### 4.Configure Apache (httpd) on app1/app2/app3
```bash
sudo yum update -y
sudo yum install -y httpd
sudo systemctl enable httpd
sudo systemctl start httpd
```


### 5.Set a unique web page on each:

# app1
```bash
echo "<h1>Hello, I am APP1</h1>" | sudo tee /var/www/html/index.html
```
# app2
```bash
echo "<h1>Hello, I am APP2</h1>" | sudo tee /var/www/html/index.html
```
# app3
```bash
echo "<h1>Hello, I am APP3</h1>" | sudo tee /var/www/html/index.html
```

### 6.Verify locally:
```bash
curl http://localhost
```

### 7.Configure Nginx on the Load Balancer
```bash
sudo yum update -y
sudo amazon-linux-extras enable nginx1
sudo yum install -y nginx
sudo systemctl enable nginx
sudo systemctl start nginx
```

Edit /etc/nginx/nginx.conf → ensure a single http {} block and include /etc/nginx/conf.d/*.conf; line exist.

### 8.Create /etc/nginx/conf.d/lb.conf:

upstream backend_pool {
    server 10.0.1.11:80;
    server 10.0.1.12:80;
    server 10.0.1.13:80;
}

server {
    listen 80;
    server_name _;

    location / {
        proxy_pass http://backend_pool;
        proxy_set_header Host $host;
        proxy_set_header X-Forwarded-For $remote_addr;
    }
}
### 9.Validate and reload:
```bash
sudo nginx -t
sudo systemctl restart nginx
```

### 10.Test the Setup

From your laptop:
```bash
curl http://<lb_public_ip>
```

### Run several times → responses should alternate:

Hello, I am APP1
Hello, I am APP2
Hello, I am APP3


###🏁 Result

✅ 3 Apache servers behind an Nginx load balancer on Amazon Linux
✅ Clean round-robin load balancing
✅ Isolated access via AWS Security Groups