#!/usr/bin/env bash

USER_HOME="/home/vagrant"
echo '' >> $USER_HOME/.bash_profile
echo 'export CLICOLOR=1' >> $USER_HOME/.bash_profile
echo 'export LSCOLORS=CxFxGxDxbxegedabagaced' >> $USER_HOME/.bash_profile
echo 'export PS1="\w : "' >> $USER_HOME/.bash_profile
echo 'export SUDO_PS1="\w : "' >> $USER_HOME/.bash_profile
echo '' >> $USER_HOME/.bash_profile
echo "alias ls='ls -Fal --color=auto'" >> $USER_HOME/.bash_profile