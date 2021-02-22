#!/bin/bash
curl -L https://bootstrap.saltstack.com -o bootstrap_salt.sh
sudo sh bootstrap_salt.sh
sudo sed -i 's/#file_client: remote/file_client: local/g' /etc/salt/minion
sudo systemctl stop salt-minion
sudo systemctl disable salt-minion
sudo mkdir /srv/salt && sudo mkdir /srv/pillar
wget https://raw.githubusercontent.com/dombisza/k8s-devops/master/salt/docker.sls -O /srv/salt/docker.sls
wget https://raw.githubusercontent.com/dombisza/k8s-devops/master/salt/k8s.sls -O /srv/salt/k8s.sls
wget https://raw.githubusercontent.com/dombisza/k8s-devops/master/salt/master_init.sls -O /srv/salt/master_init.sls
wget https://raw.githubusercontent.com/dombisza/k8s-devops/master/salt/top.sls -O /srv/salt/top.sls
sudo salt-call --local state.apply | tee /tmp/salt_init.log
