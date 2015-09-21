#!/usr/bin/env bash

USER_HOME="/home/vagrant"

# Install composer
curl -sS https://getcomposer.org/installer | php
mv composer.phar /usr/local/bin/composer
mkdir -p $USER_HOME/.composer
echo "" >> $USER_HOME/.bash_profile
echo "# Add composer to PATH" >> $USER_HOME/.bash_profile
echo 'export PATH='$USER_HOME'/.composer/vendor/bin:$PATH' >> $USER_HOME/.bash_profile