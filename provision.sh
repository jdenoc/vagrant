#!/usr/bin/env bash

SCRIPTS="/vagrant/provision_scripts"
yum -y update
yum update -y kernel*
yum install -y epel-release
yum install -y vim-X11 vim-common vim-enhanced vim-minimal

# .bash_profile
$SCRIPTS/install_base_profile.sh

# Apache
$SCRIPTS/install_apache.sh

# MySQL
$SCRIPTS/install_mysql.sh

# PHP
$SCRIPTS/install_php.sh

# PEAR
$SCRIPTS/install_pear.sh

# git
$SCRIPTS/install_git.sh

# PhpMyAdmin
$SCRIPTS/install_phpmyadmin.sh

# Java
$SCRIPTS/install_java.sh

# ElasticSearch
#rpm --import https://packages.elasticsearch.org/GPG-KEY-elasticsearch
#$SCRIPTS/install_elasticsearch.sh

# Kibana
#$SCRIPTS/install_kibana.sh #TODO - This needs finishing

# LogStash
#$SCRIPTS/install_logstash.sh