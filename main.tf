########################################################
# 
########################################################

locals {
  public_key    = "${file(pathexpand(var.public_key_file))}"
}

resource "ibm_is_ssh_key" "iac_test_key" {
  name       		= "${var.basename}-key"
  resource_group 	= var.resource_group
  public_key 		= local.public_key
}

resource "ibm_is_instance" "iac_test_instance" {
  name    = "${var.basename}-instance"
  resource_group 	= var.resource_group
  image   = "r006-14140f94-fcc4-11e9-96e7-a72723715315"
  profile = "cx2-2x4"

  primary_network_interface {
    name            = "eth1"
    subnet          = ibm_is_subnet.iac_test_subnet.id
    security_groups = [ibm_is_security_group.iac_test_security_group.id]
  }

  vpc  = ibm_is_vpc.iac_test_vpc.id
  zone = "us-south-1"
  keys = [ibm_is_ssh_key.iac_test_key.id]
  
  boot_volume {
    name = "${var.basename}-boot-volume"
  }
  
  user_data = <<-EOUD
              #!/bin/bash
              echo "Hello World" > index.html
              nohup busybox httpd -f -p ${var.port} &
              EOUD

  tags = ["iac-${var.basename}"]
}


resource "ibm_is_instance_volume_attachment" "iac_test_instance_volume_attachment" {
  instance = ibm_is_instance.iac_test_instance.id
  name     = "${var.basename}-volume-1"
  profile  = "10iops-tier"
  capacity = 200
  delete_volume_on_attachment_delete = true
  delete_volume_on_instance_delete   = true
  volume_name                        = "${var.basename}-volume-1"
}

/*
resource "ibm_is_volume" "iac_app_volume" {

  profile  = "10iops-tier"
  zone     = "us-south-1"
  capacity = 200
}
*/