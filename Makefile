
keys: 
	eval `ssh-agent` && ssh-add .ssh/id_rsa && . ./ansible/bin/activate && ansible-playbook -i inventory ./playbooks/roles/infra/init_lab.yml
