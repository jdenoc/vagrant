Vagrant.configure(2) do |config|
  # VM setup
  config.vm.box = "bento/centos-6.7"
  config.vm.provider "virtualbox" do |vb|
      vb.gui = false   # Don't display the VirtualBox GUI when booting the machine
      vb.memory = 2048 # Customize the amount of memory on the VM
      vb.cpus = 2
  end

  config.vm.synced_folder ".", "/vagrant"
  config.vm.synced_folder "logs", "/var/log/httpd",
    owner: "vagrant", group: "vagrant"

  # Forwarded port mapping
  config.vm.network "forwarded_port", guest: 80, host: 8080     # Web
  config.vm.network "forwarded_port", guest: 3306, host: 3307   # MySQL
  config.vm.network "forwarded_port", guest: 9000, host: 9001   # xdebug

  # Creating a private network
  config.vm.network "private_network", ip: "192.168.33.111"
  config.vm.hostname = "vagrant.local"
  config.hostsupdater.aliases = [
      "db.local",
      "logs.local",
  ]

  # Provisioning (shell)
  config.vm.provision :shell, path: "provision.sh"
end