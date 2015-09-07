#!/usr/bin/env bash

LINE_BREAK="#####################"
ELASTICSEARCH_REPO="/etc/yum.repos.d/elasticsearch.repo"

echo $LINE_BREAK
echo "Installing Elasticsearch"
echo $LINE_BREAK

# Write ElasticSearch repo info
echo "[elasticsearch-1.4]" >> $ELASTICSEARCH_REPO
echo "name=Elasticsearch repository for 1.4.x packages" >> $ELASTICSEARCH_REPO
echo "baseurl=http://packages.elasticsearch.org/elasticsearch/1.4/centos" >> $ELASTICSEARCH_REPO
echo "gpgcheck=1" >> $ELASTICSEARCH_REPO
echo "gpgkey=http://packages.elasticsearch.org/GPG-KEY-elasticsearch" >> $ELASTICSEARCH_REPO
echo "enabled=1" >> $ELASTICSEARCH_REPO

yum install -y elasticsearch

sed -i_bak "s/\#network.host: .*/network.host: 192.168.33.111/" /etc/elasticsearch/elasticsearch.yml
echo "http.cors.enabled: true" >> /etc/elasticsearch/elasticsearch.yml
echo "http.cors.allow-origin: \"*\"" >> /etc/elasticsearch/elasticsearch.yml

chkconfig elasticsearch on
service elasticsearch start

echo $LINE_BREAK
echo "Elasticsearch complete!!!"
echo $LINE_BREAK