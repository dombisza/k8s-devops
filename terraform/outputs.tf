output "bastion_ip" {
  value = opentelekomcloud_compute_instance_v2.bastion.access_ip_v4
}

output "controller_ip" {
  value = opentelekomcloud_compute_instance_v2.controller.access_ip_v4
}

output "worker_ip" {
  value = opentelekomcloud_compute_instance_v2.worker.*.access_ip_v4
}

output "eip_address" {
  value = opentelekomcloud_vpc_eip_v1.eip.publicip.0.ip_address
}

#output "bastion_port"{
#  value = opentelekomcloud_compute_instance_v2.bastion.network[0].port
#}
