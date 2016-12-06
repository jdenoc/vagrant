#!/usr/bin/env bash

rpm -Uvh https://centos7.iuscommunity.org/ius-release.rpm
yum install -y php56u php56u-mcrypt php56u-mysql php56u-cli php56u-common php56u-pdo php56u-pear php56u-pecl-xdebug php56u-devel php56u-pecl-imagick php56u-gd

# Update php.ini
PHP_INI="/etc/php.ini"
PHP_INI_TMP="/tmp/php.ini"
sed -i_bak "s/expose_php = On/expose_php = Off/" $PHP_INI
sed "s/error_reporting = .*/error_reporting = E_ALL/" $PHP_INI > $PHP_INI_TMP; mv -f $PHP_INI_TMP $PHP_INI;
sed "s/display_errors = Off/display_errors = On/" $PHP_INI > $PHP_INI_TMP; mv -f $PHP_INI_TMP $PHP_INI;
sed "s/;error_log = php_errors.log/error_log = \/var\/log\/php_errors.log/" $PHP_INI > $PHP_INI_TMP; mv -f $PHP_INI_TMP $PHP_INI;
sed "s/;date.timezone =.*/date.timezone = \"UTC\"/" $PHP_INI > $PHP_INI_TMP; mv -f $PHP_INI_TMP $PHP_INI;
sed "s/upload_max_filesize =.*/upload_max_filesize = 10M/" $PHP_INI > $PHP_INI_TMP; mv -f $PHP_INI_TMP $PHP_INI;
sed "s/post_max_size =.*/post_max_size = 10M/" $PHP_INI > $PHP_INI_TMP; mv -f $PHP_INI_TMP $PHP_INI;

PHPD_DIR="/etc/php.d"
if [ ! -d $PHPD_DIR ]; then
  mkdir -p $PHPD_DIR;
fi

# Update xdebug.ini
XDEBUG_INI="$PHPD_DIR/xdebug.ini"
touch $XDEBUG_INI
echo "xdebug.idekey = \"vagrant\"" >> $XDEBUG_INI
echo "xdebug.remote_enable=1" >> $XDEBUG_INI
echo "xdebug.remote_connect_back=1 ;xdebug will try to connect to the client that made the HTTP request" >> $XDEBUG_INI
echo "xdebug.remote_autostart=1 ;xdebug will always attempt to start a remote debugging session and try to connect to a client" >> $XDEBUG_INI

# Assign appropriate permissions to the php error log
ERROR_LOG="/var/log/php_errors.log"
touch $ERROR_LOG
chgrp apache $ERROR_LOG
chmod 774 $ERROR_LOG

# Restart apache after updating php config files
systemctl restart httpd   # restart apache