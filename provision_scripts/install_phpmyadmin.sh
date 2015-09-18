#!/usr/bin/env bash

CONFIG_FILE="/etc/phpMyAdmin/config.inc.php"
TMP_CONFIG="/tmp/phpMyAdmin.config.php"

yum install -y phpmyadmin

# Update PhpMyAdmin config file
sed -i_bak "s/\['verbose'\].*/\['verbose'\] = 'Vagrant';/" $CONFIG_FILE
sed "s/\['auth_type'\].*/\['auth_type'\] = 'config';/" $CONFIG_FILE > $TMP_CONFIG; mv -f $TMP_CONFIG $CONFIG_FILE
sed "s/\['user'\].*/\['user'\] = 'root';/" $CONFIG_FILE > $TMP_CONFIG; mv -f $TMP_CONFIG $CONFIG_FILE
sed "s/\['password'\].*/\['password'\] = 'root';/" $CONFIG_FILE > $TMP_CONFIG; mv -f $TMP_CONFIG $CONFIG_FILE
sed "/\['password'\]/ { n; d; }" $CONFIG_FILE > $TMP_CONFIG; mv -f $TMP_CONFIG $CONFIG_FILE # deletes line directly after ['password'] is found
sed "/\['password'\] = 'root'/a \$cfg[\'Servers\'][\$i][\'nopassword\'] = TRUE;" $CONFIG_FILE > $TMP_CONFIG; mv -f $TMP_CONFIG $CONFIG_FILE # appends a new line after the ['password']='root' is found
sed "s/\['AllowNoPassword'\].*/\['AllowNoPassword'\] = TRUE;/" $CONFIG_FILE > $TMP_CONFIG; mv -f $TMP_CONFIG $CONFIG_FILE
sed "/\['AllowNoPassword'\]/ { n; d; }" $CONFIG_FILE > $TMP_CONFIG; mv -f $TMP_CONFIG $CONFIG_FILE # deletes line directly after ['AllowNoPassword'] is found

rm -rf /etc/httpd/conf.d/phpMyAdmin.conf 	# Delete the apache conf file created at install
/vagrant/create_domain.sh -d db.local -f /usr/share/phpMyAdmin --no-index