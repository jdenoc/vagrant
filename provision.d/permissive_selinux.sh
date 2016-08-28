#!/usr/bin/env bash

# Setting system enforcement mode to Permissive, otherwise apache will freak out and now work
SELINUX_CONF="/etc/selinux/config"
sed -i_bak "s/SELINUX=enforcing/SELINUX=permissive/" $SELINUX_CONF

# setting system enforcement to Permissive, so that when we've finished provisioning, we don't have to restart the instance
setenforce 0