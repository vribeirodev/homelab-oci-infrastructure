# Route Table para subnet pública
resource "oci_core_route_table" "public" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.homelab.id
  display_name   = "homelab-${var.environment}-public-route-table"

  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_internet_gateway.homelab.id
    description       = "Route to Internet Gateway"
  }
}

# Route Table para subnet privada
resource "oci_core_route_table" "private" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.homelab.id
  display_name   = "homelab-${var.environment}-private-route-table"

  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_nat_gateway.homelab.id
    description       = "Route to NAT Gateway"
  }
}