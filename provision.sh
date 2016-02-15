#!/bin/bash
if [ -f /etc/debian_version ]; then
  sudo apt-get update
  sudo apt-get install -y git python-pip python-dev
elif [ -f /etc/redhat-release ]; then
  yum update
  yum install -y git python-pip python-dev
fi
sudo pip install ansible
sudo ansible-galaxy install -r /vagrant/requirements.yml -f
ansible-playbook -i "localhost," -c local /vagrant/playbook.yml
