#!/usr/bin/env bash

# Install PHPUnit
COMPOSER_HOME="/home/vagrant"
/usr/local/bin/composer global require "phpunit/phpunit=4.8.*"

# update $PATH variable
source $COMPOSER_HOME/.bash_profile