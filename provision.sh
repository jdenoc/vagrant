#!/usr/bin/env bash

# Set server timezone
timedatectl set-timezone UTC

# Update and install some basic packages
yum -y update
yum install -y yum-utils epel-release wget
yum update -y kernel*
yum install -y vim-X11 vim-common vim-enhanced vim-minimal

function provision {
    LINE_BREAK="#####################"
    PROVISION_DIR="/vagrant/provision.d"
    echo $LINE_BREAK
    echo "Installing "$1
    echo $LINE_BREAK

    sh $PROVISION_DIR/$1.sh > $PROVISION_DIR/$1.log 2>&1

    echo $LINE_BREAK
    echo $1" complete!!!"
    echo $LINE_BREAK
    echo ""
}

# Setting system enforcement mode to Permissive, otherwise lots of things will freak out and not work
provision 'permissive_selinux'
# Setup user bash profile stuff
provision 'profile'
# Apache
provision 'apache'
# MySQL
provision 'mysql'
# PHP
provision 'php'
# Composer
provision 'composer'
# PhpMyAdmin
provision 'phpmyadmin'
# git
provision 'git'
# Java
provision 'java'