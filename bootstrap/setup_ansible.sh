#!/bin/sh

python3 -m venv /home/vagrant/ansible;
. /home/vagrant/ansible/bin/activate;
pip install --upgrade pip;
pip install ansible;
deactivate;
