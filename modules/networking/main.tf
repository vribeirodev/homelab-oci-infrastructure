terraform {
  required_version = ">= 1.0"
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "~> 5.0"
    }
  }
}

# Data source para availability domains
data "oci_identity_availability_domains" "ads" {
  compartment_id = var.compartment_id
}

# VCN
resource "oci_core_vcn" "homelab" {
  compartment_id = var.compartment_id
  display_name   = "homelab-${var.environment}-vcn"
  cidr_blocks    = [var.vcn_cidr]
  dns_label = "hl${substr(var.environment, 0, 4)}"
}

# Internet Gateway
resource "oci_core_internet_gateway" "homelab" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.homelab.id
  display_name   = "homelab-${var.environment}-igw"
  enabled        = true
}

# NAT Gateway
resource "oci_core_nat_gateway" "homelab" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.homelab.id
  display_name   = "homelab-${var.environment}-nat"
}

# Subnet pública para load balancers
resource "oci_core_subnet" "public" {
  compartment_id             = var.compartment_id
  vcn_id                     = oci_core_vcn.homelab.id
  cidr_block                 = var.public_subnet_cidr
  display_name               = "homelab-${var.environment}-public-subnet"
  dns_label                  = "public"
  route_table_id             = oci_core_route_table.public.id
  security_list_ids          = [oci_core_security_list.public.id]
  prohibit_public_ip_on_vnic = false
}

# Subnet privada para worker nodes
resource "oci_core_subnet" "private" {
  compartment_id             = var.compartment_id
  vcn_id                     = oci_core_vcn.homelab.id
  cidr_block                 = var.private_subnet_cidr
  display_name               = "homelab-${var.environment}-private-subnet"
  dns_label                  = "private"
  route_table_id             = oci_core_route_table.private.id
  security_list_ids          = [oci_core_security_list.private.id]
  prohibit_public_ip_on_vnic = true
}
