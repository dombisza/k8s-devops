# Configure the OpenTelekomCloud Provider

terraform {
  required_providers {
    opentelekomcloud = {
      source = "opentelekomcloud/opentelekomcloud"
      version = ">= 1.22.0"
    }
  }
}

provider "opentelekomcloud" {
  user_name   = var.tenant.user_name
  password    = var.tenant.password
  domain_name = var.tenant.domain_name
  tenant_name = var.tenant.tenant_name
  auth_url    = "https://iam.eu-de.otc.t-systems.com/v3"
}

# Create a web server
#

resource "opentelekomcloud_vpc_v1" "vpc" {
  name = var.vpc.name
  cidr = var.vpc.cidr
}

resource "opentelekomcloud_vpc_subnet_v1" "subnet" {
  name       = var.vpc.subnet_name
  cidr       = var.vpc.subnet_cidr
  gateway_ip = var.vpc.subnet_gateway
  vpc_id     = opentelekomcloud_vpc_v1.vpc.id

  primary_dns = var.vpc.primary_dns
  secondary_dns = var.vpc.secondary_dns
}

resource "opentelekomcloud_vpc_eip_v1" "eip" {
  publicip {
    type = "5_bgp"
  }
  bandwidth {
    name       = var.eip.name
    size       = var.eip.bw_size
    share_type = "PER"
  }
}

resource "opentelekomcloud_nat_gateway_v2" "nat_gw" {
  name                = var.nat.name
  description         = var.nat.description
  spec                = var.nat.size
  router_id           = opentelekomcloud_vpc_v1.vpc.id 
  internal_network_id = opentelekomcloud_vpc_subnet_v1.subnet.id
}

resource "opentelekomcloud_nat_snat_rule_v2" "snat_1" {
  nat_gateway_id = opentelekomcloud_nat_gateway_v2.nat_gw.id
  network_id     = opentelekomcloud_vpc_subnet_v1.subnet.id
  floating_ip_id = opentelekomcloud_vpc_eip_v1.eip.id
}

resource "opentelekomcloud_nat_dnat_rule_v2" "dnat_1" {
  floating_ip_id        = opentelekomcloud_vpc_eip_v1.eip.id
  nat_gateway_id        = opentelekomcloud_nat_gateway_v2.nat_gw.id
  #private_ip            = var.vpc.bastion_ip 
  port_id = opentelekomcloud_compute_instance_v2.bastion.network.0.port
  internal_service_port = 22
  protocol              = "tcp"
  external_service_port = 22
}

resource "opentelekomcloud_networking_secgroup_v2" "backend" {
  name        = "backend"
  description = "Created By Terraform."
}

resource "opentelekomcloud_networking_secgroup_rule_v2" "secgroup_rule_1" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "All"
  port_range_min    = 0
  port_range_max    = 0
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = opentelekomcloud_networking_secgroup_v2.backend.id
}

#resource "opentelekomcloud_networking_network_v2" "network_1" {
#  name           = "network_1"
#  admin_state_up = "true"
#}

resource "opentelekomcloud_networking_port_v2" "port_1" {
  name           = "port_1"
  network_id     = opentelekomcloud_vpc_subnet_v1.subnet.id 
  admin_state_up = "true"
}

resource "opentelekomcloud_compute_instance_v2" "bastion" {
  name            = "${var.ecs.name}-bastion"
  image_id        = var.ecs.image_id
  flavor_name     = "s3.medium.2"
  key_pair        = var.ecs.key_pair
  security_groups = [opentelekomcloud_networking_secgroup_v2.backend.name] 
  availability_zone = var.ecs.az
  user_data = file("init_salt.sh") 
  tags = {
    owner = "sdombi"
    role = "bastion"
  }

  network {
    port = opentelekomcloud_networking_port_v2.port_1.id
    #uuid = opentelekomcloud_vpc_subnet_v1.subnet.id
    #fixed_ip_v4 = var.vpc.bastion_ip
  }

}


resource "opentelekomcloud_compute_instance_v2" "controller" {
  name            = "${var.ecs.name}-controller"
  #  image_id        = var.ecs.image_id
  flavor_name     = var.ecs.flavor
  key_pair        = var.ecs.key_pair
  security_groups = [opentelekomcloud_networking_secgroup_v2.backend.name]
  availability_zone = var.ecs.az
  user_data = file("init_salt.sh") 
  
  block_device {
    uuid = var.ecs.image_id
    source_type = "image"
    volume_size = var.controller_disk_size 
    volume_type = var.controller_disk_type
    boot_index = 0
    delete_on_termination = true
    destination_type = "volume"
  }

  tags = {
    owner = "sdombi"
    role = "master"
  }

  network {
    uuid = opentelekomcloud_vpc_subnet_v1.subnet.id 
    fixed_ip_v4 = var.vpc.master_ip
  }

}

resource "opentelekomcloud_compute_instance_v2" "worker" {
   name            = "${var.ecs.name}-worker"
   image_id        = var.ecs.image_id
   flavor_name     = var.ecs.flavor
   key_pair        = var.ecs.key_pair
   security_groups = [opentelekomcloud_networking_secgroup_v2.backend.name]
   availability_zone = var.ecs.az
   user_data = file("init_salt.sh") 
  
   block_device {
     uuid = var.ecs.image_id
     source_type = "image"
     volume_size = var.worker_disk_size 
     volume_type = var.worker_disk_type
     boot_index = 0
     delete_on_termination = true
     destination_type = "volume"
   }


   tags = {
     owner = "sdombi"
     role = "worker"
   }

   network {
     uuid = opentelekomcloud_vpc_subnet_v1.subnet.id
   }
 }

