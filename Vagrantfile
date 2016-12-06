Vagrant.configure(2) do |config|
  # VM setup
  config.vm.box = "centos/7"
  config.vm.provider "virtualbox" do |vb|
      vb.gui = false   # Don't display the VirtualBox GUI when booting the machine
      vb.memory = 2048 # Customize the amount of memory on the VM
      vb.cpus = 2
  end

  config.vm.synced_folder ".", "/vagrant"

  # Creating a private network
  config.vm.hostname = "jdenoc.local"
  config.vm.network "private_network", ip: "192.168.33.111"

  # Forwarded port mapping
  config.vm.network :forwarded_port, guest: 22, host: 2222, id: "ssh", disabled: true   # disable default ssh port
  config.vm.network :forwarded_port, guest: 22, host: 2111, auto_correct: true          # ssh
  config.vm.network :forwarded_port, guest: 80, host: 8111, auto_correct: true          # apache
  config.vm.network :forwarded_port, guest: 3306, host: 3111, auto_correct: true        # MySQL
  config.vm.network :forwarded_port, guest: 9000, host: 9111, auto_correct: true        # xDebug

  # Add custom domains from hosts.txt file
  hosts = []
  File.foreach('hosts.txt').map do |line|
      if( !line.start_with?('#') )
        hosts.push(line.strip)
      end
  end
  config.hostsupdater.aliases = hosts

  # Provisioning (shell)
  config.vm.provision :shell, path: "provision.sh"
end