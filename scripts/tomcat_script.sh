#!/usr/bin/env bash

# Script name : tomcat_script.sh
# Description : Apache Tomcat 10 installation and configuration on AWS EC2 (Amazon Linux 2)
# Author      : B.Divyasri
# Version     : 1.1 (idempotent)

#------Safety settings-------------------------------------------------------------
set -eu
# e : exit on error
# u : treat unset variables as error

#------Variables----------------------------------------------
green="\e[32m"
red="\e[31m"
blue="\e[34m"
reset="\e[0m"

#------Functions--------------------------------
print_color() {
    if [[ $? -eq 0 ]]; then
        echo -e "${green}$1${reset}"
    else
        echo -e "${red}$1${reset}"
        exit 1
    fi
}

check_service() {
    local service_name="$1"
    if systemctl is-active --quiet "$service_name"; then
        echo "Service '$service_name' is active."
    else
        echo "Service '$service_name' is inactive or not running."
        exit 1
    fi
}

#------1. Update packages--------------------------------------
echo -e "${blue}Updating packages...${reset}"
sudo yum update -y
print_color "System packages updated."

#------2. Install Java 17-------------------------------------
echo -e "${blue}Installing Java 17...${reset}"
if ! java -version &>/dev/null; then
    sudo yum install java-17-amazon-corretto -y
else
    echo "Java already installed, skipping..."
fi
print_color "Java 17 installed successfully"
java -version

#------3. Create Tomcat user-----------------------------------
echo -e "${blue}Creating tomcat user...${reset}"
if id "tomcat" &>/dev/null; then
    echo "User 'tomcat' already exists, skipping..."
else
    sudo useradd -m -U -d /opt/tomcat -s /bin/false tomcat
fi
print_color "Tomcat user ready."

#------4. Download and extract Tomcat--------------------------
echo -e "${blue}Downloading Apache Tomcat 10...${reset}"
cd /tmp

TOMCAT_VERSION="10.1.48"
TOMCAT_TAR="apache-tomcat-${TOMCAT_VERSION}.tar.gz"
TOMCAT_URL="https://downloads.apache.org/tomcat/tomcat-10/v${TOMCAT_VERSION}/bin/${TOMCAT_TAR}"

if [[ ! -f "$TOMCAT_TAR" ]]; then
    wget "$TOMCAT_URL"
else
    echo "Tomcat archive already downloaded, skipping..."
fi

if [[ -d /opt/tomcat ]]; then
    echo "/opt/tomcat already exists, skipping directory creation..."
else
    sudo mkdir /opt/tomcat
fi

sudo tar -xzvf "$TOMCAT_TAR" -C /opt/tomcat --strip-components=1
print_color "Tomcat downloaded and extracted."

#------5. Set permissions--------------------------------------
echo -e "${blue}Setting permissions...${reset}"
sudo chown -R tomcat: /opt/tomcat
sudo chmod -R 755 /opt/tomcat
print_color "Permissions set."

#------6. Create systemd service file---------------------------
echo -e "${blue}Creating systemd service file for Tomcat...${reset}"
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
print_color "Tomcat systemd service file created."

#------7. Start and enable Tomcat service-----------------------
echo -e "${blue}Starting and enabling Tomcat service...${reset}"
sudo systemctl daemon-reload
sudo systemctl enable tomcat
sudo systemctl restart tomcat
sudo systemctl status tomcat --no-pager
check_service "tomcat"
