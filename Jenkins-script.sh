#!/usr/bin/env bash


# Script name : Jenkins_script.sh
# Description : Jenkins installation and configuration on AWS Ec2 (Amazon Linux 2)
# Author      : B.Divyasri
# Version     : 1.0


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

print_color(){
if [[ $? -eq 0 ]] ; then
echo -e "${green} $1 ${reset}"
else
echo -e  "${red} $1 ${reset}"
exit 1
fi
}


check_service(){
    local service_name="$1"

    if systemctl is-active --quiet "$service_name"; then
        echo "Service '$service_name' is active."
        exit 0
    else
        echo "Service '$service_name' is inactive or not running."
        exit 1
    fi
}



# 1. Update packages

echo -e "${blue}updating packages......${reset}"

sudo yum update -y

print_color "system packages updated."


# 2. Install Java 17 

echo -e "${blue}installing java 17......${reset}"

sudo yum install java-17-amazon-corretto -y

echo -e "${green}Java 17 installed successfully.${reset}"

print_color " Java installed successfully"

#verify java :

java -version

# 3. Add jenkins repository

echo -e "${blue}Adding jenkins repository......${reset}"

sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo

sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key

print_color "jenkins repository added"

# 4. Install Jenkins

echo -e "${blue}installing jenkins......${reset}"

sudo yum install jenkins -y

print_color "Jenkins installed successfully"

# 5. Start and Enable Jenkins Service

 echo -e "${blue}starting and enabling jenkins service......${reset}"
 
sudo systemctl enable jenkins
sudo systemctl start jenkins
sudo systemctl status jenkins

check_service "jenkins"
 
 









