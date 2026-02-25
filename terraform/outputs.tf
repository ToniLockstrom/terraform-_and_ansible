#output IP-addresses to use for ansible inventory

output "bastion_ip" {
  value = openstack_networking_floatingip_v2.fip_1.address
}

output "nextcloud_ip" {
  value = openstack_compute_instance_v2.nextcloud.access_ip_v4
}
output "nextcloud_fip" {
  value = openstack_networking_floatingip_v2.fip_2.address
}
