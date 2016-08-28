#!/usr/bin/env bash

# Install MySQL 5.6
rpm -ivh http://repo.mysql.com/mysql-community-release-el7-5.noarch.rpm
yum-config-manager --disable mysql57-community
yum-config-manager --enable mysql56-community
yum-config-manager --disable mysql55-community
yum install -y mysql-community-server

# Allow mysql to be accessible outside of vagrant
sed -i_bak "s/symbolic-links=0/symbolic-links=0\nbind-address=0.0.0.0/g" /etc/my.cnf

systemctl enable mysqld # make sure MySQL starts at boot
systemctl start mysqld  # start MySQL

# Setup MySQL timezone(s)
mysql_tzinfo_to_sql /usr/share/zoneinfo > /tmp/zone_import.sql
cat /tmp/zone_import.sql | mysql -u root mysql
sed -i "s/symbolic-links=0/symbolic-links=0\ndefault_time_zone=UTC/g" /etc/my.cnf

# Create users and assign permissions
mysql -u root -e "CREATE USER 'vagrant'@'localhost';"
mysql -u root -e "CREATE USER 'vagrant'@'127.0.0.1';"
mysql -u root -e "CREATE USER 'vagrant'@'jdenoc.local';"
mysql -u root -e "GRANT ALL PRIVILEGES ON *.* TO 'vagrant'@'localhost';"
mysql -u root -e "GRANT ALL PRIVILEGES ON *.* TO 'vagrant'@'127.0.0.1';"
mysql -u root -e "GRANT ALL PRIVILEGES ON *.* TO 'vagrant'@'jdenoc.local';"
mysql -u root -e "FLUSH PRIVILEGES;"