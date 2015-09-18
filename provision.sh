#!/usr/bin/env bash

yum -y update
yum update -y kernel*
yum install -y epel-release
yum install -y vim-X11 vim-common vim-enhanced vim-minimal

function provision {
    LINE_BREAK="#####################"

    echo $LINE_BREAK
    echo "Installing "$1
    echo $LINE_BREAK

    sh /vagrant/provision_scripts/install_$1.sh

    echo $LINE_BREAK
    echo $1" complete!!!"
    echo $LINE_BREAK
    echo ""
}

# .bash_profile
provision 'base_profile'

# Apache
provision 'apache'

# MySQL
provision 'mysql'

# PHP
provision 'php'

# PEAR
provision 'pear'

# git
provision 'git'

# PhpMyAdmin
provision 'phpmyadmin'

# Java
provision 'java'

# ElasticSearch
#rpm --import https://packages.elasticsearch.org/GPG-KEY-elasticsearch
#provision 'elasticsearch'

# Kibana
#provision 'kibana' #TODO - This needs finishing

# LogStash
#provision 'logstash'