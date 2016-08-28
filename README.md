# Vagrant

## Vagrant Installation
If you haven't installed vagrant yet, you'll need to follow the instructions [here](https://www.vagrantup.com/docs/installation/).
Once you've completed the installation process, do the following
```shell
git clone https://github.com/jdenoc/vagrant.git
cd vagrant/
vagrant up
```

## Vagrant Plugins
- **vagrant-hostsupdater**
  - Description: Used to add entries to your /etc/hosts file on the host system
  - Documentation: https://github.com/cogitatio/vagrant-hostsupdater
  - Install: `vagrant plugin install vagrant-hostsupdater`
  - Uninstall: `vagrant plugin uninstall vagrant-hostsupdater`
- **vagrant-vbguest**
  - **Warning**: Make sure this isn't installed until after everything has already been setup. Installing before hand can lead to mounting of local directory issues.
  - Description: Used to keep your VirtualBox Guest Additions up to date
  - Documentation: https://github.com/dotless-de/vagrant-vbguest
  - Install: `vagrant plugin install vagrant-vbguest`
  - Uninstall: `vagrant plugin uninstall vagrant-vbguest`

## Adding a new domain
```shell
sudo /vagrant/create_domain.sh -d <domain> -f <directory> [--no-index]
```
- `<domain>` is the new domain to be created
- `<directory>` is the directory where the new domain will be house, i.e.: Where the code lives
- `--no-index` is an optional item, that prevents a dummy index.html file from being generated
You'll need to reload vagrant for the new domain to become available for testing from the host machine.

## Removing a domain
You'll need to remove the domain entry from the following:
- domain directory (_optional_): Search the `/etc/httpd/vhost.d/<domain>.conf` file for location of the domain directory and remove it
- vhost entry: `/etc/httpd/vhost.d/<domain>.conf`
- hosts entry: `/etc/hosts`
- hosts.txt entry: `/vagrant/hosts.txt`

## LAMP Stack
This vagrant instance uses the LAMP stack, containing:
- Linux (CentOS 7)
- Apache (2.4)
- MySQL (5.6)
- PHP (5.6)

## Resources  
- Vagrant documentation: https://docs.vagrantup.com
- Configuring PhpStorm to work with Vagrant:
https://confluence.jetbrains.com/display/PhpStorm/Configuring+PhpStorm+to+work+with+a+VM
http://stackoverflow.com/questions/31838687/vboxmanage-is-not-found-with-intellij-php-remote-interpreter-vagrant