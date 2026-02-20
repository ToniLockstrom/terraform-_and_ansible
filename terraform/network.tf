# Create Network
resource "openstack_networking_network_v2" "network" {
  name			= "the_network"
  admin_state_up	= "true"
}
#Create Subnet
resource "openstack_networking_subnet_v2" "subnet" {
  name			= "the_subnet"
  network_id		= openstack_networking_network_v2.network.id
  cidr			= "192.168.199.0/24"
  ip_version		= 4
  dns_nameservers	= ["1.1.1.1", "8.8.8.8"]
}
#Create security groups and firewall rules
resource "openstack_networking_secgroup_v2" "secgroup_bastion" {
  name			= "bastion_sg"
  description		= "allow SSH"
}
resource "openstack_networking_secgroup_rule_v2" "bastion_ssh" {
  direction		= "ingress"
  protocol		= "tcp"
  ethertype		= "IPv4"
  port_range_min	= 22
  port_range_max	= 22
  remote_ip_prefix	= "0.0.0.0/0"
  security_group_id	= openstack_networking_secgroup_v2.secgroup_bastion.id
}
resource "openstack_networking_secgroup_v2" "secgroup_nextcloud" {
  name                  = "nextcloud_sg"
  description           = "allow SSH only from bastion"
}
resource "openstack_networking_secgroup_rule_v2" "ssh_from_bastion" {
  direction             = "ingress"
  protocol              = "tcp"
  ethertype		= "IPv4"
  port_range_min        = 22
  port_range_max        = 22
  remote_group_id       = openstack_networking_secgroup_v2.secgroup_bastion.id
  security_group_id     = openstack_networking_secgroup_v2.secgroup_nextcloud.id
}
resource "openstack_networking_secgroup_rule_v2" "http_nextcloud" {
  direction         = "ingress"
  protocol          = "tcp"
  ethertype	    = "IPv4"
  port_range_min    = 80
  port_range_max    = 80
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.secgroup_nextcloud.id
}
#Allow ping to Bastion
resource "openstack_networking_secgroup_rule_v2" "allow_icmp" {
  direction		= "ingress"
  ethertype		= "IPv4"
  protocol		= "icmp"
  security_group_id	= openstack_networking_secgroup_v2.secgroup_bastion.id
}
