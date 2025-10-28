#!/usr/bin/env bash

# Script Name : Nginx_installation.sh
# Description : Nginx installation and configuration on AWS EC2 (Amazon Linux 2)
# Author      : B. Divyasri
# Version     : 1.0

#------Safety settings-------------------------------------------------------------

set -eu
# e : exit on error
# u : treat unset variables as error

#------Variables------------------------------------------------------------------

green="\e[32m"
red="\e[31m"
blue="\e[34m"
reset="\e[0m"

#------Functions------------------------------------------------------------------

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
        echo -e "${green}Service '$service_name' is active and running.${reset}"
    else
        echo -e "${red}Service '$service_name' is inactive or not running.${reset}"
        exit 1
    fi
}

#------Main Script----------------------------------------------------------------

# 1. Update System Packages
echo -e "${blue}Updating system packages...${reset}"
sudo yum update -y
print_color "System packages updated successfully."

# 2. Install Nginx
echo -e "${blue}Installing Nginx web server...${reset}"
sudo amazon-linux-extras install nginx1 -y || sudo dnf install nginx -y
print_color "Nginx installed successfully."

# 3. Enable and Start Nginx Service
echo -e "${blue}Starting and enabling Nginx service...${reset}"
sudo systemctl enable nginx
sudo systemctl start nginx
print_color "Nginx service started and enabled on boot."

# 4. Check Nginx Service Status
check_service "nginx"


# 5. Create Custom Web Page
# Use single quotes to avoid history expansion issues with '!'
# This prevents the error: -bash: !: event not found
echo -e "${blue}Creating a custom Nginx web page...${reset}"
echo '<h1>Welcome to My Nginx Server on Amazon Linux!</h1>' | sudo tee /usr/share/nginx/html/index.html > /dev/null
print_color "Custom Nginx web page created."

# 6. Verify Web Page Content
echo -e "${blue}Verifying Nginx web server response...${reset}"
curl -I http://localhost || true

# 7. Display Completion Message
echo -e "${green}-------------------------------------------------${reset}"
echo -e "${green}✅ Nginx installation and configuration completed successfully.${reset}"
echo -e "${green}Visit http://<EC2-PUBLIC-IP> in your browser to confirm.${reset}"
echo -e "${green}-------------------------------------------------${reset}"
