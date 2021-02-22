# k8s-devops
Terraform + salt scripts to bootstrap a k8s cluster with kubeadm on OTC.

Usage:  
add credentials to variables.tf, modify: key_pair, owner and resource names to your liking.  
`terraform plan`  
`terraform apply`  
log in to bastion EIP -> log in to controller (you need to use ssh-agent forwarding)  
check /tmp/kubeadm.log for `kubeadm join` command. run that on the worker node(s).  
if you want to set up kubectl for the cluster the setup command is in the /tmp/kubeadm.log file as well.  
have fun :)  
if you had enough fun just run terraform destroy  

Resources created by terraform:  
opentelekomcloud_vpc_v1.vpc - VPC for all nodes  
opentelekomcloud_vpc_subnet_v1.subnet - subnet for all nodes  
opentelekomcloud_networking_secgroup_v2.backend - Security group (allows all comms, but you can modify it to your taste)  
opentelekomcloud_vpc_eip_v1.eip - eip for natgw  
opentelekomcloud_vpc_subnet_v1.subnet - natgw   
opentelekomcloud_nat_snat_rule_v2.snat_1 - snat rule to allow traffic from subnet to public internet  
opentelekomcloud_nat_dnat_rule_v2.dnat_1 - dnat for natgw -> bastion ssh port forward. only port 22 is forwarded.  
opentelekomcloud_networking_port_v2.port_1 - neutron port for bastion. it is connected to the natgw via dnat rule  
opentelekomcloud_compute_instance_v2.controller - master node of k8s cluster  
opentelekomcloud_compute_instance_v2.worker - worker node of k8s cluster (you can add more than one, it will get bootstrapped with salt as well)  
opentelekomcloud_compute_instance_v2.bastion - jumphost node - connected to the natgw with DNAT  
