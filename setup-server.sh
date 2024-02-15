#!/usr/bin/bash

# This script sets up a server to host the backend of the capstone project.
# It needs to be run with sudo privileges.

source /etc/*-release

aptInstallDeps() {
    apt update
    apt install docker docker.io docker-compose nginx -y
}

setupDocker() {
    systemctl enable docker.service --now
    systemctl enable docker.socket --now
}

setupFirewallUFW() {
    ufw allow http
    ufw allow https
    ufw enable
}

setupNginx() {
    cp ./transcribro.conf /etc/nginx/sites-available/
    ln -sf /etc/nginx/sites-enabled
    systemctl restart nginx.service
}

if [[ $DISTRIB_ID == 'Ubuntu' ]]; then
    aptInstallDeps
    setupDocker
    setupFirewallUFW
    setupNginx
else
    echo "Linux distribution '$DISTRIB_ID' unsupported, please install dependencies and configure server manually."
    exit
fi

echo "In order to deploy the docker containers for the backend, you must add the docker group to your current user by running `sudo usermod -aG docker $USER` and re-login to the server to apply the docker group to your current user."