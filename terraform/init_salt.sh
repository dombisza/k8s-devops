#!/bin/bash
curl -L https://bootstrap.saltstack.com -o bootstrap_salt.sh
sudo sh bootstrap_salt.sh
sudo sed -i 's/#file_client: remote/file_client: local/g' /etc/salt/minion
sudo systemctl stop salt-minion
sudo systemctl disable salt-minion
sudo mkdir /srv/salt && sudo mkdir /srv/pillar
