#!/bin/bash
set -e  # Exit on any command failure

# Update and install Ansible
sudo apt update
sudo apt install -y ansible

# Run the playbook (inside the VM)
ansible-playbook /vagrant/ansible/playbook.yml -i /vagrant/ansible/inventory.ini