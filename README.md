# Wizard Lab
[github.com/ashemath/wizardlab](https://www.github.com/ashemath/wizardlab)

*This project is under development, and designed only
for training and testing purposes.*
Multi-Machine training environment Vagrantfile

## Features:
- Debian Bookworm featuring an XFCE4 desktop 
- Control: 2 CPU, 2GB ram, 20GB Virtual Disk
- Service: 4 CPU, 4GB ram, 20GB Virtual Disk
- Client: 2 CPU, 2GB ram, 20GB Virtual Disk

## Requirements
- Linux OS (Need to test on Windows)
- Virtualbox or Libvirt/KVM
- Vagrant and the the vagrant-libvirt plugin if using libvirt.
- Up to 8GB of RAM (16GB system RAM recommended)
- Up to 60 GB Storage

## Networking
Depending on how your are using Virtualbox or Libvirt,
the Virtual NIC Vagrant uses to provision hosts may vary, but
this file sets up a secondary network adapter on each machine that
sits on the network 192.168.56.0/24

Control: 192.168.56.2
Service: 192.168.56.3
Client: 192.168.56.4

The Control host will have a ready to use installation of Ansible
in a Python virtual environment at /home/vagrant/ansible

## Getting Started
### Install NFS Server
To use the default folder sync, you will need to install NFS.
```
$ sudo apt update
$ sudo apt install -y nfs-kernel-server
```
Vagrant will manage the NFS exports for you, but you will need to be prepared to enter
your sudo credentials when it goes to mount the shares. The shares are networked 
over the host-only interface that the VMs share with your host environment.

### Install Git if needed:

### Clone this repo with GIT
```
$ git clone https://github.com/ashemath/wizardlab.git
$ cd wizardlab
```

### Start up the machine
`
$ vagrant up
$ 
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
$ source ~/ansible/bin/activate
(ansible)$ cd /vagrant
(ansible)$ make lab
```
## What to do next?
This project sets you up with a sensible, yet beefy, baseline environment to start playing with
ansible.
After running `make lab`, you can execute this, for example:
`
(ansible)$ ansible all -i inventory -m ping
`
From the controller, you should have name resolution working via entries in `/etc/hosts`.

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
- Install either Debian or CentOS from PXE
- Managed sudo
- Network /home/${USER}
- Network shares for data-sets
- Configure VPN Acccess

### Service
- NFS: Shared storage between "Service" and "Client"
- DHCP: Configure "Client" networking options with isc-dhcp or kea (TBD)
- TFTP: Serve the network files necessary to boot with PXE
- DNS: Bind (Authoritative DNS) and Unbound (Recursive DNS Lookup)
- LDAP: Identity Management with FreeIPA
- VPN: Access your 'client' or 'control' host through a OpenVPN server
- Monitoring: ELK stack for exploring Syslog and Grafana Dashboards.
