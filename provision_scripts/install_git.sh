#!/usr/bin/env bash

USER_HOME="/home/vagrant"
LINE_BREAK="#####################"

echo $LINE_BREAK
echo "Installing git"
echo $LINE_BREAK

yum install -y git
yum install -y gitflow

git clone https://github.com/git/git.git /tmp/git
cp /tmp/git/contrib/completion/git-completion.bash $USER_HOME/git-completion.bash
rm -rf /tmp/git

echo "" >> $USER_HOME/.bash_profile
echo "source ~/git-completion.bash" >> $USER_HOME/.bash_profile

echo $LINE_BREAK
echo "git complete!!!"
echo $LINE_BREAK