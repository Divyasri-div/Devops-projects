
# 🧭 Installation of  Nginx on AWS EC2 (Amazon Linux)

## 📘 Overview
This guide explains how to install, start, and verify **Nginx** on an **Amazon Linux** EC2 instance.  
Nginx is a lightweight, high-performance web server used for serving static content, reverse proxying, and load balancing.

---

## ⚙️ Prerequisites
Before starting, ensure you have:
- An **AWS account** with EC2 access.
- One **Amazon Linux 2** instance (e.g., `t2.micro`).
- A **key pair (.pem file)** for SSH access.
- **Security Group** allowing inbound:
  - Port **22 (SSH)** from your IP.
  - Port **80 (HTTP)** from anywhere (`0.0.0.0/0`).

---

## 🚀 Steps to Install and Configure Nginx

### 1. Connect to Your EC2 Instance
Use your terminal to connect via SSH:

```bash
ssh -i "your-key.pem" ec2-user@<EC2-PUBLIC-IP>
````

> Replace `your-key.pem` with your private key filename, and `<EC2-PUBLIC-IP>` with your EC2 instance’s public IP address.

---

### 2. Update System Packages

It’s good practice to update all installed packages before installation:

```bash
sudo yum update -y
```

---

### 3. Install Nginx

```bash
sudo yum install nginx -y
```

---

### 4. Start and Enable Nginx

Start the Nginx service and enable it to run on boot:

```bash
sudo systemctl start nginx
sudo systemctl enable nginx
```

Check its status:

```bash
sudo systemctl status nginx
```

✅ You should see: `Active: active (running)`
<h3 align="left">nginx-status</h3>
<p align="left">
  <img src="./images/nginx-status.png" alt="nginx-status" 
       width="500" height="300" 
       style="border:8px solid black; border-radius:5px;">
</p>

---

### 5. Allow HTTP Traffic (if not already)

In the AWS Management Console:

1. Go to **EC2 → Instances → Security → Security Groups**.
2. Edit inbound rules → Add rule:

   * **Type:** HTTP
   * **Protocol:** TCP
   * **Port Range:** 80
   * **Source:** 0.0.0.0/0

---

### 6. Verify Installation

Open your browser and visit:

```
http://<EC2-PUBLIC-IP>
```

You should see the **Nginx Welcome Page** 🎉
<h3 align="left">nginx-webpage</h3>
<p align="left">
  <img src="./images/nginx-webpage.png" alt="nginx-webpage" 
       width="500" height="300" 
       style="border:8px solid black; border-radius:5px;">
</p>
Or check from the terminal:

```bash
curl http://localhost
```

---

### 7. Manage Nginx Service

| Action               | Command                        |
| -------------------- | ------------------------------ |
| Restart              | `sudo systemctl restart nginx` |
| Stop                 | `sudo systemctl stop nginx`    |
| Reload Configuration | `sudo nginx -s reload`         |
| Check Config Syntax  | `sudo nginx -t`                |

---

### 8. Default File Locations

| Path                     | Description                    |
| ------------------------ | ------------------------------ |
| `/etc/nginx/nginx.conf`  | Main configuration file        |
| `/etc/nginx/conf.d/`     | Additional configuration files |
| `/usr/share/nginx/html/` | Default web root directory     |
| `/var/log/nginx/`        | Log files (access/error logs)  |

---

### 9. Custom Web Page (Optional)

Replace the default index page:

```bash
echo '<h1>Welcome to My Nginx Server on Amazon Linux!</h1>' | sudo tee /usr/share/nginx/html/index.html > /dev/null
```
🟢 Note:
If you accidentally use double quotes ("") instead of single quotes (''), Bash may show the error:

-bash: !: event not found


This happens because the exclamation mark (!) triggers history expansion in Bash.
To avoid it, always use single quotes when writing HTML or text that contains !.


Then reload Nginx:

```bash
sudo systemctl reload nginx
```

Visit your EC2 Public IP again — your custom message should appear.
<h3 align="left">custom-webpage</h3>
<p align="left">
  <img src="./images/custom-webpage.png" alt="custom-webpage" 
       width="500" height="300" 
       style="border:8px solid black; border-radius:5px;">
</p>

