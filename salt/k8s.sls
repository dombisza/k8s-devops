k8s_repo:
  pkgrepo.managed:
    - humanname: Kubernetes repo
    - name: deb https://apt.kubernetes.io/ kubernetes-xenial main
    - file: /etc/apt/sources.list.d/kubernetes.list
    - gpgcheck: 1
    - key_url: https://packages.cloud.google.com/apt/doc/apt-key.gpg

kubelet:
  pkg:
    - installed
    - version: 1.19.8-00
    - update_holds: True
kubeadm:
  pkg:
    - installed
    - version: 1.19.8-00
    - update_holds: True
kubectl:
  pkg:
    - installed
    - version: 1.19.8-00
    - update_holds: True

net.bridge.bridge-nf-call-iptables:
  sysctl.present:
    - value: 1

