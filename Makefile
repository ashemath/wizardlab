
keys: 
	eval `ssh-agent` && ssh-add ~/.ssh/id_rsa && . ~/ansible/bin/activate && ansible-playbook -i inventory /vagrant/playbooks/roles/controller/init_lab.yml
pxe:
	eval `ssh-agent` && ssh-add ~/.ssh/id_rsa && . ~/ansible/bin/activate && ansible-playbook -i inventory /vagrant/playbooks/roles/pxe.yml
imaging:
	eval `ssh-agent` && ssh-add ~/.ssh/id_rsa && . ~/ansible/bin/activate && ansible-playbook -i inventory /vagrant/playbooks/roles/clonezilla_pxe.yml
