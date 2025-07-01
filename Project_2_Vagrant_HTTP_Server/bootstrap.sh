#!/bin/bash

# Update the package list to make sure we get the latest available packages
sudo apt-get update -y

# Enable the Apache2 service to start on boot
sudo systemctl enable apache2

# Start the Apache2 service immediately
sudo systemctl start apache2

# Create a basic test HTML page to verify that the server is working
# This command replaces the default index.html file
# tee reads from standard input and writes to the given file.
echo "<h1>Hello from Apache via Vagrant!</h1>" | sudo tee /var/www/html/index.html