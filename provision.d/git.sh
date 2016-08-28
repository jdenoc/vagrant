#!/usr/bin/env bash

USER_HOME="/home/vagrant"

yum install -y git gitflow

# Get git auto-complete
wget -O /tmp/git-completion.bash https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash
cp /tmp/git-completion.bash $USER_HOME/.git-completion.bash

echo "" >> $USER_HOME/.bash_profile
echo "# git auto-complete" >> $USER_HOME/.bash_profile
echo "source $USER_HOME/.git-completion.bash" >> $USER_HOME/.bash_profile