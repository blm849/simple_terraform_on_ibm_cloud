########################################################
# 
########################################################

resource "ibm_is_vpc" "iac_test_vpc" {
  name 				= "${var.basename}-vpc"
  resource_group 	= var.resource_group
  default_security_group_name = "${var.basename}-default-sg"
  tags = ["iac-${var.basename}"]
}

resource "ibm_is_subnet" "iac_test_subnet" {
  name            = "${var.basename}-subnet"
  resource_group 	= var.resource_group
  vpc             = ibm_is_vpc.iac_test_vpc.id
  zone            = "us-south-1"
  ipv4_cidr_block = "10.240.0.0/24"
  tags = ["iac-${var.basename}"]
}


resource "ibm_is_security_group" "iac_test_vpc_security_group" {
  name = "${var.basename}-sg-vpc"
  resource_group 	= var.resource_group
  vpc  = ibm_is_vpc.iac_test_vpc.id
  tags = ["iac-${var.basename}"]
}


resource "ibm_is_security_group" "iac_test_security_group" {
  name = "${var.basename}-sg-public"
  resource_group 	= var.resource_group
  vpc  = ibm_is_vpc.iac_test_vpc.id
  tags = ["iac-${var.basename}"]
}

resource "ibm_is_security_group_rule" "iac_test_security_group_rule_all_outbound" {
  group     = ibm_is_security_group.iac_test_security_group.id
  direction = "outbound"
}

resource "ibm_is_security_group_rule" "iac_test_security_group_rule_tcp_http" {
  group     = ibm_is_security_group.iac_test_security_group.id
  direction = "inbound"
  tcp {
    port_min = var.port
    port_max = var.port
  }
}

resource "ibm_is_security_group_rule" "iac_test_security_group_rule_tcp_ssh" {
  group     = ibm_is_security_group.iac_test_security_group.id
  direction = "inbound"
  tcp {
    port_min = 22
    port_max = 22
  }
}

resource "ibm_is_floating_ip" "iac_test_floating_ip" {
  name   = "${var.basename}-ip"
  resource_group 	= var.resource_group
  target = ibm_is_instance.iac_test_instance.primary_network_interface.0.id
  tags = ["iac-${var.basename}"]
}

