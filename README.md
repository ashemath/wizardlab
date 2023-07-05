# Wizard Lab
[github.com/ashemath/wizardlab](https://www.github.com/ashemath/wizardlab)

*This project is under development, and designed only
for training and testing purposes.*
Multi-Machine training environment Vagrantfile

## Features:
- Debian Bookworm featuring an XFCE4 desktop 
- Control: 2 CPU, 2GB ram, 20GB Virtual Disk
- Service: 4 CPU, 4GB ram, 20GB Virtual Disk
- Client: 2 CPU, 2 GB ram, 20GB VIrtual Disk, EFI Boot Client

## Requirements
- Linux OS (Need to test on Windows)
- Libvirt/KVM
- Vagrant and the the vagrant-libvirt plugin if using libvirt.
- Minimum 4 core system for good performance.
- Tested on Debian, Ubuntu, and Fedora systems.
- Up to 8GB of RAM (16GB system RAM recommended)
- Minimum 30GB storage (Up to 60GB depending on usage).

## Networking
Depending on how your are using Virtualbox or Libvirt,
the Virtual NIC Vagrant uses to provision hosts may vary, but
this file sets up a secondary network adapter on each machine that
sits on the network 192.168.56.0/24

- Control: 192.168.56.2
- Service: 192.168.56.3
- Client: 192.168.56.4

## Architecture
The project is designed to be a flexible place to setup a fresh environment and test out
ansible playbooks. Controller and Services both have full Debian Bookworm installs,
the Client machine is a PXE test machine, for debugging netboot.xyz menus.

### Control
The Control host will have a ready to use installation of Ansible in a Python 
virtual environment at /home/vagrant/ansible. The control host has an XFCE GUI
for the purpose of testing usability and integrating your work into your "production" workflow.
Please comment out the line with bootstrap/install_xfce.sh from the Vagrantfile if you
do not want the GUI.

Playbooks for Control are located under [playbooks/roles/controller/](playbooks/roles/controller/)

### Services
The services VM is a target for infrastructure configuration. Think of it as a blank slate
for you to test configuration against. Service knows about controller by its `/etc/hosts`
*In development*: Samba share for WDS at /srv/wds 
For a WDS server living at 192.168.56.4

Playbooks for Services are under [playbooks/roles/infra](playbooks/roles/controller)

## PXE 
TFTP, DHCP, and a configured self-hosted install of netboot.xyz.
For example: Bring up the Client machine
```
$ vagrant ssh controller
$ make pxe
```

Next, boot up the Client VM on your Host:
```
vagrant up client
```
The Client machine is configured to PXE boot, so it will hang on step where it tries to inject
the SSH key. It will be trying to PXE boot. Open up `virt-manager` and try out the netboot.xyz menus.

If you got the menu working, try setting up a beefier virtual machine from scratch on the 'wizardlab' virtual network.

## Getting Started
### Setup libvirt\KVM
Look up the best practice for installing Libvirt/KVM. For example,
in Ubuntu, you might do:
```
$ sudo apt install -y qemu-kvm virt-manager libvirt-daemon-system virtinst libvirt-clients bridge-utils
$ sudo systemctl enable --now libvirtd
```
On Fedora, the key command is something like this:
```
$ sudo dnf group install --with-optional virtualization
$ sudo systemctl enable --now libvirtd
```
To check if kvm is loaded:
```
$ lsmod | grep kvm
kvm_intel             458752  6
kvm                  1323008  1 kvm_intel
irqbypass              16384  21 kvm
```
### Setup Vagrant
Follow the instructions for your Host OS on this page:
[developer.hashicorp.com/vagrant/downloads](https://developer.hashicorp.com/vagrant/downloads)

Install the vagrant-libvirtd plugin:
```
$ vagrant plugin install vagrant-libvirt
```

### Install Git if needed:

### Clone this repo with GIT
```
$ git clone https://github.com/ashemath/wizardlab.git
$ cd wizardlab
```

### Start up the machine
`
$ vagrant up
`
### Connect to Control
`
$ vagrant ssh control
`
### Generate and Distribute Lab SSH Keys with Ansible
Playbooks live inside /vagrant/playbooks, so they can stay synced up with your project
directory, yet stay separate from you virtual machine's directory structure.

The included Makefile will help you execute an ansible playbook that distributes a fresh
SSH key to all the 'lab' hosts.
```
$ make keys
```
## What to do next?
This project sets you up with a sensible, yet beefy, baseline environment to start playing with
ansible.
After running `make keys`, you can execute this, for example:
```
source ansible/bin/activate
(ansible)$ ansible all -i inventory -m ping
```
Since the `vagrant` user has password-free sudo access on the VMs, your playbooks should be able
to elevate privileges with the 'become' option, without entering a password. You should have name resolution working via entries in `/etc/hosts`.

## What's next for this project
The plan is to flesh out the 'Client' and 'Service' roles to include configuration playbooks
for deploying and managing a variety of production-like services with Docker.

Building this project is both professional development and free entertainment for myself.
Using lightweight ansible notebooks, we an configure any number of things on top of this
type of environment.

The plan is to provide options in the Makefile to setup various system scenarios.
By using VM Snapshots, you can build a catalog of scenarios that you can reuse to practice
new strategies in System Administration with Ansible. 

### Client
- Networked `/home/${USER}`
- Network shares for data-sets
- Configure VPN Acccess

### Service
- NFS: Shared storage between "Service" and "Client"
- DNS: Bind (Authoritative DNS) and Unbound (Recursive DNS Lookup)
- LDAP: Identity Management with FreeIPA
- VPN: Access your 'client' or 'control' host through a OpenVPN server
- Monitoring: ELK stack for exploring Syslog and Grafana Dashboards.
