#!/bin/bash

set -e


# Update the package list to make sure we get the latest available packages
echo "[+] Updating package list..."
sudo apt-get update -y

# Install Apache
echo "[+] Installing Apache..."
sudo apt-get install apache2 -y

# Enable the Apache2 service to start on boot
echo "[+] Enabling and starting Apache service..."
sudo systemctl enable apache2

# Start the Apache2 service immediately
sudo systemctl start apache2

# Create a basic test HTML page to verify that the server is working
# This command replaces the default index.html file
# tee reads from standard input and writes to the given file.
echo "[+] Writing index page..."
echo "<h1>Hello from Apache via Vagrant!</h1>" | sudo tee /var/www/html/index.html