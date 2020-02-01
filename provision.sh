#!/usr/bin/env bash

echo "Installing Dependencies..."
export DEBIAN_FRONTEND="noninteractive";
sudo apt-get update
sudo apt-get install -y debconf-utils vim curl

# Install MySQL
echo "Installing MySQL..."
sudo debconf-set-selections <<< 'mysql-community-server mysql-community-server/re-root-pass password root'
sudo debconf-set-selections <<< 'myvsql-community-server mysql-community-server/root-pass password root'
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password password root'
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password root'
sudo -E apt-get install -y mysql-server


# My.cnf updates
echo "Updating my.cnf..."
sudo sed -i "s/^bind-address/#bind-address/" /etc/mysql/my.cnf
echo "[mysqld]" | sudo tee -a /etc/mysql/my.cnf
echo "bind-address=0.0.0.0" | sudo tee -a /etc/mysql/my.cnf
echo "default-time-zone='+00:00'" | sudo tee -a /etc/mysql/my.cnf
echo "default-authentication-plugin=mysql_native_password" | sudo tee -a /etc/mysql/my.cnf


echo "Granting root access via any IP..."
MYSQL_PWD=root mysql -u root -e "CREATE USER 'root'@'%' IDENTIFIED BY 'root'; GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION; FLUSH PRIVILEGES; SET GLOBAL max_connect_errors=10000;"

# Start MySQL server
echo "Restarting MySQL..."
sudo service mysql restart
echo "Provisioning Complete"
