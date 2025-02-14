#!/bin/bash
# Enable basic error debugging
PS4='+${LINENO}: '
set -u

# Basic Nextcloud installer for Raspberry Pi

# Check if the script is run as root
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

# Update and upgrade system
echo "Updating the system"
apt update && sudo apt upgrade -y

# Install required packages
echo "Installing pre-reqs"
apt install -y apache2 mariadb-server libapache2-mod-php php-gd php-json php-mysql php-curl php-mbstring php-intl php-imagick php-xml php-zip unzip

# Restart Apache
echo "Restarting the Apache service"
systemctl restart apache2

# Download and extract Nextcloud
echo "Pulling the latest version of Nextcloud"
#wget https://download.nextcloud.com/server/releases/latest.zip -P /tmp
#unzip /tmp/latest.zip -d /var/www/html/
chown -R www-data:www-data /var/www/html/

# Set up MySQL for Nextcloud using the --password option, provided by the user.
echo "Setting up the database for Nextcloud"
read -s -p "Enter MySQL password for 'nextcloud' user: " mysql_password
command="mysql --host=localhost --user=root --password=$mysql_password -e"
$command CREATE DATABASE IF NOT EXISTS nextcloud;
$command CREATE USER 'nextcloud'@'localhost' IDENTIFIED BY '$mysql_password';
$command GRANT ALL PRIVILEGES ON nextcloud.* TO 'nextcloud'@'localhost';
$command FLUSH PRIVILEGES;

echo "Success! Nextcloud is located at /var/www/html"
