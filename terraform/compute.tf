#Create compute, Bastion
resource "openstack_compute_instance_v2" "bastion" {
  name			= "bastion"
  flavor_name		= "m1.tiny"
  key_pair		= "openstack-key"
  security_groups	= [openstack_networking_secgroup_v2.secgroup_bastion.name]
 
 block_device {
    uuid                  = local.ubuntu_2404_id
    source_type           = "image"
    volume_size           = 5
    boot_index            = 0
    destination_type      = "volume"
    delete_on_termination = true
  } 
network {
    uuid		= openstack_networking_network_v2.network.id
  }
depends_on = [openstack_networking_subnet_v2.subnet]
}
#Create a public IP for my bastion
resource "openstack_networking_floatingip_v2" "fip_1" {
  pool = local.float_ip_pool
}
# find appropriate vNIC to attatch IP to
data "openstack_networking_port_v2" "bastion_port" {
  device_id = openstack_compute_instance_v2.bastion.id
}
#assign public IP to my bastions vNIC
resource "openstack_networking_floatingip_associate_v2" "fip_1-assoc" {
  floating_ip	= openstack_networking_floatingip_v2.fip_1.address
  port_id	= data.openstack_networking_port_v2.bastion_port.id
}


#Create Compute, Nextcloud server
resource "openstack_compute_instance_v2" "nextcloud" {
  name 			= "nextcloud_server"
  flavor_name		= "m1.medium"
  key_pair		= "openstack-key"
  security_groups	= [openstack_networking_secgroup_v2.secgroup_nextcloud.name]
  
block_device {
    uuid                  = local.ubuntu_2404_id
    source_type           = "image"
    volume_size           = 15
    boot_index            = 0
    destination_type      = "volume"
    delete_on_termination = true
  }
network {
    uuid                = openstack_networking_network_v2.network.id
  }  
depends_on = [openstack_networking_subnet_v2.subnet]
}
