#!/usr/bin/env bash

yum install -y mysql-server

# Allow mysql to be accessible outside of vagrant
sed -i_bak 's/symbolic-links=0/symbolic-links=0\nbind-address=0.0.0.0/g' /etc/my.cnf

chkconfig mysqld on
service mysqld start

# Create users and assign permissions
mysql -u root -e "CREATE USER 'vagrant'@'localhost';"
mysql -u root -e "CREATE USER 'vagrant'@'127.0.0.1';"
mysql -u root -e "CREATE USER 'vagrant'@'vagrant.local';"
mysql -u root -e "GRANT ALL PRIVILEGES ON *.* TO 'vagrant'@'localhost';"
mysql -u root -e "GRANT ALL PRIVILEGES ON *.* TO 'vagrant'@'127.0.0.1';"
mysql -u root -e "GRANT ALL PRIVILEGES ON *.* TO 'vagrant'@'vagrant.local';"
mysql -u root -e "FLUSH PRIVILEGES;"