#!/usr/bin/env bash

# Exit immediately if a command exits with a non-zero status
set -e

echo "Updating package list..."
sudo apt-get update -y

echo "Installing Nginx..."
sudo apt-get install -y nginx

echo "Checking for custom index.html..."

# -f checks if a regular file exists at the given path
if [ -f /vagrant/nginx/index.html ]; then
    # Prints out a message
    echo "Custom index.html found. Replacing default Nginx page..."
    # Copies our custom html file to the default nginx directory 
    sudo cp /vagrant/nginx/index.html /var/www/html/index.html
else
    # If nothing in the specified folder then use default
    echo "No custom index.html found. Using default Nginx page."
fi

echo "Enabling and restarting Nginx..."
# Automatically start Nginx at boot time
sudo systemctl enable nginx
# This ensures Nginx is running right now, and applies any new config or file changes (like the new index.html)
sudo systemctl restart nginx

echo "Provisioning complete. Nginx should now be running on http://localhost:8080"
