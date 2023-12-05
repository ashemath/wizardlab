
keys: 
	eval `ssh-agent` && ssh-add ~/.ssh/id_rsa && . ~/ansible/bin/activate && ansible-playbook -i inventory /vagrant/playbooks/init_lab.yml
pxe:
	eval `ssh-agent` && ssh-add ~/.ssh/id_rsa && . ~/ansible/bin/activate && ansible-playbook -i inventory /vagrant/playbooks/roles/netboot.xyz.yml
imaging:
	eval `ssh-agent` && ssh-add ~/.ssh/id_rsa && . ~/ansible/bin/activate && ansible-playbook -i inventory /vagrant/playbooks/roles/clonezilla_pxe.yml
docker_lab:
	eval `ssh-agent` && ssh-add ~/.ssh/id_rsa && . ~/ansible/bin/activate && ansible-playbook -i inventory /vagrant/playbooks/docker.yml
rocky_pxe:
	eval `ssh-agent` && ssh-add ~/.ssh/id_rsa && . ~/ansible/bin/activate && ansible-playbook -i inventory /vagrant/playbooks/roles/rocky_pxe.yml
