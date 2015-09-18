#!/usr/bin/env bash

# Install Phinx
COMPOSER_HOME="/home/vagrant"
/usr/local/bin/composer require robmorgan/phinx
mkdir -p /usr/share/php/migrations

# update $PATH variable
source $COMPOSER_HOME/.bash_profile