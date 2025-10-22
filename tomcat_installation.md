## 🚀 Apache Tomcat Installation on AWS EC2 (Amazon Linux 2)

## 🧭 Overview

**Apache Tomcat** is an open-source Java application server used to deploy and run Java web applications.  
In this guide, we’ll set up **Tomcat on an EC2 instance (Amazon Linux 2)** from scratch, verify the installation, and configure it as a system service.
By the end, you’ll have Tomcat running as a systemd service and accessible via port **8080**.

---

## ⚙️ Prerequisites

Before you begin, ensure you have:

- An **AWS EC2 instance** (Amazon Linux 2)
- **Security Group** with:
  - Port **22 (SSH)** open — to connect
  - Port **8080 (HTTP)** open — to access Tomcat
- A valid **key pair (.pem file)** for SSH login
- **Sudo privileges**

---

## 🧩 Step 1: Connect to Your EC2 Instance

Use SSH to connect from your local machine:

```bash
ssh -i your-key.pem ec2-user@<your-ec2-public-ip>
```

> Replace **your-key.pem** and **<your-ec2-public-ip>** with your actual key file and public IP address.

---

## ⚙️ Step 2: Update System Packages

```bash
sudo yum update -y
```

---

## ☕ Step 3: Install Java 17 (Amazon Corretto)

Tomcat requires Java to run.

```bash
sudo yum install -y java-17-amazon-corretto
java -version
```

Expected output:

```
openjdk version "17.0.x"
```

✅ **Java is ready.**

---

## 🧱 Step 4: Create a Dedicated Tomcat User

Running Tomcat as root is not recommended.

```bash
sudo useradd -m -U -d /opt/tomcat -s /bin/false tomcat
```

---

## 📦 Step 5: Download Apache Tomcat

Download the latest **Tomcat 10** tarball:

```bash
cd /tmp
wget https://downloads.apache.org/tomcat/tomcat-10/v10.1.31/bin/apache-tomcat-10.1.31.tar.gz
```

> If a newer version is available, update the version number in the URL.

---

## 🗜️ Step 6: Extract and Move Tomcat Files

```bash
sudo mkdir /opt/tomcat
sudo tar -xzvf apache-tomcat-10.1.31.tar.gz -C /opt/tomcat --strip-components=1
```

This extracts all files into `/opt/tomcat`.

---

## 🔑 Step 7: Set Permissions

```bash
sudo chown -R tomcat: /opt/tomcat
sudo chmod -R 755 /opt/tomcat
```

---

## ⚙️ Step 8: Create a systemd Service File

Create a service unit to manage Tomcat using `systemctl`:

```bash
sudo tee /etc/systemd/system/tomcat.service > /dev/null <<EOF
[Unit]
Description=Apache Tomcat Web Application Container
After=network.target

[Service]
Type=forking

User=tomcat
Group=tomcat

Environment="JAVA_HOME=/usr/lib/jvm/java-17-amazon-corretto.x86_64"
Environment="CATALINA_PID=/opt/tomcat/temp/tomcat.pid"
Environment="CATALINA_HOME=/opt/tomcat"
Environment="CATALINA_BASE=/opt/tomcat"
Environment="CATALINA_OPTS=-Xms512M -Xmx1024M -server -XX:+UseParallelGC"
Environment="JAVA_OPTS=-Djava.awt.headless=true -Djava.security.egd=file:/dev/./urandom"

ExecStart=/opt/tomcat/bin/startup.sh
ExecStop=/opt/tomcat/bin/shutdown.sh

[Install]
WantedBy=multi-user.target
EOF
```
<h3 align="left">service-file</h3>
<p align="left">
  <img src="./images/service-file.png" alt="service-file" 
       width="500" height="300" 
       style="border:8px solid black; border-radius:5px;">
</p>
---

## 🔁 Step 9: Reload Daemon and Start Tomcat

```bash
sudo systemctl daemon-reload
sudo systemctl enable tomcat
sudo systemctl start tomcat
```

Check the service status:

```bash
sudo systemctl status tomcat
```

✅ Expected: `active (running)`

<h3 align="left">tomcat-status</h3>
<p align="left">
  <img src="./images/tomcat-status.png" alt="tomcat-status" 
       width="500" height="300" 
       style="border:8px solid black; border-radius:5px;">
</p>

---

## 🌐 Step 10: Allow Port 8080 in Security Group

1. Go to your **AWS EC2 Console**
2. Navigate to **Security Groups** → Select your instance’s security group
3. Choose **Inbound rules → Edit inbound rules**
4. Add a rule:

| Type       | Protocol | Port Range | Source                    |
| ---------- | -------- | ---------- | ------------------------- |
|  SSH       | TCP      | 22         | My IP                     |
| HTTP       | TCP      | 80         | 0.0.0.0/0                 |
| Custom TCP | TCP      | 8080       | 0.0.0.0/0                 |  
---



## 🧭 Step 11: Access Tomcat in Your Browser

Visit:

```
http://<your-ec2-public-ip>:8080
```

🎉 You should see the **Apache Tomcat welcome page!**

<h3 align="left">tomcat-page</h3>
<p align="left">
  <img src="./images/tomcat-page.png" alt="tomcat-page" 
       width="500" height="300" 
       style="border:8px solid black; border-radius:5px;">
</p>



---

## 🧩 Verification

To verify Tomcat is responding:

```bash
curl http://localhost:8080
```

If successful, you’ll see the HTML of the Tomcat homepage.

---


