#!/usr/bin/env bash

LOGSTASH_REPO="/etc/yum.repos.d/logstash.repo"
echo "[logstash-1.5]" >> $LOGSTASH_REPO
echo "name=Logstash repository for 1.5.x packages" >> $LOGSTASH_REPO
echo "baseurl=http://packages.elasticsearch.org/logstash/1.5/centos" >> $LOGSTASH_REPO
echo "gpgcheck=1" >> $LOGSTASH_REPO
echo "gpgkey=http://packages.elasticsearch.org/GPG-KEY-elasticsearch" >> $LOGSTASH_REPO
echo "enabled=1" >> $LOGSTASH_REPO

yum install -y logstash

# Create input conf file
LOGSTASH_CONFIG_DIR="/etc/logstash/conf.d"
echo "input {" >> $LOGSTASH_CONFIG_DIR/lumberjack-input.conf
echo "  lumberjack {" >> $LOGSTASH_CONFIG_DIR/lumberjack-input.conf
echo "    port => 5000" >> $LOGSTASH_CONFIG_DIR/lumberjack-input.conf
echo "    type => \"logs\"" >> $LOGSTASH_CONFIG_DIR/lumberjack-input.conf
#echo "    ssl_certificate => \"/etc/pki/tls/certs/logstash-forwarder.crt\" >> $LOGSTASH_CONFIG_DIR/lumberjack-input.conf
#echo "    ssl_key => \"/etc/pki/tls/private/logstash-forwarder.key\" >> $LOGSTASH_CONFIG_DIR/lumberjack-input.conf
echo "  }" >> $LOGSTASH_CONFIG_DIR/lumberjack-input.conf
echo "}" >> $LOGSTASH_CONFIG_DIR/lumberjack-input.conf
# Create syslog conf file
echo "filter {" >> $LOGSTASH_CONFIG_DIR/syslog.conf
echo "  if [type] == \"syslog\" {" >> $LOGSTASH_CONFIG_DIR/syslog.conf
echo "    grok {" >> $LOGSTASH_CONFIG_DIR/syslog.conf
echo "      match => { \"message\" => \"%{SYSLOGTIMESTAMP:syslog_timestamp} %{SYSLOGHOST:syslog_hostname} %{DATA:syslog_program}(?:\[%{POSINT:syslog_pid}\])?: %{GREEDYDATA:syslog_message}\" }" >> $LOGSTASH_CONFIG_DIR/syslog.conf
echo "      add_field => [ \"received_at\", \"%{@timestamp}\" ]" >> $LOGSTASH_CONFIG_DIR/syslog.conf
echo "      add_field => [ \"received_from\", \"%{host}\" ]" >> $LOGSTASH_CONFIG_DIR/syslog.conf
echo "    }" >> $LOGSTASH_CONFIG_DIR/syslog.conf
echo "    syslog_pri { }" >> $LOGSTASH_CONFIG_DIR/syslog.conf
echo "    date {" >> $LOGSTASH_CONFIG_DIR/syslog.conf
echo "      match => [ \"syslog_timestamp\", \"MMM  d HH:mm:ss\", \"MMM dd HH:mm:ss\" ]" >> $LOGSTASH_CONFIG_DIR/syslog.conf
echo "    }" >> $LOGSTASH_CONFIG_DIR/syslog.conf
echo "  }" >> $LOGSTASH_CONFIG_DIR/syslog.conf
echo "}" >> $LOGSTASH_CONFIG_DIR/syslog.conf
# Create output conf file
echo "output {" >> $LOGSTASH_CONFIG_DIR/lumberjack-output.conf
echo "  elasticsearch { host => localhost }" >> $LOGSTASH_CONFIG_DIR/lumberjack-output.conf
echo "  stdout { codec => rubydebug }" >> $LOGSTASH_CONFIG_DIR/lumberjack-output.conf
echo "}" >> $LOGSTASH_CONFIG_DIR/lumberjack-output.conf

chkconfig logstash on
service logstash start