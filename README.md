#Vagrant
##Vagrant Plugins
- vagrant-hostsupdater
  - Description: Used to add entries to your /etc/hosts file on the host system
  - Install: `vagrant plugin install vagrant-hostsupdater`
  - Uninstall: `vagrant plugin uninstall vagrant-hostsupdater`
- vagrant-vbguest
  - **Warning**: Make sure this isn't installed until after everything has already been setup. Installing before hand can lead to mounting of local directory issues.
  - Description: Used to keep your VirtualBox Guest Additions up to date
  - Install: `vagrant plugin install vagrant-vbguest`
  - Uninstall: `vagrant plugin uninstall vagrant-vbguest`

##LAMP Stack
This vagrant instance uses the LAMP stack, containing:
- Linux (CentOS 6.6)
- Apache (2.2.15)
- MySQL (5.1.73)
- PHP (5.6)

##ELK Stack
The ELK stack contains:  
- ElasticSearch
- LogStash
- Kibana  
**Warning:** ELK Stack does not fully work as of yet and has been disabled in provisioning

##Resources  
- Vagrant documentation: https://docs.vagrantup.com
- vagrant-hostsupdater documentation: https://github.com/cogitatio/vagrant-hostsupdater
- vagrant-vbguest documentation: https://github.com/dotless-de/vagrant-vbguest
- Instructions on how to setup the ELK stack: https://www.digitalocean.com/community/tutorials/how-to-install-elasticsearch-logstash-and-kibana-4-on-centos-7
- Kibana as a service: https://groups.google.com/forum/#!topic/elasticsearch/XIxPHa_DdwE
- Configuring PhpStorm to work with Vagrant:
https://confluence.jetbrains.com/display/PhpStorm/Configuring+PhpStorm+to+work+with+a+VM
http://stackoverflow.com/questions/31838687/vboxmanage-is-not-found-with-intellij-php-remote-interpreter-vagrant