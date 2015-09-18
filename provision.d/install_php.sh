#!/usr/bin/env bash

rpm -Uvh https://mirror.webtatic.com/yum/el6/latest.rpm
yum install -y php56w php56w-opcache php56w-mcrypt php56w-mysql php56w-cli php56w-common php56w-pdo php56w-pear php56w-pecl-xdebug php56w-soap php56w-ldap php56w-devel libssh2-devel

# Update php.ini
PHP_INI="/etc/php.ini"
PHP_INI_TMP="/tmp/php.ini"
sed -i_bak "s/expose_php = On/expose_php = Off/" $PHP_INI
sed "s/error_reporting = .*/error_reporting = E_ALL/" $PHP_INI > $PHP_INI_TMP; mv -f $PHP_INI_TMP $PHP_INI;
sed "s/display_errors = Off/display_errors = On/" $PHP_INI > $PHP_INI_TMP; mv -f $PHP_INI_TMP $PHP_INI;
sed "s/;error_log = php_errors.log/error_log = \/var\/log\/httpd\/php_errors.log/" $PHP_INI > $PHP_INI_TMP; mv -f $PHP_INI_TMP $PHP_INI;
sed "s/;date.timezone =.*/date.timezone = \"America\/Chicago\"/" $PHP_INI > $PHP_INI_TMP; mv -f $PHP_INI_TMP $PHP_INI;
sed "s/upload_max_filesize =.*/upload_max_filesize = 10M/" $PHP_INI > $PHP_INI_TMP; mv -f $PHP_INI_TMP $PHP_INI;
sed "s/post_max_size =.*/post_max_size = 20M/" $PHP_INI > $PHP_INI_TMP; mv -f $PHP_INI_TMP $PHP_INI;

# Update xdebug.ini
XDEBUG_INI="/etc/php.d/xdebug.ini"
echo "xdebug.remote_enable=1" >> $XDEBUG_INI
echo "xdebug.remote_port=9000" >> $XDEBUG_INI
echo "xdebug.remote_connect_back=1" >> $XDEBUG_INI
echo "xdebug.idekey = \"vagrant\"" >> $XDEBUG_INI
echo "xdebug.remote_autostart=1 ;this will allow xdebug to auto-connect" >> $XDEBUG_INI

# Installs ssh2 PHP extension
pecl install -f ssh2
SSH2_INI="/etc/php.d/ssh2.ini"
touch $SSH2_INI # create empty file
echo "extension=/usr/lib64/php/modules/ssh2.so" > $SSH2_INI

# Restart apache after updating php config files
service httpd restart