variable "tenant" {
  type = map

  default = {
    user_name = ""
    password = ""
    domain_name = ""
    tenant_name = ""
  }
}

variable "ecs" {
  type = map
  default = {
    name = "sdombi-k8s"
    image_id = "dcc3d489-c7ff-4f26-8ab0-745b74a690e0"
    flavor = "s3.xlarge.2"
    key_pair = "terraform"
    az = "eu-de-01"
  }
}
variable "controller_disk_size" {
  default = 20
}
variable "controller_disk_type" {
  default = "SSD"
}
variable "worker_disk_type"{
  default = "SSD"
}
variable "worker_disk_size" {
  default = 20
}

variable "vpc" {
  type = map
  default = {
    name = "sdombi-kubernetes"
    cidr = "192.168.0.0/16"

    subnet_name = "control"
    subnet_cidr = "192.168.0.0/24"
    subnet_gateway = "192.168.0.1"

    master_ip = "192.168.0.100"
    bastion_ip = "192.168.0.101"

    primary_dns = "100.125.4.25"
    secondary_dns = "8.8.8.8"
  }
}

variable "nat" {
  type = map
  default = {
    name = "sdombi-k8s-nat"
    description = "natgw for k8s cluster"
    size = "1"
  }
}

variable "eip" {
  type = map
  default = {
    name = "sdombi-gw-bw"
    bw_size = "5"
  }
}


