output "vcn_id" {
  description = "OCID da VCN criada"
  value       = oci_core_vcn.homelab.id
}

output "vcn_cidr" {
  description = "CIDR da VCN"
  value       = var.vcn_cidr
}

output "public_subnet_id" {
  description = "OCID da subnet pública"
  value       = oci_core_subnet.public.id
}

output "private_subnet_id" {
  description = "OCID da subnet privada"
  value       = oci_core_subnet.private.id
}

output "internet_gateway_id" {
  description = "OCID do Internet Gateway"
  value       = oci_core_internet_gateway.homelab.id
}

output "nat_gateway_id" {
  description = "OCID do NAT Gateway"
  value       = oci_core_nat_gateway.homelab.id
}

output "availability_domains" {
  description = "Lista de availability domains disponíveis"
  value       = data.oci_identity_availability_domains.ads.availability_domains
}
