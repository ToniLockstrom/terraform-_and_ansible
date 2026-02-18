data "openstack_networking_network_v2" "ext-net" {
  name		= "external-net"
}
resource "openstack_networking_router_v2" "router" {
  name			= "nextcloud_router"
  external_network_id	= data.openstack_networking_network_v2.ext-net.id
}
resource "openstack_networking_router_interface_v2" "router_interface" {
  router_id		= openstack_networking_router_v2.router.id
  subnet_id		= openstack_networking_subnet_v2.subnet.id
}
