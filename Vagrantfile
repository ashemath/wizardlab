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
  # Ansible configuration management development VM
  config.vm.define "control" do |control|
    control.vm.network :private_network,
      ip: "192.168.56.2",
      libvirt__network_name: "wizardlab0",
      libvirt__dhcp_enabled: "false"
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
    SHELL
    control.vm.provision "shell", privileged: false, inline: <<-SHELL
      cp /vagrant/playbooks/roles/infra/files/config.ssh ~/.ssh/config
      sh /vagrant/bootstrap/setup_ansible.sh
      cp /vagrant/Makefile /home/vagrant/
      cp -r /vagrant/playbooks /home/vagrant/playbooks
      cp /vagrant/inventory /home/vagrant/inventory
      ssh-keygen -t rsa -C 'localhost' -N '' -f /home/vagrant/.ssh/id_rsa
      cat /home/vagrant/.ssh/id_rsa.pub >> /home/vagrant/.ssh/authorized_keys
    SHELL
  end

  config.vm.define "services" do |services|
    services.vm.network :private_network,
      ip: "192.168.56.3",
      libvirt__network_name: "wizardlab0",
      libvirt__dhcp_enabled: "false"

    services.vm.provider :libvirt do |v|
      v.nested = true
      v.channel :type => 'unix', :target_type => 'virtio', :target_name => 'org.qemu.guest_agent.0'
      v.cpu_mode = "host-model"
      v.memory = 4096
      v.cpus = 4
    end
    services.vm.provision "shell", inline: <<-SHELL
      hostnamectl set-hostname services;
    SHELL
   end

  # Target machine
  config.vm.define "client", autostart: false do |client|
    client.vm.boot_timeout = 3600
    client.vm.network :private_network,
      libvirt__network_name: "wizardlab0"
    client.vm.provider :libvirt do |v|
      v.channel :type => 'unix', :target_type => 'virtio', :target_name => 'org.qemu.guest_agent.0'
      v.memory = 4096
      v.cpus = 2
      # For redhat: path with edk2
      #v.loader = "/usr/share/edk2/ovmf/OVMF_CODE.fd"
      # For Ubuntu\Debian
      v.loader = "/usr/share/ovmf/OVMF.fd"
      boot_network = {'network' => 'wizardlab0'}
      v.boot boot_network
      v.boot 'hd'
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
    apt-get update
    echo vagrant:vagrant | chpasswd
    sed -i 's/PasswordAuthentication\ no//' /etc/ssh/sshd_config
    apt install -y htop tmux vim
    systemctl reload sshd
    echo '192.168.56.2 control' >> /etc/hosts
    echo '192.168.56.3 services' >> /etc/hosts
    echo '192.168.56.4 client' >> /etc/hosts
    echo '192.168.56.12 node0' >> /etc/hosts
  SHELL

end

