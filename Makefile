
keys: 
	eval `ssh-agent` && ssh-add ~/.ssh/id_rsa && . ./ansible/bin/activate && ansible-playbook -i inventory ./playbooks/roles/controller/init_lab.yml
pxe:
	eval `ssh-agent` && ssh-add ~/.ssh/id_rsa && . ./ansible/bin/activate && ansible-playbook -i inventory ./playbooks/roles/pxe.yml
