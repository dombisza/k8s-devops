'kubeadm init --pod-network-cidr=10.10.0.0/16 | tee /tmp/kubeadm.log':
  cmd.run:
    - unless: test -f /tmp/kubeadm.log

'mkdir -p $HOME/.kube && sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config && sudo chown $(id -u):$(id -g) $HOME/.kube/config':
  cmd.run:
    - unless: test -f $HOME/.kube/config

'kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml':
  cmd.run
