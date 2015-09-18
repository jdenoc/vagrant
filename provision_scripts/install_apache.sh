#!/usr/bin/env bash

yum install -y httpd mod_ssl

# Add vagrant user to apache group
usermod -G apache vagrant

# Update httpd.conf file
HTTPD_CONF="/etc/httpd/conf/httpd.conf"
HTTPD_CONF_TMP="/tmp/httpd.conf"
sed -i_bak "s/\#NameVirtualHost \*\:80/NameVirtualHost \*\:80/" $HTTPD_CONF
sed "s/User apache/User vagrant/" $HTTPD_CONF > $HTTPD_CONF_TMP; mv -f $HTTPD_CONF_TMP $HTTPD_CONF
sed "s/ServerAdmin .*/ServerAdmin jdenoc@gmail.com/" $HTTPD_CONF > $HTTPD_CONF_TMP; mv -f $HTTPD_CONF_TMP $HTTPD_CONF
sed "s/#ServerName .*/ServerName vagrant.local\:80/" $HTTPD_CONF > $HTTPD_CONF_TMP; mv -f $HTTPD_CONF_TMP $HTTPD_CONF
sed "s/#EnableSendfile off/EnableSendfile off/" $HTTPD_CONF > $HTTPD_CONF_TMP; mv -f $HTTPD_CONF_TMP $HTTPD_CONF
sed "s/DocumentRoot .*/DocumentRoot \"\/var\/www\"/" $HTTPD_CONF > $HTTPD_CONF_TMP; mv -f $HTTPD_CONF_TMP $HTTPD_CONF
sed "s/<Directory \"\/var\/www\/html\">/<Directory \"\/var\/www\">/" $HTTPD_CONF > $HTTPD_CONF_TMP; mv -f $HTTPD_CONF_TMP $HTTPD_CONF
echo "" >> $HTTPD_CONF
echo "SetEnv ENVIRONMENT local" >> $HTTPD_CONF

chkconfig httpd on
service httpd start

/vagrant/create_domain.sh -d vagrant.local -f /var/www > /dev/null
mv /var/www/index.html /var/www/index.php
echo "<?php phpinfo(); ?>" >> /var/www/index.php