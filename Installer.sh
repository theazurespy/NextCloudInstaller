#!/bin/bash

# Basic Nextcloud installer for Raspberry Pi

# Check if the script is run as root
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

# Update and upgrade system
apt update && sudo apt upgrade -y

# Install required packages
apt install -y apache2 mariadb-server libapache2-mod-php php-gd php-json php-mysql php-curl php-mbstring php-intl php-imagick php-xml php-zip

# Restart Apache
systemctl restart apache2

# Download and extract Nextcloud
wget https://download.nextcloud.com/server/releases/latest.zip -P /tmp
unzip /tmp/latest.zip -d /var/www/html/
chown -R www-data:www-data /var/www/html/nextcloud

# Prompt user for MySQL password
read -s -p "Enter MySQL password for 'nextcloud' user: " mysql_password
echo

# Set up MySQL for Nextcloud using the --password option
mysql --user=root --password=$mysql_password <<EOF
CREATE DATABASE nextcloud;
CREATE USER 'nextcloud'@'localhost' IDENTIFIED BY '$mysql_password';
GRANT ALL PRIVILEGES ON nextcloud.* TO 'nextcloud'@'localhost';
FLUSH PRIVILEGES;
EXIT
EOF
