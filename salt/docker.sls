software-properties-common:
  pkg:
    - installed
apt-transport-https:
  pkg:
    - installed
ca-certificates:
  pkg:
    - installed
curl:
  pkg:
    - installed
gnupg-agent:
  pkg:
    - installed

docker_repo:
  pkgrepo.managed:
    - humanname: Docker repo
    - name: deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable 
    - file: /etc/apt/sources.list.d/docker.list
    - gpgcheck: 1
    - key_url: https://download.docker.com/linux/ubuntu/gpg

docker-ce:
  pkg:
    - installed
    - require:
      - docker_repo
docker:
  service.running:
    - enable: True
    - require: 
      - docker-ce

