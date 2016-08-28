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
sed "s/#ServerName .*/ServerName jdenoc.local\:80/" $HTTPD_CONF > $HTTPD_CONF_TMP; mv -f $HTTPD_CONF_TMP $HTTPD_CONF
sed "s/#EnableSendfile off/EnableSendfile off/" $HTTPD_CONF > $HTTPD_CONF_TMP; mv -f $HTTPD_CONF_TMP $HTTPD_CONF    # Stops some annoying apache caching
sed "s/EnableSendfile .*/EnableSendfile off/" $HTTPD_CONF > $HTTPD_CONF_TMP; mv -f $HTTPD_CONF_TMP $HTTPD_CONF      # In case it was already turned on and not caught on the line above
echo "" >> $HTTPD_CONF
echo "# Load vhost config files in the \"/etc/httpd/vhosts.d\" directory, if any." >> $HTTPD_CONF
echo "IncludeOptional vhosts.d/*.conf" >> $HTTPD_CONF

VHOSTS_DIR="/etc/httpd/vhosts.d"
if [ ! -d $VHOSTS_DIR ]; then
  mkdir -p $VHOSTS_DIR;
fi

systemctl enable httpd.service  # make sure apache starts at boot
systemctl start httpd.service   # start apache

# Create server vhost
WEB_ROOT=/var/www/html
/vagrant/create_domain.sh -d jdenoc.local -f $WEB_ROOT
mv $WEB_ROOT/index.html $WEB_ROOT/index.php
echo "<?php phpinfo(); ?>" >> $WEB_ROOT/index.php