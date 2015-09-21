#!/usr/bin/env bash

USER_HOME="/home/vagrant"

yum install -y git
yum install -y gitflow

git clone https://github.com/git/git.git /tmp/git
cp /tmp/git/contrib/completion/git-completion.bash $USER_HOME/.git-completion.bash
rm -rf /tmp/git

echo "" >> $USER_HOME/.bash_profile
echo "# git auto-complete"
echo "source ~/.git-completion.bash" >> $USER_HOME/.bash_profile