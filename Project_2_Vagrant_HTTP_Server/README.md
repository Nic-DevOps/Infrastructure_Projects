
# This is the readme for Project 2

This project provisions an Ubuntu 18.04 virtual machine using Vagrant and VirtualBox, and automatically installs and configures an Apache HTTP server using a bootstrap.sh

I had issues apt installing vagrant, the error I got was "E: Package 'vagrant' has no installation candidate".That error means the current APT sources do not include the official HashiCorp packages or the Ubuntu repo i'm using has dropped Vagrant.

To fix this 
1. Add HashiCorp’s GPG key
    curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
2. Add the HashiCorp repository
    echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
3. Update your package list
    sudo apt update
4. Install Vagrant
    sudo apt install vagrant
5. Verify that vagrant was installed
    vagrant --version
Vagrant 2.4.7

And then I had to scrap all of that because virtualbox doesn't work on WSL so I've moved the project files to windows and then downloaded virutalbox and vagrant on windows. 

I also had to add add virtualbox manager to the environment path. 

Test the Project
Ensure Vagrant and Virtualbox are installed

1. Navigate to your project directory
    cd project-2-vagrant-apache-http-server
2. Start the VM
    vagrant up
3. Verify Apache is working
    Open your browser and go to: http://localhost:8080

# Shut Down / Cleanup

To halt the VM:
vagrant halt

# Link to the vargrant cloud where config.vm.box pulls the image from
https://portal.cloud.hashicorp.com/vagrant/discover?query=ubuntu%2Fbionic64