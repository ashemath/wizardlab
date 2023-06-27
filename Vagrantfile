# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|
  # Bookworm 64-bit, official box
  config.vm.box = "debian/bookworm64"
  # Folder sync configuration
  # Control\Devel VM without optional GUI installed
  config.vm.define "control" do |control|
    control.vm.network :private_network, ip: "192.168.56.2", netmask: "255.255.255.0",
      auto_config: "false"
    control.vm.provider :libvirt do |v|
      v.nested = true
      v.channel :type => 'unix', :target_type => 'virtio', :target_name => 'org.qemu.guest_agent.0'
      v.cpu_mode = "host-model"
      v.memory = 4096
      v.cpus = 2
    end
    # uncomment install_XFCE.sh to install GUI
    control.vm.provision "shell", inline: <<-SHELL
      echo "Installing Dependencies on the Controller"
      hostnamectl set-hostname control;
      apt install -y make sshpass python3-venv python3-dev;
      sh /vagrant/bootstrap/install_xfce.sh
    SHELL
    control.vm.provision "shell", privileged: false, inline: <<-SHELL
      cp /vagrant/playbooks/roles/controller/files/config.ssh ~/.ssh/config
      sh /vagrant/bootstrap/setup_ansible.sh
      cp /vagrant/Makefile /home/vagrant/
      cp -r /vagrant/playbooks /home/vagrant/playbooks
      cp /vagrant/bootstrap/inventory /home/vagrant/inventory
      ssh-keygen -t rsa -C 'localhost' -N '' -f /home/vagrant/.ssh/id_rsa
      cat /home/vagrant/.ssh/id_rsa.pub >> /home/vagrant/.ssh/authorized_keys
      sudo reboot
    SHELL
    config.trigger.after [:provision] do |t|
      t.name = "Reboot after provisioning"
      t.run = { :inline => "vagrant reload" }
    end
  end

  config.vm.define "services" do |services|
    services.vm.network :private_network, ip: "192.168.56.3", netmask: "255.255.255.0",
      auto_config: "false"
    services.vm.provider :libvirt do |v|
      v.nested = true
      v.channel :type => 'unix', :target_type => 'virtio', :target_name => 'org.qemu.guest_agent.0'
      v.cpu_mode = "host-model"
      v.memory = 4096
      v.cpus = 4
    end
     # uncomment install_XFCE.sh to install GUI
    services.vm.provision "shell", inline: <<-SHELL
      hostnamectl set-hostname services;
    SHELL
   end

  # Target machine
  config.vm.define "client" do |client|
    client.vm.network :private_network, ip: "192.168.56.4", netmask: "255.255.255.0",
      auto_config: "false"
    client.vm.provider :libvirt do |v|
      v.channel :type => 'unix', :target_type => 'virtio', :target_name => 'org.qemu.guest_agent.0'
      v.memory = 2048
      v.cpus = 2
    end
    client.vm.provision "shell", inline: <<-SHELL
        hostnamectl set-hostname client;
    SHELL
  end
  
  # Labwide unprivileged command (USER=vagrant)
  config.vm.provision "shell", inline: <<-SHELL
    touch .vimrc
    # Remove mouse controls from vim while preserving defaults
    echo 'unlet! skip_defaults_vim' >> .vimrc
    echo 'source $VIMRUNTIME/defaults.vim'>> .vimrc
    echo 'set mouse-=a' >> .vimrc
  SHELL
  # Labwide privileged commands (USER=root)
  config.vm.provision "shell", inline: <<-SHELL
    #sh /vagrant/grow-root.sh
    echo vagrant:vagrant | chpasswd
    sed -i 's/PasswordAuthentication\ no//' /etc/ssh/sshd_config
    systemctl restart sshd
    apt update && apt upgrade -y
    apt install -y htop tmux vim
    echo '192.168.56.2 control' >> /etc/hosts
    echo '192.168.56.3 services' >> /etc/hosts
    echo '192.168.56.4 client' >> /etc/hosts
  SHELL

end

